//
//  DesireViewController.h
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"

@interface DesireViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate> {
}
@property(nonatomic,retain) IBOutlet UITableView *favourateTableView;
@property (nonatomic, retain) NSArray* categorys;

@end
