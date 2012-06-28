//
//  MainViewController.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "MainViewController.h"
#import "ViewSwitcher.h"
#import "UpdateManager.h"
#import "BrandManager.h"
#import "ItemManager.h"
#import "Item.h"
#import "Brand.h"

@implementation MainViewController

@synthesize brandView = _brandView;
@synthesize itemView = _itemView;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)viewItem:(id)sender    {
    [ViewSwitcher switchToItem];
    activeBrand = [[BrandManager defaultManager]getBrand:@"Forever21Collector"];
    NSLog(@"Active brand: %@", activeBrand);
    
    Item* head = [[ItemManager defaultManager]itemForBrand:activeBrand offsetToHead:0];
    NSLog(@"Current item: %@", head);
    
    Item* prev = [[ItemManager defaultManager]itemForBrand:activeBrand offsetToHead:-1];
    NSLog(@"Previous item: %@", prev);
    
    Item* next = [[ItemManager defaultManager]itemForBrand:activeBrand offsetToHead:1];
    NSLog(@"Next item: %@", next);
    
    Brand* previousBrand = [[BrandManager defaultManager]getVisibleBrand:activeBrand withOffset:-1];
    NSLog(@"Previous brand: %@", previousBrand);

    Brand* nextBrand = [[BrandManager defaultManager]getVisibleBrand:activeBrand withOffset:1];
    NSLog(@"Next brand: %@", nextBrand);
}

-(IBAction)viewBrand:(id)sender    {
    [ViewSwitcher switchToBrand];
    visibleBrands = [[BrandManager defaultManager]allVisibleBrands];
    NSLog(@"Visible brands: %@", visibleBrands);    
}

@end
