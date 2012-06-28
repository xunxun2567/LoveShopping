//
//  ViewSwitcher.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brand.h"
#import <UIKit/UIKit.h>

@interface ViewSwitcher : NSObject <UITabBarControllerDelegate>

+(void)start;

+(void)switchToItem;
+(void)switchToBrand;
+(void)switchToItemView:(Brand*)brand;

@end
