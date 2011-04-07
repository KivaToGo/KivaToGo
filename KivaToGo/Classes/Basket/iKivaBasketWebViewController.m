//
//  iKivaBasketWebViewController.m
//  iKiva
//
//  Created by SWP on 12/21/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import "iKivaBasketWebViewController.h"
#import "iKivaConstants.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "GANTracker.h"

@implementation iKivaBasketWebViewController
@synthesize webView = _webView, activityIndicator = _activityIndicator, uploadString = _uploadString, donationString = _donationString;

- (void)populateLoanBasketOnline
{	
	// Setup request
    NSURL *url = [NSURL URLWithString:BASKET_URL];
    NSMutableData *postBody = [NSMutableData data];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	NSString *boundary = @"----xasd2t3vAFLKb3230gbSNBKLq323nbx000";  // This is random
	NSString *loanJSON = self.uploadString;
    NSString *donation = self.donationString;
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
    [req setValue:contentType forHTTPHeaderField:@"Content-Type"];

    // Change to POST, default is GET
	[req setHTTPMethod:@"POST"];

    // Add loans
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name= \"loans\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[loanJSON dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add donation
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name= \"donation\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[donation dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add App ID
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name= \"app_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"com.SWP.kivatogo" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Final boundry
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add Body to request
    [req setHTTPBody:postBody];
    
    // Load this bad boy
    [self.webView loadRequest:req];

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:@"/Basket/Checkout" withError:nil];
	self.navigationItem.title = @"Checkout";
	[self populateLoanBasketOnline];
}

#pragma mark -
#pragma mark webView Delegate Methods
- (void)webViewDidStartLoad:(UIWebView *)wv {
    NSLog (@"webViewDidStartLoad: %@", wv.request);
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    NSLog (@"webViewDidFinishLoad: %@", wv.request);
    [self.activityIndicator stopAnimating];
	NSString *url = [[[wv request] URL] absoluteString];
	NSLog(@"** URL: %@ - %@", url, [url lastPathComponent]);
    
    // The below code can be used to inject JavaScript to perform certain actions (like autoclicking the 'Submit' button on the Review page
    // It can also be used if you wish to implement a custom UID/PWD system and you can inject them into the respective fields in the logon 
    // screen.
    // I commented it out because it broken when Kiva released their updated site in March 2011 (needs a simple fix)
	/*if ([[url lastPathComponent] hasPrefix:@"basket"]) {
		
		self.navigationItem.title = @"Review";
		[self.webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit()"];
	}
	else if ([[url lastPathComponent] hasPrefix:@"register?"]) {
		self.navigationItem.title = @"Log On";
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[0].click()"];
	}
	else if ([[url lastPathComponent] hasPrefix:@"payment"]) {
		self.navigationItem.title = @"Checkout";
		//UIViewController *mvc = [[UIViewController alloc] initWithNibName:@"iKivaBasketWebViewController" bundle:nil];
		//[self presentModalViewController:mvc animated:YES];
	}
	//[self.webView stringByEvaluatingJavaScriptFromString:@"var field = document.getElementById('email');" "field.value='chris@rules.com';"];
	//	[self.webView stringByEvaluatingJavaScriptFromString:@"var field2 = document.getElementsByName('password');" "field2.value='password';"];
	//[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('loginForm').submit();"];
     */
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    NSLog (@"webView:didFailLoadWithError");
    [self.activityIndicator stopAnimating];
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: [error localizedDescription]
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK" 
								   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
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
    self.webView = nil;
    self.activityIndicator = nil;
}


- (void)dealloc {
	self.webView.delegate = nil;
	self.webView = nil;
	self.activityIndicator = nil;
    self.donationString = nil;
    [super dealloc];
}


@end
