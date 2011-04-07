//
//  iKivaConstants.h
//  iKiva
//
//  Created by SWP on 11/2/10.
//  Copyright 2010 Solo Wolf Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

// Newest Loan JSON
#define LOANS @"loans"
#define PAGING @"paging"
#define LOAN_PAGE @"page"
#define LOAN_TOTAL @"total"
#define LOANS_RETURNED @"page_size"
#define TOTAL_LOAN_PAGES @"pages"
#define ACTIVITY @"activity"
#define BASKET_AMOUNT @"basket_amount"
#define BORROWER_COUNT @"borrower_count"
#define DESCRIPTION @"description"
#define LANGUAGE @"language"
#define FUNDED_AMOUNT @"funded_amount"
#define NAME @"name"
#define USE @"use"
#define STATUS @"status"
#define SECTOR @"sector"
#define PARTNER_ID @"partner_id"
#define POSTED_DATE @"posted_date"
#define LOAN_AMOUNT @"loan_amount"
#define LOCATION @"location"
#define COUNTRY @"country"
#define TOWN @"town"
#define COUNTRY_CODE @"country_code"
#define GEO @"geo"
#define LEVEL @"level"
#define LATLONG @"pairs"
#define TYPE @"type"
#define ID @"id"
#define IMAGE @"image"

// Individual Loan JSON
#define LANGUAGES @"languages"
#define TEXTS @"texts"
#define ENGLISH  @"en"
#define BORROWERS @"borrowers" 
#define TERMS @"terms"
#define LOCAL_PAYMENTS @"local_payments"
#define SCHEDULED_PAYMENTS @"scheduled_payments"
#define DISBURSAL_DATE @"disbursal_date"

// Teams JSON
#define LOAN_COUNT @"loan_count"
#define MEMBERSHIP_COUNT @"member_count"
#define MEMBERSHIP_TYPE @"membership_type"
#define LOANED_AMOUNT @"loaned_amount"
#define TEAM_START_DATE @"team_since"
#define LOAN_REASON @"loan_because"
#define WEBSITE_URL @"website_url"
#define CATEGORY @"category"
#define SHORT_NAME @"shortname"
#define WHERE_LOCATION @"whereabouts"
#define TEAMS @"teams"

// Invidiual Team JSON

// Basket JSON
#define REMOVE_TAG -20
#define CHECKOUT_TAG 10
#define PERSONAL_URL @"personal_url"
#define OCCUPATION @"occupation"
#define OCCUPATION_INFO @"occupational_info"
#define LENDER_ID @"lender_id"
#define USER_ID @"uid"

// Portfolio JSON
#define LENDERS @"lenders"
#define LENDER_ID_KEY @"lenderIDKey"
#define MEMBER_SINCE @"member_since"

// App Data
#define HAS_LAUNCHED_APP @"hasLaunchedAppBefore"
#define FONT_SIZE 18.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f

// Kiva URLs
#define FEATURED_LOANS_URL @"http://api.kivaws.org/v1/loans/newest.json?app_id=com.SWP.kivatogo&page=%i"
#define INDIVIDUAL_LOAN_URL @"http://api.kivaws.org/v1/loans/%i.json?app_id=com.SWP.kivatogo"
#define SHARE_INDIVIDUAL_LOAN_URL @"http://www.kiva.org/lend/%i"
#define FEATURED_TEAMS_URL @"http://api.kivaws.org/v1/teams/search.json?sort_by=member_count&app_id=com.SWP.kivatogo&page=%i"
#define FEATURED_IMAGE_URL @"http://www.kiva.org/img/s50/%i.jpg"
#define INDIVIDUAL_IMAGE_URL @"http://www.kiva.org/img/s300/%i.jpg"
#define PORTFOLIO_URL @"http://api.kivaws.org/v1/lenders/%@.json?app_id=com.SWP.kivatogo"
#define INDIVIDUAL_TEAM_URL @"http://api.kivaws.org/v1/teams/%i.json?app_id=com.SWP.kivatogo"
#define BASKET_URL @"http://www.kiva.org/basket/set"
#define LENDER_HELP_URL @"http://www.kiva.org/myLenderId?app_id=com.SWP.kivatogo"
#define SEARCH_URL @"http://api.kivaws.org/v1/loans/search.json?app_id=com.SWP.kivatogo&q=%@&page=%i"
#define FILTER_URL @"http://api.kivaws.org/v1/loans/search.json?app_id=com.SWP.kivatogo&status=fundraising&sort_by=%@&page=%i"

// UI Colors
#define TABLE_COLOR_LIGHT [UIColor colorWithRed:129/255.0 green:172/255.0 blue:103/255.0 alpha:0.9]
#define TABLE_COLOR_DARK  [UIColor colorWithRed:85/255.0 green:124/255.0 blue:61/255.0 alpha:0.6]
#define TABLE_COLOR_LIGHT_BLUE  [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0]

// Helper method for App version in Settings
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// Google Analytics
static const NSInteger kGANDispatchPeriodSec = 10;
#define GOOGLE_ANALYTICS_UID @"UA-22172558-1"

@interface iKivaConstants : NSObject {

}

+ (BOOL)hasLenderID;
+ (BOOL)hasKeyInDefaults:(NSString *)keyToFind;
+ (void)saveToUserDefaults:(id)myObject forKey:(NSString *)key;
+ (NSString *)normalFormattedDateForDate:(NSString *)dateString;
+ (NSString *)normalFormattedDateWithoutYearForDate:(NSString *)dateString;
+ (NSString *)normalFormattedCurrencyFromAmount:(int)amountString;
+ (CGFloat)dynamicRowHeightFromText:(NSString *)cellText;

@end
