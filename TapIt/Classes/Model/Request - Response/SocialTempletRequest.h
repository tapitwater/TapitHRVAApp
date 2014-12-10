//
//  SocialTempletRequest.h
//  TapIt
//
//  Created by Admin on 8/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface SocialTempletRequest : Request
{
    NSString *serviceMethodName;
}

- (NSString *)url;

@end
