//
//  ShopManager.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@interface ShopManager : NSObject

+(ShopManager*)defaultManager;

-(NSArray*)shopsForBrand:(Brand*)brand;

@end
