//
//  UpdateManager.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface UpdateManager : NSObject {
    NSURL* serverURL;
    NSManagedObjectContext* objectContext;
    NSUserDefaults* userDefaults;
    NSOperationQueue* queue;
    NSString* cacheRoot;
    NSURL* documentDirectory;
    Reachability* internetReachability;
}

// get the update manager
+(UpdateManager*)defaultManager;

-(void)start;

@end
