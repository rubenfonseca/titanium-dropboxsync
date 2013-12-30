//
//  Com0x82DropboxsyncDataStoreProxy.m
//  dropboxsync
//
//  Created by Ruben Fonseca on 17/07/13.
//
//

#import "Com0x82DropboxsyncDataStoreProxy.h"

#import "Com0x82DropboxsyncAccountProxy.h"

@implementation Com0x82DropboxsyncDataStoreProxy {
	DBDatastore *dataStore;
}

-(void)_initWithProperties:(NSDictionary *)properties {
	[super _initWithProperties:properties];
	
	Com0x82DropboxsyncAccountProxy *accountProxy = [properties valueForKey:@"account"];
	DBAccount *account = accountProxy.account;
	
	DBDatastoreManager *storeManager = [DBDatastoreManager managerForAccount:account];
	
	DBError *error;
	dataStore = [storeManager openDefaultDatastore:&error];
	if(error)
		NSLog(@"Error opening default datastore: %@", error);
}

@end
