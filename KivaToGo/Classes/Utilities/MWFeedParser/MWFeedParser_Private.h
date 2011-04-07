//
//  MWFeedParser_Private.h
//  MWFeedParser
//
//  Created by Michael Waterfall on 19/05/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWFeedParser ()

#pragma mark Private Properties

// Feed Downloading Properties
@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSMutableData *asyncData;

// Parsing Properties
@property (nonatomic, retain) NSXMLParser *feedParser;
@property (nonatomic, retain) NSString *currentPath;
@property (nonatomic, retain) NSMutableString *currentText;
@property (nonatomic, retain) NSDictionary *currentElementAttributes;
@property (nonatomic, retain) MWFeedItem *item;
@property (nonatomic, retain) MWFeedInfo *info;

#pragma mark Private Methods

// Parsing Methods
- (void)reset;
- (void)startParsingData:(NSData *)data;
- (void)abortParsing;

// Error Handling
- (void)failWithErrorCode:(int)code description:(NSString *)description;

// Misc
- (NSString *)linkFromAtomLinkAttributes:(NSDictionary *)attributes;
- (NSDate *)dateFromRFC822String:(NSString *)dateString;
- (NSDate *)dateFromRFC3339String:(NSString *)dateString;

@end