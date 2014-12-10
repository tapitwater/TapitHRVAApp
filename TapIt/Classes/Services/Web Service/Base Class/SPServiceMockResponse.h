//
//  SPServiceMockResponse.h
//  DnaTicket
//
//  Created by Shardul Patel on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MOCK_RESPONSE_WAIT_ENABLED      YES
#define DEFAULT_WAIT_SECONDS            1.0

@interface SPServiceMockResponse : NSObject {
    
    float totalWaitSeconds;
    BOOL waitUntilFinish;
}

// Utility Methods
- (NSDictionary *) params:(NSString *)url;
- (NSString *) getFileContent:(NSString *)fileName ofFileType:(NSString *)fileType afterDelay:(float)seconds;
- (NSString *) serviceResponse:(NSString *)url;

@end

// Add Private Methods Here
@interface SPServiceMockResponse (Private)

- (void) waitBeforeGivingResponseForSeconds:(float)seconds;   // Useful in mocksevice response

@end