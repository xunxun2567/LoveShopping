//
//  ItemManager.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "ItemManager.h"
#import "UpdateManager.h"
#import "Brand.h"
#import "Item.h"
#import <CoreData/CoreData.h>

@implementation ItemManager

ItemManager* itemManager;

+(ItemManager*)defaultManager {
    if (!itemManager)   {
        itemManager = [[ItemManager alloc]init];
    }
    return itemManager;
}

-(NSManagedObjectContext*)context   {
    return [[UpdateManager defaultManager]objectContext];
}

-(Item*)itemForBrand:(Brand*)brand offsetToHead:(int)offset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collector == %@", brand.collector];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    int index;
    index =  brand.head_index.intValue + offset;
    if (index < 0) return nil;
    if (index >= [results count] - 1) return nil;
    
    return [results objectAtIndex:index];
}

-(NSArray*)desiredItems {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"desire = 0"];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    return results;
}

@end
