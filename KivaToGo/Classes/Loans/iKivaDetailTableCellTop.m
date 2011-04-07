//
//  iKivaDetailTableCellTop.m
//  iKiva
//
//  Created by SWP on 11/14/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaDetailTableCellTop.h"


@implementation iKivaDetailTableCellTop
@synthesize countryFlag, country, sector, loanUse;
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
	self.countryFlag = nil;
	self.country = nil;
	self.sector = nil;
	self.loanUse = nil;
    [super dealloc];
}


@end
