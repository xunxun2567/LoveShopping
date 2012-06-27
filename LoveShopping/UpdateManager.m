//
//  UpdateManager.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "UpdateManager.h"
#import "JSONKit.h"
#import "Brand.h"
#import "Shop.h"
#import <CoreData/CoreData.h>

@implementation UpdateManager

UpdateManager* manager;

+(UpdateManager*)defaultManager {
    if (!manager)   {
        manager = [[UpdateManager alloc]init];
    }
    return manager;
}

-(id)init   {
    self = [super init];
    if (self != nil)    {
        NSString* configFile = [[NSBundle mainBundle]pathForResource:@"config" ofType:@"plist"];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:configFile];
            
        NSString* serverAddress = [dict objectForKey:@"server_address"];
        NSString* databaseFile = [dict objectForKey:@"database_file"];
        NSLog(@"Database file: %@", databaseFile);
        
        documentDirectory = [[[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]objectAtIndex:0]retain];            
        NSURL* databaseFilepath = [documentDirectory URLByAppendingPathComponent:databaseFile];
            
        serverURL = [[NSURL URLWithString:serverAddress]retain];
        NSLog(@"Server address:%@", serverURL);
            
        NSManagedObjectModel* objectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
        NSPersistentStoreCoordinator* coordinator = [[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:objectModel]retain];
        NSPersistentStore* store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseFilepath options:nil error:nil];
        if (!store)   {
            NSLog(@"Critical: cannot init persistence store, check the db file!");
            abort();
        }
        objectContext = [[NSManagedObjectContext alloc]init];
        [objectContext setPersistentStoreCoordinator:coordinator];
        NSLog(@"Database connection was setup successfully.");
            
        userDefaults = [NSUserDefaults standardUserDefaults];
        queue = [[NSOperationQueue alloc]init];
        static int MAX_OPERATION_COUNT = 12;
        [queue setMaxConcurrentOperationCount:MAX_OPERATION_COUNT];
        NSLog(@"Operation queue initiated. Max threads: %d", MAX_OPERATION_COUNT);
            
        cacheRoot = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]retain];
        NSLog(@"Cache root:%@", cacheRoot);
            
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
            
        internetReachability = [[Reachability reachabilityForInternetConnection]retain];
        [internetReachability startNotifier];
        NSLog(@"Watching for internet connection change.");
        
        //[self checkNetworkStatus:nil];
    }
    return self;
}

-(void)start    {
    if (![self lastUpdate]) {
        NSLog(@"First run. Loading init config from server...");
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"正在初始化" message:@"请稍后" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];    
        
        NSString* requestString = [NSString stringWithFormat:@"http://%@/init_config", serverURL];
        NSURL* url = [NSURL URLWithString:requestString];
        NSLog(@"Reading config from URL: %@", requestString);
        
        NSString* responseText = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray* array = [responseText mutableObjectFromJSONString];
        for (NSDictionary* dict in array)   {            
            Brand* newBrand = [NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:objectContext];
            newBrand.collector = [dict objectForKey:@"collector"];
            
            NSString* logoUrlString = [NSString stringWithFormat:@"http://%@/%@", serverURL, [dict objectForKey:@"logo_url"]];
            NSString* filename = [[documentDirectory path] stringByAppendingPathComponent: newBrand.collector];
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString: logoUrlString]];
            
            if (![[NSFileManager defaultManager]createFileAtPath:filename contents:data attributes:nil])    {
                NSLog(@"Failed to get brand logo!");
            };
            
            newBrand.logo = filename;
            newBrand.display_name = [dict objectForKey:@"display_name"];
            newBrand.unread_count = [NSNumber numberWithInt:0];
            newBrand.head_index = [NSNumber numberWithInt:0];
            newBrand.total_count = [NSNumber numberWithInt:0];
            newBrand.visible = [NSNumber numberWithInt:1];
            NSLog(@"Brand added: %@", newBrand.display_name);
            
            for (NSString* address in [dict objectForKey:@"store_address"]) {
                NSLog(@"   Shop address: %@", address);
                Shop* shop = [NSEntityDescription insertNewObjectForEntityForName:@"Shop" inManagedObjectContext:objectContext];
                shop.collector = newBrand.collector;
                shop.address = address;
            }
        }
        [objectContext save:nil];
                
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert release];
    }
}

-(NSString*)lastUpdate  {
    return [userDefaults objectForKey:@"last_update"];
}

-(void)checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down. Queue suspended."); 
            [queue setSuspended:YES];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI. Queue continued."); 
            [queue setSuspended:NO];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN. Queue suspended.");
            [queue setSuspended:YES];
            break;
        }
    }
}

-(void)dealloc  {
    [objectContext release];    
    [super dealloc];
}

@end
