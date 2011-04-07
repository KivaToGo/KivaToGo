//
//  iKivaTeams.m
//  iKiva
//
//  Created by SWP on 11/13/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaTeams.h"
#import "iKivaConstants.h"

@implementation iKivaTeams
@synthesize dict,teamID,imageID,name,shortName,category,location,loanReason,description,website,teamStartDate,membershipType,loanedAmount,loanAmountString,membershipCount,loanCount;
@synthesize loanCountString, membershipCountString;
+ (iKivaTeams *)teamsFromDictioary:(NSDictionary *)dictionary
{
	iKivaTeams *team = [[iKivaTeams alloc] init];
	team.dict = [NSDictionary dictionaryWithDictionary:dictionary];
	return [team autorelease];
}

- (int)teamID
{
	return [[self.dict objectForKey:ID] intValue];
}
- (int)imageID
{
	return [[[self.dict objectForKey:IMAGE] objectForKey:ID] intValue];
}
- (NSString *)name
{
	return [self.dict objectForKey:NAME];
}
- (NSString *)shortName
{
	return [self.dict objectForKey:SHORT_NAME];
}
- (NSString *)category
{
	return [self.dict objectForKey:CATEGORY];
}
- (NSString *)location
{
	return [self.dict objectForKey:WHERE_LOCATION];
}
- (NSString *)loanReason
{
	return [self.dict objectForKey:LOAN_REASON];
}
- (NSString *)description
{
	return [self.dict objectForKey:DESCRIPTION];
}
- (NSString *)website
{
	return [self.dict objectForKey:WEBSITE_URL];
}
- (NSString *)teamStartDate
{
	return [iKivaConstants normalFormattedDateForDate:[self.dict objectForKey:MEMBER_SINCE]];
}
- (NSString *)membershipType
{
	return [self.dict objectForKey:MEMBERSHIP_TYPE];
}
- (int)loanedAmount
{
	return [[self.dict objectForKey:LOANED_AMOUNT] intValue];
}
- (NSString *)loanAmountString
{
	NSNumberFormatter *currFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[currFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[currFormatter setCurrencyCode:@"USD"];
	[currFormatter setCurrencySymbol:@"$"];
	[currFormatter setGroupingSeparator:@","];
	return [NSString stringWithFormat:@"%@ loaned", [currFormatter stringFromNumber:[NSNumber numberWithInt:self.loanedAmount]]];
}
- (NSString *)membershipCountString
{
	NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *correctString = [NSString stringWithFormat:@"%@ members",
							   [formatter stringFromNumber:[NSNumber numberWithInt:self.membershipCount]]];
	return correctString;
}
- (NSString *)loanCountString
{
	NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString *correctString = [NSString stringWithFormat:@"%@ loans",
							   [formatter stringFromNumber:[NSNumber numberWithInt:self.loanCount]]];
	return correctString;
}
- (int)membershipCount
{
	return [[self.dict objectForKey:MEMBERSHIP_COUNT] intValue];
}
- (int)loanCount
{
	return [[self.dict objectForKey:LOAN_COUNT] intValue];
}

@end
