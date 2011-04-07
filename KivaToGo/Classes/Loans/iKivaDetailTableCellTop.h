//
//  iKivaDetailTableCellTop.h
//  iKiva
//
//  Created by SWP on 11/14/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKivaDetailTableCellTop : UITableViewCell {
	UIImageView *countryFlag;
	UILabel *country;
	UILabel *sector;
	UITextView *loanUse;
}
@property (nonatomic, assign) IBOutlet UIImageView *countryFlag;
@property (nonatomic, assign) IBOutlet UILabel *country;
@property (nonatomic, assign) IBOutlet UILabel *sector;
@property (nonatomic, assign) IBOutlet UITextView *loanUse;
@end
