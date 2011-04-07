//
//  iKivaDetailTableCell.m
//  iKiva
//
//  Created by SWP on 11/7/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaDetailTableCell.h"


@implementation iKivaDetailTableCell
@synthesize loanAmount, percentAmount, basketButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	self.loanAmount = nil;
	self.percentAmount = nil;
	self.basketButton = nil;
    [super dealloc];
}


@end
