//
//  Com0x82DropboxsyncAccount.h
//  dropboxsync
//
//  Created by Ruben Fonseca on 08/02/13.
//
//

#import "TiProxy.h"

#import <Dropbox/Dropbox.h>

@interface Com0x82DropboxsyncAccountProxy : TiProxy

@property (nonatomic, retain) DBAccount *account;

@end
