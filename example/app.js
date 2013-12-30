var window = Ti.UI.createWindow({
	backgroundColor:'white',
  title: 'Dropbox Sync module'
});

var nav = Ti.UI.iPhone.createNavigationGroup({
  window: window
});

var navigationWindow = Ti.UI.createWindow();
navigationWindow.add(nav);
navigationWindow.open();

var dropboxsync = require('com.0x82.dropboxsync');
Ti.API.info("module is => " + dropboxsync);

dropboxsync.configure('ozafak4s7qy0q7w', 'mzt6qbnzc142cbm');
Ti.API.log("  linked account => " + dropboxsync.linkedAccount);

var dropboxtest_path = dropboxsync.getPath('/dropboxtest');

dropboxsync.addEventListener('registration_change', function(e) {
  if(e.account.isLinked) {
    Ti.API.log("Account Registered :D Account: " + e.account);

    Ti.API.log("\t\tuserID: " + e.account.userID);
    Ti.API.log("\t\tisLinked: " + e.account.isLinked);
    Ti.API.log("\t\tdisplayName: " + e.account.displayName);
    Ti.API.log("\t\temail: " + e.account.email);

    Ti.API.log(e);

    Ti.API.log("Registering for account changes:");
    e.account.addEventListener("change", function(event) {
      Ti.API.warn("ACCOUNT CHANGEDDDDDDD");
    });
  } else {
    Ti.API.warn("Account Unregistered!");
    alert('Unlinked!');
  }
});

function link_account() {
  Ti.API.log("auhenticating");

  if(dropboxsync.linkedAccount) {
    alert('You are already linked with dropbox');
    return;
  }

  dropboxsync.link();
}

function unlink() {
  if(!dropboxsync.linkedAccount) {
    alert('No session to unlink');
    return;
  }

  dropboxsync.linkedAccount.unlink();
}

function browserFolders() {
  if(!dropboxsync.linkedAccount) {
    alert('First link an account');
    return;
  }

  var root_path = dropboxsync.getPath('/');
  var filesystem = dropboxsync.createFilesystem();
  
  var win = Ti.UI.createWindow({
    url: "folder_list.js",
    backgroundColor: 'white',
    dropbox_fs: filesystem,
    dropbox_path: root_path,
    nav: nav
  });

  nav.open(win, {animated:true});
}

// Tableview
var data = [
  {title:'Link account', hasChild:true, callback: link_account, header:'Authentication'},
  {title:'Unlink account', hasChild:true, callback: unlink},

  {title:'Browser folders', hasChild:true, callback:browserFolders, header:'Dropboxsync API'},
];

var tableview = Ti.UI.createTableView({
  data: data,
  style: Ti.UI.iPhone.TableViewStyle.GROUPED
});
window.add(tableview);

tableview.addEventListener('click', function(e) {
  if(e.rowData.callback) {
    tableview.footerTitle = null;
    e.rowData.callback();
  }
});

window.open();
