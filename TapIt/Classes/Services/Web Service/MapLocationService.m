//
//  MapLocationService.m
//  TapIt
//
//  Created by Admin on 7/15/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "MapLocationService.h"

@implementation MapLocationService

#pragma mark - Initialization Methods

static MapLocationService *instance;

+ (MapLocationService *) getInstance {
	if (instance == nil) {
        instance = [[MapLocationService alloc] init];
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

- (NSMutableDictionary *) serviceParams:(MapLocationRequest *)request  {
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
    
    // Set Radius
    if([super hasValue:[request radius]])   {
        [dictionary setObject:[request radius] forKey:@"radius"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"radius"];
    }
    
    // Set MapCenterLat
    if([super hasValue:[request mapCenterLat]])   {
        [dictionary setObject:[request mapCenterLat] forKey:@"mapCenterLat"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"mapCenterLat"];
    }
    
    // Set MapCenterLon
    if([super hasValue:[request mapCenterLon]])   {
        [dictionary setObject:[request mapCenterLon] forKey:@"mapCenterLon"];
    }
    else    {
        [dictionary setObject:@"" forKey:@"mapCenterLon"];
    }
    
    // Set Query
//    if([super hasValue:[request query]])   {
//        [dictionary setObject:[request query] forKey:@"query"];
//    }
//    else    {
//        [dictionary setObject:@"" forKey:@"query"];
//    }
   

    return dictionary;
}

- (NSMutableArray *) generateResponseModal:(NSDictionary *)json
{
    MapLocationResponce *mapLocationResponce = [[MapLocationResponce alloc] init];
    
    //if ([super hasValue:[json objectForKey:@"Success"]])
    //if ([(NSString *)[json objectForKey:@"Success"] isEqualToString:@"1"])
    bool checkSuccess = [[json valueForKey:@"Success"] boolValue];
    if (checkSuccess)
    {
        NSString *success = (NSString *) [json objectForKey:@"Success"];
        if ([super hasValue:success]==1) {
            mapLocationResponce.success = [success boolValue];
        }
        // Get Report Data
        NSArray *reportData = [json objectForKey:@"Data"];
        if ([super hasValue:reportData]) {
            
            int totalReports = [reportData count];
            NSMutableArray *reportList = [NSMutableArray arrayWithCapacity:totalReports];
            
            for (int count=0; count<totalReports; count++) {
                
                NSDictionary *reportInfo = (NSDictionary *) [reportData objectAtIndex:count];
                MapLocationModel *report = [[MapLocationModel alloc] init];
                
                // Get ID
                int reportID = [[reportInfo objectForKey:@"id"] intValue];
                report.ID = reportID;
                
                //Get icontype
                int icontype = [[reportInfo objectForKey:@"icontype"] intValue];
                report.icontype = icontype;
                
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
            
            mapLocationResponce.mapLocationList =  reportList;
        }
    }
    else
    {
        mapLocationResponce.success = [[json valueForKey:@"Success"] boolValue];
        mapLocationResponce.errorMessage = [[json objectForKey:@"Data"] objectForKey:@"ErrorMessage"];
    }

    return mapLocationResponce.mapLocationList;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(MapLocationRequest *)request {
    
    NSString *response = @"";
    switch (MAP_LOCATION_SERVICE) {
            
        case LIVE_SERVICE:  {
            
            NSMutableDictionary *dictionary = [self serviceParams:request];
            response = [self serviceResponseByPostJSON:requestUrl
                                            jsonParameters:[super JSONFromDictionary:dictionary]];
            break;
        }
            
        case MOCK_SERVICE:  {
            response = [[SPServiceMockResponse alloc] getFileContent:@"MapLocationServiceResponse"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    
    return response;
}

- (NSMutableArray *) mapLocation:(MapLocationRequest *)request
{
    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self generateResponseModal:json];
}

@end
