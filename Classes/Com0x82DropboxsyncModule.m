/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "Com0x82DropboxsyncModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

#import "Com0x82DropboxsyncAccountProxy.h"
#import "Com0x82DropboxsyncPathProxy.h"

#import <Dropbox/Dropbox.h>
#define DropboxLoginResult @"DropboxLoginResult"

#import "JRSwizzle.h"

@implementation TiApp (Dropbox)

-(BOOL)dropboxApplication:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation {
	[TiApp jr_swizzleMethod:@selector(application:openURL:sourceApplication:annotation:) withMethod:@selector(dropboxApplication:openURL:sourceApplication:annotation:) error:nil];
	BOOL res = [self application:app openURL:url sourceApplication:source annotation:annotation];
	[TiApp jr_swizzleMethod:@selector(application:openURL:sourceApplication:annotation:) withMethod:@selector(dropboxApplication:openURL:sourceApplication:annotation:) error:nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:DropboxLoginResult object:self];
	
	return res;
}

-(BOOL)dropboxApplication:(UIApplication *)app handleOpenURL:(NSURL *)url {
	[TiApp jr_swizzleMethod:@selector(application:handleOpenURL:) withMethod:@selector(dropboxApplication:handleOpenURL:) error:nil];
	BOOL res = [self application:app handleOpenURL:url];
	[TiApp jr_swizzleMethod:@selector(application:handleOpenURL:) withMethod:@selector(dropboxApplication:handleOpenURL:) error:nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:DropboxLoginResult object:self];
	
	return res;
}

@end

@implementation Com0x82DropboxsyncModule {
	KrollCallback *authenticateSuccessCallback, *authenticateCancelCallback;
}

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"9e972c57-fe1b-4a38-bac9-4cbe2e2cb22e";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.0x82.dropboxsync";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	if([[TiApp app] respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
		NSError *error = nil;
		[TiApp jr_swizzleMethod:@selector(application:openURL:sourceApplication:annotation:) withMethod:@selector(dropboxApplication:openURL:sourceApplication:annotation:) error:&error];
		if(error)
			NSLog(@"[WARN] Cannot swizzle openURL delegate: %@", error);
	}
	
	if([[TiApp app] respondsToSelector:@selector(application:handleOpenURL:)]) {
		NSError *error = nil;
		[TiApp jr_swizzleMethod:@selector(application:handleOpenURL:) withMethod:@selector(dropboxApplication:handleOpenURL:) error:&error];
		if(error)
			NSLog(@"[WARN] Cannot swizzle handleOpenURL delegate: %@", error);
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumed:) name:DropboxLoginResult object:nil];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// you *must* call the superclass
	[super shutdown:sender];
}

-(void)resumed:(id)sender {
	[super resumed:sender];
	
	NSDictionary *launchOptions = [[TiApp app] launchOptions];
	if(launchOptions != nil) {
		NSString *urlString = [launchOptions objectForKey:@"url"];
		if(urlString != nil && [urlString hasPrefix:@"db"]) {
			NSURL *url = [NSURL URLWithString:urlString];
			
			DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
			if(account) {
				DBFilesystem *filesystem = [[[DBFilesystem alloc] initWithAccount:account] autorelease];
				[DBFilesystem setSharedFilesystem:filesystem];
				
				NSLog(@"App linked successfully!");
			}
		}
	}
}

#pragma mark Cleanup 

-(void)configure:(id)args {
	ENSURE_UI_THREAD_1_ARG(args)
	
	enum {
		kAppKey = 0,
		kAppSecret,
		kArgsCount
	};
	
	ENSURE_ARG_COUNT(args, kArgsCount);
	
	NSString *appKey; ENSURE_ARG_AT_INDEX(appKey, args, kAppKey, NSString);
	NSString *appSecret; ENSURE_ARG_AT_INDEX(appSecret, args, kAppSecret, NSString);
	
	if(!appKey || !appSecret)
		[self throwException:@"missing key or secret" subreason:nil location:CODELOCATION];
	
	DBAccountManager *accountMgr = [[[DBAccountManager alloc] initWithAppKey:appKey secret:appSecret] autorelease];
	[DBAccountManager setSharedManager:accountMgr];
	DBAccount *account = accountMgr.linkedAccount;
	
	if(account) {
		DBFilesystem *filesystem = [[[DBFilesystem alloc] initWithAccount:account] autorelease];
		[DBFilesystem setSharedFilesystem:filesystem];
	}
	
	[[DBAccountManager sharedManager] addObserver:self block:^(DBAccount *account) {
		Com0x82DropboxsyncAccountProxy *accountProxy = [[[Com0x82DropboxsyncAccountProxy alloc] _initWithPageContext:self.pageContext] autorelease];
		accountProxy.account = account;
		
		NSDictionary *event = @{ @"account" : accountProxy };
		[self fireEvent:@"registration_change" withObject:event];
	}];
}

-(id)linkedAccount {
	DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
	if(account) {
		Com0x82DropboxsyncAccountProxy *accountProxy = [[Com0x82DropboxsyncAccountProxy alloc] _initWithPageContext:self.pageContext];
		accountProxy.account = account;
		
		return [accountProxy autorelease];
	} else {
		return nil;
	}
}

-(void)link:(id)args {
	ENSURE_UI_THREAD_0_ARGS
	
	[[DBAccountManager sharedManager] linkFromController:[TiApp controller]];
}

-(Com0x82DropboxsyncPathProxy *)getPath:(id)args {
	NSString *pathString; ENSURE_ARG_AT_INDEX(pathString, args, 0, NSString);
	
	DBPath *path = [[DBPath alloc] initWithString:pathString];
	Com0x82DropboxsyncPathProxy *pathProxy = [[Com0x82DropboxsyncPathProxy alloc] _initWithPageContext:self.pageContext];
	pathProxy.path = [path autorelease];
	
	return [pathProxy autorelease];
}

MAKE_SYSTEM_NUMBER(ERROR_UNKNOWN, DBErrorUnknown)
MAKE_SYSTEM_NUMBER(ERROR_CORE_SYSTEM, DBErrorCoreSystem)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS, DBErrorParams)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS_INVALID, DBErrorParamsInvalid)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS_NOTFOUND, DBErrorParamsNotFound)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS_EXISTS, DBErrorParamsExists)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS_ALREADY_OPEN, DBErrorParamsAlreadyOpen)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS_PARENT, DBErrorParamsParent)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS_NOT_EMPTY, DBErrorParamsNotEmpty)
MAKE_SYSTEM_NUMBER(ERROR_PARAMS_NOT_CACHED, DBErrorParamsNotCached)
MAKE_SYSTEM_NUMBER(ERROR_SYSTEM, DBErrorSystem)
MAKE_SYSTEM_NUMBER(ERROR_SYSTEM_DISK_SPACE, DBErrorSystemDiskSpace)
MAKE_SYSTEM_NUMBER(ERROR_NETWORK, DBErrorNetwork)
MAKE_SYSTEM_NUMBER(ERROR_NETWORK_TIMEOUT, DBErrorNetworkTimeout)
MAKE_SYSTEM_NUMBER(ERROR_NETWORK_NO_CONNECTION, DBErrorNetworkNoConnection)
MAKE_SYSTEM_NUMBER(ERROR_NETWORK_SSL, DBErrorNetworkSSL)
MAKE_SYSTEM_NUMBER(ERROR_NETWORK_SERVER, DBErrorNetworkServer)
MAKE_SYSTEM_NUMBER(ERROR_AUTH, DBErrorAuth)
MAKE_SYSTEM_NUMBER(ERROR_AUTH_UNLINKED, DBErrorAuthUnlinked)
MAKE_SYSTEM_NUMBER(ERROR_AUTH_INVALID_APP, DBErrorAuthInvalidApp)

@end
