//
//  Brand.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Brand : NSManagedObject

@property (nonatomic, retain) NSNumber * visible;
@property (nonatomic, retain) NSNumber * unread_count;
@property (nonatomic, retain) NSString * collector;
@property (nonatomic, retain) NSString * display_name;
@property (nonatomic, retain) NSNumber * head_index;
@property (nonatomic, retain) NSNumber * total_count;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSNumber * index;


@end
