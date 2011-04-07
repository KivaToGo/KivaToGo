//
//  iKivaLoanRepaymentTableViewController.h
//  iKiva
//
//  Created by SWP on 11/20/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKivaLoanRepaymentTableViewController : UITableViewController {
	NSArray *_localPayments;
	NSArray *_scheduledPayments;
	NSDictionary *_terms;
}
@property (nonatomic, retain) NSDictionary *terms;
@property (nonatomic, retain) NSArray *localPayments;
@property (nonatomic, retain) NSArray *scheduledPayments;
@end
