//
//  InfoAboutService.m
//  TapIt
//
//  Created by Admin on 7/26/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "InfoAboutService.h"

@implementation InfoAboutService
#pragma mark - Initialization Methods

static InfoAboutService *instance;

+ (InfoAboutService *) getInstance {
	if (instance == nil) {
        instance = [[InfoAboutService alloc] init];
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
- (NSMutableDictionary *) serviceParams:(InfoAboutRequest *)request  {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    return dictionary;
}

- (InfoAboutResponce *) generateResponseModal:(NSDictionary *)json  {
    
    InfoAboutResponce *infoAboutRes = [[InfoAboutResponce alloc] init];
    
    //if ([super hasValue:[json objectForKey:@"Success"]])
    //if ([(NSString *)[json objectForKey:@"Success"] isEqualToString:@"1"])
    bool checkSuccess = [[json valueForKey:@"Success"] boolValue];
    if (checkSuccess)
    {
        NSString *success = (NSString *) [json objectForKey:@"Success"];
        if ([super hasValue:success]==0) {
            infoAboutRes.success = [success boolValue];
        }
        else
        {
            infoAboutRes.success = [success boolValue];
        }
        
        // Get Report Data
        NSArray *reportData = [json objectForKey:@"Data"];
        if ([super hasValue:reportData]) {
            
            int totalReports = [reportData count];
            NSMutableArray *reportList = [NSMutableArray arrayWithCapacity:totalReports];
            
            for (int count=0; count<totalReports; count++) {
                
                NSDictionary *reportInfo = (NSDictionary *) [reportData objectAtIndex:count];
                InfoAboutModel *report = [[InfoAboutModel alloc] init];
                
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
                
                //Get detail
                NSString *detail = (NSString *) [reportInfo objectForKey:@"detail"];
                if ([super hasValue:detail]) {
                    report.detail = detail;
                }
                
                // Store Report Model into Array
                [reportList addObject:report];
            }
            
            infoAboutRes.infoAboutList =  reportList;
        }
    }
    else
    {
        infoAboutRes.success = [[json valueForKey:@"Success"] boolValue];
        infoAboutRes.errorMessage = [[json objectForKey:@"Data"] objectForKey:@"ErrorMessage"];
    }
    return infoAboutRes;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(InfoAboutRequest *)request {
    
    NSString *response = @"";
    switch (INFO_ABOUT_SERVICE) {
            
        case LIVE_SERVICE:  {
            
            NSMutableDictionary *dictionary = [self serviceParams:request];
            response = [self serviceResponseByPostJSON:requestUrl
                                            jsonParameters:[super JSONFromDictionary:dictionary]];
            break;
        }
            
        case MOCK_SERVICE:  {
            response = [[SPServiceMockResponse alloc] getFileContent:@"InfoAboutServiceResponse"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    
    return response;
}


- (InfoAboutResponce *) getInfoAbout: (InfoAboutRequest *)request;
{
    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self generateResponseModal:json];
}

@end

