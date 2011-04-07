//
//  iKivaBaseTableViewController.m
//  iKiva
//
//  Created by SWP on 11/7/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaBaseTableViewController.h"
#import "iKivaLoanViewController.h"
#import "GANTracker.h"

@implementation iKivaBaseTableViewController
@synthesize groups = _groups;
@synthesize responseData = _responseData;
@synthesize pageNumber = _pageNumber;
@synthesize totalPages = _totalPages;
@synthesize pageSize = _pageSize;
@synthesize loanCount = _loanCount;
@synthesize dataLoaded = _dataLoaded;
@synthesize objectID = _objectID;
@synthesize imageCache = _imageCache;
@synthesize dataURL, pageTitle, pageDescriptor, singleDataSet, filteredListContent, sortOption = _sortOption;

#pragma mark -
#pragma mark Kiva Loan lifecycle
- (void)loadKivaData
{	
    // Fail-safe to make sure we a URL to call
	if (self.dataURL != @"") {
        
        if (!self.responseData)
            self.responseData = [NSMutableData data];

		self.dataLoaded = NO;
        
        NSString *urlString;
        // Finish building URL - if we are searching, we need an extra parm
        if ([FILTER_URL isEqualToString:self.dataURL]) {
           urlString = [NSString stringWithFormat:FILTER_URL, self.sortOption, self.pageNumber];
        } else {
            urlString = [NSString stringWithFormat:self.dataURL, self.pageNumber];
        }
        
        NSLog(@"** REQUESTING URL: %@, page %i", urlString, self.pageNumber);
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
		[NSURLConnection connectionWithRequest:request delegate:self];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[GANTracker sharedTracker] dispatch];

	}
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Problem!" 
                                                        message:@"Trouble connecting to Kiva!  Check your Internet connection and try again later." 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:@"Retry", nil];
	[errorView show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	self.dataLoaded = NO;
    [errorView release];
	[super stopLoading];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"** %@", responseString);
	
    // Populate "meta" properties for the data
	//{"page":1,"total":491,"page_size":20,"pages":25
	NSDictionary *pagingResponse = [[responseString JSONValue] objectForKey:PAGING];
	self.totalPages = [[pagingResponse objectForKey:TOTAL_LOAN_PAGES] intValue];
	self.pageSize = [[pagingResponse objectForKey:LOANS_RETURNED] intValue];
	self.loanCount = [[pagingResponse objectForKey:LOAN_TOTAL] intValue];
    
    // We set page to +1 to detect if there is another page to load later
	self.pageNumber = [[pagingResponse objectForKey:LOAN_PAGE] intValue]+1; 
   
    NSLog(@"** PAGE: %i, page %i", self.totalPages, self.pageNumber);

    // If we've never loaded the group yet, or if we are refreshing the first page
	if (!self.groups || (self.groups && (self.pageNumber -1 == 1))) {
        [self.groups removeAllObjects];
		self.groups = [[responseString JSONValue] objectForKey:self.pageDescriptor];
	}
    else { // User selected "More loans"
		for (id key in [[responseString JSONValue] objectForKey:self.pageDescriptor])
			[self.groups addObject:key];
	}
	
	if (self.groups)
	{
		self.dataLoaded = YES;
	}
    
    // Setup our Filter array to match our Groups array
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.groups count]];
	
	self.navigationItem.title = self.pageTitle;
	[self.tableView reloadData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[responseString release];
    // Call the PullToRefresh stopLoading so our arrow resets
	[super stopLoading];
    
}
- (void)refreshLoans:(id)sender
{
	NSLog(@"** Refresh Requested");
    
	// Get Kiva data
	self.pageNumber = 1;
    
    // We dont want to the "Pull To Refresh" feature when viewing search results
    if (!self.searchDisplayController.active) {
        NSLog(@"** Load Kiva Data");
        [self loadKivaData];
    } else {
        NSLog(@"** Viewing search results, cancelling Load Data");
        [super stopLoading];
    }
}
// Override of super class (PullToRefresh) method when arrow is exposed
- (void)refresh
{
	[self refreshLoans:self];
}

#pragma mark -
#pragma mark Sort Delegate Method
- (void)userSelectedSortOption:(NSString *)sortOption withDisplayName:(NSString *)displayName
{
    // First make sure user didnt select Cancel
    if (![@"Cancel" isEqualToString:sortOption]) {
        NSLog(@"** User selected: %@", sortOption);
        self.pageNumber = 1;
        self.dataURL = FILTER_URL;
        self.sortOption = sortOption;
        self.navigationItem.title = @"Loading...";
        self.pageTitle = displayName;
        [self loadKivaData];
        
        // Scroll the table back to the top with new data
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    } else {
        NSLog(@"** User selected cancel");
    }
}

// User selects the AZ icon
- (void)sortButtonSelected:(id)sender
{
    NSLog(@"** Sort selected");
    KTGSortOptionsTableViewController *dvc = [[KTGSortOptionsTableViewController alloc] initWithNibName:@"KTGSortOptionsTableViewController" bundle:nil];
    dvc.delegate = self;
    
    // Check what kind of class we are, in the future this can used for offering filtering for Teams, Lenders, etc
    if ([self isKindOfClass:[iKivaLoanViewController class]]) {
        dvc.sortClass = @"Loans";
    }
    
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:dvc];
    [self presentModalViewController:navBar animated:YES];
    [dvc release];
}

- (void)removeExistingImageView:(UITableViewCell *)cell
{
	iKivaImageView *oldImage = (iKivaImageView *)[cell.contentView viewWithTag:999];
	[oldImage removeFromSuperview];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Prompt for connection error - User selects "RETRY"
	if (buttonIndex == 1) {
		[self loadKivaData];
	}
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
		
	self.navigationItem.title = self.pageTitle;
	self.tableView.backgroundColor = TABLE_COLOR_DARK;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor lightGrayColor];

    // Subclass will implement sortButtonSelected:
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"a-z"] style:UIBarButtonItemStyleBordered target:self action:@selector(sortButtonSelected:)];
    
    self.navigationItem.rightBarButtonItem = sort;
    [sort release];
   
    // Set table offset to hide 'Filter' upfront
    self.tableView.contentOffset = CGPointMake(0.0, 44.0);
    
	// Get Kiva data - If data has not been loaded (i.e. first time load, no internet, etc)
	if (!self.dataLoaded) {
        if (!self.imageCache) {
            self.imageCache = [[[NSMutableDictionary alloc] init] autorelease];
        }
		self.pageNumber = 1;
		[self loadKivaData];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source
- (UITableViewCell *)showMoreGroupsAvailableTableCellInTable:(UITableView *)tableView
{
	static NSString *CellIdentifier2 = @"CellMore";
	UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
	if (cell2 == nil) {
		cell2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
	}
	
	// Configure the cell...
	cell2.textLabel.text = [NSString stringWithFormat:@"%i more loans available", (self.loanCount - [self.groups count])];
	cell2.textLabel.textAlignment = UITextAlignmentCenter;
    cell2.textLabel.textColor = [UIColor blackColor];
	return cell2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 65.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [self.filteredListContent count];
    else  {
        if (self.dataLoaded && (self.totalPages >= self.pageNumber))
            return [self.groups count]+1;  // Show "More Loans Available" cell at the bottom
        else
            return [self.groups count]; // Otherwise, just show the loans
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
    self.responseData = nil;
}


- (void)dealloc {
    self.imageCache = nil;
    self.dataURL = nil;
    self.pageTitle = nil;
    self.sortOption = nil;
    self.filteredListContent = nil;
	self.pageDescriptor = nil;
	self.groups = nil;
	self.responseData = nil;
    [super dealloc];
}

@end