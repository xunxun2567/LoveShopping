//
//  MainViewController.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@interface MainViewController : UIViewController <UITabBarDelegate> {
    NSArray* visibleBrands;
    Brand* activeBrand;
}

@property (nonatomic, strong) IBOutlet UIView* brandView;
@property (nonatomic, strong) IBOutlet UIView* itemView;

-(IBAction)viewItem:(id)sender;
-(IBAction)viewBrand:(id)sender;

@end
