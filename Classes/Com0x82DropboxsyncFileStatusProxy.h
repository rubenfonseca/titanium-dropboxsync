//
//  Com0x82DropboxsyncFileStatusProxy.h
//  dropboxsync
//
//  Created by Ruben Fonseca on 12/02/13.
//
//

#import "TiProxy.h"

#import <Dropbox/Dropbox.h>

@interface Com0x82DropboxsyncFileStatusProxy : TiProxy

@property (nonatomic, retain) DBFileStatus *fileStatus;

@end
