//
//  SPService.h
//  DnaTicket
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPServiceMockResponse.h"
#import "SBJson.h"
#import "Constants.h"

@interface SPService : NSObject {
    
}

// Utility Methods
- (BOOL) hasValue:(id)field;
- (NSString *) currentTimeStamp;
- (NSString *) getStringFromBoolianValue:(BOOL)value;
- (BOOL) getBoolianValueFromString:(NSString *)string;

// JSON Helper Methods
- (NSDictionary *) dictionaryFromJSON:(NSString *)jsonString;
- (NSString *) JSONFromDictionary:(NSDictionary *)dictionary;
- (NSString *) JSONFromArray:(NSArray *)array;

// Supporting Methods
- (NSString *) serviceResponse:(NSString *)requestUrl;
- (NSString *) serviceResponseByPostDictionary:(NSString *)requestUrl dictionary: (NSDictionary *)dictionary;
- (NSString *) serviceResponseByGetDictionary:(NSString *)requestUrl dictionary:(NSDictionary *)dictionary;
- (NSString *) serviceResponseByPostJSON:(NSString *)requestUrl jsonParameters:(NSString *)jsonParameter;

@end