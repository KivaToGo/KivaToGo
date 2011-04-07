//
//  iKivaTeams.h
//  iKiva
//
//  Created by SWP on 11/13/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iKivaTeams : NSObject {
	NSDictionary *dict;
}
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, assign) int teamID;
@property (nonatomic, assign) int imageID;
@property (nonatomic, assign) NSString * name;
@property (nonatomic, assign) NSString * shortName;
@property (nonatomic, assign) NSString * category;
@property (nonatomic, assign) NSString * location;
@property (nonatomic, assign) NSString * loanReason;
@property (nonatomic, assign) NSString * description;
@property (nonatomic, assign) NSString * website;
@property (nonatomic, assign) NSString * teamStartDate;
@property (nonatomic, assign) NSString * membershipType;
@property (nonatomic, assign) int loanedAmount;
@property (nonatomic, assign) NSString * loanAmountString;
@property (nonatomic, assign) int membershipCount;
@property (nonatomic, assign) NSString * membershipCountString;
@property (nonatomic, assign) NSString * loanCountString;
@property (nonatomic, assign) int loanCount;

+ (iKivaTeams *)teamsFromDictioary:(NSDictionary *)dictionary;

@end
