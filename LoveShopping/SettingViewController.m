//
//  SettingViewController.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "SettingViewController.h"
#import "BrandManager.h"
#import "ViewSwitcher.h"
#import "BrandGadget.h"

@implementation SettingViewController

@synthesize settingsTableView;

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480

-(void)viewWillAppear:(BOOL)animated    {
    allBrands = [[BrandManager defaultManager]allBrands];
    NSLog(@"All Brands: %@", allBrands);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidLoad {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *background = [[UIImageView alloc] initWithFrame:rect];
    background.image = [UIImage imageNamed:@"background.png"];
    [self.view insertSubview:background atIndex:0];
    [background release];
    
    settingsTableView.backgroundView = nil;
    settingsTableView.backgroundColor = [UIColor clearColor];
    settingsTableView.opaque = NO;
}

-(IBAction)showMainView:(id)sender
{
    [ViewSwitcher switchToBrand];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allBrands count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Brand* brand = [allBrands objectAtIndex:indexPath.row];
    
    static NSString *simpleTableIdentifier=@"SettingsTableCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] 
              autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    CGRect rect = CGRectMake(40, 0, 80, 80);
    
    BrandGadget *brandGadget = [[BrandGadget alloc]initWithFrame:rect];
    [brandGadget initWithLogo:brand.logo];
    
    [cell addSubview:brandGadget];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(170, 30, 120, 30);
    
    button.tag = indexPath.row;
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if(brand.visible.intValue == 1) {
        [button setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    }
    [cell addSubview:button]; 
    return cell;
}

-(void)buttonPressed:(id)sender{
    UIButton* button = (UIButton*)sender;
    
    Brand* brand = [allBrands objectAtIndex:button.tag];
    brand.visible = brand.visible.intValue == 1 ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
    NSLog(@"Brand changed for %@ to: %@", brand.display_name, brand.visible);
    
    if(brand.visible.intValue == 1) {
        [button setBackgroundImage:[UIImage imageNamed:@"on.png"] forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}

@end
