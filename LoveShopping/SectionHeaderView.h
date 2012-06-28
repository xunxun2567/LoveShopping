//
//  SectionHeaderView.h
//  FavorateTableView
//
//  Created by admin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeaderViewDelegate;

@interface SectionHeaderView: UIView {
}
@property(nonatomic, retain) IBOutlet UILabel*     leibeiLabel;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UIButton*    toggleButton;
@property(nonatomic) NSInteger section;
@property (nonatomic, retain) id <SectionHeaderViewDelegate> delegate;
- (id)initWithTitle:title section:(NSInteger)sectionNumber; //delegate:(id <SectionHeaderViewDelegate>)viewDelegate;
-(IBAction)toggleAction:(id)sender; 
-(void)toggleOpenWithUserAction:(BOOL)userAction;
@end

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;
@end