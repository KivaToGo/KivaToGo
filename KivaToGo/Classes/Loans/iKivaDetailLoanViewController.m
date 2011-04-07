//
//  iKivaDetailLoanViewController.m
//  iKiva
//
//  Created by SWP on 11/6/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaDetailLoanViewController.h"
#import "iKivaDetailTableCell.h"
#import "iKivaDetailTableCellTop.h"
#import "iKivaLoanRepaymentTableViewController.h"
#import "iKivaBasketViewController.h"
#import "iKivaDetailLoans.h"
#import "iKivaLoanDetailImageTableCell.h"
#import "SHK.h"
#import "iKivaDetailDescriptionViewController.h"
#import "GANTracker.h"

@implementation iKivaDetailLoanViewController
@synthesize repaymentScheduleButton, addLoanToBasketButton;

- (IBAction)addLoanToBasket:(id)sender
{
	NSLog(@"** Add Loan to basket");	
	
    iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
    [[iKivaBasketViewController sharedInstance] addLoanToBasket:loans.name loanID:loans.loanIDString loanAmount:[NSString stringWithFormat:@"%i", 25]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loan Added!" message:@"This loan has been added to your basket." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)removeLoanFromBasket:(id)sender
{
	NSLog(@"** Remove Loan from basket");	
	iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
    [[iKivaBasketViewController sharedInstance] removeLoanFromBasketWithID:loans.loanID];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loan Removed!" message:@"This loan has been removed from your basket." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)shareLoan:(id)sender
{
	NSLog(@"** Share Loan Button Selected");
	
    // Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SHARE_INDIVIDUAL_LOAN_URL, self.objectID]];
	SHKItem *item = [SHKItem URL:url title:@"Check out this loan on Kiva (via KivaToGo)!"];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

// The first action sheet that comes up needs to be configured based on available options
- (void)shareItemSelected
{
	NSLog(@"** Share Item Selected");
	
	iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
	UIActionSheet *action;
	if (loans.amountNeeded > 0) { // Check if loan is fully funded
        // If not fully funded, check if we've already added to basket
        if ([[iKivaBasketViewController sharedInstance] loanExistsInBasket:loans.loanIDString]) {
            
            action = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Remove from basket", @"Share this loan", nil];
        } else {
            action = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Add to basket", @"Share this loan", nil];
        }
	} else {  // If fully funded, just provide Share, Cancel options
		action = [[UIActionSheet alloc] initWithTitle:nil
											 delegate:self
									cancelButtonTitle:@"Cancel"
							   destructiveButtonTitle:nil
									otherButtonTitles:@"Share this loan", nil];
	}
	
	action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[action showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
	[action release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
	NSLog(@"** Index: %i", buttonIndex);
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else {
        switch (buttonIndex) {
            case 0:
                // Check for # of buttons to determine if loan is full
                if ([actionSheet numberOfButtons] == 2) {
                    [self shareLoan:self];
                }
                else {
                    if ([[iKivaBasketViewController sharedInstance] loanExistsInBasket:loans.loanIDString]) {
                        [self removeLoanFromBasket:self];
                    } else {
                        [self addLoanToBasket:self];
                    }
                }
                break;
            case 1:
                [self shareLoan:self];
                break;
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    
    self.pageTitle = @"Loan Details";
	self.dataURL = [NSString stringWithFormat:INDIVIDUAL_LOAN_URL, self.objectID];
	self.pageDescriptor = LOANS;
    
	UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareItemSelected)];
	self.navigationItem.rightBarButtonItem = shareItem;
	
    [shareItem release];
	
    [[GANTracker sharedTracker] trackPageview:@"LoanDetail/LoanDetailMain" withError:nil];
    
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Give users a helpful hint they can scroll
	[self.tableView flashScrollIndicators];
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Need more space for Image cell
	if (indexPath.section == 0 && indexPath.row == 0) {
		return 300.0f;
	}
	else if (indexPath.section == 2 && indexPath.row == 1) {
		iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
		return [iKivaConstants dynamicRowHeightFromText:loans.loanUse];
	}
	return 55.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0)	// Loan Image
		return 1;
	else if (section == 1)	// About Lendee
		return 4;
	// About Loan
    return 8;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
	if (section == 1)
	{
		if (loans.name) { // If we have the name, show it, otherwise make it generic
			return [NSString stringWithFormat:@"About %@", loans.name];
		}
		else {
			return @"About this Entrepreneur";
		}
        
	}
	else if (section == 2)
	{
		return [NSString stringWithFormat:@"About this Loan"];
	}
    
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
	NSString *CellIdentifier;
	UITableViewCell *cell = nil;
	
    // Reset cell contents - for some reason it wasnt clearing by itself
	if (cell) {
		cell.textLabel.text = @"";
		cell.detailTextLabel.text = @"";
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == 0)
			{	
				CellIdentifier = @"ImageCell";
				cell = (iKivaLoanDetailImageTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (cell == nil) {
					NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"iKivaLoanDetailImageTableCell" owner:self options:nil];
					for (id obj in topLevelObjects){
						if ([obj isKindOfClass: [iKivaLoanDetailImageTableCell class]]) {
							cell = (iKivaLoanDetailImageTableCell *)obj;
						}
					}
				}	
                
                // Download image if we dont have it already
				NSString *imageIDString = [NSString stringWithFormat:@"%i", loans.imageID];
				iKivaImageView *loanImageView = [self.imageCache objectForKey:imageIDString];
				if (loanImageView == nil) {
					CGRect frame = CGRectMake(0, 0, 300, 300);
					iKivaImageView *loanImageView = [[[iKivaImageView alloc] initWithFrame:frame] autorelease];
					loanImageView.tag = 999;
					NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:INDIVIDUAL_IMAGE_URL,loans.imageID]];
					[loanImageView loadImageFromURL:url];
					[self.imageCache setObject:loanImageView forKey:imageIDString];
                    [((iKivaLoanDetailImageTableCell *)cell).lenderImage addSubview:loanImageView];
				}
			}
			break;
		case 1:
			CellIdentifier = @"Cell";
			cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
            
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Country";
					cell.detailTextLabel.text = loans.country;
					if (loans.countryCode && [loans.countryCode length] > 0) {
						cell.accessoryView = [[[UIImageView alloc] initWithImage:
											   [UIImage imageNamed:
												[NSString stringWithFormat:@"%@", [loans.countryCode lowercaseString]]]]
											  autorelease];
					}
					break;
				case 1:
					cell.textLabel.text = @"Industry";
					if (loans.activity && [loans.activity length] > 0) {
						cell.detailTextLabel.text =	[NSString stringWithFormat:@"%@ - %@", loans.sector, loans.activity];
					}
					else {
						cell.detailTextLabel.text = loans.sector;
					}
					break;
				case 2:
					cell.textLabel.text = @"Borrowers";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [loans.borrowers count]];
					break;
				case 3:
					cell.textLabel.text = @"Description";
					cell.detailTextLabel.text = @"";
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
					break;
				default:
					break;
			}
			break;
		case 2:
			CellIdentifier = @"Cell2";
			cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
			}
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
            
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Status";
					cell.detailTextLabel.text = [loans.fundingStatus capitalizedString];
					break;
				case 1:
					cell.textLabel.text = @"Use";
					cell.detailTextLabel.numberOfLines = 0;
					cell.detailTextLabel.text = loans.loanUse;
					break;
				case 2:
					cell.textLabel.text = @"Requested";
					cell.detailTextLabel.text = [iKivaConstants normalFormattedCurrencyFromAmount:loans.loanAmount];
					break;
				case 3:
					cell.textLabel.text = @"Raised";
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",
												 [iKivaConstants normalFormattedCurrencyFromAmount:loans.trueFundedAmount],
												 loans.fundedPercentage];
					break;
				case 4:
					cell.textLabel.text = @"Still Needed";
                    if (loans.amountNeeded > 0) {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                    } else {
                        cell.detailTextLabel.textColor = TABLE_COLOR_LIGHT_BLUE; // standard UITableView blue
                    }
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",
												 [iKivaConstants normalFormattedCurrencyFromAmount:loans.amountNeeded],
												 loans.remainingPercentage];
					break;
				case 5:
					cell.textLabel.text = @"Repayments";
                    if ([loans.loanTerms objectForKey:SCHEDULED_PAYMENTS]) {
                        int loanPayments = [[loans.loanTerms objectForKey:SCHEDULED_PAYMENTS] count];
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", loanPayments];
                    } else {
                        cell.detailTextLabel.text = @"";
                    }
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
					break;
				case 6:
					cell.textLabel.text = @"Loan ID";
					cell.detailTextLabel.text = loans.loanIDString;
					break;
				case 7:
					cell.textLabel.text = @"Date Posted";
					cell.detailTextLabel.text = [iKivaConstants normalFormattedDateWithoutYearForDate:loans.postedDate];
					break;
				default:
					break;
			}
			break;
		default:
			CellIdentifier = @"Cell3";
			cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
			}
			cell.textLabel.text = @"";
			cell.detailTextLabel.text = @"";
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
	}
    
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // User selected "Description" cell
    if (indexPath.section == 1 && indexPath.row == 3) {
		iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
		iKivaDetailDescriptionViewController *detailViewController = [[iKivaDetailDescriptionViewController alloc] initWithNibName:@"iKivaDetailDescriptionViewController" bundle:nil];
		detailViewController.description = loans.englishDescription;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
    // User selected "Repayments" cell
	else if (indexPath.section == 2 && indexPath.row == 5) {
		iKivaDetailLoans *loans = [iKivaDetailLoans detailsFromDictioary:[self.groups objectAtIndex:0]];
		iKivaLoanRepaymentTableViewController *detailViewController = [[iKivaLoanRepaymentTableViewController alloc] initWithNibName:@"iKivaLoanRepaymentTableViewController" bundle:nil];
		detailViewController.terms = loans.loanTerms;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    self.repaymentScheduleButton = nil;
	self.addLoanToBasketButton = nil;
}


- (void)dealloc {
	self.repaymentScheduleButton = nil;
	self.addLoanToBasketButton = nil;
    [super dealloc];
}


@end

