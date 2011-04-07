//
//  KTGSortOptionsTableViewController.m
//  iKiva
//
//  Created by SWP on 3/13/11.
//  Copyright 2011 Kallos Inc. All rights reserved.
//

#import "KTGSortOptionsTableViewController.h"
#import "GANTracker.h"

@implementation KTGSortOptionsTableViewController
@synthesize sortOptions, sortClass, delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:@"/Loans/SortModal" withError:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.title = @"Sort Options";
    
    // Check if we're using Loans (only implementation thus far)
    if ([@"Loans" isEqualToString:sortClass] && !self.sortOptions) {
        //popularity, loan_amount, oldest, expiration, newest, amount_remaining, repayment_term
        self.sortOptions = [NSArray arrayWithObjects:
                       @"Newest (Default)", 
                       @"Most Popular",
                       @"Oldest", 
                       @"Amount Remaining",
                       @"Repayment Terms", 
                       nil];
        [self.tableView reloadData];
    }
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = cancel;
    [cancel release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sortOptions = nil;
    self.sortClass = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    self.sortOptions = nil;
    self.sortClass = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sortOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.sortOptions objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedOption = nil;
    NSString *displayName = nil;
    if ([@"Loans" isEqualToString:sortClass]) {
        switch (indexPath.row) {
            case 0:
                selectedOption = @"newest";
                displayName = @"Newest Loans";
                break;
            case 1:
                selectedOption = @"popularity";
                displayName = @"Most Popular Loans";
                break;
            case 2:
                selectedOption = @"oldest";
                displayName = @"Oldest Loans";
                break;
            case 3:
                selectedOption = @"amount_remaining";
                displayName = @"Amount Remaining";
                break;
            case 4:
                selectedOption = @"repayment_term";
                displayName = @"Repayment Terms";
                break;
            default:
                selectedOption = @"newest";
                displayName = @"Newest Loans";

                break;
        }
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString *logSort = [NSString stringWithFormat:@"/Loans/SortModal/%@", selectedOption];
    [[GANTracker sharedTracker] trackPageview:logSort withError:nil];
    
    [self.delegate userSelectedSortOption:selectedOption withDisplayName:displayName];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel:(id)sender
{
    [self.delegate userSelectedSortOption:@"Cancel" withDisplayName:nil];
    [self dismissModalViewControllerAnimated:YES];
}

@end
