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
#import "BrandGadget.h"

@implementation MainViewController

@synthesize brandView = _brandView;
@synthesize itemView = _itemView;

@synthesize brandScrollView;
@synthesize pageController;

@synthesize activeBrand;

#define BRAND_PAGE_SIZE 12.0f
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480

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

-(void)viewDidLoad  {
    [super viewDidLoad];
    
    visibleBrands = [[BrandManager defaultManager] allVisibleBrands];
    int pages = ceil([visibleBrands count] / BRAND_PAGE_SIZE);
    
    CGSize contentSize = CGSizeMake(SCREEN_WIDTH * pages, SCREEN_HEIGHT - 45);
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45);
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:rect];
    background.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:background];
    [background release];

    self.brandScrollView = [[UIScrollView alloc]initWithFrame:rect];
    [self.brandScrollView setContentSize:contentSize];
    self.brandScrollView.delegate = self;
    self.brandScrollView.pagingEnabled = YES;    
    self.brandScrollView.showsHorizontalScrollIndicator = NO;
    self.brandScrollView.bounces = YES;
    [self.view addSubview:self.brandScrollView];
    
    CGRect pageRect = CGRectMake(0, 3, 320, 10);
    pageController = [[UIPageControl alloc] initWithFrame:pageRect];
    pageController.numberOfPages = pages;
    pageController.currentPage = 0;    
    [self.brandView addSubview:pageController];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageController setCurrentPage:offset.x / bounds.size.width];
}

-(void)viewWillAppear:(BOOL)animated    {
    for (UIView* view in self.brandScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    visibleBrands = [[BrandManager defaultManager] allVisibleBrands];
    int row = 0;
    int column = 0;
    int page = 0;
    int width = 80;
    int height = 80;
    
    for (Brand* brand in visibleBrands)    {
        CGRect rect = CGRectMake(18 + column * (width + 20) + SCREEN_WIDTH * page,
                                 18 + row * (height + 20), 
                                 width, height);
        
        BrandGadget* brandGadget = [[BrandGadget alloc]initWithFrame:rect];
        [brandGadget initWithBrand:brand];
        [self.brandScrollView addSubview:brandGadget];
        
        
        //        UIView *frontView = [[UIView alloc]initWithFrame:rect];
        //        frontView.backgroundColor = [UIColor grayColor];
        //        frontView.alpha = 0.3;
        //        CALayer *brandGadgetLayer = [frontView layer];
        //        [brandGadgetLayer setMasksToBounds:NO];
        //        [brandGadgetLayer setCornerRadius:9.5];
        //        [self.brandScrollView addSubview:frontView];
        
        
        
        column++;
        if (column == 3) {
            row++;
            column = 0;
        }
        if (row == 4)   {
            row = 0;
            page++; 
        }
        
    }
}

@end
