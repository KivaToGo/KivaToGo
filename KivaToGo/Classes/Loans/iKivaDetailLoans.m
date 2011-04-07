//
//  iKivaDetailLoans.m
//  iKiva
//
//  Created by SWP on 11/14/10.
//  Copyright 2010 SWP. All rights reserved.
//

#import "iKivaDetailLoans.h"
#import "iKivaConstants.h"


@implementation iKivaDetailLoans
@synthesize dict;

+ (iKivaDetailLoans *)detailsFromDictioary:(NSDictionary *)dictionary
{
	iKivaDetailLoans *details = [[iKivaDetailLoans alloc] init];
	details.dict = [NSDictionary dictionaryWithDictionary:dictionary];
	return [details autorelease];
}

- (int)loanID
{
	return [[self.dict objectForKey:ID] intValue];
}
- (NSString *)loanIDString
{
	return [[self.dict objectForKey:ID] stringValue];
}
- (NSString *)name
{
	return	[self.dict objectForKey:NAME];
}
- (NSArray *)languages
{
	return [[self.dict objectForKey:DESCRIPTION] objectForKey:LANGUAGES];
}
- (NSString *)englishDescription
{
	return [[[self.dict objectForKey:DESCRIPTION] objectForKey:TEXTS] objectForKey:ENGLISH];
}
- (NSString *)fundingStatus
{
	return [self.dict objectForKey:STATUS];
}
- (int)fundedAmount
{
	return [[self.dict objectForKey:FUNDED_AMOUNT] intValue];
}
- (int)basketAmount
{
	return [[self.dict objectForKey:BASKET_AMOUNT] intValue];
}
- (int)amountNeeded
{
	return (fabs((self.fundedAmount + self.basketAmount) - self.loanAmount));
}
- (NSString *)fundedPercentage
{
    NSString *response;
    
    if (self.loanAmount) {
        response = [NSString stringWithFormat:@"%.f%%", (floor(((self.fundedAmount + self.basketAmount)/(float)self.loanAmount)*100))];
    } else {
        response = @"100%";
    }
	return response;
}
- (NSString *)remainingPercentage
{
	NSString *response;
    
    if (self.loanAmount) {
        response = [NSString stringWithFormat:@"%.f%%", (fabs((floor(((self.fundedAmount + self.basketAmount)/(float)self.loanAmount)*100)) - 100))];
    } else {
        response = @"0%";
    }
	return response;
}
- (int)imageID
{
	return [[[self.dict objectForKey:IMAGE] objectForKey:ID] intValue];
}
- (NSString *)imageIDString
{
	return [NSString stringWithFormat:@"%i", self.imageID];
}
- (NSString *)activity
{
	return [self.dict objectForKey:ACTIVITY];
}
- (NSString *)loanUse
{
	return [self.dict objectForKey:USE];
}
- (NSString *)sector
{
	return [self.dict objectForKey:SECTOR];
}
- (NSString *)countryCode
{
	return [[self.dict objectForKey:LOCATION] objectForKey:COUNTRY_CODE];
}
- (UIImage *)countryFlagImage
{
	NSString *flag = [NSString stringWithFormat:@"%@.png", [self.countryCode capitalizedString]];
	UIImage *image = [UIImage imageNamed:flag];
	return image;
}
- (NSString *)country
{
	return [[self.dict objectForKey:LOCATION] objectForKey:COUNTRY];
}
- (int)partnerID
{
	return [[self.dict objectForKey:PARTNER_ID] intValue];
}
- (NSArray *)borrowers
{
	return [self.dict objectForKey:BORROWERS];
}
- (NSDictionary *)loanTerms
{
	return [self.dict objectForKey:TERMS];
}
- (NSArray *)loanLocalPayments
{
	return [[self.dict objectForKey:TERMS] objectForKey:LOCAL_PAYMENTS];
}
- (NSArray *)loanRepayments
{
	return [[self.dict objectForKey:TERMS] objectForKey:SCHEDULED_PAYMENTS];
}
- (NSString *)disbersalDate
{
	//TODO: Return date
	return [[self.dict objectForKey:TERMS] objectForKey:DISBURSAL_DATE];
}
- (NSString *)postedDate
{
	//TODO: Return date
	return [self.dict objectForKey:POSTED_DATE];
}
- (int)loanAmount
{
	return [[[self.dict objectForKey:TERMS] objectForKey:LOAN_AMOUNT] intValue];
}
- (int)trueFundedAmount
{
	return (self.fundedAmount + self.basketAmount);
}

@end