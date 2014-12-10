//
//  GetLatLongModel.m
//  TapIt
//
//  Created by Admin on 8/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "GetLatLongModel.h"

@implementation GetLatLongModel

#pragma mark - Synthesized Objects

@synthesize latitude, longitude;

#pragma mark - Initialization Method

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Supporting Methods


#pragma mark - Copy With Zone Helper Method

// Copy With Zone Method
- (id)copyWithZone:(NSZone *)zone    {
    
    GetLatLongModel *copy = [[GetLatLongModel alloc] init];
    copy.latitude = latitude;
    copy.longitude = longitude;
    return copy;
}

#pragma mark - NSCoding Protocols

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    /* [encoder encodeObject:self.ID forKey:@"loginID"];
     [encoder encodeObject:self.name forKey:@"password"];
     [encoder encodeObject:self.firstName forKey:@"firstName"];
     [encoder encodeObject:self.lastName forKey:@"lastName"];
     [encoder encodeObject:self.token forKey:@"token"];*/
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        
        /*self.loginID = [decoder decodeObjectForKey:@"loginID"];
         self.password = [decoder decodeObjectForKey:@"password"];
         self.firstName = [decoder decodeObjectForKey:@"firstName"];
         self.lastName = [decoder decodeObjectForKey:@"lastName"];
         self.token = [decoder decodeObjectForKey:@"token"];*/
    }
    return self;
}


@end
