//
//  BrandManager.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@interface BrandManager : NSObject

+(BrandManager*)defaultManager;

-(NSArray*)allVisibleBrands;
-(NSArray*)allBrands;
-(Brand*)getBrand:(NSString*)collector;
-(Brand*)getVisibleBrand:(Brand*)brand withOffset:(int)offset;

@end
