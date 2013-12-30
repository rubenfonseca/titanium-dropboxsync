//
//  Com0x82DropboxsyncFileProxy.h
//  dropboxsync
//
//  Created by Ruben Fonseca on 12/02/13.
//
//

#import "TiProxy.h"

#import <Dropbox/Dropbox.h>

@interface Com0x82DropboxsyncFileProxy : TiProxy

@property (nonatomic, retain) DBFile *file;

@end
