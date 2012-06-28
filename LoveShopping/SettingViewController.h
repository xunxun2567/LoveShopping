//
//  SettingViewController.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray* allBrands;
}

@property (strong, nonatomic) IBOutlet UITableView* settingsTableView;

-(IBAction)showMainView:(id)sender;
@end
