//
//  MWFeedInfo.h
//  MWFeedParser
//
//  Created by Michael Waterfall on 10/05/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWFeedInfo : NSObject {
	
	NSString *title;
	NSString *link;
	NSString *summary;
	
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;

@end
