//
//  Com0x82DropboxsyncFileInfoProxy.m
//  dropboxsync
//
//  Created by Ruben Fonseca on 11/02/13.
//
//

#import "Com0x82DropboxsyncFileInfoProxy.h"

#import "Com0x82DropboxsyncPathProxy.h"

@implementation Com0x82DropboxsyncFileInfoProxy

-(void)dealloc {
	[super dealloc];
	
	[_fileInfo release];
}

-(Com0x82DropboxsyncPathProxy *)path {
	Com0x82DropboxsyncPathProxy *pathProxy = [[Com0x82DropboxsyncPathProxy alloc] _initWithPageContext:self.pageContext];
	pathProxy.path = [self.fileInfo path];
	
	return [pathProxy autorelease];
}

-(NSNumber *)isFolder {
	return @([self.fileInfo isFolder]);
}

-(NSDate *)modifiedTime {
	return [self.fileInfo modifiedTime];
}

-(NSNumber *)size {
	return @([self.fileInfo size]);
}

@end
