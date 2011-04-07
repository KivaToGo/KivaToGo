//
//  iKivaLoanDetailImageTableCell.m
//  iKiva
//
//  Created by SWP on 12/22/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import "iKivaLoanDetailImageTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation iKivaLoanDetailImageTableCell
@synthesize name = _name, lenderImage = _lenderImage, spinner = _spinner;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)awakeFromNib
{
    // Round image corners and start animating spinner
	self.lenderImage.layer.cornerRadius = 8.0;
	self.lenderImage.layer.masksToBounds = YES;
	[self.spinner startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageFinishedLoading) name:@"DetailImageDownloaded" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state.
}

- (void)imageFinishedLoading
{
    // Sleep the timer because it is being called to stopAnimating too soon (before the picture is actually added to the Image)
    // This simulates the image loading for the user
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self.spinner
                                   selector:@selector(stopAnimating)
                                   userInfo:nil
                                    repeats:NO];
   // [self.spinner stopAnimating];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	self.name = nil;
	self.lenderImage = nil;
	self.spinner = nil;
    [super dealloc];
}


@end
