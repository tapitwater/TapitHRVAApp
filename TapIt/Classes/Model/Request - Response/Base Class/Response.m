//
//  Response.m
//  Gobymobile
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Response.h"

@implementation Response

#pragma mark - Synthesized Objects

@synthesize success;
@synthesize errorCode;
@synthesize errorMessage;

#pragma mark - Initialization Methods

- (id)init {
    
    self = [super init];
    if (self) {
        
        // Custom Initialization Code
    }
    return self;
}

@end
