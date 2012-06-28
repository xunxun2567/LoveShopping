//
//  ItemManager.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Brand.h"

@interface ItemManager : NSObject

+(ItemManager*)defaultManager;

-(NSArray*)desiredItems;
-(Item*)itemForBrand:(Brand*)brand offsetToHead:(int)offset;

@end
