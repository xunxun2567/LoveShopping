//
//  Shop.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Shop : NSManagedObject

@property (nonatomic, retain) NSString * collector;
@property (nonatomic, retain) NSString * address;

@end
