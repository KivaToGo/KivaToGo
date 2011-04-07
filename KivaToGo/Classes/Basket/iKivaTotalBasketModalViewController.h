//
//  iKivaTotalBasketModalViewController.h
//  iKiva
//
//  Created by SWP on 12/24/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTGDonationDelegate <NSObject>
-(void)userChangedDonationToggle:(BOOL)status;
@end

@interface iKivaTotalBasketModalViewController : UIViewController {
    id<KTGDonationDelegate> delegate;
    BOOL donationSwitchStatus;
    UISwitch *donationSwitch;
}

@property (nonatomic, assign) id<KTGDonationDelegate> delegate;
@property (nonatomic, retain) IBOutlet UISwitch *donationSwitch;
- (IBAction)doneButtonSelected:(id)sender;
- (IBAction)toggleChanged:(id)sender;

@end
