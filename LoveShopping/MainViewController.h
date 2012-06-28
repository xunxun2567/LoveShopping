//
//  MainViewController.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@interface MainViewController : UIViewController <UITabBarDelegate, UIScrollViewDelegate> {
    NSArray* visibleBrands;
    Brand* activeBrand;
}

@property (nonatomic, strong) IBOutlet UIView* brandView;
@property (nonatomic, strong) IBOutlet UIView* itemView;
@property (strong, nonatomic) UIScrollView* brandScrollView;
@property (strong, nonatomic) UIPageControl* pageController;
@property (strong, nonatomic) Brand* activeBrand;

-(IBAction)viewBrand:(id)sender;

-(IBAction)desireTouched:(id)sender;
-(IBAction)browseTouched:(id)sender;
-(IBAction)shopTouched:(id)sender;
-(IBAction)weiboTouched:(id)sender;

@end
