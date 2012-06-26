//
//  ViewSwitcher.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "ViewSwitcher.h"
#import "MainViewController.h"
#import "ItemViewController.h"
#import "SettingViewController.h"
#import "DesireViewController.h"

@implementation ViewSwitcher

ViewSwitcher* instance;

UIWindow* mainWindow;
MainViewController* mainViewController;
ItemViewController* itemViewController;
SettingViewController* settingViewController;
DesireViewController* desireViewController;

+(void)start    {
    mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainViewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    itemViewController = [[ItemViewController alloc]initWithNibName:@"ItemViewController" bundle:nil];
    settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    desireViewController = [[DesireViewController alloc]initWithNibName:@"DesireViewController" bundle:nil];
    
    [ViewSwitcher switchToMain];
    [mainWindow makeKeyAndVisible];
}

+(void)switchToMain {
    mainWindow.rootViewController = mainViewController;
}

@end
