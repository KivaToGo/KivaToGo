//
//  iKivaLoans.m
//  iKiva
//
//  Created by SWP on 11/2/10.
//  Copyright 2010 Solo Wolf Productions. All rights reserved.
//

#import "iKivaLoans.h"
#import "iKivaConstants.h"
@implementation iKivaLoans
@synthesize dict;

+ (iKivaLoans *)loansFromDictioary:(NSDictionary *)dictionary
{
	iKivaLoans *loans = [[iKivaLoans alloc] init];
	loans.dict = [NSDictionary dictionaryWithDictionary:dictionary];
	return [loans autorelease];
}

- (NSString *)activity
{
	return [self.dict objectForKey:ACTIVITY];
}
- (int)basketAmount
{
	return [[self.dict objectForKey:BASKET_AMOUNT] intValue];
}
- (int)borrowerCount
{
	return [[self.dict objectForKey:BORROWER_COUNT] intValue];
}
- (int)fundedAmount
{
	return [[self.dict objectForKey:FUNDED_AMOUNT] intValue];
}
- (int)loanID
{
	return [[self.dict objectForKey:ID] intValue];
}
- (NSArray *)languages
{
	return [[self.dict objectForKey:DESCRIPTION] objectForKey:LANGUAGE];
}
- (int)imageID
{
	return [[[self.dict objectForKey:IMAGE] objectForKey:ID] intValue];
}
- (int)loanAmount
{
	return [[self.dict objectForKey:LOAN_AMOUNT] intValue];
}
- (NSString *)country
{
	return [[self.dict objectForKey:LOCATION] objectForKey:COUNTRY];
}
- (NSString *)town
{
	return [[self.dict objectForKey:LOCATION] objectForKey:TOWN];
}
- (NSString *)townCountry
{
	return [NSString stringWithFormat:@"%@, %@", self.country, self.town];
}
- (NSString *)countryCode
{
	return [[self.dict objectForKey:LOCATION] objectForKey:COUNTRY_CODE];
}
- (NSString *)langitudeLongitude
{
	return [[[self.dict objectForKey:LOCATION] objectForKey:GEO] objectForKey:LATLONG];
}
- (NSString *)name
{
	return [self.dict objectForKey:NAME];
}
- (int)partnerID
{
	return [[self.dict objectForKey:PARTNER_ID] intValue];
}
- (NSString *)postedDate
{
	return [self.dict objectForKey:POSTED_DATE];
}
- (NSString *)sector
{
	return [self.dict objectForKey:SECTOR];
}
- (NSString *)fundingStatus
{
	return [[self.dict objectForKey:STATUS] capitalizedString];
}
- (NSString *)use
{
	return [self.dict objectForKey:USE];
}
- (NSString *)fundedPercentage
{
	return [NSString stringWithFormat:@"%.f%% raised", (floor(((self.fundedAmount + self.basketAmount)/(float)self.loanAmount)*100))];
}
- (NSString *)loanAmountString
{
	NSNumberFormatter *currFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[currFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[currFormatter setCurrencyCode:@"USD"];
	[currFormatter setCurrencySymbol:@"$"];
	return [NSString stringWithFormat:@"%@ loan", [currFormatter stringFromNumber:[NSNumber numberWithInt:self.loanAmount]]];
}
- (void)dealloc
{
	self.dict = nil;
	[super dealloc];
}
@end
