//
//  iKivaDetailDescriptionViewController.h
//  iKiva
//
//  Created by SWP on 2/11/11.
//  Copyright 2011 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKivaDetailDescriptionViewController : UIViewController {
	UITextView *descriptionLabel;
	NSString *description;
}
@property (nonatomic, retain) IBOutlet UITextView *descriptionLabel;
@property (nonatomic, copy) NSString *description;

@end

