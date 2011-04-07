//
//  iKivaSearchViewController.m
//  iKiva
//
//  Created by SWP on 2/6/11.
//  Copyright 2011 Kallos Inc. All rights reserved.
//

#import "iKivaSearchViewController.h"
#import "JSON.h"
#import "iKivaConstants.h"
#import "iKivaDetailLoanViewController.h"
#import "iKivaLoans.h"
#import "iKivaBaseTableCell.h"
#import "GANTracker.h"

@implementation iKivaSearchViewController
@synthesize listContent;
@synthesize responseData = _responseData, pageNumber = _pageNumber, totalPages = _totalPages;
@synthesize pageSize = _pageSize, loanCount = _loanCount, dataLoaded = _dataLoaded, objectID = _objectID;
@synthesize imageCache = _imageCache, dataURL, pageTitle, pageDescriptor, singleDataSet;
@synthesize searchBar;

#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
    [[GANTracker sharedTracker] trackPageview:@"Search/SearchMain" withError:nil];
    self.pageTitle = @"Search";
	self.title = self.pageTitle;
	self.pageDescriptor = LOANS;
	self.dataURL = SEARCH_URL;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;	
	[super viewDidLoad];
}

- (UITableViewCell *)showMoreGroupsAvailableTableCellInTable:(UITableView *)tableView
{
	static NSString *CellIdentifier2 = @"CellMore";
	UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
	if (cell2 == nil) {
		cell2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
	}
	
	// Configure the cell...
	cell2.textLabel.text = [NSString stringWithFormat:@"%i more loans available", (self.loanCount - [self.listContent count])];
	cell2.textLabel.textAlignment = UITextAlignmentCenter;
    cell2.textLabel.textColor = [UIColor darkGrayColor];
	return cell2;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.dataLoaded) {
		if ([self.listContent count] == 0) {
			return 1; // Show "no results"
		} else if (self.totalPages >= self.pageNumber) {
            return [self.listContent count]+1;
        }
	}
	return [self.listContent count]; // When we have <20 loans (1 page), just return the count
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	
	if ([self.listContent count] > 0) {
		if (indexPath.row < [self.listContent count])
        {
            static NSString *CellIdentifier = @"Cell";
            iKivaLoans *loan = [iKivaLoans loansFromDictioary:[self.listContent objectAtIndex:indexPath.row]];
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.textLabel.text = loan.name;
            // "in_repayment" is ugly, make it pretty
            if ([@"in_repayment" isEqualToString:[loan.fundingStatus lowercaseString]]) {
                cell.detailTextLabel.text = @"Repayment";
            } else {
                cell.detailTextLabel.text = loan.fundingStatus;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            NSString *flagName = [NSString stringWithFormat:@"%@", [loan.countryCode lowercaseString]];
            NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:flagName ofType:@"png"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName]) {
                cell.accessoryView = [[[UIImageView alloc] initWithImage:
                                       [UIImage imageNamed:
                                        flagName]]
                                      autorelease];
            }
            else { // We dont have the flag
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        } else {
            return [self showMoreGroupsAvailableTableCellInTable:tableView];
        }
	}
    // Configure the cell...
    else {
		static NSString *CellIdentifier = @"Cell1";		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.textLabel.text = @"No results found";
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Fail-safe to limit selecting rows until we have the data
    if ([self.listContent count] > 0 && self.dataLoaded) {
        // User selected "Load More Loans" cell
        if (indexPath.row == [self.listContent count] && (self.totalPages != (self.pageNumber -1))) {
            NSLog(@"** User selected more loans");
            [self searchKivaForLoans:self.searchBar.text withPage:self.pageNumber];
        }
        // User selected a loan to drill down
        else {
            iKivaDetailLoanViewController *detailViewController = [[iKivaDetailLoanViewController alloc] initWithNibName:@"iKivaDetailLoanViewController" bundle:nil];
            iKivaLoans *loan = [iKivaLoans loansFromDictioary:[self.listContent objectAtIndex:indexPath.row]];
            detailViewController.objectID = loan.loanID;
            [self.navigationController pushViewController:detailViewController animated:YES];
            detailViewController.navigationController.navigationBarHidden = NO;
            [detailViewController release];
        }
	}
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.dataLoaded = NO;
	NSLog(@"** User selected search");
    // Clear the contents of the table view while we're searching
	if (self.listContent) {
		self.listContent = nil;
		[self.tableView reloadData];
	}
    self.pageNumber = 1;
	self.searchBar.showsCancelButton = NO;
	[self searchKivaForLoans:self.searchBar.text withPage:self.pageNumber];
}

#pragma mark -
#pragma mark Kiva Loan lifecycle
- (void)searchKivaForLoans:(NSString *)searchText withPage:(int)pageNumber
{	
	self.dataLoaded = NO;
    [self.searchBar resignFirstResponder]; // Remove keyboard
    
	if (!self.responseData)
		self.responseData = [NSMutableData data];
	
	NSString *urlString;
	self.navigationItem.title = @"Searching...";
	if (self.dataURL == SEARCH_URL) {
        NSString *convertedText = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"&"];
		urlString = [NSString stringWithFormat:self.dataURL, convertedText, pageNumber];
	}
	else {
		urlString = [NSString stringWithFormat:self.dataURL, [searchText intValue]];
	}
	
	NSLog(@"** Searching for: %@", urlString);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[NSURLConnection connectionWithRequest:request delegate:self];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[GANTracker sharedTracker] dispatch];
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    // We want to show the right keyboard for the user to search
	[self.searchBar resignFirstResponder];
	switch (selectedScope) {
		case 0: // Loans
			NSLog(@"** Selected Loans");
			self.searchBar.keyboardType = UIKeyboardTypeDefault;
			self.dataURL = SEARCH_URL;
			break;
		case 1: // Loan ID
			NSLog(@"** Selected Loans");
			self.searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation; // Default to the number pad
			self.dataURL = INDIVIDUAL_LOAN_URL; //Use this because user is searching for specific loan
			break;
		default:
			break;
	}
	[self.searchBar becomeFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	self.searchBar.showsCancelButton = YES;
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	[self.searchBar resignFirstResponder];
	self.searchBar.showsCancelButton = NO;
}
#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.dataLoaded = NO;
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Uh oh!" 
                                                        message:@"Trouble connecting to Kiva!  Double check your Internet connection and try again later." 
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:@"Retry", nil];
	[errorView show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [errorView release];
	self.navigationItem.title = self.pageTitle;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    self.dataLoaded = YES;
	NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"** %@", responseString);
	
	//{"page":1,"total":491,"page_size":20,"pages":25
	NSDictionary *pagingResponse = [[responseString JSONValue] objectForKey:PAGING];
	self.totalPages = [[pagingResponse objectForKey:TOTAL_LOAN_PAGES] intValue];
	self.pageSize = [[pagingResponse objectForKey:LOANS_RETURNED] intValue];
	self.loanCount = [[pagingResponse objectForKey:LOAN_TOTAL] intValue];
	self.pageNumber = [[pagingResponse objectForKey:LOAN_PAGE] intValue]+1;
	
	if (!self.listContent) {
		self.listContent = [[responseString JSONValue] objectForKey:self.pageDescriptor];
	}
	else {
		for (id key in [[responseString JSONValue] objectForKey:self.pageDescriptor])
            [self.listContent addObject:key];
	}
    
	self.navigationItem.title = self.pageTitle;
	[self.tableView reloadData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[responseString release];
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods 
//Prompt from 'Cannot connect to Kiva'
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		[self searchKivaForLoans:self.searchBar.text withPage:1];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
    self.responseData = nil;
    self.searchBar = nil;
    self.pageTitle = nil;
	self.pageDescriptor = nil;
	self.dataURL = nil;
}


- (void)dealloc {
    self.searchBar = nil;
    self.singleDataSet = nil;
    self.imageCache = nil;
    self.responseData = nil;
    self.listContent = nil;
    self.dataURL = nil;
    self.pageTitle = nil;
    self.pageDescriptor = nil;
    [super dealloc];
}


@end

