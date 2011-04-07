//
//  iKivaDetailTableCell.h
//  iKiva
//
//  Created by SWP on 11/7/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKivaDetailTableCell : UITableViewCell {
	UILabel *loanAmount;
	UILabel *percentAmount;
	UIButton *basketButton;
}
@property (nonatomic, assign) IBOutlet UILabel *loanAmount;
@property (nonatomic, assign) IBOutlet UILabel *percentAmount;
@property (nonatomic, assign) IBOutlet UIButton *basketButton;
@end
