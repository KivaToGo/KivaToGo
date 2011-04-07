//
//  iKivaPortfolioImageView.h
//  iKiva
//
//  Created by SWP on 12/26/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKivaPortfolioImageView : UIView {
	UILabel *_topLabel;
	UILabel *_bottomLabel;
	UIImageView *_lenderImage;
}
@property (nonatomic, assign) IBOutlet UILabel *topLabel;
@property (nonatomic, assign) IBOutlet UILabel *bottomLabel;
@property (nonatomic, assign) IBOutlet UIImageView *lenderImage;
@end
