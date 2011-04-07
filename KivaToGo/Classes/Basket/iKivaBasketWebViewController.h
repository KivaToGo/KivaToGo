//
//  iKivaBasketWebViewController.h
//  iKiva
//
//  Created by SWP on 12/21/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKivaBasketWebViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *_webView;
	UIActivityIndicatorView *_activityIndicator;
	NSString *_uploadString;
	NSString *_donationString;

}
@property (nonatomic, copy) NSString *uploadString;
@property (nonatomic, copy) NSString *donationString;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
