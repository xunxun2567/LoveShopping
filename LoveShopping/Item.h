//
//  Item.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * leibie;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * desire;
@property (nonatomic, retain) NSString * image_url2;
@property (nonatomic, retain) NSString * collector;

@end
