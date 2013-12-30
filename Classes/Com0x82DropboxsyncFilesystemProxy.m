//
//  Com0x82DropboxsyncFilesystemProxy.m
//  dropboxsync
//
//  Created by Ruben Fonseca on 11/02/13.
//
//

#import "Com0x82DropboxsyncFilesystemProxy.h"

#import "Com0x82DropboxsyncPathProxy.h"
#import "Com0x82DropboxsyncFileInfoProxy.h"
#import "Com0x82DropboxsyncFileProxy.h"
#import "Com0x82DropboxsyncAccountProxy.h"

#import <Dropbox/Dropbox.h>

@implementation Com0x82DropboxsyncFilesystemProxy

+(dispatch_queue_t)backgroundQueue {
	static dispatch_queue_t queue;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		queue = dispatch_queue_create("com.0x82.dropboxsync.filesystemqueue", DISPATCH_QUEUE_CONCURRENT);
	});
	
	return queue;
}

-(void)dealloc {
	[super dealloc];
	
	[[DBFilesystem sharedFilesystem] removeObserver:self];
}

-(void)listFolder:(id)args {
	enum {
		kArgPath = 0,
		kArgOptions,
		kArgCount = kArgOptions
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	NSDictionary *options; ENSURE_ARG_OR_NIL_AT_INDEX(options, args, kArgOptions, NSDictionary);
	
	KrollCallback *success; ENSURE_ARG_FOR_KEY(success, options, @"success", KrollCallback);
	KrollCallback *failure; ENSURE_ARG_FOR_KEY(failure, options, @"failure", KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFilesystemProxy backgroundQueue], ^{
		DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
		
		DBError *error = nil;
		NSArray *contents = [filesystem listFolder:pathProxy.path error:&error];
		
		if(!error) {
			NSMutableArray *fileInfoArray = [NSMutableArray arrayWithCapacity:[contents count]];
			for(DBFileInfo *fileInfo in contents) {
				Com0x82DropboxsyncFileInfoProxy *fileInfoProxy = [[Com0x82DropboxsyncFileInfoProxy alloc] _initWithPageContext:self.pageContext];
				fileInfoProxy.fileInfo = fileInfo;
				
				[fileInfoArray addObject:[fileInfoProxy autorelease]];
			}
			
			NSDictionary *event = @{ @"files" : fileInfoArray };
			if(success)
				[self _fireEventToListener:@"success" withObject:event listener:success thisObject:self];
		} else {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			if(failure)
				[self _fireEventToListener:@"failure" withObject:event listener:failure thisObject:self];
		}
	});
}

-(void)fileInfoForPath:(id)args {
	enum {
		kArgPath = 0,
		kArgOptions,
		kArgCount = kArgOptions
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	NSDictionary *options; ENSURE_ARG_OR_NIL_AT_INDEX(options, args, kArgOptions, NSDictionary);
	
	KrollCallback *success; ENSURE_ARG_FOR_KEY(success, options, @"success", KrollCallback);
	KrollCallback *failure; ENSURE_ARG_FOR_KEY(failure, options, @"failure", KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFilesystemProxy backgroundQueue], ^{
		DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
		
		DBError *error = nil;
		DBFileInfo *fileInfo = [filesystem fileInfoForPath:pathProxy.path error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			
			if(failure)
				[self _fireEventToListener:@"failure" withObject:event listener:failure thisObject:self];
		} else {
			Com0x82DropboxsyncFileInfoProxy *fileInfoProxy = [[[Com0x82DropboxsyncFileInfoProxy alloc] _initWithPageContext:self.pageContext] autorelease];
			fileInfoProxy.fileInfo = fileInfo;
			
			NSDictionary *event = @{ @"fileinfo" : fileInfoProxy };
			if(success)
				[self _fireEventToListener:@"success" withObject:event listener:success thisObject:self];
		}
	});
}

-(void)openFile:(id)args {
	enum {
		kArgPath = 0,
		kArgOptions,
		kArgCount = kArgOptions
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	NSDictionary *options; ENSURE_ARG_OR_NIL_AT_INDEX(options, args, kArgOptions, NSDictionary);
	
	KrollCallback *success; ENSURE_ARG_FOR_KEY(success, options, @"success", KrollCallback);
	KrollCallback *failure; ENSURE_ARG_FOR_KEY(failure, options, @"failure", KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFilesystemProxy backgroundQueue], ^{
		DBError *error = nil;
		DBFile *file = [[DBFilesystem sharedFilesystem] openFile:pathProxy.path error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			
			if(failure)
				[self _fireEventToListener:@"failure" withObject:event listener:failure thisObject:self];
		} else {
			Com0x82DropboxsyncFileProxy *fileProxy = [[[Com0x82DropboxsyncFileProxy alloc] _initWithPageContext:self.pageContext] autorelease];
			fileProxy.file = file;
			
			NSDictionary *event = @{ @"file" : fileProxy };
			if(success)
				[self _fireEventToListener:@"success" withObject:event listener:success thisObject:self];
		}
	});
}

-(void)createFile:(id)args {
	enum {
		kArgPath = 0,
		kArgOptions,
		kArgCount = kArgOptions
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	NSDictionary *options; ENSURE_ARG_OR_NIL_AT_INDEX(options, args, kArgOptions, NSDictionary);
	
	KrollCallback *success; ENSURE_ARG_FOR_KEY(success, options, @"success", KrollCallback);
	KrollCallback *failure; ENSURE_ARG_FOR_KEY(failure, options, @"failure", KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFilesystemProxy backgroundQueue], ^{
		DBError *error = nil;
		DBFile *file = [[DBFilesystem sharedFilesystem] createFile:pathProxy.path error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			
			if(failure)
				[self _fireEventToListener:@"failure" withObject:event listener:failure thisObject:self];
		} else {
			Com0x82DropboxsyncFileProxy *fileProxy = [[[Com0x82DropboxsyncFileProxy alloc] _initWithPageContext:self.pageContext] autorelease];
			fileProxy.file = file;
			
			NSDictionary *event = @{ @"file" : fileProxy };
			if(success)
				[self _fireEventToListener:@"success" withObject:event listener:success thisObject:self];
		}
	});
}

-(void)createFolder:(id)args {
	enum {
		kArgPath = 0,
		kArgOptions,
		kArgCount = kArgOptions
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	NSDictionary *options; ENSURE_ARG_OR_NIL_AT_INDEX(options, args, kArgOptions, NSDictionary);
	
	KrollCallback *success; ENSURE_ARG_FOR_KEY(success, options, @"success", KrollCallback);
	KrollCallback *failure; ENSURE_ARG_FOR_KEY(failure, options, @"failure", KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFilesystemProxy backgroundQueue], ^{
		DBError *error = nil;
		BOOL result = [[DBFilesystem sharedFilesystem] createFolder:pathProxy.path error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			
			if(failure)
				[self _fireEventToListener:@"failure" withObject:event listener:failure thisObject:self];
		} else {
			NSDictionary *event = @{ @"result" : @(result) };
			if(success)
				[self _fireEventToListener:@"success" withObject:event listener:success thisObject:self];
		}
	});
}

-(void)deletePath:(id)args {
	enum {
		kArgPath = 0,
		kArgOptions,
		kArgCount = kArgOptions
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	NSDictionary *options; ENSURE_ARG_OR_NIL_AT_INDEX(options, args, kArgOptions, NSDictionary);
	
	KrollCallback *success; ENSURE_ARG_FOR_KEY(success, options, @"success", KrollCallback);
	KrollCallback *failure; ENSURE_ARG_FOR_KEY(failure, options, @"failure", KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFilesystemProxy backgroundQueue], ^{
		DBError *error = nil;
		BOOL result = [[DBFilesystem sharedFilesystem] deletePath:pathProxy.path error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			
			if(failure)
				[self _fireEventToListener:@"failure" withObject:event listener:failure thisObject:self];
		} else {
			NSDictionary *event = @{ @"result" : @(result) };
			if(success)
				[self _fireEventToListener:@"success" withObject:event listener:success thisObject:self];
		}
	});
}

-(void)movePath:(id)args {
	enum {
		kArgOriginPath = 0,
		kArgDestinationPath,
		kArgOptions,
		kArgCount = kArgOptions
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *originPathProxy; ENSURE_ARG_AT_INDEX(originPathProxy, args, kArgOriginPath, Com0x82DropboxsyncPathProxy);
	Com0x82DropboxsyncPathProxy *destPathProxy; ENSURE_ARG_AT_INDEX(destPathProxy, args, kArgDestinationPath, Com0x82DropboxsyncPathProxy);
	NSDictionary *options; ENSURE_ARG_OR_NIL_AT_INDEX(options, args, kArgOptions, NSDictionary);
	
	KrollCallback *success; ENSURE_ARG_FOR_KEY(success, options, @"success", KrollCallback);
	KrollCallback *failure; ENSURE_ARG_FOR_KEY(failure, options, @"failure", KrollCallback);
	
	dispatch_async([Com0x82DropboxsyncFilesystemProxy backgroundQueue], ^{
		DBError *error = nil;
		BOOL result = [[DBFilesystem sharedFilesystem] movePath:originPathProxy.path toPath:destPathProxy.path error:&error];
		
		if(error) {
			NSDictionary *event = @{ @"error" : [error localizedDescription], @"code": @(error.code) };
			
			if(failure)
				[self _fireEventToListener:@"failure" withObject:event listener:failure thisObject:self];
		} else {
			NSDictionary *event = @{ @"result" : @(result) };
			if(success)
				[self _fireEventToListener:@"success" withObject:event listener:success thisObject:self];
		}
	});
}

/** @name Getting the current state */

-(Com0x82DropboxsyncAccountProxy *)account {
	Com0x82DropboxsyncAccountProxy *accountProxy = [[Com0x82DropboxsyncAccountProxy alloc] _initWithPageContext:self.pageContext];
	accountProxy.account = [[DBFilesystem sharedFilesystem] account];
	
	return [accountProxy autorelease];
}

-(NSNumber *)completedFirstSync {
	return @([[DBFilesystem sharedFilesystem] completedFirstSync]);
}

-(NSNumber *)isShuttingDown {
	return @([[DBFilesystem sharedFilesystem] isShutDown]);
}

-(NSNumber *)status {
	DBSyncStatus status = [[DBFilesystem sharedFilesystem] status];
	
	return @(status);
}

MAKE_SYSTEM_UINT(SYNC_STATUS_DOWNLOADING, DBSyncStatusDownloading);
MAKE_SYSTEM_UINT(SYNC_STATUS_UPLOADING, DBSyncStatusUploading);
MAKE_SYSTEM_UINT(SYNC_STATUS_SYNCING, DBSyncStatusSyncing);
MAKE_SYSTEM_UINT(SYNC_STATUS_ACTIVE, DBSyncStatusActive);

/** @name Watching for changes */

-(void)_listenerAdded:(NSString *)type count:(int)count {
	if([type isEqualToString:@"change"] && count == 1) {
    [[DBFilesystem sharedFilesystem] addObserver:self block:^{
      [self fireEvent:@"change" withObject:@{}];
    }];
  }
}

-(void)_listenerRemoved:(NSString *)type count:(int)count {
	if([type isEqualToString:@"change"] && count == 0) {
    [[DBFilesystem sharedFilesystem] removeObserver:self];
  }
}

-(void)observePath:(id)args {
	enum {
		kArgPath = 0,
		kArgCallback,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	KrollCallback *callback; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	if(callback) {
		[[DBFilesystem sharedFilesystem] addObserver:self forPath:pathProxy.path block:^{
			[self _fireEventToListener:@"path_changed" withObject:nil listener:callback thisObject:self];
		}];
	}
}

-(void)observePathAndChildren:(id)args {
	enum {
		kArgPath = 0,
		kArgCallback,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	KrollCallback *callback; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	if(callback) {
		[[DBFilesystem sharedFilesystem] addObserver:self forPathAndChildren:pathProxy.path block:^{
			[self _fireEventToListener:@"path_and_children_changed" withObject:nil listener:callback thisObject:self];
		}];
	}
}

-(void)observePathAndDescendants:(id)args {
	enum {
		kArgPath = 0,
		kArgCallback,
		kArgCount
	};
	
	ENSURE_ARG_COUNT(args, kArgCount);
	
	Com0x82DropboxsyncPathProxy *pathProxy; ENSURE_ARG_AT_INDEX(pathProxy, args, kArgPath, Com0x82DropboxsyncPathProxy);
	KrollCallback *callback; ENSURE_ARG_AT_INDEX(callback, args, kArgCallback, KrollCallback);
	
	if(callback) {
		[[DBFilesystem sharedFilesystem] addObserver:self forPathAndDescendants:pathProxy.path block:^{
			[self _fireEventToListener:@"path_and_descendants_changed" withObject:nil listener:callback thisObject:self];
		}];
	}
}

@end
