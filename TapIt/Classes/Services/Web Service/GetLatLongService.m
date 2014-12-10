//
//  GetLatLongService.m
//  TapIt
//
//  Created by Admin on 8/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "GetLatLongService.h"

@implementation GetLatLongService

#pragma mark - Initialization Methods

static GetLatLongService *instance;

+ (GetLatLongService *) getInstance {
	if (instance == nil) {
        instance = [[GetLatLongService alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - Supporting Methods

- (NSMutableDictionary *) serviceParams:(GetLatLongRequest *)request  {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    // Set Latitude
    if([super hasValue:[request address]])   {
        [dictionary setObject:[request address] forKey:@"query"];
    }
    return dictionary;
}

- (GetLatLongResponse *) generateResponseModal:(NSDictionary *)json  {
    
    GetLatLongResponse *getLatLongRes = [[GetLatLongResponse alloc] init];
    
    //if ([super hasValue:[json objectForKey:@"Success"]])
    //if ([(NSString *)[json objectForKey:@"Success"] isEqualToString:@"1"])
    bool checkSuccess = [[json valueForKey:@"Success"] boolValue];
    if (checkSuccess)
    {
        NSString *success = (NSString *) [json objectForKey:@"Success"];
        if ([super hasValue:success]==1) {
            getLatLongRes.success = [success boolValue];
        }
        
        getLatLongRes.latitude = [[json objectForKey:@"Data"] objectForKey:@"lat"];
        getLatLongRes.longitude = [[json objectForKey:@"Data"] objectForKey:@"lon"];
    }
    else
    {
        getLatLongRes.success = [[json valueForKey:@"Success"] boolValue];
        getLatLongRes.errorMessage = [[json objectForKey:@"Data"] objectForKey:@"ErrorMessage"];
    }
    

    return getLatLongRes;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(GetLatLongRequest *)request {
    
    NSString *response = @"";
    switch (GET_LAT_LONG_SERVICE) {
            
        case LIVE_SERVICE:  {
            NSMutableDictionary *dictionary = [self serviceParams:request];
            response = [self serviceResponseByPostJSON:requestUrl
                                            jsonParameters:[super JSONFromDictionary:dictionary]];
            break;
        }
            
        case MOCK_SERVICE:  {
            response = [[SPServiceMockResponse alloc] getFileContent:@"GetLatLongServiceResponse"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    
    return response;
}

- (GetLatLongResponse *) getLatLong: (GetLatLongRequest *)request;
{
    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self generateResponseModal:json];
}

@end
