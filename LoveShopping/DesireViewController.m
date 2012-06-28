//
//  DesireViewController.m
//  LoveShopping
//
//  Created by Lingkai Kong on 12-6-26.
//  Copyright (c) 2012年 Egibbon Inc. All rights reserved.
//

#import "DesireViewController.h"
#import "SectionInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "Category.h"
#import "Item.h"
#import "ItemManager.h"
#import "Category.h"

@interface FavorateItemCell : UITableViewCell {
}
@property(nonatomic, retain) IBOutlet UIImageView* brandImageView;
@property(nonatomic, retain) IBOutlet UIImageView* itemImageView;
@property(nonatomic, retain) IBOutlet UILabel*     priceLabel;
@property(nonatomic, retain) IBOutlet UILabel*     likeabilityLabel;
@property(nonatomic, retain) IBOutlet UIButton*    deleteButton;

-(void)parseFromItem:(Item *) item;
-(IBAction)deleteAction:(id)sender;
-(IBAction)shareAction:(id)sender;

@end

@implementation FavorateItemCell
@synthesize brandImageView;
@synthesize itemImageView;
@synthesize priceLabel;
@synthesize likeabilityLabel;
@synthesize deleteButton;

-(void)parseFromItem:(Item *) item {
    [self.likeabilityLabel.layer setCornerRadius:6.0];
    [self.likeabilityLabel setClipsToBounds:YES];
    [self.imageView.layer setBorderWidth:1.0];
    [self.imageView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    //   self.brandImageView.image =
    //   self.itemImageView.image = image;
    self.priceLabel.text = item.title;
    self.likeabilityLabel.text = item.time;
}

-(IBAction)deleteAction:(id)sender {
    NSLog(@"delete item from favorate list");
}
-(IBAction)shareAction:(id)sender {
    NSLog(@"share item to weibo");
}
@end


@interface FavorateSummaryCell: UITableViewCell {
}
@property(nonatomic, retain) IBOutlet UILabel* totalPriceLabel;

@end

@implementation FavorateSummaryCell
@synthesize totalPriceLabel;

@end

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 45

@interface DesireViewController ()
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
-(void)searchForCategorys;
@end

@implementation DesireViewController
@synthesize favourateTableView;
@synthesize sectionInfoArray;
@synthesize openSectionIndex = _openSectionIndex;
@synthesize categorys;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _openSectionIndex = NSNotFound;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated]; 
    [self searchForCategorys];
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
	if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.favourateTableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (Category *category in self.categorys) {
			
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.category = category;
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
			NSInteger countOfQuotations = [[sectionInfo.category items] count];
			for (NSInteger i = 0; i < countOfQuotations; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
	}
}

-(void) searchForCategorys {
    NSArray *allItem = [[ItemManager defaultManager] desiredItems];
    Category *cat1 = [[Category alloc] init];
    cat1.title = @"1";
    cat1.items = [allItem subarrayWithRange:NSMakeRange(0, 3)];
//    NSLog(@"cat1.items: %@", cat1.items);
    Category *cat2 = [[Category alloc] init];
    cat2.title = @"2";
    cat2.items = [allItem subarrayWithRange:NSMakeRange(4, 3)];
//    NSLog(@"cat2.items: %@", cat2.items);
    self.categorys = [NSArray arrayWithObjects:cat1,cat2,nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // To reduce memory pressure, reset the section info array if the view is unloaded.
	self.sectionInfoArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.categorys count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.category items] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     Create the section header views lazily.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
        sectionInfo.headerView = [[SectionHeaderView alloc] initWithTitle: sectionInfo.category.title section:section delegate:self];
    }
    return sectionInfo.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemCellId = @"FavorateItemCellId";
    //    static NSString *summaryCellId = @"FavorateSummaryCellId";
    NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"ViewCells" 
                                                   owner:self 
                                                 options:nil];
    
    FavorateItemCell *cell = (FavorateItemCell*)[tableView dequeueReusableCellWithIdentifier:itemCellId];
    if (cell == nil) {
        cell = (FavorateItemCell *)[cells objectAtIndex:0];
    }
    
    Category *category = (Category *)[[self.sectionInfoArray objectAtIndex:indexPath.section] category];
    [cell parseFromItem:[category.items objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.category.items count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.category.items count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.favourateTableView beginUpdates];
    [self.favourateTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.favourateTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.favourateTableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.favourateTableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.favourateTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}


@end
