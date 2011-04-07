//
//  iKivaLoanDetailImageTableCell.h
//  iKiva
//
//  Created by SWP on 12/22/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iKivaImageView.h"

@interface iKivaLoanDetailImageTableCell : UITableViewCell <KTGImageViewDelegate> {
	UILabel *_name;
	UIImageView *_lenderImage;
	UIActivityIndicatorView *_spinner;
}
@property (nonatomic, assign) IBOutlet UILabel *name;
@property (nonatomic, assign) IBOutlet UIImageView *lenderImage;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *spinner;
@end
