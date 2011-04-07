//
//  iKivaDetailLoans.h
//  iKiva
//
//  Created by SWP on 11/14/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface iKivaDetailLoans : NSObject {
	NSDictionary *dict;
}

@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, readonly) int loanID;
@property (nonatomic, readonly) NSString *loanIDString;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *languages;
@property (nonatomic, readonly) NSString *englishDescription;
@property (nonatomic, readonly) NSString *fundingStatus;
@property (nonatomic, readonly) int fundedAmount;
@property (nonatomic, readonly) int trueFundedAmount;
@property (nonatomic, readonly) int amountNeeded;
@property (nonatomic, readonly) int basketAmount;
@property (nonatomic, readonly) int imageID;
@property (nonatomic, readonly) NSString *imageIDString;
@property (nonatomic, readonly) NSString *activity;
@property (nonatomic, readonly) NSString *loanUse;
@property (nonatomic, readonly) NSString *sector;
@property (nonatomic, readonly) NSString *countryCode;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) int partnerID;
@property (nonatomic, readonly) NSArray *borrowers;
@property (nonatomic, readonly) NSDictionary *loanTerms;
@property (nonatomic, readonly) NSArray *loanLocalPayments;
@property (nonatomic, readonly) NSArray *loanRepayments;
@property (nonatomic, readonly) NSString *disbersalDate;
@property (nonatomic, readonly) NSString *postedDate;
@property (nonatomic, readonly) int loanAmount;
@property (nonatomic, readonly) UIImage *countryFlagImage;
@property (nonatomic, readonly) NSString *fundedPercentage;
@property (nonatomic, readonly) NSString *remainingPercentage;


+ (iKivaDetailLoans *)detailsFromDictioary:(NSDictionary *)dictionary;

@end
