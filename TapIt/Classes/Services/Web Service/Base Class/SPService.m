//
//  SPService.m
//  DnaTicket
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPService.h"
#import "Flurry.h"

@implementation SPService

#pragma mark - Initialization Methods

- (id)init {
    self = [super init];
    if (self) {
        // Custom Initialization
    }
    return self;
}

#pragma mark - Utility Methods

- (BOOL) hasValue:(id)object {
    
    if(object!=nil && (NSNull *)object != [NSNull null])    {
        
        // Check NSString Class
        if([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSMutableString class]]) {
            if([object length]>0) {
                return YES;
            }
        } 
        
        // Check UIImage Class
        if([object isKindOfClass:[UIImage class]]){
            if ([object CGImage]!=nil) {
                return YES;
            }
        }
        
        // Check NSArray Class
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
            if ([object count] > 0) {
                return YES;
            }
        }
        
        
        // Check NSDictionary Class
        if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
            if ([object count] > 0) {
                return YES;
            }
        }
        else {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *) currentTimeStamp {
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    return [[NSNumber numberWithUnsignedInteger:timeStamp] stringValue];
}

- (NSString *) getStringFromBoolianValue:(BOOL)value {
    
    if (value) {
        return @"true";
    }
    else    {
        return @"false";
    }
}

- (BOOL) getBoolianValueFromString:(NSString *)string    {
    
    if ([string isEqualToString:@"true"] || [string isEqualToString:@"YES"] || [string isEqualToString:@"1"]) {
        return YES;
    }
    else    {
        return NO;
    }
}

#pragma mark - JSON Helper Methods

- (NSDictionary *) dictionaryFromJSON:(NSString *)jsonString
{
    NSDictionary *json = [[NSMutableDictionary alloc] init];
    if([self hasValue:jsonString]) {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        @try {
            json = [parser objectWithString:jsonString];
        }
        @catch (NSException *exception) {
            [Flurry logEvent:@"Dictionary_From_Json_Exception"];
        }
        @finally {
            
        }
    }
    return json;
}

- (NSString *) JSONFromDictionary:(NSDictionary *)dictionary    {
    NSString *jsonString = [[NSString alloc] init];
    
    @try {
        if([self hasValue:dictionary])
            jsonString = [dictionary JSONRepresentation];
    }
    @catch (NSException *exception) {
        [Flurry logEvent:@"Json_From_Dictionary_Exception"];    }
    @finally {
        
    }
    return jsonString;
}

- (NSString *) JSONFromArray:(NSArray *)array {
    
    NSString *jsonString = [[NSString alloc] init];
    
    @try {
        NSString *jsonString = [[NSString alloc] init];
        if([self hasValue:array]) {
            jsonString = [array JSONRepresentation];
        }
    }
    @catch (NSException *exception) {
        [Flurry logEvent:@"Json_From_Array_Exception"];
    }
    @finally {
        
    }
    return jsonString;
}

#pragma mark - Private Helper Methods

- (NSString *)appendTimestampInRequestUrl:(NSString *)requestUrl  {
    
    if([requestUrl rangeOfString:@"?"].location == NSNotFound)
        requestUrl = [requestUrl stringByAppendingString:@"?"];
    else
        requestUrl = [requestUrl stringByAppendingString:@"&"];
    
    requestUrl = [requestUrl stringByAppendingFormat:@"timeStamp=%@",[self currentTimeStamp]];
    
    return requestUrl;
}

- (NSMutableURLRequest *)createRequest:(NSString *)requestUrl  {
    
    NSURL *url = [NSURL URLWithString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url 
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                          timeoutInterval:10];
    return urlRequest;
}

- (NSString *)createResponse:(NSMutableURLRequest *)urlRequest  {
    	
    NSString *response;
    @try {
        NSData *urlData;
        NSURLResponse *urlResponse;
        NSError *error;
        
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&urlResponse
                                                    error:&error];
        
        response = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        [Flurry logEvent:@"Create_Response_Exception"];
    }
    @finally {
        
    }
    
    return response;
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse   {
    return nil;
}

#pragma mark - Supporting Methods

- (NSString *) serviceResponse:(NSString *)requestUrl {
    
    if([self hasValue:requestUrl])
    {
        NSMutableURLRequest *urlRequest = [self createRequest:requestUrl];
        //    NSLog(@"Service Request : %@", urlRequest.URL);
        NSString *response = [self createResponse:urlRequest];
        return response;
    }
    return [[NSString alloc] init];
}

- (NSString *) serviceResponseByPostDictionary:(NSString *)requestUrl dictionary:(NSDictionary *)dictionary {
    
	NSMutableURLRequest *urlRequest = [self createRequest:requestUrl];
    NSString *httpPostString = [[NSString alloc] init];
    
    NSArray *keyArray =  [dictionary allKeys];
    for(NSString *key in keyArray) {
        id value = [dictionary objectForKey:key];
        httpPostString = [httpPostString stringByAppendingFormat:@"%@=%@&", key, value];
    }
    if([httpPostString length]>0) httpPostString = [httpPostString substringToIndex:[httpPostString length] - 1];
//    NSLog(@"Post Parameters : %@", httpPostString);
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[httpPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *response = [self createResponse: urlRequest];
    return response;
}

- (NSString *) serviceResponseByGetDictionary:(NSString *)requestUrl dictionary:(NSDictionary *)dictionary {
    
    NSString *httpGetString = [[NSString alloc] init];
    
    NSArray *keyArray =  [dictionary allKeys];
    for(NSString *key in keyArray) {
        id value = [dictionary objectForKey:key];
        httpGetString = [httpGetString stringByAppendingFormat:@"%@=%@&", key, value];
    }
    if([httpGetString length]>0) httpGetString = [httpGetString substringToIndex:[httpGetString length] - 1];
    
    NSString *url = requestUrl;
    if ([httpGetString isEqualToString:@""]==NO) {
        url = [NSString stringWithFormat:@"%@?%@",requestUrl,httpGetString];
    }
    
//    NSLog(@"Get Parameterised URL : %@", url);
    
    NSMutableURLRequest *urlRequest = [self createRequest:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSString *response = [self createResponse: urlRequest];
    return response;
}

- (NSString *) addCommonRequestParametersIntoJSONBody:(NSString *)body     {
    
    if (![self hasValue:body]) {
        body = @"{}";
    }
    
    // Convert JSON Body into JSON Object
    NSMutableDictionary *bodyParameters = (NSMutableDictionary *) [self dictionaryFromJSON:body];
    
    // Get App Bundle Reference
    NSBundle *appBundle = [NSBundle mainBundle];
    
    // Set Bundle Identifier
    NSString *bundleID = [appBundle bundleIdentifier];
    [bodyParameters setObject:bundleID forKey:@"BundleId"];
    
    // Convert JSON Object into JSON String
    NSString *jsonBody = [[NSString alloc] init];
    if([self hasValue:bodyParameters]) {
        jsonBody = [bodyParameters JSONRepresentation];
    }
    return jsonBody;
}

- (NSString *) serviceResponseByPostJSON:(NSString *)requestUrl jsonParameters:(NSString *)jsonParameter {
    
    jsonParameter = [self addCommonRequestParametersIntoJSONBody:jsonParameter];
    
	NSMutableURLRequest *urlRequest = [self createRequest:requestUrl];
//    NSLog(@"POST JSON = %@",jsonParameter);
    NSData *requestData = [NSData dataWithBytes:[jsonParameter UTF8String] length:strlen([jsonParameter UTF8String])];
    
    //prepare http body
	[urlRequest setHTTPMethod: @"POST"];
	[urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:APP_STATE_TOKEN forHTTPHeaderField:@"AppState-Token"];
	[urlRequest setHTTPBody:requestData];
    
    // Call Service & Get Response
    NSData *urlData;
    NSURLResponse *urlResponse;
    NSString *response;
    @try {
        
        NSError *error;
        
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&urlResponse
                                                    error:&error];
        response = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        [Flurry logEvent:@"ServiceResponse_ByPostJSON_Exception"];
    }
    @finally {
        
    }
    
    // Extract Response Data
    /*
    NSDictionary *responseJSON = (NSDictionary *) [self dictionaryFromJSON:response];
    NSString *data = (NSString *) [responseJSON objectForKey:@"d"];
    
    if ([self hasValue:data]) {
        response = data;
    }
    */
    
    return response;
}

@end
