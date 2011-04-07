//
//  iKivaDetailTeamViewController.m
//  iKiva
//
//  Created by SWP on 11/13/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaDetailTeamViewController.h"
#import "iKivaDetailTeams.h"
#import "GANTracker.h"

@implementation iKivaDetailTeamViewController
@synthesize summaryView = _summaryView;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [[GANTracker sharedTracker] trackPageview:@"TeamsDetail/TeamsDetalMain" withError:nil];
	_name = [[NSString alloc] initWithString:self.navigationItem.title];
	self.pageTitle = _name;
	self.dataURL = [NSString stringWithFormat:INDIVIDUAL_TEAM_URL, self.objectID];
	self.pageDescriptor = TEAMS;
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshLoans:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
	
	[super viewDidLoad];
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
	return [iKivaConstants dynamicRowHeightFromText:[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (self.dataLoaded) {
		return 3;
	}
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	iKivaDetailTeams *teams = [iKivaDetailTeams teamsFromDictioary:[self.groups objectAtIndex:0]];
	if (self.dataLoaded) {
	
	// Return the number of rows in the section.
	if (section == 0) 
		return 0;
	else if (section == 1)
		return 4;
	else if (section == 2  && (teams.description.length > 0))
		return 3;
	else
		return 2;
	}
	else {
		return 1;
	}

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
	iKivaDetailTeams *teams = [iKivaDetailTeams teamsFromDictioary:[self.groups objectAtIndex:0]];

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	// Configure the cell...
	iKivaImageView *loanImageView = [self.imageCache objectForKey:teams.imageIDString];
	
	if (loanImageView == nil) {
		CGRect frame = CGRectMake(0, 0, 55, 55);
		iKivaImageView *loanImageView = [[[iKivaImageView alloc] initWithFrame:frame] autorelease];
		loanImageView.tag = 999;
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:FEATURED_IMAGE_URL,teams.imageID]];
		[loanImageView loadImageFromURL:url];
		[self.imageCache setObject:loanImageView forKey:teams.imageIDString];
	}
	
	[self.summaryView.lenderImage addSubview:[self.imageCache objectForKey:teams.imageIDString]];
	self.summaryView.topLabel.text = teams.name;
	self.summaryView.bottomLabel.text = teams.shortName;
	cell.detailTextLabel.numberOfLines = 0;
	if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"formed";
				cell.detailTextLabel.text = teams.teamSince;
				break;
			case 1:
				cell.textLabel.text = @"type";
				cell.detailTextLabel.text = teams.membershipType;
				break;
			case 2:
				cell.textLabel.text = @"members";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", teams.membershipCount];
				break;
			case 3:
				cell.textLabel.text = @"amount";
				cell.detailTextLabel.text = teams.loanedAmountString; //[NSString stringWithFormat:@"$%.2f", (double)teams.loanedAmount];
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
				cell.textLabel.text = @"reason";
				cell.detailTextLabel.text = teams.loanReason;
				break;
			case 1:
				if (teams.description && ![teams.description isEqualToString:@""]) {
					cell.textLabel.text = @"description";
					cell.detailTextLabel.text = teams.description;
				}
				else {
					cell.textLabel.text = @"website";
					cell.detailTextLabel.text = teams.teamURL;
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
				break;
			case 2:
				if (teams.description && ![teams.description isEqualToString:@""]) {
					cell.textLabel.text = @"website";
					cell.detailTextLabel.text = teams.teamURL;
					cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				}
				break;
			default:
				cell.textLabel.text = @"other";
				cell.detailTextLabel.text = @"N/A";
				break;
		}
	}
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
    self.summaryView = nil;
}


- (void)dealloc {
    self.summaryView = nil;
    [super dealloc];
}


@end

