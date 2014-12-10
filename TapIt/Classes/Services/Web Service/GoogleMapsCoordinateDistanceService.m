//
//  GoogleMapsCoordinateDistanceService.m
//  Proxinets
//
//  Created by Shardul Patel on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleMapsCoordinateDistanceService.h"
#import "SPServiceMockResponse.h"
#import "CoordinateDistanceModel.h"

@implementation GoogleMapsCoordinateDistanceService

static GoogleMapsCoordinateDistanceService *instance;

+ (GoogleMapsCoordinateDistanceService *) getInstance {
	if (instance == nil) {
        instance = [[GoogleMapsCoordinateDistanceService alloc] init];
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

- (NSString *)serviceParams:(GoogleMapsCoordinateDistanceRequest *)request  {
    
    // Get Base Request URL
    NSString *requestURL = [request url];
    
    // Set Origin Coordinates
    if (request.originLatitude && request.originLongitude) {
        NSString *origin = [NSString stringWithFormat:@"%f,%f",[request.originLatitude doubleValue],[request.originLongitude doubleValue]];
        requestURL = [requestURL stringByAppendingFormat:@"origins=%@&",origin];
    }
    
    // Set Destination Coordinates
    if (request.destinationLatitude && request.destinationLongitude) {
        NSString *destination = [NSString stringWithFormat:@"%f,%f",[request.destinationLatitude doubleValue],[request.destinationLongitude doubleValue]];
        requestURL = [requestURL stringByAppendingFormat:@"destinations=%@&",destination];
    }
    
    // Set Default Unit
    requestURL = [requestURL stringByAppendingFormat:@"units=metric&"];
    
    // Set Sensor type
    requestURL = [requestURL stringByAppendingFormat:@"sensor=%@",[self getStringFromBoolianValue:FALSE]];
    

    
    return requestURL;
}


- (GoogleMapsCoordinateDistanceResponse *) getCoordinateDistanceResponse:(NSDictionary *)json  {
    
    GoogleMapsCoordinateDistanceResponse *coordinateDistanceResponse = [[GoogleMapsCoordinateDistanceResponse alloc] init];
    
    // Get Status
    NSString *status = (NSString *) [json objectForKey:@"status"];
    if ([super hasValue:status]) {
        
        BOOL success = NO;
        if ([status isEqualToString:@"OK"]) {
            success = YES;
        }
        
        coordinateDistanceResponse.success = success;
    }
    
    // Get Rows
    if ([super hasValue:[json objectForKey:@"rows"]]) {
        
        NSArray *objArray = (NSArray *) [json objectForKey:@"rows"];
        if ([objArray count]>0) {
            
            NSDictionary *obj = (NSDictionary *) [objArray objectAtIndex:0];
            // Get Elements
            if ([super hasValue:[obj objectForKey:@"elements"]]) {
                
                NSArray *elementsArray = [obj objectForKey:@"elements"];
                if ([elementsArray count]>0) {
                    
                    NSDictionary *elementObj = (NSDictionary *) [elementsArray objectAtIndex:0];
                    CoordinateDistanceModel *coordinateDistanceModel = [[CoordinateDistanceModel alloc] init];
                    
                    // Get Distance
                    if ([super hasValue:[elementObj objectForKey:@"distance"]]) {
                        
                        NSDictionary *distance = [elementObj objectForKey:@"distance"];
                        
                        if ([super hasValue:[distance objectForKey:@"text"]]) {
                            
                            coordinateDistanceModel.distanceString = (NSString *) [distance objectForKey:@"text"];
                        }
                        
                        if ([super hasValue:[distance objectForKey:@"value"]]) {
                            
                            coordinateDistanceModel.distance = [NSNumber numberWithUnsignedInt:[[distance objectForKey:@"value"] doubleValue]];
                        }
                    }
                    
                    // Get Duration
                    if ([super hasValue:[elementObj objectForKey:@"duration"]]) {
                        
                        NSDictionary *duration = [elementObj objectForKey:@"duration"];
                        
                        if ([super hasValue:[duration objectForKey:@"text"]]) {
                            
                            coordinateDistanceModel.durationString = (NSString *) [duration objectForKey:@"text"];
                        }
                        
                        if ([super hasValue:[duration objectForKey:@"value"]]) {
                            
                            coordinateDistanceModel.duration = [NSNumber numberWithUnsignedInt:[[duration objectForKey:@"value"] unsignedIntValue]];
                        }
                    }
                    
                    // Get Status
                    NSString *status = (NSString *) [json objectForKey:@"status"];
                    if ([super hasValue:status]) {
                        
                        BOOL success = NO;
                        if ([status isEqualToString:@"OK"]) {
                            success = YES;
                        }
                        
                        coordinateDistanceModel.success = success;
                    }
                    
                    // Assign CoordinateDistance Model tO response Object
                    coordinateDistanceResponse.coordinateDistance = coordinateDistanceModel;
                }
            }
        }
    }
    
    return coordinateDistanceResponse;
}

- (NSString *) serviceResponseForURL:(NSString *)requestUrl withRequest:(GoogleMapsCoordinateDistanceRequest *)request {
    
    NSString *response = @"";
    switch (GOOGLE_MAPS_COORDINATE_DISTANCE_SERVICE) {
            
        case LIVE_SERVICE:  {
            
            NSString *requestURL = [self serviceParams:request];
            //response = [self serviceResponse:requestURL];
            response = [self serviceResponse:@""];
            break;
        }
            
        case MOCK_SERVICE:  {
            response = [[SPServiceMockResponse alloc] getFileContent:@"GoogleMapsCoordinateDistanceResponse"
                                                          ofFileType:@"json"
                                                          afterDelay:0.0];
            break;
        }
            
        default:
            break;
    }
    
    return response;
}

- (GoogleMapsCoordinateDistanceResponse *) getGoogleMapsCoordinateDistanceWithRequest:(GoogleMapsCoordinateDistanceRequest *)request   {   
    

    NSString *serviceResponse = [self serviceResponseForURL:[request url] withRequest:request];

    // NSLog(@"_______________________________________________________");
    NSDictionary *json = [super dictionaryFromJSON:serviceResponse];
    return [self getCoordinateDistanceResponse:json];
}

@end
