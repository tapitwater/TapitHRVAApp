//
//  LocationPinModal.m
//  Gobymobile
//
//  Created by Kuldip on 7/29/13.
//  Copyright (c) 2013 Techgrains. All rights reserved.
//

#import "LocationPinModal.h"

@implementation LocationPinModal

@synthesize coordinate;



- (id)copyWithZone:(NSZone *)zone    {
    
    LocationPinModal *copy = [[LocationPinModal alloc] init];
    copy.coordinate = coordinate;
    
    return copy;
}

@end

