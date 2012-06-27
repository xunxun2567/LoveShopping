//
//  UpdateManager.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-27.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "UpdateManager.h"

@implementation UpdateManager

UpdateManager* manager;

+(UpdateManager*)defaultManager {
    if (!manager)   {
        manager = [[UpdateManager alloc]init];
    }
    return manager;
}

-(id)init   {
    self = [super init];
    if (self != nil)    {
        
    }
    return self;
}

@end
