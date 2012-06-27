//
//  MainViewController.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "MainViewController.h"
#import "ViewSwitcher.h"

@implementation MainViewController

@synthesize brandView = _brandView;
@synthesize itemView = _itemView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)viewItem:(id)sender    {
    [ViewSwitcher switchToItem];
}

-(IBAction)viewBrand:(id)sender    {
    [ViewSwitcher switchToBrand];
}

@end
