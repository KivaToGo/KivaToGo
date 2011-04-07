//
//  iKivaBasketViewController.m
//  iKiva
//
//  Created by SWP on 11/6/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaBasketViewController.h"
#import "iKivaDetailLoanViewController.h"
#import "KivaToGoAppDelegate.h"
#import "iKivaConstants.h"
#import "iKivaBasketWebViewController.h"
#import "iKivaTotalBasketModalViewController.h"
#import "SBJSON.h"
#import "GANTracker.h"

@implementation iKivaBasketViewController
@synthesize loansToFund, tableView = _tableView, totalAmountButton = _totalAmountButton, totalInfoButton = _totalInfoButton;

#pragma mark - 
#pragma mark View lifecycle
- (void)viewDidAppear:(BOOL)animated
{
    // Update the total label so its nicely formatted for the user
	self.totalAmountButton.title = [NSString stringWithFormat:@"$%i.00", totalAmount];
	[super viewDidAppear:YES];
}

- (void)viewDidLoad {
	self.navigationItem.title = @"Loan Basket";
    [[GANTracker sharedTracker] trackPageview:@"/Basket/BasketMain" withError:nil];
    
	[self.tableView reloadData];
    
	UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(checkout:)];
	self.navigationItem.rightBarButtonItem = checkoutButton;
	[checkoutButton release];
	
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Basket" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
    
    [super viewDidLoad];
}

- (void)checkout:(id)sender
{
	NSLog(@"** Loan Checkout");
	if (![self.loansToFund count] > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Loans!" message:@"There are no loans in your basket." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else {
        NSString *checkoutText = [NSString stringWithFormat:@"Fund these loans totaling $%i.00?  This will also clear your Basket.", totalAmount];
		UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:checkoutText delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes!", nil];
        action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		[action showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
		action.tag = CHECKOUT_TAG;
		[action release];
	}
    
}
- (void)clearLoansInTable
{
    NSLog(@"** Clearing loans in table");
	[self.loansToFund removeAllObjects];
	[self.tableView reloadData];
	totalAmount = 0;
    donationAmount = 0;
	[self updateTotalAmount:[NSNumber numberWithDouble:0]];
}

// Generate the JSON string used as a the 'loans' parameter when sending to Kiva
- (NSString *)generateJSONDataFromLoansArray
{
	SBJSON *serial = [[[SBJSON alloc] init] autorelease];
	NSString *prepString = [serial stringWithObject:self.loansToFund];
	NSLog(@"** %@", prepString);
	return prepString;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) { //User clicked 'Yes' fund loans
		NSLog(@"** User selected to fund loans!");
		iKivaBasketWebViewController *detailViewController = [[iKivaBasketWebViewController alloc] initWithNibName:@"iKivaBasketWebViewController" bundle:nil];
		detailViewController.uploadString = [self generateJSONDataFromLoansArray];
        detailViewController.donationString = [NSString stringWithFormat:@"%i", donationAmount];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
		[self clearLoansInTable];
        [[GANTracker sharedTracker] dispatch];
        
	} else {
		[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
	}
    
    
}

- (void)updateBadgeCount
{
    if ([self.loansToFund count] > 0) {
        NSString *loanBadge = [NSString stringWithFormat:@"%i", [self.loansToFund count]];
        [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = loanBadge;
    }
    else {
        [[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
    }
}

- (void)updateTotalAmount:(NSNumber *)loanAmount
{
	int amount = [loanAmount intValue];
	int totals = totalAmount + amount ;
    if (shouldAddDonation) {
        donationAmount += (amount * 0.1);
        totals += donationAmount;
    }
	totalAmount = totals;
    self.totalAmountButton.title = [NSString stringWithFormat:@"$%i.00", totalAmount];
    [self updateBadgeCount];
}
- (void)removeLoanFromBasketWithID:(int)loanID
{
    NSLog(@"** In Basket, Removing Loan");
	NSNumber *loan = [NSNumber numberWithInt:loanID];
    int loanAmount = 0;
    for (int i = 0; i < [self.loansToFund count]; i++) {
        if ([[[self.loansToFund objectAtIndex:i] objectForKey:@"id"] isEqual:loan]) {
            loanAmount = [[[self.loansToFund objectAtIndex:i] objectForKey:@"amount"] intValue];
            [self.loansToFund removeObjectAtIndex:i];
        }
    }
    int negativeLoanAmount = (loanAmount * -1);
	[self updateTotalAmount:[NSNumber numberWithInt:negativeLoanAmount]];
    [self.tableView reloadData];
}
- (void)addLoanToBasket:(NSString *)name loanID:(NSString *)loanIDString loanAmount:(NSString *)loanAmountString
{
	NSLog(@"** In Basket, Adding Loan");
	if (!self.loansToFund) {
		self.loansToFund = [[NSMutableArray alloc] init];
		totalAmount = 0;
        donationAmount = 0;
	}
    
	NSNumber *loanID = [NSNumber numberWithInt:[loanIDString intValue]];
	NSNumber *loanAmount = [NSNumber numberWithInt:[loanAmountString intValue]];
	[self.loansToFund addObject:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", loanID, @"id", loanAmount, @"amount", nil]];
	[self updateTotalAmount:loanAmount];
    [self.tableView reloadData];
    
}

- (BOOL)loanExistsInBasket:(NSString *)loanID
{
	BOOL doesLoanExist = NO;
	for (int i = 0 ; i < [self.loansToFund count];  i++) {
		NSString *loanIDTest = [[[self.loansToFund objectAtIndex:i] objectForKey:@"id"] stringValue];
		if (loanIDTest && [loanIDTest isEqualToString:loanID]) {
            NSLog(@"** Loan Exists in Basket!");
			doesLoanExist = YES;
		}
	}
	
	return doesLoanExist;
}

- (IBAction)totalButtonSelected:(id)sender
{
	iKivaTotalBasketModalViewController *detailViewController = [[iKivaTotalBasketModalViewController alloc] initWithNibName:@"iKivaTotalBasketModalViewController" bundle:nil];
    detailViewController.delegate = self;
    detailViewController.navigationItem.title = @"Total Details";
	[self presentModalViewController:detailViewController animated:YES];
	[detailViewController release];
}

#pragma mark -
#pragma mark Modal Delegate
-(void)userChangedDonationToggle:(BOOL)status
{
    NSLog(@"** User Donation statis is: %i", status);
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"donationSwitch"];
    if (totalAmount > 0) {
        if (status) { // ON = User wants donation
            shouldAddDonation = YES;
            [self updateTotalAmount:0];
        } else  {
            shouldAddDonation = NO;
            [self updateTotalAmount:0];
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.loansToFund) {
        return [self.loansToFund count];
    } else {
        return 1;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	if ([self.loansToFund count] == 0 || self.loansToFund == nil) {
		cell.textLabel.text = @"Basket is empty";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else {
		cell.textLabel.text = [[self.loansToFund objectAtIndex:indexPath.row] objectForKey:@"name"];
		cell.detailTextLabel.text = [[self.loansToFund objectAtIndex:indexPath.row] objectForKey:@"amount"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        // Using the Detail Disclosure Indicator would be a good idea for changing the loan amount on a per loan basis
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //UITableViewCellAccessoryDetailDisclosureButton;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"** User selected button!");
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (self.loansToFund) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        int removedAmount = [[[self.loansToFund objectAtIndex:indexPath.row] objectForKey:@"amount"] intValue] * -1;
		[self.loansToFund removeObjectAtIndex:indexPath.row];
		[self updateTotalAmount:[NSNumber numberWithInt:removedAmount]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView reloadData];
		
	} 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.loansToFund) {
        iKivaDetailLoanViewController *detailViewController = [[iKivaDetailLoanViewController alloc] initWithNibName:@"iKivaDetailLoanViewController" bundle:nil];
		detailViewController.objectID = [[[self.loansToFund objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark StackOverflow Singleton Instance

static iKivaBasketViewController *sharedInstance = nil;

+ (iKivaBasketViewController *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
		{
			sharedInstance = [[iKivaBasketViewController alloc] init];
		}
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
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
    self.tableView = nil;
    self.totalInfoButton = nil;
    self.totalAmountButton = nil;
}


- (void)dealloc {
	self.totalInfoButton = nil;
	self.totalAmountButton = nil;
	self.tableView = nil;
	self.loansToFund = nil;
    
    [super dealloc];
}


@end

