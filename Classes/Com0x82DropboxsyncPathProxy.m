//
//  Com0x82DropboxsyncPathProxy.m
//  dropboxsync
//
//  Created by Ruben Fonseca on 11/02/13.
//
//

#import "Com0x82DropboxsyncPathProxy.h"

@implementation Com0x82DropboxsyncPathProxy

-(void)dealloc {
	[super dealloc];
	
	[_path release];
}

-(Com0x82DropboxsyncPathProxy *)root {
	DBPath *rootPath = [DBPath root];
	
	Com0x82DropboxsyncPathProxy *pathProxy = [[Com0x82DropboxsyncPathProxy alloc] _initWithPageContext:self.pageContext];
	pathProxy.path = rootPath;
	
	return [pathProxy autorelease];
}

-(Com0x82DropboxsyncPathProxy *)childPath:(id)args {
	NSString *childPathString; ENSURE_ARG_AT_INDEX(childPathString, args, 0, NSString);
	
	DBPath *childPath = [_path childPath:childPathString];
	
	Com0x82DropboxsyncPathProxy *childPathProxy = [[Com0x82DropboxsyncPathProxy alloc] _initWithPageContext:self.pageContext];
	childPathProxy.path = childPath;
	
	return [childPathProxy autorelease];
}

-(Com0x82DropboxsyncPathProxy *)parent {
	DBPath *parentPath = [_path parent];
	
	Com0x82DropboxsyncPathProxy *parentPathProxy = [[Com0x82DropboxsyncPathProxy alloc] _initWithPageContext:self.pageContext];
	parentPathProxy.path = parentPath;
	
	return [parentPathProxy autorelease];
}

-(NSString *)stringValue:(id)args {
	return [_path stringValue];
}

@end
