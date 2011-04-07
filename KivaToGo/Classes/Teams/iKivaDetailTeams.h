//
//  iKivaDetailTeams.h
//  iKiva
//
//  Created by SWP on 12/29/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface iKivaDetailTeams : NSObject {
	NSDictionary *dict;
}

@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, readonly) int teamID;
@property (nonatomic, readonly) NSString *teamIDString;
@property (nonatomic, readonly) NSString *shortName;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *category;
@property (nonatomic, readonly) int imageID;
@property (nonatomic, readonly) NSString *imageIDString;
@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) NSString *loanReason;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, readonly) NSString *teamURL;
@property (nonatomic, readonly) NSString *teamSince;
@property (nonatomic, readonly) NSString *membershipType;
@property (nonatomic, readonly) int membershipCount;
@property (nonatomic, readonly) int loanCount;
@property (nonatomic, readonly) int loanedAmount;
@property (nonatomic, readonly) NSString *loanedAmountString;

+ (iKivaDetailTeams *)teamsFromDictioary:(NSDictionary *)dictionary;

@end
