//
//  ViewSwitcher.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "ViewSwitcher.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "DesireViewController.h"
#import "AboutViewController.h"

@implementation ViewSwitcher

ViewSwitcher* instance;

UIWindow* mainWindow;
MainViewController* mainViewController;
SettingViewController* settingViewController;
DesireViewController* desireViewController;
AboutViewController* aboutViewController;

UITabBarController* mainTabBarController;

+(void)start    {
    
    mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainTabBarController = [[UITabBarController alloc]init]; 
     
    mainViewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    mainViewController.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"新货" image:nil tag:0]autorelease];
    [mainTabBarController addChildViewController:mainViewController];
    
    settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    settingViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"品牌" image:nil tag:1];
    [mainTabBarController addChildViewController:settingViewController];
    
    desireViewController = [[DesireViewController alloc]initWithNibName:@"DesireViewController" bundle:nil];
    desireViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"欲望" image:nil tag:2];
    [mainTabBarController addChildViewController:desireViewController];
    
    aboutViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    aboutViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"关于" image:nil tag:3];
    [mainTabBarController addChildViewController:aboutViewController];
        
    mainWindow.rootViewController = mainTabBarController;
    
    [mainWindow makeKeyAndVisible];

    [ViewSwitcher switchToItem];
    [ViewSwitcher switchToBrand];
}

+(void)switchToItem   {
    mainTabBarController.selectedIndex = 0;
    [UIView beginAnimations:@"flip1" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mainViewController.itemView cache:YES];
    mainViewController.view = mainViewController.itemView;
    [UIView commitAnimations];
}

+(void)switchToBrand   {
    mainTabBarController.selectedIndex = 0;
    [UIView beginAnimations:@"flip2" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:mainViewController.brandView cache:YES];
    mainViewController.view = mainViewController.brandView;
    [UIView commitAnimations];
}

@end
