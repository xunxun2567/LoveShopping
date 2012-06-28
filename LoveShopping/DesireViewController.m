//
//  DesireViewController.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "DesireViewController.h"
#import "ItemManager.h"

@implementation DesireViewController

-(void)viewWillAppear:(BOOL)animated    {
    desiredItems = [[ItemManager defaultManager]desiredItems];
    NSLog(@"Desired items: %@", desiredItems);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
