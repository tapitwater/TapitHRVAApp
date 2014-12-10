//
//  SocialTempletResponce.h
//  TapIt
//
//  Created by Admin on 8/6/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface SocialTempletResponce : Response
{
    
}

@property (nonatomic, retain) NSString *media, *templet;
@property (nonatomic, retain) NSMutableArray *socialTempletList;

@end
