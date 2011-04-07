//
//  iKivaPortfolioViewController.h
//  iKiva
//
//  Created by SWP on 11/6/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKivaBaseDetailTableViewController.h"
#import "iKivaPortfolioImageView.h"

@interface iKivaPortfolioViewController : iKivaBaseDetailTableViewController <UITableViewDelegate, UITableViewDataSource> {
	NSString *lenderID;
	iKivaPortfolioImageView *_summaryView;
}
@property (nonatomic, copy) NSString *lenderID;
@property (nonatomic, retain) iKivaPortfolioImageView *summaryView;
@end
