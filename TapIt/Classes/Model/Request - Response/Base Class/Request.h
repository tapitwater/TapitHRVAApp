//
//  Request.h
//  Gobymobile
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Request : NSObject {
    
    NSString *serverName;
    
    NSString *caller;
    NSString *version;
}

@property (nonatomic, retain) NSString *serverName;
@property (nonatomic, retain) NSString *caller;
@property (nonatomic, retain) NSString *version;

- (NSString *) url;

@end