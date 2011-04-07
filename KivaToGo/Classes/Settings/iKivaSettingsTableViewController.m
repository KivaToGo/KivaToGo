//
//  iKivaSettingsTableViewController.m
//  iKiva
//
//  Created by SWP on 12/9/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import "iKivaSettingsTableViewController.h"
#import "iKivaConstants.h"
#import "iKivaLenderIDInputViewController.h"
#import <MessageUI/MessageUI.h>
#import "GANTracker.h"
@implementation iKivaSettingsTableViewController
@synthesize aboutInfo = _aboutInfo;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:@"Settings/SettingsMain" withError:nil];
	self.navigationItem.title = @"Settings";
	if (!self.aboutInfo) {
		self.aboutInfo = [NSArray arrayWithObjects:@"Lender ID",
						  @"Kiva's mission is to connect people, through lending, for the sake of alleviating poverty.  By combining microfinance with the Internet, Kiva is creating a global community of people connected through lending.",
						  @"KivaToGo aims to be a natural extension of Kiva.com on your mobile device.  We give you the ability to Find and Fund loans directly from your phone, anywhere in the world.  We are not endorsed, sponsored, or in any way affiliated with Kiva.",
						  [NSArray arrayWithObjects:@"SWP", @"Vijay Kiran", @"Shunji Hori", nil],
						  nil];
	}
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
	else if (section == 1) {
        return 1;   
    }
    else if (section == 2){
        return 3;
    }
	return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = nil;
	cell.detailTextLabel.text = nil; //Clear out our labels
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 1 || indexPath.section == 2) {
		cell.textLabel.numberOfLines = 0;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    // Configure the cell...
	if (indexPath.section == 3)
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Nate Weiner";
                cell.detailTextLabel.text = @"ShareKit";
                break;
            case 1:
                cell.textLabel.text = @"Leah Culver";
                cell.detailTextLabel.text = @"PullToRefresh";
                break;
            case 2:
                cell.textLabel.text = @"Stig Brautaset";
                cell.detailTextLabel.text = @"JSON";
                break;
            case 3:
                cell.textLabel.text = @"IconDrawer";
                cell.detailTextLabel.text = @"Flags";
                break;
            default:
                break;
        }
		
	}
	else {
        if (indexPath.section == 2 && indexPath.row == 2) {
            cell.textLabel.text = @"Version";
            cell.detailTextLabel.text = APP_VERSION;
        }
        else if (indexPath.section == 2 && indexPath.row == 1) {
            cell.textLabel.text = @"Send App Feedback";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else  { //About this app description
            cell.textLabel.text = [self.aboutInfo objectAtIndex:indexPath.section];
		}
        
		if (indexPath.section == 0)
		{
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			if ([iKivaConstants hasLenderID])
				cell.detailTextLabel.text = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LENDER_ID_KEY];
		}
	}
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return nil;
			break;
		case 1:
			return @"About Kiva";
			break;
		case 2:
			return @"About This App";
			break;
		case 3:
			return @"Special Thanks";
			break;
		default:
			return nil;
			break;
	}
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return NO;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1 || (indexPath.section == 2 && indexPath.row == 0)) {
		return [iKivaConstants dynamicRowHeightFromText:[self.aboutInfo objectAtIndex:indexPath.section]];
	}
	return 44.0f;
}


#pragma mark -
#pragma mark Table view delegate

 -(void) showEmailModalView {
     
     MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
     NSString *subject = [NSString stringWithFormat:@"KivaToGo App (%@) Feedback", APP_VERSION];
     [picker setSubject:subject];
     [picker setToRecipients:[NSArray arrayWithObject:@"KivaToGo@Gmail.com"]];
     picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
     picker.mailComposeDelegate = self;
     [self presentModalViewController:picker animated:YES];
     [picker release];
     
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback Sent!" 
                                                            message:@"Thank you for your time.  Your feedback is appreciated and will result in a better app for everyone!"
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
            break;
        case MFMailComposeResultFailed:  
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback Error!" message:@"Sending your feedback failed for an unknown reason.  Please try again."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.section == 0) {
		iKivaLenderIDInputViewController *detailViewController = [[iKivaLenderIDInputViewController alloc] initWithNibName:@"iKivaLenderIDInputViewController" bundle:nil];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController.textField becomeFirstResponder];
		[detailViewController release];
	}
    else if (indexPath.section == 2 && indexPath.row == 1) {
        [self showEmailModalView];
    }
	else if (indexPath.section == 3) {
		switch (indexPath.row) {
			case 0:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.getsharekit.com"]];
				break;
			case 1:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.plancast.com"]];
				break;
			case 2:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://code.google.com/p/json-framework/"]];
				break;
            case 3:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.icondrawer.com"]];
				break;
            default:
				break;
		}
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
	self.aboutInfo = nil;
}


- (void)dealloc {
    self.aboutInfo = nil;
    [super dealloc];
}


@end

