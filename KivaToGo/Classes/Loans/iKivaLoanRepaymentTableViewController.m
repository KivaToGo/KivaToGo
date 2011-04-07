//
//  iKivaLoanRepaymentTableViewController.m
//  iKiva
//
//  Created by SWP on 11/20/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaLoanRepaymentTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "iKivaConstants.h"
#import "GANTracker.h"
@implementation iKivaLoanRepaymentTableViewController
@synthesize localPayments = _localPayments, scheduledPayments = _scheduledPayments, terms = _terms;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [[GANTracker sharedTracker] trackPageview:@"LoanDetail/RepaymentTerms" withError:nil];
	self.navigationItem.title = @"Repayment Terms";
	self.localPayments = [self.terms objectForKey:LOCAL_PAYMENTS];
	self.scheduledPayments = [self.terms objectForKey:SCHEDULED_PAYMENTS];
    [super viewDidLoad];

}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (self.localPayments && self.scheduledPayments) {
		return 3;
	}
    return 2; // You'll always local payments
}

//TODO: Reorg this
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 2) {
		return [self.scheduledPayments count];
	}
	else if (section == 1) {
		return [self.localPayments count];
	}
	else {
		return 6; // Section 0
	}


}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 1) {
        NSString *currency;
        if ([self.terms objectForKey:@"disbursal_currency"]) {
            currency = [NSString stringWithFormat:@"Local Payments (%@)", [self.terms objectForKey:@"disbursal_currency"]];
        }
        else {
            currency = @"Local Payments";
        }
		return currency;
	}
	else if (section == 2) {
		return @"Scheduled Repayments (USD)";
	}
	else {
		return @"Repayment Details";
	}
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 32.0f;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Loan Date";
				cell.detailTextLabel.text = [iKivaConstants normalFormattedDateWithoutYearForDate:[self.terms objectForKey:@"disbursal_date"]];
				break;
			case 1:
				cell.textLabel.text = @"Local Amount";
                NSString *currency;
                if ([self.terms objectForKey:@"disbursal_currency"]) {
                    currency = [NSString stringWithFormat:@"%@ (%@)",
                                [iKivaConstants normalFormattedCurrencyFromAmount:[[self.terms objectForKey:@"disbursal_amount"] intValue]], [self.terms objectForKey:@"disbursal_currency"]];
                }
                else {
                    currency = [NSString stringWithFormat:@"%@",
                                [iKivaConstants normalFormattedCurrencyFromAmount:[[self.terms objectForKey:@"disbursal_amount"] intValue]]];
                }
				cell.detailTextLabel.text = currency;				
                break;
			case 2:
				cell.textLabel.text = @"Loan Amount";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",
											 [iKivaConstants normalFormattedCurrencyFromAmount:[[self.terms objectForKey:@"loan_amount"] intValue]],
											 @"USD"]; 
				break;
			case 3:
				cell.textLabel.text = @"Repayments";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [self.scheduledPayments count]];
				break;
			case 4:
				cell.textLabel.text = @"Non-payment Liability";
				cell.detailTextLabel.text = [[[self.terms objectForKey:@"loss_liability"] objectForKey:@"nonpayment"] capitalizedString];
				break;
			case 5:
				cell.textLabel.text = @"Currency Exchange Loss";
				cell.detailTextLabel.text = [[[self.terms objectForKey:@"loss_liability"] objectForKey:@"currency_exchange"] capitalizedString];
				break;
			default:
				break;
		}
	}
	else if (indexPath.section == 1) {
		double amount = [[[self.localPayments objectAtIndex:indexPath.row] objectForKey:@"amount"] doubleValue];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", amount];
		cell.textLabel.text = [iKivaConstants normalFormattedDateWithoutYearForDate:[[self.localPayments objectAtIndex:indexPath.row] objectForKey:@"due_date"]];
	}
	else {
		double amount = [[[self.scheduledPayments objectAtIndex:indexPath.row] objectForKey:@"amount"] doubleValue];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", amount];
		cell.textLabel.text = [iKivaConstants normalFormattedDateWithoutYearForDate:[[self.scheduledPayments objectAtIndex:indexPath.row] objectForKey:@"due_date"]];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Do nothing
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super viewDidUnload];
    self.localPayments = nil;
	self.scheduledPayments = nil;
}


- (void)dealloc {
	self.scheduledPayments = nil;
	self.localPayments = nil;
    [super dealloc];
}


@end

