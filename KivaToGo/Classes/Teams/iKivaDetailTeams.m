//
//  iKivaDetailTeams.m
//  iKiva
//
//  Created by SWP on 12/29/10.
//  Copyright 2010 Kallos Inc. All rights reserved.
//

#import "iKivaDetailTeams.h"
#import "iKivaConstants.h"

@implementation iKivaDetailTeams
@synthesize dict;

+ (iKivaDetailTeams *)teamsFromDictioary:(NSDictionary *)dictionary
{
	iKivaDetailTeams *details = [[iKivaDetailTeams alloc] init];
	details.dict = [NSDictionary dictionaryWithDictionary:dictionary];
	return [details autorelease];
}

- (void)dealloc
{
	self.dict = nil;
	[super dealloc];
}

- (int)teamID
{
	return [[self.dict objectForKey:ID] intValue];	
}
- (NSString *)teamIDString
{
	return [self.dict objectForKey:ID];		
}
- (NSString *)shortName
{
	return [self.dict objectForKey:SHORT_NAME];	
}
- (NSString *)name
{
	return [self.dict objectForKey:NAME];
}
- (NSString *)category
{
	return [self.dict objectForKey:CATEGORY];
}
- (int)imageID
{
	return [[[self.dict objectForKey:IMAGE] objectForKey:ID] intValue];
}
- (NSString *)imageIDString
{
	return [NSString stringWithFormat:@"%i", self.imageID];
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
- (NSString *)teamURL
{
	return [self.dict objectForKey:WEBSITE_URL];	
}
- (NSString *)teamSince
{
	return [iKivaConstants normalFormattedDateForDate:[self.dict objectForKey:TEAM_START_DATE]];

}
- (NSString *)membershipType
{
	return [self.dict objectForKey:MEMBERSHIP_TYPE];
}
- (int)membershipCount
{
	return [[self.dict objectForKey:MEMBERSHIP_COUNT] intValue];	
}
- (int)loanCount
{
	return [[self.dict objectForKey:LOAN_COUNT] intValue];		
}
- (int)loanedAmount
{
	return [[self.dict objectForKey:LOANED_AMOUNT] intValue];		
}
- (NSString *)loanedAmountString
{
	return [iKivaConstants normalFormattedCurrencyFromAmount:self.loanedAmount];
}
@end


