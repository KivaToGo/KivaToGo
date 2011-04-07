//
//  iKivaTeamsViewController.m
//  iKiva
//
//  Created by SWP on 11/6/10.
//  Copyright 2010 SWP. All rights reserved.
//
#import "iKivaTeams.h"
#import "iKivaTeamsViewController.h"
#import "iKivaDetailTeamViewController.h"
#import "GANTracker.h"
@implementation iKivaTeamsViewController

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [[GANTracker sharedTracker] trackPageview:@"Teams/TeamsMain" withError:nil];
	self.dataLoaded = NO;
	// TODO: Is this a memory leak?
	self.dataURL = FEATURED_TEAMS_URL;
	self.pageDescriptor = TEAMS;

	self.pageTitle = @"Top Teams";
	// Set the back button when we push a new VC
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Teams" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
    [super viewDidLoad];

}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.groups count])
	{
		static NSString *CellIdentifier = @"Cell";
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
		
		iKivaTeams *team = [iKivaTeams teamsFromDictioary:[self.groups objectAtIndex:indexPath.row]];
		NSString *imageIDString = [NSString stringWithFormat:@"%i", team.imageID];
		
		iKivaImageView *loanImageView = [self.imageCache objectForKey:imageIDString];
		
		if (loanImageView == nil) {
			CGRect frame = CGRectMake(0, 0, 55, 55);
			iKivaImageView *loanImageView = [[[iKivaImageView alloc] initWithFrame:frame] autorelease];
			loanImageView.tag = 999;
			NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:FEATURED_IMAGE_URL,team.imageID]];
			[loanImageView loadImageFromURL:url];
			[self.imageCache setObject:loanImageView forKey:imageIDString];
			NSLog(@"** DOWNLOADED TEAM IMAGE: %@ %@", loanImageView, imageIDString);
		}	
		
		// Configure the cell...
		cell.name.text = team.name;
		cell.bottomRight.text = team.loanCountString;
		cell.bottomLeft.text = team.location;
		cell.topRight.text = team.membershipCountString;
		cell.topLeft.text = team.category;
		[cell.cellImage addSubview:[self.imageCache objectForKey:imageIDString]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
	else {
		return [super showMoreGroupsAvailableTableCellInTable:tableView];
	}
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	if (indexPath.row == [self.groups count]) {
		[self loadKivaData];
	}
	else {
		iKivaDetailTeamViewController *detailViewController = [[iKivaDetailTeamViewController alloc] initWithNibName:@"iKivaDetailTeamViewController" bundle:nil];
		iKivaTeams *team = [iKivaTeams teamsFromDictioary:[self.groups objectAtIndex:indexPath.row]];
		detailViewController.objectID = team.teamID;
		detailViewController.navigationItem.title = [NSString stringWithFormat:@"Team %i", team.teamID];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    // Relinquish ownership any cached data, images, etc that aren't in use.
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidLoad];
}


- (void)dealloc {
    [super dealloc];
}


@end
