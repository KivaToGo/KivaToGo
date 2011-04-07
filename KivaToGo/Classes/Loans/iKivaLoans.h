//
//  iKivaLoans.h
//  iKiva
//
//  Created by SWP on 11/2/10.
//  Copyright 2010 Solo Wolf Productions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface iKivaLoans : NSObject {
	NSDictionary *dict;
}
@property (nonatomic, retain) NSDictionary *dict;

@property (nonatomic, readonly) NSString *activity;
@property (nonatomic, readonly) int basketAmount;
@property (nonatomic, readonly) int borrowerCount;
@property (nonatomic, readonly) int fundedAmount;
@property (nonatomic, readonly) int loanID;
@property (nonatomic, readonly) NSArray *languages;
@property (nonatomic, readonly) int imageID;
@property (nonatomic, readonly) int loanAmount;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *town;
@property (nonatomic, readonly) NSString *townCountry;
@property (nonatomic, readonly) NSString *countryCode;
@property (nonatomic, readonly) NSString *langitudeLongitude;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) int partnerID;
@property (nonatomic, readonly) NSString *postedDate;
@property (nonatomic, readonly) NSString *sector;
@property (nonatomic, readonly) NSString *fundingStatus;
@property (nonatomic, readonly) NSString *use;
@property (nonatomic, readonly) NSString *fundedPercentage;
@property (nonatomic, readonly) NSString *loanAmountString;
+ (iKivaLoans *)loansFromDictioary:(NSDictionary *)dictionary;

@end
