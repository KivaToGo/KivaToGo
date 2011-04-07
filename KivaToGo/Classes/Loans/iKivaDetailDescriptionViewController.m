//
//  iKivaDetailDescriptionViewController.m
//  iKiva
//
//  Created by SWP on 2/11/11.
//  Copyright 2011 Kallos Inc. All rights reserved.
//

#import "iKivaDetailDescriptionViewController.h"
#import "GANTracker.h"

@implementation iKivaDetailDescriptionViewController
@synthesize descriptionLabel, description;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"Description";
	self.descriptionLabel.text = self.description;
    [[GANTracker sharedTracker] trackPageview:@"LoanDetail/Description" withError:nil];
    [super viewDidLoad];
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
    [super dealloc];
}


@end
