//
//  iKivaPortfolioImageView.m
//  iKiva
//
//  Created by SWP on 12/26/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import "iKivaPortfolioImageView.h"


@implementation iKivaPortfolioImageView
@synthesize topLabel = _topLabel;
@synthesize bottomLabel = _bottomlabel;
@synthesize lenderImage = _lendgerImage;

-(id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		// Code
	}
	return self;
}

- (void)dealloc {
	self.topLabel = nil;
	self.bottomLabel = nil;
	self.lenderImage = nil;
    [super dealloc];
}


@end
