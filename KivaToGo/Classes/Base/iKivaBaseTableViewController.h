//
//  iKivaBaseTableViewController.h
//  iKiva
//
//  Created by SWP on 11/7/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKivaConstants.h"
#import "iKivaImageView.h"
#import "JSON.h"
#import "iKivaBaseTableCell.h"
#import "PullRefreshTableViewController.h"
#import "KTGSortOptionsTableViewController.h"


@interface iKivaBaseTableViewController : PullRefreshTableViewController <UISearchBarDelegate, UISearchDisplayDelegate, KTGSortOptionsDelegate> {
	BOOL _dataLoaded;
	int _pageNumber;
	int _totalPages;
	int _pageSize;
	int _loanCount;
	int _objectID;

	NSMutableArray *_groups;
    NSMutableData *_responseData;
	NSMutableDictionary *_imageCache;
	NSString *dataURL;
	NSString *pageTitle;
	NSString *_sortOption;
    
    NSMutableArray	*filteredListContent; // The content filtered as a result of a search.

}
@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic, retain) NSMutableArray	*filteredListContent;
@property (nonatomic, retain) NSMutableDictionary *singleDataSet;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, copy) NSString *dataURL;
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *pageDescriptor;
@property (nonatomic, copy) NSString *sortOption;
@property (nonatomic, assign) BOOL dataLoaded;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int totalPages;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int loanCount;
@property (nonatomic, assign) int objectID;

- (UITableViewCell *)showMoreGroupsAvailableTableCellInTable:(UITableView *)tableView;
- (void)removeExistingImageView:(UITableViewCell *)cell;
- (void)loadKivaData;
@end
