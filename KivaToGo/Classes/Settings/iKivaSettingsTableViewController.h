//
//  iKivaSettingsTableViewController.h
//  iKiva
//
//  Created by SWP on 12/9/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface iKivaSettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>{
	NSArray *_aboutInfo;
}
@property (nonatomic, retain) NSArray *aboutInfo;
@end
