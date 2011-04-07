//
//  iKivaDetailLoanViewController.h
//  iKiva
//
//  Created by SWP on 11/6/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKivaBaseDetailTableViewController.h"

@interface iKivaDetailLoanViewController : iKivaBaseDetailTableViewController <UIActionSheetDelegate> {
	UIBarButtonItem *addLoanToBasketButton;
	UIBarButtonItem *repaymentScheduleButton;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addLoanToBasketButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *repaymentScheduleButton;	

- (IBAction)addLoanToBasket:(id)sender;
- (IBAction)shareLoan:(id)sender;
@end