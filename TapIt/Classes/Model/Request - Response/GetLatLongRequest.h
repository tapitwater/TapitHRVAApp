//
//  GetLatLongRequest.h
//  TapIt
//
//  Created by Admin on 8/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface GetLatLongRequest : Request
{
    NSString *serviceMethodName;
}

@property (nonatomic, strong) NSString *address;

- (NSString *)url;

@end
