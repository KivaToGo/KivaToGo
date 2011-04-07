//
//  iKivaImageView.m
//  iKiva
//
//  Created by SWP on 11/15/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation iKivaImageView

- (void)loadImageFromURL:(NSURL*)url {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	if (_urlConnection != nil) [_urlConnection release];
	if (_imageData != nil) [_imageData release];

    NSURLRequest* request = [NSURLRequest requestWithURL:url 
										  cachePolicy:NSURLRequestUseProtocolCachePolicy 
										  timeoutInterval:60.0];
	_urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (_imageData == nil)
		_imageData = [[NSMutableData alloc] init]; 
	[_imageData appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	[_urlConnection release], _urlConnection=nil;
	
	if ([[self subviews] count]>0)		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	
	//make an image view for the image
	_imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:_imageData]];
	_imageView.contentMode = UIViewContentModeScaleToFill;
	_imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	[self addSubview:_imageView];
	_imageView.frame = self.bounds;
	[_imageView setNeedsLayout];
	[self setNeedsLayout];
    
	[_imageData release]; 
	_imageData=nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	NSLog(@"** iKivaImageView Download Completed");
    // Post the notification that the image was downloaded
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailImageDownloaded" object:nil];
}

// Returns the Image directly
- (UIImage *)image {
	UIImageView* _iv = [[self subviews] objectAtIndex:0];
	return [_iv image];
}

- (void)dealloc {
	[_imageView release];
	[_urlConnection cancel]; //in case the URL is still downloading
	[_urlConnection release];
	[_imageData release]; 
    [super dealloc];
}

@end
