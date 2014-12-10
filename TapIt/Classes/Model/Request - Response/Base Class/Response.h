//
//  Response.h
//  Gobymobile
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Response : NSObject  {
 
    BOOL success;
    int errorCode;
    NSString *errorMessage;
}

@property (nonatomic) BOOL success;
@property (nonatomic) int errorCode;
@property (nonatomic, retain) NSString *errorMessage;

@end
