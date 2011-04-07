//
//  iKivaLenderIDInputViewController.h
//  iKiva
//
//  Created by SWP on 12/9/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKivaLenderIDInputViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate> {
	UITextField *_textField;
	UIButton *_findLenderButton;
}
@property (nonatomic, retain) IBOutlet 	UITextField *textField;
@property (nonatomic, retain) IBOutlet 	UIButton *findLenderButton;
- (IBAction)findLenderButtonSelected:(id)sender;
@end
