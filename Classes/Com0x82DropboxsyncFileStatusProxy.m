//
//  Com0x82DropboxsyncFileStatusProxy.m
//  dropboxsync
//
//  Created by Ruben Fonseca on 12/02/13.
//
//

#import "Com0x82DropboxsyncFileStatusProxy.h"

#import <Dropbox/Dropbox.h>

@implementation Com0x82DropboxsyncFileStatusProxy

-(void)dealloc {
	[super dealloc];
	
	[_fileStatus release];
}

/** @name Basic information */

-(NSNumber *)cached {
	return @([_fileStatus cached]);
}

/** @name Transfer information */

-(NSNumber *)state {
	return @([_fileStatus state]);
}

-(NSNumber *)progress {
	return @([_fileStatus progress]);
}

-(NSString *)error {
	return [[_fileStatus error] localizedDescription];
}

MAKE_SYSTEM_NUMBER(STATE_DOWNLOADING, DBFileStateDownloading);
MAKE_SYSTEM_NUMBER(STATE_IDLE, DBFileStateIdle);
MAKE_SYSTEM_NUMBER(STATE_UPLOADING, DBFileStateUploading);

@end
