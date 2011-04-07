//
//  iKivaPortfolioViewController.m
//  iKiva
//
//  Created by SWP on 11/6/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaPortfolioViewController.h"
#import "iKivaPortfolio.h"
#import "iKivaImageView.h"
#import "GANTracker.h"
@implementation iKivaPortfolioViewController
@synthesize lenderID, summaryView = _summaryView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	if ([iKivaConstants hasLenderID]) {
		self.lenderID = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LENDER_ID_KEY];
		self.dataURL = [NSString stringWithFormat:PORTFOLIO_URL, self.lenderID];
	}
	else {
		self.dataURL = @"";
	}
	self.pageTitle = @"My Portfolio";
	self.pageDescriptor = LENDERS;
    [[GANTracker sharedTracker] trackPageview:@"Portfolio/PortfolioMain" withError:nil];
	[super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = nil;

}
- (void)refreshLoans:(id)sender
{
	NSString *newID = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LENDER_ID_KEY];
	if (![newID isEqualToString:self.lenderID]) {
		self.lenderID = newID;
		self.dataURL = nil;
		self.dataURL = [NSString stringWithFormat:PORTFOLIO_URL, self.lenderID];
	}
	[super refreshLoans:sender];
}
#pragma mark -
#pragma mark Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return 65.0f; //return self.summaryView.frame.size.height; //This is shrunked 10 points to bring the tables closer together
	return 0.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	iKivaPortfolio *portfolio = [iKivaPortfolio portfolioFromDictioary:[self.groups objectAtIndex:0]];

	if (indexPath.section == 2 && indexPath.row == 1) {		
		return [iKivaConstants dynamicRowHeightFromText:[NSString stringWithFormat:@"%@ - %@", portfolio.occupation, portfolio.occupationDetails]];						
	}
	else if (indexPath.section == 1 && indexPath.row == 2) {		
		return [iKivaConstants dynamicRowHeightFromText:portfolio.loanReason];
	}
	return 55.0f;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
	if (self.dataLoaded) 
		return 3;
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (self.dataLoaded) 
	{
		if (section == 0) 
			return 0;
		else if ([self.groups count] > 0)
			return 3;
		else
			return 1;
	}
	else 
		return 1; //Show no lender found cell
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		if(!self.summaryView)
			self.summaryView = [[[NSBundle mainBundle] loadNibNamed:@"iKivaPortfolioImageView" owner:self options:nil] objectAtIndex:0];
		return self.summaryView;
	}	
	return nil;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if ([self.groups count] > 0) //Determine if we find lender ID/a connection
	{
		//Download Lender Image
		iKivaPortfolio *portfolio = [iKivaPortfolio portfolioFromDictioary:[self.groups objectAtIndex:0]];
		iKivaImageView *loanImageView = [self.imageCache objectForKey:portfolio.imageIDString];
		if (loanImageView == nil) {
			CGRect frame = CGRectMake(0, 0, 55, 55);
			iKivaImageView *loanImageView = [[[iKivaImageView alloc] initWithFrame:frame] autorelease];
			loanImageView.tag = 999;
			NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:FEATURED_IMAGE_URL,portfolio.imageID]];
			[loanImageView loadImageFromURL:url];
			[self.imageCache setObject:loanImageView forKey:portfolio.imageIDString];
		}
		[self.summaryView.lenderImage addSubview:[self.imageCache objectForKey:portfolio.imageIDString]];
		self.summaryView.topLabel.text = portfolio.name;
		self.summaryView.bottomLabel.text = portfolio.lenderID;
		
		if (indexPath.section == 1) {
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"joined";
					cell.detailTextLabel.text = portfolio.memberSince;
					break;
				case 1:
					cell.textLabel.text = @"loan count";
					cell.detailTextLabel.text = portfolio.loanCount;
					break;
				case 2:
					cell.textLabel.text = @"reason";
					cell.detailTextLabel.text = portfolio.loanReason;
					cell.detailTextLabel.numberOfLines = 0;
					break;
				default:
					cell.textLabel.text = @"other";
					cell.detailTextLabel.text = @"N/A";
					break;
			}
		}
		else if (indexPath.section == 2) {
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"location";
					if (portfolio.countryCode && portfolio.countryCode != @"")
						cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", portfolio.location, portfolio.countryCode];
					else
						cell.detailTextLabel.text = portfolio.location;
					break;
				case 1:
					cell.textLabel.text = @"occupation";
					if (portfolio.occupationDetails && portfolio.occupationDetails != @"")
						cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", portfolio.occupation, portfolio.occupationDetails];						
					else 
						cell.detailTextLabel.text = portfolio.occupation;
					cell.detailTextLabel.numberOfLines = 0;
					break;
				case 2:
					cell.textLabel.text = @"website";
					cell.detailTextLabel.text = portfolio.personalURL;
					//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					break;
				default:
					cell.textLabel.text = @"other";
					cell.detailTextLabel.text = @"N/A";
					break;
			}
		}
		return cell;
	}
	else {
		//cell.textLabel.text = @"loading";
		cell.detailTextLabel.text = @"No Details Found";
		return cell;
	}
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Nothing
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
    self.lenderID = nil;
}


- (void)dealloc {
    self.lenderID = nil;
    self.summaryView = nil;
    [super dealloc];
}


@end

