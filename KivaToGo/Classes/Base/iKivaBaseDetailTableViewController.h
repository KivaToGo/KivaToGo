//
//  iKivaBaseDetailTableViewController.h
//  iKiva
//
//  Created by SWP on 11/7/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKivaConstants.h"
#import "iKivaImageView.h"
#import "JSON.h"

@interface iKivaBaseDetailTableViewController : UIViewController {
	int _objectID;
	BOOL _dataLoaded;
	int _pageNumber;
	int _totalPages;
	int _pageSize;
	int _loanCount;
	
	NSMutableArray *_groups;
    NSMutableData *_responseData;
	NSMutableDictionary *_imageCache;
	NSString *_dataURL;
	NSString *_pageTitle;
	UITableView *_tableView;
	NSMutableDictionary *_singleDataSet;

}
@property (nonatomic, retain) NSMutableDictionary *singleDataSet;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@property (nonatomic, copy) NSString *dataURL;
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *pageDescriptor;
@property (nonatomic, assign) BOOL dataLoaded;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int totalPages;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int loanCount;
@property (nonatomic, assign) int objectID;

- (void)refreshLoans:(id)sender;

@end
