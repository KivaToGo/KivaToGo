//
//  iKivaLoanViewController.m
//  iKiva
//
//  Created by SWP on 11/2/10.
//  Copyright 2010 Solo Wolf Productions. All rights reserved.
//

#import "iKivaLoanViewController.h"
#import "iKivaDetailLoanViewController.h"
#import "GANTracker.h"
@implementation iKivaLoanViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {

	self.dataURL = FEATURED_LOANS_URL;
	self.pageTitle = @"Featured Entrepreneurs";
	self.pageDescriptor = LOANS;
    [[GANTracker sharedTracker] trackPageview:@"Loans/LoansMain" withError:nil];
	
    // Set the back button when we push a new VC
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Loans" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];

	[super viewDidLoad];

}
#pragma mark -
#pragma mark Table view data source

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.row < [self.groups count])
	{
		static NSString *CellIdentifier = @"BaseCell";
		iKivaBaseTableCell *cell = (iKivaBaseTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"iKivaBaseTableCell" owner:self options:nil];
			for (id obj in topLevelObjects){
				if ([obj isKindOfClass: [iKivaBaseTableCell class]]) {
					cell = (iKivaBaseTableCell *)obj;
				}
			}
		}
		else {
			[super removeExistingImageView:cell];
		}
        iKivaLoans *loan;
       
        // If we're in the Filter view
        if (tableView == self.searchDisplayController.searchResultsTableView)
            loan = [iKivaLoans loansFromDictioary:[self.filteredListContent objectAtIndex:indexPath.row]];
        else
            loan = [iKivaLoans loansFromDictioary:[self.groups objectAtIndex:indexPath.row]];
        
        // Download the Image
		NSString *imageIDString = [NSString stringWithFormat:@"%i", loan.imageID];
		iKivaImageView *loanImageView = [self.imageCache objectForKey:imageIDString];
		if (loanImageView == nil) {
			CGRect frame = CGRectMake(0, 0, 55, 55);
			iKivaImageView *loanImageView = [[[iKivaImageView alloc] initWithFrame:frame] autorelease];
			loanImageView.tag = 999;
			NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:FEATURED_IMAGE_URL,loan.imageID]];
			[loanImageView loadImageFromURL:url];
			[self.imageCache setObject:loanImageView forKey:imageIDString];
		}
		
		// Configure the cell...
		cell.name.text = loan.name;
		cell.topLeft.text = loan.sector;
		cell.bottomRight.text = loan.fundedPercentage;
		cell.topRight.text = loan.loanAmountString;
		cell.bottomLeft.text = loan.country;
		[cell.cellImage addSubview:[self.imageCache objectForKey:imageIDString]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		cell.bottomRight.textColor = [UIColor blackColor];
		cell.topRight.textColor = [UIColor blackColor];

		//Alternating background Color
        UIView *views = [[[UIView alloc] init] autorelease];
		if (indexPath.row % 2 == 0) {
			views.backgroundColor = TABLE_COLOR_DARK;
        }
		else {
			views.backgroundColor = TABLE_COLOR_LIGHT;
        }
        
        cell.backgroundView = views;
		
        return cell;
	}
	else
		return [super showMoreGroupsAvailableTableCellInTable:tableView];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    if (self.dataLoaded) {
        // User selected the "Load More Loans" cell
        if (indexPath.row == [self.groups count] && (self.totalPages != (self.pageNumber -1))) {
            [self loadKivaData];
        }
        // User selected a loan to drill down
        else {
            iKivaDetailLoanViewController *detailViewController = [[iKivaDetailLoanViewController alloc] initWithNibName:@"iKivaDetailLoanViewController" bundle:nil];
            iKivaLoans *loan;
            if (tableView == self.searchDisplayController.searchResultsTableView)
            {
                loan = [iKivaLoans loansFromDictioary:[self.filteredListContent objectAtIndex:indexPath.row]];
            } else {
                loan = [iKivaLoans loansFromDictioary:[self.groups objectAtIndex:indexPath.row]];                
            }
            detailViewController.objectID = loan.loanID;
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
    }
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{

	 // Update the filtered array based on the search text and scope.
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (int i = 0; i < [self.groups count]; i++)
    {
        iKivaLoans *loan = [iKivaLoans loansFromDictioary:[self.groups objectAtIndex:i]];

        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(SELF contains[cd] %@)", searchText];

        [loan.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
        // Search through the various fields for the Filter text
        BOOL resultName = [predicate evaluateWithObject:loan.name];
        BOOL resultID = [predicate evaluateWithObject:[NSString stringWithFormat:@"%i", loan.loanID]];
        BOOL resultCountry = [predicate evaluateWithObject:loan.country];
        BOOL resultTown = [predicate evaluateWithObject:loan.town];
        BOOL resultSector = [predicate evaluateWithObject:loan.sector];
       
        // If any of the above searches had a hit, return those cells
        if (resultName || resultCountry || resultID || resultSector || resultTown) {
            [self.filteredListContent addObject:[self.groups objectAtIndex:i]];
        }
    }
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end

