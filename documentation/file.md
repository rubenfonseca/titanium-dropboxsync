# com.0x82.dropboxsync.File

## Description

The file object represents a particular file at a particular version. It has
basic file operations such as reading and writing the file's contents and
getting info about the file. It can also tell you the current sync status,
whether there's a newer version available, and allows you to update to the newer
version.

**Whatever you do, please don't forget to `.close()` after you don't need the
file reference anymore. Otherwise bad things will happen eventually!**

## Reference

### file.readData(callback)

Starts reading the file's data as a `TiBlob`. When the reading finished or
there's an error, `callback` is called.

`callback` is a function that contains an event object with the following keys:

- error[string]: error description if there's an error reading the file
- code[integer]: code of the error if there's an error
- data[TiBlob]: the blob with the read data if the file is read successfully.

Example:

    var file = ...;
    file.readData(function(event) {
      file.close(); // close the file if you don't need it anymore!

      if(event.error) {
        Ti.API.error("Error reading file: " + event);
        return
      }

      var blob = event.data;
      // handle blob
    });

### file.readString(callback)

Starts reading the file's data as a normal string. When the reading finished or
there's an error, `callback` is called.

`callback` is a function that contains an event object with the following keys:

- error[string]: error description if there's an error reading the file
- code[integer]: code of the error if there's an error
- string[string]: the text read from the file if the read was succesfull

Example:

    var file = ...;
    file.readString(function(event) {
      file.close(); // close the file if you don't need it anymore!

      if(event.error) {
        Ti.API.error("Error reading file: " + event);
        return
      }

      var string = event.string;
      Ti.API.warn("READ: " + string);
    });

## file.writeData(blob, callback)

Writes the content of the passed `TiBlob` param to the file. When the writes
finishes, the callback is called.

`callback` is a function that contains an event object with the following keys:

- error[string]: error description if there's an error writing the file
- code[integer]: code of the error if there's an error
- result[boolean]: true if the file was written successfully, or false if an error occurred

### file.writeString(string, callback)

Writes the content of the passed string param to the file. When the writes
finishes, the callback is called.

`callback` is a function that contains an event object with the following keys:

- error[string]: error description if there's an error writing the file
- code[integer]: code of the error if there's an error
- result[boolean]: true if the file was written successfully, or false if an error occurred

Example:

    var file = ...;
    file.writeString("Lorem ipsum...", function(e) {
      file.close(); // If you don't need the file anymore

      if(!e.result) {
        Ti.API.error("Error writing file: " + e.error);
      }
    });

### file.update(callback)

If there is a newer version of the file available, and it's cached (determined by the cached
property on <newerStatus>), then this method will update the file object to reference the newer
version so it can be read from or written to. The callback is fired after the
update finishes.

`callback` is a function that contains an event object with the following keys:

- error[string]: error description if there's an error updating the file
- code[integer]: code of the error if there's an error
- result[boolean]: true if the file was written successfully, or false if an error occurred

### file.close()

Closes the file, preventing any further operations to occur and allowing the file to be opened
again.

### file.info

Returns the [FileInfo](fileinfo.html) for this file.

### file.isOpen

Whether the file is currently open.

### file.status

Returns the [FileStatus](filestatus.html) for this file.

### file.newerStatus

The current [FileStatus](filestatus.html) sync status for the newer version of the file. If the file is the
newest version, then this property is `null`.

## Events

### change

Fired when a property of the file changes.

Example:

    var file = ...;
    file.addEventListener('change', function(e) {
      Ti.API.info("Something changed on the file, reload user interface?");
    });

