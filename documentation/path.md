# com.0x82.dropboxsync.Path

## Description

The path object represents a valid Dropbox path, and knows how to do correct
path comparisons. It also has convenience methods for constructing new paths.

## Reference

### path.root

The top-most folder in your app's view of the user's Dropbox.

### path.childPath(childName)

Create a new path by treating the current path as a path to a folder, and
`childName` as the name of an item in that folder.

Returns a new path object or `null` if the name is invalid.

Example:

    var path = ....;
    var newPath = path.childPath("/another_dir");

### path.parent

Create a new path that is the folder containing the current path.

### path.stringValue()

The fully qualified path (relative to the root) as a string, with original casing.

Example:

    var path = ....;
    Ti.API.warn("Path is " + path.stringValue());

