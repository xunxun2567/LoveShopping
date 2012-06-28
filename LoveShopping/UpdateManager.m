//
//  UpdateManager.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "UpdateManager.h"
#import "BrandManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSONKit.h"
#import "Brand.h"
#import "Item.h"
#import "Shop.h"
#import <CoreData/CoreData.h>

@implementation UpdateManager

@synthesize objectContext;

UpdateManager* updateManager;

+(UpdateManager*)defaultManager {
    if (!updateManager)   {
        updateManager = [[UpdateManager alloc]init];
    }
    return updateManager;
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
    if (![userDefaults objectForKey:@"last_config"]) {
        NSLog(@"First run. Loading init config from server...");  
        
        NSString* requestString = [NSString stringWithFormat:@"http://%@/init_config", serverURL];
        NSURL* url = [NSURL URLWithString:requestString];
        NSLog(@"Reading config from URL: %@", requestString);
        
        NSString* responseText = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        int brandIndex = 0;
        if (responseText)   {        
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
                newBrand.index = [NSNumber numberWithInt:brandIndex];
                NSLog(@"Brand added: %@", newBrand.display_name);
                brandIndex++;
                
                for (NSString* address in [dict objectForKey:@"store_address"]) {
                    Shop* shop = [NSEntityDescription insertNewObjectForEntityForName:@"Shop" inManagedObjectContext:objectContext];
                    shop.collector = newBrand.collector;
                    shop.address = address;
                }
                NSLog(@"%d Shops added.", [[dict objectForKey:@"store_address"] count]);
            }
            if ([objectContext save:nil])   {
                NSDate* today = [NSDate dateWithTimeIntervalSinceNow:0];
                [userDefaults setObject:today forKey:@"last_config"];
                if ([userDefaults synchronize]) {
                    NSLog(@"Init config successfully!");   
                    [self update];
                };
            }        
        }
        else {
            NSLog(@"Cannot connect to server, fail to start...");
        }
    }
}

-(NSString*)makeRequestString   {
    NSDate* lastUpdate = [userDefaults objectForKey:@"last_update"];
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YMMddHHmm"];
    
    NSString* queryString = @"";
    NSString* requestString = @"";
    if (!lastUpdate)  {
        NSLog(@"last_update not found in NSUserDefaults, this seems to be your first run.");
        queryString = [@"init=1" copy];
    }
    else {
        queryString = [NSString stringWithFormat:@"prev_update=%@", [format stringFromDate:lastUpdate]];
    }
    requestString = [NSString stringWithFormat:@"http://%@/api/?key=timeline&%@", serverURL, queryString];
    return requestString;
}

-(void)updateToContext:(NSMutableDictionary*)dict   {    
    NSMutableArray* operationArray = [[NSMutableArray alloc]init];
    
    for (NSString* key in [dict allKeys]) {
        Brand* brand = [[BrandManager defaultManager]getBrand:key];
        
        NSArray* arr = [dict objectForKey:key];
        NSLog(@"collector: %@, %d objects", key, [arr count]);
        for (NSDictionary* objectDict in arr)   {  
            Item* item = (Item*)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:objectContext];
            item.url = [objectDict objectForKey:@"url"];
            item.image_url = [objectDict objectForKey:@"image_url"];
            item.image_url2 = [objectDict objectForKey:@"image_url2"];
            item.price = [objectDict objectForKey:@"price"];
            item.time = [objectDict objectForKey:@"time"];
            item.title = [objectDict objectForKey:@"title"];
            item.leibie = [objectDict objectForKey:@"leibie"];
            item.unread = [NSNumber numberWithInt:1];
            item.desire = [NSNumber numberWithInt:0];
            item.collector = key;
            
            brand.unread_count = [NSNumber numberWithInt:[brand.unread_count intValue] + 1];
            brand.total_count = [NSNumber numberWithInt:[brand.total_count intValue] + 1];
            
            NSInvocationOperation* operation=[[NSInvocationOperation alloc]initWithTarget:self
                                                                                  selector:@selector(getImage:)
                                                                                    object:item.image_url];
            [operationArray addObject:operation];
        }
        NSLog(@"Updated: %@ - %@ / %@", brand.display_name, brand.unread_count, brand.total_count);
    }
    [queue setSuspended:YES];
    [queue addOperations:operationArray waitUntilFinished:NO];
    [operationArray release];
    [self checkNetworkStatus:nil];
    
    [objectContext save:nil];
}

-(void)update   {
    NSLog(@"Starting update.");
    
    NSString* requestString = [self makeRequestString];
    NSLog(@"Query string formed as: %@", requestString);
    
    NSURL* url = [NSURL URLWithString:requestString];
    NSString* responseText = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary* dict = [responseText mutableObjectFromJSONString];
    NSMutableDictionary* content = [dict objectForKey:@"content"];
    if (content != nil) {
        [self updateToContext:content];
        NSDate* today = [NSDate dateWithTimeIntervalSinceNow:0];
        [userDefaults setObject:today forKey:@"last_update"];
        [userDefaults synchronize];
        NSLog(@"Update successful at time: %@", today);
        [self checkNetworkStatus:nil];
    }
    else {
        NSLog(@"Update failed! cannot connect to server.");
    }
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
            //[queue setSuspended:NO];
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

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

-(UIImage*)getImage:(NSString*)imageUrl {
    if (!imageUrl) {
        NSLog(@"Empty image url: %@", imageUrl);
        return nil;
    }
    
    NSString* filename = [cacheRoot stringByAppendingPathComponent: [self sha1:imageUrl]];    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filename])    {
        NSLog(@"Image found in cache...");
        UIImage* image = [UIImage imageWithContentsOfFile:filename];
        return image;
    }
    
    NSURL* url = [NSURL URLWithString:imageUrl];    
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (![manager createFileAtPath:filename contents:data attributes:nil])  {
        NSLog(@"Failed to create the cache file!");
        return nil;
    }
    
    NSLog(@"Cached ++.");
    UIImage* image = [UIImage imageWithData:data];    
    return image;
}

@end
