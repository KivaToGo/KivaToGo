//
//  iKivaLenderIDInputViewController.m
//  iKiva
//
//  Created by SWP on 12/9/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import "iKivaLenderIDInputViewController.h"
#import "iKivaConstants.h"
#import "GANTracker.h"
@implementation iKivaLenderIDInputViewController
@synthesize textField = _textField;
@synthesize findLenderButton = _findLenderButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:@"Settings/LenderIDInput" withError:nil];
	self.navigationItem.title = @"Enter ID";
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
    [super viewDidUnload];
	self.textField = nil;
	self.findLenderButton = nil;
}

- (IBAction)findLenderButtonSelected:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leaving KivaToGo" message:@"This will launch Safari and take you to Kiva.com to help you find your Lender ID" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

-(BOOL) textFieldShouldReturn:(UITextField *) textField {
    [self.textField resignFirstResponder];
	[self.navigationController popViewControllerAnimated:YES];	
	[iKivaConstants saveToUserDefaults:self.textField.text forKey:LENDER_ID_KEY];
	return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 1:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:LENDER_HELP_URL]];
			break;
		default:
			break;
	}
}

- (void)dealloc {
    // Should probably catch this somewhere else
    // If the user has entered text and hit the "Back" button, save that entry
	if ([self.textField.text length] > 0)
		[iKivaConstants saveToUserDefaults:self.textField.text forKey:LENDER_ID_KEY];
    
    self.textField = nil;
	self.findLenderButton = nil;
    [super dealloc];
}


@end
