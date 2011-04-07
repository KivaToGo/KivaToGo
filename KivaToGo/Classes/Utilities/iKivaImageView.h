//
//  iKivaImageView.h
//  iKiva
//
//  Created by SWP on 11/15/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTGImageViewDelegate <NSObject>
- (void)imageFinishedLoading;
@end

@interface iKivaImageView : UIView {
    NSURLConnection *_urlConnection;
	NSMutableData* _imageData; 
	UIImageView *_imageView;
}

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;

@end