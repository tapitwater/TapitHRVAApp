//
//  TwitterFeedService.m
//  TapIt
//
//  Created by Admin on 7/24/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "TwitterFeedService.h"


@implementation TwitterFeedService

#pragma mark - Initialization Methods

static TwitterFeedService *instance;

+ (TwitterFeedService *) getInstance {
	if (instance == nil) {
        instance = [[TwitterFeedService alloc] init];
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

- (NSMutableDictionary *) serviceParams:(TwitterFeedRequest *)request  {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    // Set User Name
    if([super hasValue:[request UserName]])   {
        [dictionary setObject:[request UserName] forKey:@"userName"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"userName"];
    }
    
    // Set Longitude
    if([super hasValue:[request Password]])   {
        [dictionary setObject:[request Password] forKey:@"password"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"password"];
    }
    
    return dictionary;
}

- (TwitterFeedResponce *) generateResponseModal:(NSDictionary *)json  {
    TwitterFeedResponce *twitterFeedResponce = [[TwitterFeedResponce alloc] init];
    
    //if ([super hasValue:[json objectForKey:@"Success"]])
    //if ([(NSString *)[json objectForKey:@"Success"] isEqualToString:@"1"])
    bool checkSuccess = [[json valueForKey:@"Success"] boolValue];
    if (checkSuccess)
    {
        NSString *success = (NSString *) [json objectForKey:@"Success"];
        if ([super hasValue:success]==0) {
            twitterFeedResponce.success = [success boolValue];
        }
        
        // Get Report Data
        //NSString *strDataUntil =[[json objectForKey:@"Data"] objectForKey:@"dataUntil"];
        
        NSArray *reportData = [[json objectForKey:@"Data"] objectForKey:@"tweetfeeds"];
        if ([super hasValue:reportData]) {
            
            int totalReports = [reportData count];
            NSMutableArray *reportList = [NSMutableArray arrayWithCapacity:totalReports];
            
            for (int count=0; count<totalReports; count++) {
                
                NSDictionary *reportInfo = (NSDictionary *) [reportData objectAtIndex:count];
                TwitterFeedModel *report = [[TwitterFeedModel alloc] init];
                
                // Get Detail
                NSString *feedhtml = (NSString *) [reportInfo objectForKey:@"feedhtml"];
                if ([super hasValue:feedhtml]) {
                    report.feedhtml = feedhtml;
                }
                
                // Store Report Model into Array
                [reportList addObject:report];
            }
            
            twitterFeedResponce.twitterFeedList =  reportList;
        }
    }
    else
    {
        twitterFeedResponce.success = [[json valueForKey:@"Success"] boolValue];
        twitterFeedResponce.errorMessage = [[json objectForKey:@"Data"] objectForKey:@"ErrorMessage"];
    }
    
    return twitterFeedResponce;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(TwitterFeedRequest *)request {
    
    NSString *response = @"";
    switch (TWITTER_FEED_SERVICE) {
            
        case LIVE_SERVICE:  {
            NSMutableDictionary *dictionary = [self serviceParams:request];
            response = [self serviceResponseByPostJSON:requestUrl
                                            jsonParameters:[super JSONFromDictionary:dictionary]];
            break;
        }
            
        case MOCK_SERVICE:  {
            response = [[SPServiceMockResponse alloc] getFileContent:@"TwitterFeedServiceResponse1"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    
    return response;
}


- (TwitterFeedResponce *) twitterFeedWithRequest:(TwitterFeedRequest *)request
{
    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self generateResponseModal:json];
}

@end
