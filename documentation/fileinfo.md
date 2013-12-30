# com.0x82.dropboxsync.FileInfo

## Description

The file info class contains basic information about a file or folder.

## Reference

### fileInfo.path

Returns a [Path](path.html) of the file or folder.

Example:

    var fileInfo = ...;
    Ti.API.info("File path is " + fileInfo.path.stringValue());

### fileInfo.isFolder

Whether the item at `path` is a folder or a file.

### fileInfo.modifiedTime

The last time the file or folder was modified.

### fileInfo.size

The file's size. This property is always 0 for folders.

