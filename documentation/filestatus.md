# com.0x82.dropboxsync.FileStatus

## Description

The file status object exposes information about the file's current sync status,
including whether it's cached, if it's uploading or downloading, and if it's
uploading or downloading the progress of that transfer.

## Reference

### fileStatus.cached

Whether the contents of the file are cached locally and can be read without
making a network request.

### fileStatus.state

Whether the file is currently uploading, downloading, or neither (idle).

It returns one of the following values:

- fileStatus.STATE_DOWNLOADING
- fileStatus.STATE_IDLE
- fileStatus.STATE_UPLOADING

### fileStatus.progress

If the file is transferring, the progress of the transfer, between 0 and 1.

### fileStatus.error

If the file needs to be transferred, but can't for whatever reason (such as no
internet connection), then this property is set to the last error that prevented
the transfer. Returns a string.

