//
//  KTGSortOptionsTableViewController.h
//  iKiva
//
//  Created by SWP on 3/13/11.
//  Copyright 2011 Kallos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocol for using the Sort delegate.  This can used by any class that needs to provide sorting abilities such as Loans, Teams, Lenders
@protocol KTGSortOptionsDelegate <NSObject>
- (void)userSelectedSortOption:(NSString *)sortOption withDisplayName:(NSString *)displayName;
@end


@interface KTGSortOptionsTableViewController : UITableViewController {
    NSArray *sortOptions;
    NSString *sortClass;
    id <KTGSortOptionsDelegate> delegate;
}
@property (nonatomic, copy) NSString *sortClass;
@property (nonatomic, retain) NSArray *sortOptions;
@property (nonatomic, assign) id <KTGSortOptionsDelegate> delegate;
@end
