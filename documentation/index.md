# dropboxsync Module

## Description

This is a Titanium Mobile module for iOS (iPhone/iPad) that allows to use the
full power of the official Dropbox Sync SDK to sync files between multiple
devices and platforms.

The official Dropbox Sync SDK can be found
[here](https://www.dropbox.com/developers/sync).

## Basic installation instructions

Please follow the guide available [here](http://wiki.appcelerator.org/display/tis/Using+Titanium+Modules).

Also, **please follow the additional instructions below**.

## Changelog

See [here](changelog.html)

## Accessing the dropboxsync Module

To access this module from JavaScript, you would do the following:

	var dropboxsync = require("com.0x82.dropboxsync");

The dropboxsync variable is a reference to the Module object.	

## Additional Installation instructions (VERY IMPORTANT)

You are required to do these steps in order for this module to work.

That required us to set a proper UrlScheme, so the browser or the Dropbox
application can then came back to our application, after we finish the auth 
phase. To do that on the iPhone, you have to change the Info.plist file on
your build directory. Unfortunately, at this moment, it is not possible to 
change the file automatically, so you always have to do this step by hand.
This is a limitation of Titanium and I'm working with them to solve this 
problem.

### First step: generate a app key and secret

Go to the website https://www.dropbox.com/developers and generate a new 
application. Save the application key.

### Manually edit the Info.plist file

Open the `build/iphone/Info.plist` on Finder. It will probably open the file
in XCode or something.

Open the "URL Types" -> "Item 0" -> "URL Schemes" path. You should have an
"Item 0" String entry with the name of your application. Add a new item "Item 1"
with the following format "db-YOUR_API_KEY".

You can see the result on the following screenshot:

![Screenshot](http://f.cl.ly/items/30363R3R393g1L1B3r37/Screen%20Shot%202011-10-26%20at%2016.51.33.png)

If you are using a custom `Info.plist` file already, you need to copy the custom
file to the root of your project directory. That way, Titanium will use that
file everytime it builds the project, instead of generating a new one.

## Reference

Here's the module API.

### dropboxsync.configure(app_key, secret)

To start using the Dropbox Sync API, you need to boostrap the program by calling
this method with the correct Dropbox app key and secret. This should be the very
first method you should call on your applicaton, since it sets the necessary
underlying connections for you to use the module.

Note that right now only apps with the App Folder permission can use the Sync
API.

Example:

        dropboxsync.configure("APP KEY", "APP SECRET");

### dropboxsync.link()

The next step is to link to a user's account. The linking process will switch to
the Dropbox mobile app if it's installed. 

To know when this process finishes, please see bellow for the event
`registration_change`.

Example:

        var button = Ti.UI.createButton({ title: "Connect with Dropbox", ...});
        button.addEventListener('click', function(e) {
            dropboxsync.link();
        });

### dropboxsync.linkedAccount

Returns a [Account](account.html) reference if the there is any linked account.
Returns `null` otherwise. This is usefull to check if there's already a linked
user account on the system.

Example:

        if(dropboxsync.linkedAccount)
            alert("Signed in!");
        else
            alert("Signed out!");

### dropboxsync.getPath(path)

Create a new path object from a string. Some special characters, names, or
encodings a are not allowed in a Dropbox path. For more details see this
[article](http://www.dropbox.com/help/145).

Returns a [Path](path.html) object.

Example:

        var filePath = dropboxsync.getPath("file.txt");
        var rootPath = dropboxsync.getPath("/");

## Events

### registration_change

This event is fired when the state of the linked or linking account changes. For
instance, after the authentication is completed, this event is fired to signal
that you are ready to start using Dropbox Sync. The current linked account is
passed as the `account` key.

Example:

        dropboxsync.addEventListener('registration_change', function(event) {
          if(event.account.isLinked) {
            alert("You are now logged in :D");
          }
        });
        dropboxsync.link();

## Error constants

- dropboxsync.ERROR_UNKNOWN
- dropboxsync.ERROR_CORE_SYSTEM
- dropboxsync.ERROR_PARAMS
- dropboxsync.ERROR_PARAMS_INVALID
- dropboxsync.ERROR_PARAMS_NOTFOUND
- dropboxsync.ERROR_PARAMS_EXISTS
- dropboxsync.ERROR_PARAMS_ALREADY_OPEN
- dropboxsync.ERROR_PARAMS_PARENT
- dropboxsync.ERROR_PARAMS_NOT_EMPTY
- dropboxsync.ERROR_PARAMS_NOT_CACHED
- dropboxsync.ERROR_SYSTEM
- dropboxsync.ERROR_SYSTEM_DISK_SPACE
- dropboxsync.ERROR_NETWORK
- dropboxsync.ERROR_NETWORK_TIMEOUT
- dropboxsync.ERROR_NETWORK_NO_CONNECTION
- dropboxsync.ERROR_NETWORK_SSL
- dropboxsync.ERROR_NETWORK_SERVER
- dropboxsync.ERROR_AUTH
- dropboxsync.ERROR_AUTH_UNLINKED
- dropboxsync.ERROR_AUTH_INVALID_APP

## Usage

Please see the `examples/app.js` for a full app example.

## Author

Ruben Fonseca, root (at) cpan (dot) org

You can also find me on [github](http://github.com/rubenfonseca) and on my
[blog](http://blog.0x82.com).

## License

This module is licensed under a Commercial license.
