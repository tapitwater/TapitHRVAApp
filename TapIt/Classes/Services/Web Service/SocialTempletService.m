//
//  SocialTempletService.m
//  TapIt
//
//  Created by Admin on 8/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "SocialTempletService.h"

@implementation SocialTempletService

#pragma mark - Initialization Methods

static SocialTempletService *instance;

+ (SocialTempletService *) getInstance {
	if (instance == nil) {
        instance = [[SocialTempletService alloc] init];
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
- (NSMutableDictionary *) serviceParams:(SocialTempletRequest *)request  {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    return dictionary;
}

- (SocialTempletResponce *) generateResponseModal:(NSDictionary *)json  {
    
    SocialTempletResponce *socialTempletRes = [[SocialTempletResponce alloc] init];
    
    //if ([super hasValue:[json objectForKey:@"Success"]])
    //if ([(NSString *)[json objectForKey:@"Success"] isEqualToString:@"1"])
    bool checkSuccess = [[json valueForKey:@"Success"] boolValue];
    if (checkSuccess)
    {
        NSString *success = (NSString *) [json objectForKey:@"Success"];
        if ([super hasValue:success]==1) {
            socialTempletRes.success = [success boolValue];
        }
        
        // Get Report Data
        NSArray *reportData = [json objectForKey:@"Data"];
        if ([super hasValue:reportData]) {
            
            int totalReports = [reportData count];
            NSMutableArray *reportList = [NSMutableArray arrayWithCapacity:totalReports];
            
            for (int count=0; count<totalReports; count++) {
                
                NSDictionary *reportInfo = (NSDictionary *) [reportData objectAtIndex:count];
                SocialTempleteModel *report = [[SocialTempleteModel alloc] init];
                
                // Get media
                NSString *media = (NSString *) [reportInfo objectForKey:@"media"];
                if ([super hasValue:media]) {
                    report.media = media;
                }
                
                //Get templet
                NSString *templet = (NSString *) [reportInfo objectForKey:@"template"];
                if ([super hasValue:templet]) {
                    report.templet = templet;
                }

                
                // Store Report Model into Array
                [reportList addObject:report];
            }
            
            socialTempletRes.socialTempletList =  reportList;
        }
    }
    else
    {
        socialTempletRes.success = [[json valueForKey:@"Success"] boolValue];
        socialTempletRes.errorMessage = [[json objectForKey:@"Data"] objectForKey:@"ErrorMessage"];
    }
    
    return socialTempletRes;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(SocialTempletRequest *)request {
    
    NSString *response = @"";
    switch (SOCIALTEMPLETE_NAME_SERVICE) {
            
        case LIVE_SERVICE:  {
            
            NSMutableDictionary *dictionary = [self serviceParams:request];
            response = [self serviceResponseByPostJSON:requestUrl
                                            jsonParameters:[super JSONFromDictionary:dictionary]];
            break;
        }
            
        case MOCK_SERVICE:  {
            
            response = [[SPServiceMockResponse alloc] getFileContent:@"SocialTempleteServiceResponse"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    return response;
}


- (SocialTempletResponce *) getSocialTemplet: (SocialTempletRequest *)request {
    
    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self generateResponseModal:json];
}

@end
