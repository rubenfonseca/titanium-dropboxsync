var filesystem = Ti.UI.currentWindow.dropbox_fs;
var file = Ti.UI.currentWindow.dropbox_file;

var textViewLoaded = false;
var writeTimer = null;

Ti.UI.currentWindow.title = file.info.path.stringValue();
Ti.UI.currentWindow.addEventListener('close', function(e) {
  Ti.API.info("Window is closing, closing file too.");
  saveChanges(function() { file.close() });
});

var updateItem = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.REFRESH
});
updateItem.addEventListener('click', didPressUpdate);
Ti.UI.currentWindow.rightNavButton = updateItem;

var textArea = Ti.UI.createTextArea({
  returnKeyType: Ti.UI.RETURNKEY_DONE,
  textAlign: 'left',
  value: 'Loading...',
  top: 0,
  width: 320, height : 420
});
textArea.addEventListener('change', function(e) {
  Ti.API.warn('CHANGED');
  if(writeTimer) clearTimeout(writeTimer);
  writeTimer = setTimeout(function() {
    saveChanges(null);
  }, 3000);
});
Ti.UI.currentWindow.add(textArea);

var activityIndicator = Ti.UI.createActivityIndicator({
  style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK,
});
Ti.UI.currentWindow.add(activityIndicator);
activityIndicator.show();

function reload() {
  var updateEnabled = false;

  if(file.status.cached) {
    if(!textViewLoaded) {
      textViewLoaded = true;

      file.readString(function(e) {
        if(e.error) {
          Ti.API.error(e.error);
          alert("Error reading file contents.");
          return;
        }
        textArea.value = e.string;
      });
    }

    activityIndicator.hide();
    textArea.show();

    if(file.newerStatus && file.newerStatus.cached)
      updateEnabled = true;
  } else {
    activityIndicator.show();
    textArea.hide();
  }

  updateItem.enabled = updateEnabled;
}

function saveChanges(cb) {
  Ti.API.info("Saving changes...");

  if(writeTimer) clearTimeout(writeTimer);
  writeTimer = null;

  file.writeString(textArea.value, function(e) {
    if(cb) cb();

    if(e.error) {
      Ti.API.error(e.error);
      alert("Error saving changes");
      return;
    }

    Ti.API.info("Changes are written.");
  });
}

function didPressUpdate() {
  file.update(function(e) {
    if(e.error) {
      Ti.API.error(e.error);
      alert("Error updating the file");
      return;
    }

    textViewLoaded = false;
    reload();
  });
}

file.addEventListener('change', function(e) { reload(); });
reload();

