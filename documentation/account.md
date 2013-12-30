# com.0x82.dropboxsync.Account

## Description

The account represents a particular user who has linked his account to your app.

## Reference

### account.unlink()

This method unlinks a user's account from your app.
 
Once an account is unlinked, the local cache is deleted. If there is a
[Filesystem](filesystem.html) object created with this account it will stop
running.

### account.userID

The user id of the account. This can be used to associate metadata with a given account.

### account.isLinked

Whether the account is currently linked. Note that accounts can be unlinked via
the unlink method or from the Dropbox website.

### account.displayName

The user's name.

### account.email

The user's email address, if available.

## Events

### change

Fired when some property of the account changes. For instance, when the account
is marked as linked or marked as unlinked, or a user's display name changes.

Example:

    account.addEventListener('change', function(e) {
      Ti.API.warn('Something changed on the account!');
    });

