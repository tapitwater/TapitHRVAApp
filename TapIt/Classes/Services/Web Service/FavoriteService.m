//
//  FavoriteService.m
//  TapIt
//
//  Created by Admin on 7/25/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "FavoriteService.h"

@implementation FavoriteService

#pragma mark - Initialization Methods

static  FavoriteService *instance;

+ (FavoriteService *) getInstance {
	if (instance == nil) {
        instance = [[FavoriteService alloc] init];
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

- (NSMutableDictionary *) serviceParams:(FavoritesRequest *)request  {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    // Set Latitude
    if([super hasValue:[request latitude]])   {
        [dictionary setObject:[request latitude] forKey:@"lat"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"lat"];
    }
    
    // Set Longitude
    if([super hasValue:[request longitude]])   {
        [dictionary setObject:[request longitude] forKey:@"lon"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"lon"];
    }
    
    // Set Favorites
    if([super hasValue:[request favorites]])   {
        [dictionary setObject:[request favorites] forKey:@"favorites"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"favorites"];
    }
    return dictionary;
}

- (NSMutableArray *) generateResponseModal:(NSDictionary *)json  {
    FavoritesResponce *favoritesResponce = [[FavoritesResponce alloc] init];
    
    //if ([super hasValue:[json objectForKey:@"Success"]])
    //if ([(NSString *)[json objectForKey:@"Success"] isEqualToString:@"1"])
    bool checkSuccess = [[json valueForKey:@"Success"] boolValue];
    if (checkSuccess)
    {
        NSString *success = (NSString *) [json objectForKey:@"Success"];
        if ([super hasValue:success]==0) {
            favoritesResponce.success = [success boolValue];
        }
        
        // Get Report Data
        NSArray *reportData = [json objectForKey:@"Data"];
        if ([super hasValue:reportData]) {
            
            int totalReports = [reportData count];
            NSMutableArray *reportList = [NSMutableArray arrayWithCapacity:totalReports];
            
            for (int count=0; count<totalReports; count++) {
                
                NSDictionary *reportInfo = (NSDictionary *) [reportData objectAtIndex:count];
                FavoriteModel *report = [[FavoriteModel alloc] init];
                
                // Get ID
                int reportID = [[reportInfo objectForKey:@"id"] intValue];
                report.ID = reportID;
                
                // Get Name
                NSString *name = (NSString *) [reportInfo objectForKey:@"name"];
                if ([super hasValue:name]) {
                    report.name = name;
                }
                
                // Get Address
                NSString *address = (NSString *) [reportInfo objectForKey:@"address"];
                if ([super hasValue:address]) {
                    report.address = address;
                }
                
                // Get Distance
                double distance = [[reportInfo objectForKey:@"distance"] doubleValue];
                report.distance = distance;
                
                // Get Water Access Mode
                NSString *waterAccessMode = (NSString *) [reportInfo objectForKey:@"waterAccessMode"];
                if ([super hasValue:waterAccessMode]) {
                    report.waterAccessMode = waterAccessMode;
                }
                
                // Get Water Type
                NSString *waterType = (NSString *) [reportInfo objectForKey:@"waterType"];
                if ([super hasValue:waterType]) {
                    report.waterType = waterType;
                }
                
                // Get Note
                NSString *note = (NSString *) [reportInfo objectForKey:@"note"];
                if ([super hasValue:note]) {
                    report.note = note;
                }
                
                // Get Business Phone
                NSString *businessPhone = (NSString *) [reportInfo objectForKey:@"businessPhone"];
                if ([super hasValue:businessPhone]) {
                    report.businessPhone = businessPhone;
                }
                
                // Get latitide
                double latitude = [[reportInfo objectForKey:@"lat"] doubleValue];
                report.latitude = latitude;
                
                // Get longitude
                double longitude = [[reportInfo objectForKey:@"lon"] doubleValue];
                report.longitude = longitude;
                
                // Store Report Model into Array
                [reportList addObject:report];
            }
            
            favoritesResponce.favoritesList =  reportList;
        }
    }
    else
    {
        favoritesResponce.success = [[json valueForKey:@"Success"] boolValue];
        favoritesResponce.errorMessage = [[json objectForKey:@"Data"] objectForKey:@"ErrorMessage"];
    }
    
    return favoritesResponce.favoritesList;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(FavoritesRequest *)request {
    
    NSString *response = @"";
    switch (FAVORITES_SERVICE) {
            
        case LIVE_SERVICE:  {
            
            NSMutableDictionary *dictionary = [self serviceParams:request];
                response = [self serviceResponseByPostJSON:requestUrl
                                            jsonParameters:[super JSONFromDictionary:dictionary]];
            break;
        }
            
        case MOCK_SERVICE:  {
            response = [[SPServiceMockResponse alloc] getFileContent:@"FavoritesServiceRespon"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    
    return response;
}

- (NSMutableArray *) mapLocation:(FavoritesRequest *)request
{
    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self generateResponseModal:json];
}

@end
