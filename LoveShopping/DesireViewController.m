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
#import "BrandManager.h"
#import "BrandGadget.h"
#import "UIAsyncImageView.h"

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
    [self.itemImageView.layer setBorderWidth:1.0];
    [self.itemImageView.layer setMasksToBounds:YES];
    [self.itemImageView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    Brand *brand = [[BrandManager defaultManager] getBrand:item.collector];    
    self.brandImageView.image = [UIImage imageWithContentsOfFile:brand.logo];
    [self.brandImageView setContentMode: UIViewContentModeScaleAspectFit];

    if ((UIAsyncImageView*) [self.contentView viewWithTag:999] == nil) {
        UIAsyncImageView* asyncImage = [[[UIAsyncImageView alloc]
                                     initWithFrame:self.itemImageView.frame] autorelease];
        asyncImage.tag = 999;
        [asyncImage loadImageFromURL:[NSURL URLWithString:item.image_url]];
        [asyncImage.layer setBorderWidth:1.0];
        [asyncImage.layer setMasksToBounds:YES];
        [asyncImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self.contentView addSubview:asyncImage];
    }

    self.priceLabel.text = item.price;
    self.likeabilityLabel.text = item.title;
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
-(void)searchForCategorys;
@end

@implementation DesireViewController
@synthesize favourateTableView;
@synthesize sectionInfoArray;
@synthesize categorys;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    
    cat1.items = [allItem subarrayWithRange:NSMakeRange(0, 10)];
    Item *item1 = (Item *)[cat1.items objectAtIndex:0];
    cat1.collector = item1.collector;
    cat1.title =  [[BrandManager defaultManager] getBrand: item1.collector].display_name;
//    NSLog(@"cat1.items: %@", cat1.items);
    Category *cat2 = [[Category alloc] init];
    cat2.items = [allItem subarrayWithRange:NSMakeRange(4, 10)];
    Item *item2 = (Item *)[cat2.items objectAtIndex:0];
    cat2.collector = item2.collector;
    cat2.title =  [[BrandManager defaultManager] getBrand: item2.collector].display_name;
    
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
	
    return  numStoriesInSection;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    /*
     Create the section header views lazily.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
        sectionInfo.headerView = [[SectionHeaderView alloc] initWithCollector: sectionInfo.category.collector title: sectionInfo.category.title section:section]; //delegate:self];
    }
    return sectionInfo.headerView.frame.size.height;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:[self.sectionInfoArray count]];
//    for (SectionInfo *sectionInfo in self.sectionInfoArray) {
//         [indexArray addObject:sectionInfo.category.title];
//    }
//    return indexArray;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     Create the section header views lazily.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
         sectionInfo.headerView = [[SectionHeaderView alloc] initWithCollector: sectionInfo.category.collector title: sectionInfo.category.title section:section]; //delegate:self];
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

@end
