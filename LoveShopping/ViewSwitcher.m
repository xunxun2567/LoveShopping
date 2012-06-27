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
#import "AboutViewController.h"

@implementation ViewSwitcher

ViewSwitcher* instance;

UIWindow* mainWindow;
MainViewController* mainViewController;
ItemViewController* itemViewController;
SettingViewController* settingViewController;
DesireViewController* desireViewController;
AboutViewController* aboutViewController;

UITabBarController* mainTabBarController;

+(void)start    {
    
    mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainTabBarController = [[UITabBarController alloc]init];
    
    mainViewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    mainViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"浏览商品" image:nil tag:0];
    [mainTabBarController addChildViewController:mainViewController];
    
    settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    settingViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"关注品牌" image:nil tag:1];
    [mainTabBarController addChildViewController:settingViewController];
    
    desireViewController = [[DesireViewController alloc]initWithNibName:@"DesireViewController" bundle:nil];
    desireViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"欲望清单" image:nil tag:2];
    [mainTabBarController addChildViewController:desireViewController];
    
    aboutViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    aboutViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"天生购物狂" image:nil tag:3];
    [mainTabBarController addChildViewController:aboutViewController];
    
    itemViewController = [[ItemViewController alloc]initWithNibName:@"ItemViewController" bundle:nil];
    
    [ViewSwitcher switchToMain];
    [mainWindow makeKeyAndVisible];
}

+(void)switchToMain {    
    mainWindow.rootViewController = mainTabBarController;
}

@end
