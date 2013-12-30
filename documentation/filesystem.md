# com.0x82.dropboxsync.FileSystem

## Description

The filesystem object provides a files and folder view of a user's Dropbox. The
most basic operations are listing a folder and opening a file, but it also
allows you to move, delete, and create files and folders.

## Reference

### fileSystem.listFolder(path, options)

Returns a list of DBFileInfo objects representing the files contained in the
folder at `path`.  If <completedFirstSync> is false, then this call will block
until the first sync completes or an error occurs.

The options object should contain two keys: 

- success[callback]: called if the listFolder succeeds. Contains a `files` key
  with the list of [FileInfo](fileinfo.html) objects.
- failure[callback]: called if the there's an error listing the folder. Contains
  a `error` key with the error description.

Example:

    var fileSystem = ...;
    fileSystem.listFolder(dropboxsync.getPath('/'), {
      success: function(e) {
        for(var i=0; i<e.files.length; i++) {
          Ti.API.info("New file :)");
        }
      },
      failure: function(e) {
        Ti.API.error("Error getting the list of files: " + e.error);
      }
    });

### fileSystem.fileInfoForPath(path, options)

Returns the [FileInfo](fileinfo.html) for the file or folder at `path`.

The options object should contain two keys: 

- success[callback]: called if the call succeeds. Contains a `fileinfo` key
  with the [FileInfo](fileinfo.html) of the path.
- failure[callback]: called if the there's an error getting the info. Contains
  a `error` key with the error description.

### fileSystem.openFile(path, options)

Opens an existing file and returns a [File](file.html) object representing the file at `path`.
 
Files are opened at the newest cached version if the file is cached. Otherwise,
the file will open at the latest server version and start downloading. Check
the `status` property of the returned file object to determine whether it's
cached. Only 1 file can be open at a given path at the same time.

The options object should contain two keys: 

- success[callback]: called if the call succeeds. Contains a `file` key
  with the [File](file.html) of the path.
- failure[callback]: called if the there's an error getting the file. Contains
  a `error` key with the error description.

### fileSystem.createFile(path, options)

Creates a new file at `path` and returns a file object open at that path.

The options object should contain two keys: 

- success[callback]: called if the call succeeds. Contains a `file` key
  with the new [File](file.html) of the path.
- failure[callback]: called if the there's an error creating the file. Contains
  a `error` key with the error description.

### fileSystem.createFolder(path, options)

Creates a new folder at `path`.

The options object should contain two keys: 

- success[callback]: called if the call succeeds. Contains a `result` key
  with the result of the calling method (boolean).
- failure[callback]: called if the there's an error. Contains a `error` key with
  the error description.

### fileSystem.deletePath(path, options)

Deletes the file or folder at `path`.

The options object should contain two keys: 

- success[callback]: called if the call succeeds. Contains a `result` key
  with the result of the calling method (boolean).
- failure[callback]: called if the there's an error. Contains a `error` key with
  the error description.

### fileSystem.movePath(fromPath, toPath, options)

Moves a file or folder at `fromPath` to `toPath`.

The options object should contain two keys: 

- success[callback]: called if the call succeeds. Contains a `result` key
  with the result of the calling method (boolean).
- failure[callback]: called if the there's an error. Contains a `error` key with
  the error description.

### fileSystem.account

The [Account](account.html) object this filesystem was created with.

### fileSystem.completedFirstSync

When a user's account is first linked, the filesystem needs to be synced with
the server before it can be used. This property indicates whether the first sync
has completed and the filesystem is ready to use.

### fileSystem.isShuttingDown

Whether the filesystem is currently shut down. The filesystem will shut down if
the account associated with this filesystem becomes unlinked.

### fileSystem.status

Returns a bitmask representing all the currently active states of the filesystem OR'ed together.

Could be one of the following:

- SYNC_STATUS_DOWNLOADING
- SYNC_STATUS_UPLOADING
- SYNC_STATUS_SYNCING
- SYNC_STATUS_ONLINE

### fileSystem.observePath(path, callback)

Add an observer to be notified any time the file or folder at `path` changes.

### fileSystem.observePathAndChildren(path, callback)

Add an observer to be notified any time the folder at `path` changes or a file
or folder directly contained in `path` changes.

### fileSystem.observePathAndDescendants(path, callback)

Add an observer to be notified any time the folder at `path` changes or a file or folder
 contained somewhere beneath `path` changes.

## Events

### change

The event will be fired anytime completedFirstSync, shutDown, or status changes.

