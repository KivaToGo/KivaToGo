//
//  iKivaLoanTableCell.m
//  iKiva
//
//  Created by SWP on 11/3/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaBaseTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation iKivaBaseTableCell
@synthesize name, topLeft, topRight, bottomLeft, bottomRight, cellImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Set rounded corners on the lendee image
	self.cellImage.layer.cornerRadius = 5.0;
	self.cellImage.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	self.name = nil;
	self.topLeft = nil;
	self.topRight = nil;
	self.bottomLeft = nil;
	self.bottomRight = nil;
	self.cellImage = nil;
    [super dealloc];
}


@end
