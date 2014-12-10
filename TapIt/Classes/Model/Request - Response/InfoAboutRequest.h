//
//  InfoAboutRequest.h
//  TapIt
//
//  Created by Admin on 7/26/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface InfoAboutRequest : Request
{
    NSString *serviceMethodName;
}

- (NSString *)url;

@end
