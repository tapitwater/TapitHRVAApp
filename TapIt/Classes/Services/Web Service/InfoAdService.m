//
//  InfoAdService.m
//  TapIt
//
//  Created by Admin on 7/26/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "InfoAdService.h"

@implementation InfoAdService

#pragma mark - Initialization Methods

static  InfoAdService *instance;

+ (InfoAdService *) getInstance {
	if (instance == nil) {
        instance = [[InfoAdService alloc] init];
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
#pragma mark - Supporting Methods

- (NSMutableDictionary *) serviceParams:(infoAdRequest *)request  {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    return dictionary;
}

- (infoAdResponce *) generateResponseModal:(NSDictionary *)json  {
    
    infoAdResponce *infoAdRes = [[infoAdResponce alloc] init];
    
    //if ([super hasValue:[json objectForKey:@"Success"]])
    //if ([(NSString *)[json objectForKey:@"Success"] isEqualToString:@"1"])
    bool checkSuccess = [[json valueForKey:@"Success"] boolValue];
    if (checkSuccess)
    {
        NSString *success = (NSString *) [json objectForKey:@"Success"];
        if ([super hasValue:success]==1) {
            infoAdRes.success = [success boolValue];
        }
    
        // Get Report Data
        NSArray *reportData = [json objectForKey:@"Data"];
        if ([super hasValue:reportData]) {
            
            int totalReports = [reportData count];
            NSMutableArray *reportList = [NSMutableArray arrayWithCapacity:totalReports];
            
            for (int count=0; count<totalReports; count++) {
                
                NSDictionary *reportInfo = (NSDictionary *) [reportData objectAtIndex:count];
                InfoAdModel *report = [[InfoAdModel alloc] init];
                
                // Get imageUrl
                NSString *imageUrl = (NSString *) [reportInfo objectForKey:@"imageUrl"];
                if ([super hasValue:imageUrl]) {
                    report.imageUrl = imageUrl;
                }
                
                //Get linkUrl
                NSString *linkUrl = (NSString *) [reportInfo objectForKey:@"linkUrl"];
                if ([super hasValue:linkUrl]) {
                    report.linkUrl = linkUrl;
                }
                
                // Get height
                NSString *height = (NSString *) [reportInfo objectForKey:@"height"];
                if ([super hasValue:height]) {
                    infoAdRes.height = height;
                }
                
                // Get width
                NSString *width = (NSString *) [reportInfo objectForKey:@"width"];
                if ([super hasValue:width]) {
                    infoAdRes.width = width;
                }
                
                // Store Report Model into Array
                [reportList addObject:report];
            }
            
            infoAdRes.infoAdList =  reportList;
        }
    }
    else
    {
        infoAdRes.success = [[json valueForKey:@"Success"] boolValue];
        infoAdRes.errorMessage = [[json objectForKey:@"Data"] objectForKey:@"ErrorMessage"];
    }
    
    return infoAdRes;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(infoAdRequest *)request {
    
    NSString *response = @"";
    switch (INFO_AD_SERVICE) {
            
        case LIVE_SERVICE:  {
            
            NSMutableDictionary *dictionary = [self serviceParams:request];
            response = [self serviceResponseByPostJSON:requestUrl
                                            jsonParameters:[super JSONFromDictionary:dictionary]];
            break;
        }
            
        case MOCK_SERVICE:  {
            response = [[SPServiceMockResponse alloc] getFileContent:@"InfoAdServiceResponse"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    
    return response;
}

- (infoAdResponce *) getInfoAd: (infoAdRequest *)request;
{
    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self generateResponseModal:json];
}

@end
