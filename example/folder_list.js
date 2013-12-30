var filesystem = Ti.UI.currentWindow.dropbox_fs;
var path = Ti.UI.currentWindow.dropbox_path;

if(path.stringValue() == path.root.stringValue())
  Ti.UI.currentWindow.title = "Dropbox";
else
  Ti.UI.currentWindow.title = path.stringValue();

var fromPath = null;
var moving = false;
var creatingFolder = false;

// TableView
var data = [];
var tableview = Ti.UI.createTableView({
  data: data,
  style: Ti.UI.iPhone.TableViewStyle.PLAIN,
  editable: true
});
Ti.UI.currentWindow.add(tableview);
tableview.addEventListener('click', function(e) {
  if(data.length <= e.index) return;

  var info = data[e.index].fileInfo;
  if(!moving) {
    if(info.isFolder) {
      openFolder(info.path);
    } else {
      filesystem.openFile(info.path, {
        success: function(e) {
          var file = e.file;

          var win = Ti.UI.createWindow({
            url: "note.js",
            backgroundColor: 'white',
            dropbox_file: file,
            dropbox_fs: filesystem,
            nav: Ti.UI.currentWindow.nav
          });
          Ti.UI.currentWindow.nav.open(win, {animated: true});
        }, 
        failure: function(e) {
          alert("Error", "There was an error opening your note");
        }
      });
    }
  } else {
    fromPath = info.path;

    var actionSheet = Ti.UI.createAlertDialog({
      title: 'Choose a destination',
      style: Ti.UI.iPhone.AlertDialogStyle.PLAIN_TEXT_INPUT,
      buttonNames: ['Move', 'Cancel']
    });
    actionSheet.addEventListener('click', processAddMoveResult);
    actionSheet.show();
  }
});
tableview.addEventListener('delete', function(e) {
  var info = data[e.index].fileInfo;

  filesystem.deletePath(info.path, {
    success: function(event) {
      data.splice(e.index, 1);
    }, 
    failure: function(event) {
      Ti.API.error("Error", "There was an error deleting that file.");
      reload()
    }
  });
});

// Toolbar
var toolbar = Ti.UI.iOS.createToolbar({
  items: [],
  bottom: 0,
  borderTop: true,
  borderBottom: false,
});
Ti.UI.currentWindow.add(toolbar);

function processAddMoveResult(e) {
  if(e.index != 1) {
    if(moving)
      moveTo(e.text);
    else
      createAt(e.text);
  }

  moving = false;
  fromPath = null;
  loadFiles();
}

function showAddOptions() {
  var actionSheet = Ti.UI.createAlertDialog({
    title: creatingFolder ? 'Create a folder' : 'Create a file',
    style: Ti.UI.iPhone.AlertDialogStyle.PLAIN_TEXT_INPUT,
    buttonNames: ['Create', 'Cancel']
  });
  actionSheet.addEventListener('click', processAddMoveResult);
  actionSheet.show();
}

function didPressAdd() {
  opts = {
    options: ['Create file', 'Create folder', 'Cancel'],
    cancel: 2
  };

  actionSheet = Ti.UI.createOptionDialog(opts);
  actionSheet.addEventListener('click', function(e) {
    if(e.index == 1) creatingFolder = true;
    if(e.index != 2) { showAddOptions(); }
  });
  actionSheet.show();
}

function didPressMove() {
  moving = true;
  reload();
}

function openFolder(path) {
  var win = Ti.UI.createWindow({
    url: "folder_list.js",
    backgroundColor: "white",
    dropbox_fs: filesystem,
    dropbox_path: path,
    nav: Ti.UI.currentWindow.nav
  });
  Ti.UI.currentWindow.nav.open(win, {animated: true});
}

// Bar buttons
var flexSpace = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE
});
var moveItem = Ti.UI.createButton({
  title: 'Move'
});
moveItem.addEventListener('click', didPressMove);
var messageItem = Ti.UI.createButton({
  title: 'Select a file to move',
});
var cancelItem = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.CANCEL
});
cancelItem.addEventListener('click', function(e) {
  moving = false;
  reload();
});
var addItem = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.ADD
});
addItem.addEventListener('click', didPressAdd);
var activityIndicator = Ti.UI.createActivityIndicator({
  style: Ti.UI.iPhone.ActivityIndicatorStyle.PLAIN,
  height: Ti.UI.SIZE,
  width: Ti.UI.SIZE
});
activityIndicator.show();

function reload() {
  tableview.data = data;

  moveItem.enabled = data != [];
  if(moving) {
    moveItem.enabled = false;

    toolbar.items = [moveItem, messageItem];
    Ti.UI.currentWindow.rightNavButton = cancelItem;
  } else {
    var items = [moveItem];
    if(filesystem.status & filesystem.SYNC_STATUS_UPLOADING) {
      items.push(flexSpace);
      items.push(activityIndicator);
    }
    
    toolbar.items = items;
    Ti.UI.currentWindow.rightNavButton = addItem;
  }
}

var loadingFiles = false;
function loadFiles() {
  if(loadingFiles) return;
  loadingFiles = true;

  filesystem.listFolder(path, {
    success: function(event) {
      data = [];

      Ti.API.info("Will process #files: " + event.files.length);
      for(var i=0; i<event.files.length; i++) {
        var fileInfo = event.files[i];
        var fileData = {};

        if(fileInfo.isFolder)
          data.push({ title: fileInfo.path.stringValue(), hasDetail: true, fileInfo: fileInfo });
        else
          data.push({ title: fileInfo.path.stringValue(), fileInfo: fileInfo });
      }

      data = data.sort(function(a, b) {
        if(a.fileInfo.path.stringValue()<b.fileInfo.path.stringValue()) return -1;
        if(a.fileInfo.path.stringValue()>b.fileInfo.path.stringValue()) return 1;
        return 0;
      });
      
      reload();
      loadingFiles = false;
    },
    failure: function(event) {
      Ti.API.error("Error listing folder: " + event.error);
      loadingFiles = false;
    }
  });
}

function createAt(input) {
  if(!creatingFolder) {
    var noteFileName = input + ".txt";
    var newPath = path.childPath(noteFileName);
    filesystem.createFile(newPath, {
      success: function(e) {
        var file = e.file;
        alert('Should open new controller');
        file.close();
      },
      failure: function(e) {
        Ti.API.error(e.error);
        alert('Unable to create note', 'An error has occured');
      }
    });
  } else {
    var newPath = path.childPath(input);
    filesystem.createFolder(newPath, {
      success: function(e) {
        openFolder(newPath);
      },
      failure: function(e) {
        Ti.API.error(e.error);
        alert('Unable to create folder', 'An error has occured');
      }
    });
  }
}

function moveTo(input) {
  var components = input.split('/');

  var newPath = path;
  if(components[0].length == 0)
    newPath = path.root;

  for(var i=0; i<components.length; i++) {
    var component = components[i];
    if(component == "..")
      newPath = path.parent;
    else
      newPath = path.childPath(component);
  }

  Ti.API.info("Moving from " + fromPath.stringValue() + " to " + newPath.stringValue());
  filesystem.movePath(fromPath, newPath, {
    success: function(e) {
      moving = false;
      fromPath = null;
    },
    failure: function(e) {
      Ti.API.error(e.error);
      alert('Unable to move file', 'An error has occured');
    }
  });
}

filesystem.addEventListener('change', function(e) { reload() });
filesystem.observePathAndChildren(path, loadFiles);
loadFiles();

