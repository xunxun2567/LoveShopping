//
//  SettingViewController.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "SettingViewController.h"
#import "BrandManager.h"

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated    {
    allBrands = [[BrandManager defaultManager]allBrands];
    NSLog(@"All Brands: %@", allBrands);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
