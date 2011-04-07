//
//  iKivaBaseDetailTableViewController.m
//  iKiva
//
//  Created by SWP on 11/7/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaBaseDetailTableViewController.h"
#import "GANTracker.h"

@implementation iKivaBaseDetailTableViewController
@synthesize objectID = _objectID;
@synthesize tableView = _tableView;
@synthesize groups = _groups;
@synthesize responseData = _responseData;
@synthesize pageNumber = _pageNumber;
@synthesize totalPages = _totalPages;
@synthesize pageSize = _pageSize;
@synthesize loanCount = _loanCount;
@synthesize dataLoaded = _dataLoaded;
@synthesize imageCache = _imageCache;
@synthesize dataURL = _dataURL, pageTitle = _pageTitle, pageDescriptor = _pageDescriptor;
@synthesize singleDataSet = _singleDataSet;

#pragma mark -
#pragma mark Kiva Loan lifecycle
- (void)loadKivaData
{	
	if (!self.responseData)
		self.responseData = [NSMutableData data];
	
	if (self.dataURL != @"") {
		// Set title while loading
		self.navigationItem.title = @"Loading...";
		self.dataLoaded = NO;
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dataURL]];
		[NSURLConnection connectionWithRequest:request delegate:self];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[GANTracker sharedTracker] dispatch];
	}
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Uh oh!" 
                                                        message:@"Trouble connecting to Kiva!  Double check your Internet connection and try again later." 
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:@"Retry", nil];
	[errorView show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	self.navigationItem.title = self.pageTitle;
    [errorView release];
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

	if (!self.groups) {
		// Check whether we only have 1 element or not
		if ([[[responseString JSONValue] objectForKey:self.pageDescriptor] count] == 1) {
			self.singleDataSet = [[responseString JSONValue] objectForKey:self.pageDescriptor];
			self.groups = [[responseString JSONValue] objectForKey:self.pageDescriptor]; // Legacy support for non-singleDataSet use
		}
		else
			self.groups = [[responseString JSONValue] objectForKey:self.pageDescriptor];
	}
	else { // user requested more data on existing page, append values to array
		for (id key in [[responseString JSONValue] objectForKey:self.pageDescriptor])
			[self.groups addObject:key];
	}
	
    // If we have data, set the dataLoaded flat to YES
	if (self.groups || self.singleDataSet)
	{
		self.dataLoaded = YES;
	}
    
	self.navigationItem.title = self.pageTitle;
	[self.tableView reloadData]; // Refresh the table with our new data
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[responseString release];
    
}

- (void)refreshLoans:(id)sender
{
	NSLog(@"** Refresh Requested");
	// Get Kiva data
	[self.groups removeAllObjects];
	[self.singleDataSet removeAllObjects];
	[self loadKivaData];
}

// Abstracted base method to remove the existing image in the Image cell - this should most likely never be called
// because the cell is recreated on every drill down
- (void)removeExistingImageView:(UITableViewCell *)cell
{
	iKivaImageView *oldImage = (iKivaImageView *)[cell.contentView viewWithTag:999];
	[oldImage removeFromSuperview];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// Prompt from 'Cannot connect to Kiva'
    // User selected "Retry"
    if (buttonIndex == 1) {
		[self loadKivaData];
	}
}

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.dataLoaded = NO;
	self.navigationItem.title = self.pageTitle;
	if (!self.imageCache)
		self.imageCache = [[[NSMutableDictionary alloc] init] autorelease];
		
	// Get Kiva data
	if (!self.dataLoaded) {
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
    self.responseData = nil;
}


- (void)dealloc {
    self.singleDataSet = nil;
    self.tableView = nil;
    self.groups = nil;
    self.responseData = nil;
    self.imageCache = nil;
    self.dataURL = nil;
    self.pageTitle = nil;
    self.pageDescriptor = nil;
    [super dealloc];
}

@end

