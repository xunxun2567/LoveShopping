//
//  AppDelegate.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewSwitcher.h"
#import "UpdateManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UpdateManager defaultManager]start];
    [ViewSwitcher start];
    return YES;
}

@end
