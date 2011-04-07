//
//  iKivaSearchViewController.h
//  iKiva
//
//  Created by SWP on 2/6/11.
//  Copyright 2011 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKivaSearchViewController : UITableViewController <UISearchBarDelegate, UIAlertViewDelegate> {
	
    NSMutableArray *listContent;			// The master content.
    UISearchBar *searchBar;

    BOOL _dataLoaded;
	int _pageNumber;
	int _totalPages;
	int _pageSize;
	int _loanCount;
	int _objectID;
	
    NSMutableData *_responseData;
	NSMutableDictionary *_imageCache;
	NSString *dataURL;
	NSString *pageTitle;
	NSMutableDictionary *singleDataSet;
}
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableDictionary *singleDataSet;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, copy) NSString *dataURL;
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *pageDescriptor;
@property (nonatomic, assign) BOOL dataLoaded;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int totalPages;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int loanCount;
@property (nonatomic, assign) int objectID;

- (void)searchKivaForLoans:(NSString *)searchText withPage:(int)pageNumber;

@end
