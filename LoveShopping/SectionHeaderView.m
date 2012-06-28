//
//  SectionHeaderView.m
//  FavorateTableView
//
//  Created by admin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SectionHeaderView.h"
#import "BrandManager.h"
#import "BrandGadget.h"

@implementation SectionHeaderView
@synthesize leibeiLabel;
@synthesize imageView;
@synthesize section;
@synthesize toggleButton;
@synthesize delegate;

- (id)initWithCollector:collector title:title section:(NSInteger)sectionNumber //delegate:(id <SectionHeaderViewDelegate>)viewDelegate 
{
    NSArray *headers = [[NSBundle mainBundle] loadNibNamed:@"ViewHeaders" 
                                         owner:self 
                                       options:nil];
    self = [[headers objectAtIndex:0] retain];
    
    Brand *brand = [[BrandManager defaultManager] getBrand:collector];
    NSLog(@"title: %@, %@", title, brand.logo);
    UIImageView *brandImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    [brandImageView setContentMode: UIViewContentModeScaleAspectFit];
    brandImageView.image = [UIImage imageWithContentsOfFile:brand.logo];
    self.imageView = brandImageView;
    [brandImageView release];
    
    self.leibeiLabel.text = title;
    self.section = sectionNumber;
   // self.delegate = viewDelegate;
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
