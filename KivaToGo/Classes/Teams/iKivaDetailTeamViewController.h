//
//  iKivaDetailTeamViewController.h
//  iKiva
//
//  Created by SWP on 11/13/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKivaBaseDetailTableViewController.h"
#import "iKivaPortfolioImageView.h"

@interface iKivaDetailTeamViewController : iKivaBaseDetailTableViewController {
	iKivaPortfolioImageView *_summaryView;
	NSString *_name;
}
@property (nonatomic, retain) iKivaPortfolioImageView *summaryView;
@end
