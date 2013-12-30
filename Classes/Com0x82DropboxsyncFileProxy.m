//
//  Com0x82DropboxsyncFileProxy.m
//  dropboxsync
//
//  Created by Ruben Fonseca on 12/02/13.
//
//

#import "Com0x82DropboxsyncFileProxy.h"

#import "Com0x82DropboxsyncFileInfoProxy.h"
#import "Com0x82DropboxsyncFileStatusProxy.h"

#import "TiBlob.h"

@implementation Com0x82DropboxsyncFileProxy

+(dispatch_queue_t)backgroundQueue {
	static dispatch_queue_t queue;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		queue = dispatch_queue_create("com.0x82.dropboxsync.filequeue", DISPATCH_QUEUE_CONCURRENT);
	});
	
	return queue;
}

-(void)dealloc {
	[super dealloc];
	
	NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$ DEALLOC FILE");
	
	[_file removeObserver:self];
	[_file release];
}

-(void)setFile:(DBFile *)file {
	if(file != _file) {
		DBFile *savedObject = _file;
		_file = [file retain];
		
		[savedObject removeObserver:self];
		[savedObject release];
		
		[_file addObserver:self block:^{
			[self fireEvent:@"change"];
		}];
	}
}

-(void)readData:(id)args {
	enum {
		kArgCallback = 0,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	KrollCallback *callback = nil; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFileProxy backgroundQueue], ^{
		DBError *error = nil;
		NSData *data = [_file readData:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		} else {
			TiBlob *b = [[[TiBlob alloc] _initWithPageContext:self.pageContext] autorelease];
			b.data = data;
			
			NSDictionary *event = @{ @"data" : b };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		}
	});
}

-(void)readString:(id)args {
	enum {
		kArgCallback = 0,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	KrollCallback *callback; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFileProxy backgroundQueue], ^{
		DBError *error = nil;
		NSString *string = [_file readString:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		} else {
			NSDictionary *event = @{ @"string" : string };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		}
	});
}

-(void)writeData:(id)args {
	enum {
		kArgBlob = 0,
		kArgCallback,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	TiBlob *blob; ENSURE_ARG_AT_INDEX(blob, args, kArgBlob, TiBlob);
	KrollCallback *callback; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFileProxy backgroundQueue], ^{
		DBError *error = nil;
		BOOL result = [_file writeData:blob.data error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		} else {
			NSDictionary *event = @{ @"result" : @(result) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		}
	});
}

-(void)writeString:(id)args {
	enum {
		kArgBlob = 0,
		kArgCallback,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	NSString *string = nil; ENSURE_ARG_AT_INDEX(string, args, kArgBlob, NSString);
	KrollCallback *callback = nil; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFileProxy backgroundQueue], ^{
		DBError *error = nil;
		BOOL result = [_file writeString:string error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		} else {
			NSDictionary *event = @{ @"result" : @(result) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		}
	});
}

-(void)update:(id)args {
	enum {
		kArgCallback = 0,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	KrollCallback *callback; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFileProxy backgroundQueue], ^{
		DBError *error = nil;
		BOOL result = [_file update:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		} else {
			NSDictionary *event = @{ @"result" : @(result) };
			[self _fireEventToListener:@"callback" withObject:event listener:callback thisObject:self];
		}
	});
}

-(void)close:(id)args {
	[_file close];
}

/** @name Getting the current state */

-(Com0x82DropboxsyncFileInfoProxy *)info {
	Com0x82DropboxsyncFileInfoProxy *infoProxy = [[Com0x82DropboxsyncFileInfoProxy alloc] _initWithPageContext:self.pageContext];
	infoProxy.fileInfo = [_file info];
	
	return [infoProxy autorelease];
}

-(NSNumber *)isOpen {
	return @([_file isOpen]);
}

-(Com0x82DropboxsyncFileStatusProxy *)status {
	Com0x82DropboxsyncFileStatusProxy *statusProxy = [[Com0x82DropboxsyncFileStatusProxy alloc] _initWithPageContext:self.pageContext];
	statusProxy.fileStatus = [_file status];
	
	return [statusProxy autorelease];
}

-(Com0x82DropboxsyncFileStatusProxy *)newerStatus {
	if(![_file newerStatus])
		return nil;
	
	Com0x82DropboxsyncFileStatusProxy *statusProxy = [[Com0x82DropboxsyncFileStatusProxy alloc] _initWithPageContext:self.pageContext];
	statusProxy.fileStatus = [_file newerStatus];
	
	return [statusProxy autorelease];
}

@end
