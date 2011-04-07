//
//  iKivaLoanTableCell.h
//  iKiva
//
//  Created by SWP on 11/3/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iKivaBaseTableCell : UITableViewCell {
	UILabel *name;
	UILabel *topLeft;
	UILabel *topRight;
	UILabel *bottomLeft;
	UILabel *bottomRight;
	UIImageView *cellImage;
}
@property (nonatomic, assign) IBOutlet UILabel *name;
@property (nonatomic, assign) IBOutlet UILabel *topLeft;
@property (nonatomic, assign) IBOutlet UILabel *topRight;
@property (nonatomic, assign) IBOutlet UILabel *bottomLeft;
@property (nonatomic, assign) IBOutlet UILabel *bottomRight;
@property (nonatomic, assign) IBOutlet UIImageView *cellImage;
@end
