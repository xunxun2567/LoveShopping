//
//  BrandManager.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "BrandManager.h"
#import "UpdateManager.h"
#import "Brand.h"
#import <CoreData/CoreData.h>

@implementation BrandManager

BrandManager* brandManager;

+(BrandManager*)defaultManager {
    if (!brandManager)   {
        brandManager = [[BrandManager alloc]init];
    }
    return brandManager;
}

-(NSManagedObjectContext*)context   {
    return [[UpdateManager defaultManager]objectContext];
}

-(Brand*)getBrand:(NSString*)collector    {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collector == %@", collector];
    [request setPredicate:predicate];
    
    NSMutableArray* mutableFetchResults = [[[self context] executeFetchRequest:request error:nil] mutableCopy];        
    [request release];    
    
    if (mutableFetchResults.count == 0)
        return nil;
    else
        return [mutableFetchResults objectAtIndex:0];
}

-(NSArray*)allBrands    {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];    
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    return results;
}

-(NSArray*)allVisibleBrands {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visible == 1"];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    return results;
}

-(Brand*)getVisibleBrand:(Brand*)brand withOffset:(int)offset  {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:[self context]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"index == %d", brand.index.intValue + offset];
    [request setPredicate:predicate];
    
    NSArray* results = [[[self context] executeFetchRequest:request error:nil]copy];
    [request release];
    
    if ([results count] == 0) return nil;
    
    Brand* result = [results objectAtIndex:0];
    if (result.visible.intValue == 1)
        return result;
    
    if ([result.collector isEqualToString:brand.collector]) {
        return nil;
    }
    return [self getVisibleBrand:result withOffset:offset];    
}

@end
