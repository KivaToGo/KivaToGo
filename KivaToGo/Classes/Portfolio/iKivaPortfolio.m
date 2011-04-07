//
//  iKivaPortfolio.m
//  iKiva
//
//  Created by SWP on 11/26/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaPortfolio.h"
#import "iKivaConstants.h"

@implementation iKivaPortfolio
@synthesize dict;

+ (iKivaPortfolio *)portfolioFromDictioary:(NSDictionary *)dictionary
{
	iKivaPortfolio *details = [[iKivaPortfolio alloc] init];
	details.dict = [NSDictionary dictionaryWithDictionary:dictionary];
	return [details autorelease];	
}
- (NSString *)lenderID
{
	return [self.dict objectForKey:LENDER_ID];	
}
- (NSString *)name
{
	return [self.dict objectForKey:NAME];		
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
- (NSString *)countryCode
{
	return [self.dict objectForKey:COUNTRY_CODE];
}
- (NSString *)UID
{
	return [self.dict objectForKey:USER_ID];	
}
- (NSString *)memberSince
{
	//2008-04-05T16:02:53Z
	NSMutableString *joined = [self.dict objectForKey:MEMBER_SINCE];
	NSString *one = [joined stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	NSString *two = [one stringByReplacingOccurrencesOfString:@"Z" withString:@""]; //Now "2008-04-05 16:02:53"
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *realDate = [formatter dateFromString:two];
	[formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
	return [formatter stringFromDate:realDate];
}
- (NSString *)personalURL
{
	return [self.dict objectForKey:PERSONAL_URL];
}
- (NSString *)occupation
{
	return [self.dict objectForKey:OCCUPATION];
}
- (NSString *)occupationDetails
{
	return [self.dict objectForKey:OCCUPATION_INFO];
}
- (NSString *)loanReason
{
	return [self.dict objectForKey:LOAN_REASON];
}
- (NSString *)loanCount
{
	// For some reason this needed to be converted to a string
	return [NSString stringWithFormat:@"%@", [self.dict objectForKey:LOAN_COUNT]];
}

- (void)dealloc
{
	self.dict = nil;
	[super dealloc];
}
@end
