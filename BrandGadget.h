//
//  BrandGadget.h
//  ShoppingMaster
//
//  Created by egibbon on 12-6-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@interface BrandGadget : UIView

@property (nonatomic, assign) Brand* brandToShow;
@property (nonatomic, strong) NSOperationQueue* queue;

-(void)initWithBrand:(Brand*)brand;
-(void)initWithLogo:(NSString*)logo;

@end
