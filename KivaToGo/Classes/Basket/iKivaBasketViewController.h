//
//  iKivaBasketViewController.h
//  iKiva
//
//  Created by SWP on 11/6/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKivaTotalBasketModalViewController.h"


@interface iKivaBasketViewController : UIViewController <UIActionSheetDelegate, KTGDonationDelegate> {
	NSMutableArray *loansToFund;
	UITableView *_tableView;
	UIBarButtonItem *_totalAmountButton;
	UIButton *_totalInfoButton;
	NSString *_totalAmountText;
	int totalAmount;
    int donationAmount;
    BOOL shouldAddDonation;
    BOOL previouslyDonated;
}
@property (nonatomic, retain) NSMutableArray *loansToFund;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *totalAmountButton;
@property (nonatomic, retain) IBOutlet UIButton *totalInfoButton;
- (void)addLoanToBasket:(NSString *)name loanID:(NSString *)loanID loanAmount:(NSString *)loanAmount;
- (void)removeLoanFromBasketWithID:(int)loanID;
- (void)updateTotalAmount:(NSNumber *)loanAmount;
+ (iKivaBasketViewController *)sharedInstance;
- (BOOL)loanExistsInBasket:(NSString *)loanID;
- (IBAction)totalButtonSelected:(id)sender;
@end
