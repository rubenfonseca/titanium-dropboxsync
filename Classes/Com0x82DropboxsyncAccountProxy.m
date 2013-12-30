//
//  Com0x82DropboxsyncAccount.m
//  dropboxsync
//
//  Created by Ruben Fonseca on 08/02/13.
//
//

#import "Com0x82DropboxsyncAccountProxy.h"

@interface Com0x82DropboxsyncAccountProxy ()

@end

@implementation Com0x82DropboxsyncAccountProxy

-(void)dealloc {
	[super dealloc];
	
  [_account removeObserver:self];
	self.account = nil;
}

-(void)setAccount:(DBAccount *)account {
	[_account removeObserver:self];
	
	_account = [account retain];
	[_account addObserver:self block:^{
		[self fireEvent:@"changed" withObject:self];
	}];
}

-(void)unlink:(id)args {
	[_account unlink];
}

-(id)userID {
	return [_account userId];
}

-(id)isLinked {
	return @([_account isLinked]);
}

-(id)displayName {
	return [[_account info] displayName];
}

-(void)_listenerAdded:(NSString *)type count:(int)count {
	if([type isEqualToString:@"change"] && count == 1) {
    [_account addObserver:self block:^{
      [self fireEvent:@"change" withObject:@{}];
    }];
  }
}

-(void)_listenerRemoved:(NSString *)type count:(int)count {
	if([type isEqualToString:@"change"] && count == 0) {
    [_account removeObserver:self];
  }
}

@end
