//
//  BrandGadget.m
//  ShoppingMaster
//
//  Created by egibbon on 12-6-16.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "BrandGadget.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewSwitcher.h"
#import "API.h"

#define RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation BrandGadget

@synthesize brandToShow;
@synthesize queue;


-(CGRect)_makeFitRect:(CGSize)size   {
    if (size.height == 0)
        return CGRectMake(0, 0, 140, 140);
    
    float ratio = size.width / size.height;
    float width, height;
    float x, y;
    if (ratio > 1.0)    {
        width = 140;
        height = width / ratio;
        x = 0;
        y = (140.0 - height) / 2;
    }
    else    {
        height = 140;
        width = height * ratio;
        y = 0;
        x = (140.0 - width) / 2;
    }
    return CGRectMake(x, y, width, height);
}


-(void)_drawBrandLogo:(NSString*)brandLogo{
    //set logo view
    CGRect logoRect = CGRectMake(10, 13, 60, 60); 
    UIImage *logoImage = [UIImage imageWithContentsOfFile:brandLogo];
//    CGRect *imageRect = [self _makeFitRect:logoImage.size];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:logoRect];
    logoImageView.image = logoImage;
    
    //bound a gesture delegate to itemImageView
    logoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemImageClick)];
    
    [logoImageView addGestureRecognizer:singleTap];
       
    [self addSubview:logoImageView];
    [logoImageView release];
}

-(void)_drawRedBrand{
    CGRect redRect = CGRectMake(0, 0, 80, 10);
    UIImage *redImage = [UIImage imageNamed:@"red_head.png"];
    
    UIImageView *redImageView = [[UIImageView alloc] initWithFrame:redRect];
    redImageView.image = redImage;
           
    [self addSubview:redImageView];
    [redImageView release];
}


-(void)_drawUnreadCount:(NSInteger)count{
    //set white background
    CGRect backgroundRect = CGRectMake(57, 62, 31, 21);
    UILabel *backgroundLabel = [[UILabel alloc]initWithFrame:backgroundRect];
    
    CALayer *backgroundLayer = [backgroundLabel layer];
    [backgroundLayer setMasksToBounds:YES];
    [backgroundLayer setCornerRadius:10.0];
    
    [self addSubview:backgroundLabel];
    [backgroundLabel release];
       
    //set label for count
    CGRect countRect = CGRectMake(60, 65, 25, 15);
    UILabel *countLabel = [[UILabel alloc] initWithFrame:countRect];
    countLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    countLabel.textAlignment = UITextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    [countLabel setText:[NSString stringWithFormat:@"%d", count]];
   
    countLabel.backgroundColor = [UIColor redColor];
    
    //set label corner
    CALayer *countLayer = [countLabel layer];
    [countLayer setMasksToBounds:YES];
    [countLayer setCornerRadius:8.0];
    
    [self addSubview:countLabel];

    [countLabel release];
}

-(void)initWithBrand:(Brand*)brand{
    self.queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:5];
    
    self.brandToShow = brand;
    NSArray* arr = [API unreadImagesForBrand:brand];
    
    CALayer *brandGadgetLayer = [self layer];
    [brandGadgetLayer setMasksToBounds:NO];
    [brandGadgetLayer setCornerRadius:5.0];
    
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(2, 4)];
    [self.layer setShadowOpacity:0.7];
    [self.layer setShadowRadius:2.3];
    
    [self _drawRedBrand];
    [self _drawBrandLogo:brand.logo];
    [self _drawUnreadCount:[arr count]];
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];    //[self _drawCountInCircle:brand.unread_count];
}

-(void)initWithLogo:(NSString*)logo{
    CALayer *brandGadgetLayer = [self layer];
    [brandGadgetLayer setMasksToBounds:YES];
    [brandGadgetLayer setCornerRadius:4.0];

    
    [self _drawRedBrand];
    [self _drawBrandLogo:logo];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
}

-(void)itemImageClick{
    [[ViewSwitcher instance]goToItemsView:self.brandToShow];
    NSLog(@"Switched to ItemsView with brand: %@!", self.brandToShow.display_name);
}

@end
