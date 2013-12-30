//
//  Com0x82DropboxsyncFileInfoProxy.h
//  dropboxsync
//
//  Created by Ruben Fonseca on 11/02/13.
//
//

#import "TiProxy.h"

#import <Dropbox/Dropbox.h>

@interface Com0x82DropboxsyncFileInfoProxy : TiProxy

@property (nonatomic, retain) DBFileInfo *fileInfo;

@end
