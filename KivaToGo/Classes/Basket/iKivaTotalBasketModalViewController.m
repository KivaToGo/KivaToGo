//
//  iKivaTotalBasketModalViewController.m
//  iKiva
//
//  Created by SWP on 12/24/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import "iKivaTotalBasketModalViewController.h"
#import "GANTracker.h"

@implementation iKivaTotalBasketModalViewController
@synthesize delegate, donationSwitch;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:@"Basket/DonateModal" withError:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL switchOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"donationSwitch"];
    if (switchOn) {
        [self.donationSwitch setOn:YES animated:NO];
    } else {
        [self.donationSwitch setOn:NO animated:NO];
    }
}

- (IBAction)doneButtonSelected:(id)sender
{
    [self.delegate userChangedDonationToggle:donationSwitchStatus];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)toggleChanged:(id)sender
{
    UISwitch *don = (UISwitch *)sender;
    BOOL donation = NO;
    if ([don isOn]) {
        donation = YES;
    }
    [[NSUserDefaults standardUserDefaults] setBool:donation forKey:@"donationSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    donationSwitchStatus = donation;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.donationSwitch = nil;
    self.delegate = nil;
    [super dealloc];
}


@end
