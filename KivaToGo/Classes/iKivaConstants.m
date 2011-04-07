//
//  iKivaConstants.m
//  iKiva
//
//  Created by SWP on 11/2/10.
//  Copyright 2010 Solo Wolf Productions. All rights reserved.
//

#import "iKivaConstants.h"


@implementation iKivaConstants

+ (BOOL)hasLenderID
{
	NSString *myLenderID = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LENDER_ID_KEY];
	if ([myLenderID length] > 0 && myLenderID != nil) // If it found anything
		return YES;
	else
		return NO;
}
// A generic method, similar to hasLenderID but for other values
+ (BOOL)hasKeyInDefaults:(NSString *)keyToFind
{
	NSString *myObject = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:keyToFind];
	if ([myObject length] > 0 && myObject != nil)
		return YES;
	else
		return NO;
}

+ (void)saveToUserDefaults:(id)myObject forKey:(NSString *)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:myObject forKey:key];
		[standardUserDefaults synchronize];
	}
}

// Provide consistent user-friendly formatting
+ (NSString *)normalFormattedDateForDate:(NSString *)dateString
{
	NSMutableString *joined = (NSMutableString *)dateString;
	NSString *one = [joined stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	NSString *two = [one stringByReplacingOccurrencesOfString:@"Z" withString:@""]; //Now "2008-04-05 16:02:53"
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *realDate = [formatter dateFromString:two];
	[formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
	return [formatter stringFromDate:realDate];
}
// Same method as above but does not return timestamp
+ (NSString *)normalFormattedDateWithoutYearForDate:(NSString *)dateString
{
	NSMutableString *joined = (NSMutableString *)dateString;
	NSString *one = [joined stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	NSString *two = [one stringByReplacingOccurrencesOfString:@"Z" withString:@""]; //Now "2008-04-05 16:02:53"
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *realDate = [formatter dateFromString:two];
	[formatter setDateFormat:@"MM/dd/yyyy"];
	return [formatter stringFromDate:realDate];
}

+ (NSString *)normalFormattedCurrencyFromAmount:(int)amount
{
	NSNumberFormatter *currFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[currFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[currFormatter setCurrencyCode:@"USD"];
	[currFormatter setCurrencySymbol:@"$"];
	[currFormatter setGroupingSeparator:@","];
	return [NSString stringWithFormat:@"%@", [currFormatter stringFromNumber:[NSNumber numberWithInt:amount]]];	
	
}

// This method calculates the row height based off of the amount of text sent it, it will return a height of 44 or higher
+ (CGFloat)dynamicRowHeightFromText:(NSString *)cellText;
{
	NSString *text = cellText;
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGFloat height = MAX(size.height, 44.0f);
	if (text) {
		height =  height + (CELL_CONTENT_MARGIN * 2);
		text = nil;
	}
	else {
		height = 44.0f;
	}

	return height;
}
@end
