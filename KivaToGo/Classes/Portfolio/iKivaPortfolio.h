//
//  iKivaPortfolio.h
//  iKiva
//
//  Created by SWP on 11/26/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface iKivaPortfolio : NSObject {
	NSDictionary *dict;
}
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, readonly) NSString *lenderID;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *imageIDString;
@property (nonatomic, readonly) int imageID;
@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) NSString *countryCode;
@property (nonatomic, readonly) NSString *UID;
@property (nonatomic, readonly) NSString *memberSince;
@property (nonatomic, readonly) NSString *personalURL;
@property (nonatomic, readonly) NSString *occupation;
@property (nonatomic, readonly) NSString *occupationDetails;
@property (nonatomic, readonly) NSString *loanReason;
@property (nonatomic, readonly) NSString *loanCount;

+ (iKivaPortfolio *)portfolioFromDictioary:(NSDictionary *)dictionary;

@end

