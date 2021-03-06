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
UITabBarController *tabbar_controller;
UIWindow* mainWindow;
MainViewController* mainViewController;
SettingViewController* settingViewController;
DesireViewController* desireViewController;
AboutViewController* aboutViewController;

UITabBarController* mainTabBarController;

+(void)start    {
    
    mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    mainTabBarController = [[UITabBarController alloc]init];
    [mainTabBarController.tabBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar.png"]]];
    
    mainViewController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    mainViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"更新" image:nil tag:0];
    [mainViewController.tabBarItem setImage:[UIImage imageNamed:@"logo1.png"]];
    [mainTabBarController addChildViewController:mainViewController];
    
    settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    settingViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"关注品牌" image:nil tag:1];
    [settingViewController.tabBarItem setImage:[UIImage imageNamed:@"logo2.png"]];
    [mainTabBarController addChildViewController:settingViewController];
    
    desireViewController = [[DesireViewController alloc]initWithNibName:@"DesireViewController" bundle:nil];
    desireViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"帮助" image:nil tag:2];
    [desireViewController.tabBarItem setImage:[UIImage imageNamed:@"logo3.png"]];
    [mainTabBarController addChildViewController:desireViewController];
    
    aboutViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    aboutViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"搜索品牌" image:nil tag:3];
    [aboutViewController.tabBarItem setImage:[UIImage imageNamed:@"logo4.png"]];
    
    [mainTabBarController addChildViewController:aboutViewController];
        
    mainWindow.rootViewController = mainTabBarController;
    [mainWindow addSubview:mainViewController.popupDesire];
    
   

    
    [mainWindow makeKeyAndVisible];

    [ViewSwitcher switchToItemView:nil];
    [ViewSwitcher switchToBrand];
        
}

+(void)registerPopup:(UIView*)popup {
    NSLog(@"Popup: %@", popup);
    [popup removeFromSuperview];
   
    [mainWindow.rootViewController.view addSubview:popup];
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

+(void)switchToItemView:(Brand*)brand{
    if(brand){
        mainViewController.activeBrand = brand;
    }
    mainTabBarController.selectedIndex = 0;
    [UIView beginAnimations:@"flip1" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mainViewController.itemView cache:YES];
    mainViewController.view = mainViewController.itemView;
    [UIView commitAnimations];}

@end
