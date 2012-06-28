//
//  ShopManager.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "ShopManager.h"
#import "UpdateManager.h"
#import <CoreData/CoreData.h>

@implementation ShopManager

ShopManager* shopManager;

+(ShopManager*)defaultManager {
    if (!shopManager)   {
        shopManager = [[ShopManager alloc]init];
    }
    return shopManager;
}

-(NSManagedObjectContext*)context   {
    return [[UpdateManager defaultManager]objectContext];
}

-(NSArray*)shopsForBrand:(Brand*)brand  {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shop" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collector == %@", brand.collector];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];

    
    return results;
}

@end
