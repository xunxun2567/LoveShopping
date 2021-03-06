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
    NSUserDefaults* userDefaults;
    NSOperationQueue* queue;
    NSString* cacheRoot;
    NSURL* documentDirectory;
    Reachability* internetReachability;
}

@property (strong, nonatomic) NSManagedObjectContext* objectContext;

+(UpdateManager*)defaultManager;

-(void)start;
-(void)update;

@end
