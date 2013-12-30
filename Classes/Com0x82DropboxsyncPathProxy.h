//
//  Com0x82DropboxsyncPathProxy.h
//  dropboxsync
//
//  Created by Ruben Fonseca on 11/02/13.
//
//

#import "TiProxy.h"

#import <Dropbox/Dropbox.h>

@interface Com0x82DropboxsyncPathProxy : TiProxy

@property (nonatomic, strong) DBPath *path;

@end
