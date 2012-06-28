//
//  SectionHeaderView.m
//  FavorateTableView
//
//  Created by admin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView
@synthesize leibeiLabel;
@synthesize leibeiImageView;
@synthesize section;
@synthesize toggleButton;
@synthesize delegate;

- (id)initWithTitle:title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)viewDelegate 
{
    NSArray *headers = [[NSBundle mainBundle] loadNibNamed:@"ViewHeaders" 
                                         owner:self 
                                       options:nil];
    self = [[headers objectAtIndex:0] retain];
    self.leibeiLabel.text = title;
    self.section = sectionNumber;
    self.delegate = viewDelegate;
    return self;
}

-(IBAction)toggleAction:(id)sender {
    [self toggleOpenWithUserAction:YES];
}
-(void)toggleOpenWithUserAction:(BOOL)userAction {
        // Toggle the disclosure button state.
        self.toggleButton.selected = !self.toggleButton.selected;
        
        // If this was a user action, send the delegate the appropriate message.
        if (userAction) {
            if (self.toggleButton.selected) {
                if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                    [self.delegate sectionHeaderView:self sectionOpened:self.section];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                    [self.delegate sectionHeaderView:self sectionClosed:self.section];
                }
            }
        }
}

@end
