//
//  InfoAboutResponce.h
//  TapIt
//
//  Created by Admin on 7/26/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface InfoAboutResponce : Response
{
    
}

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *linkUrl;
@property (nonatomic, retain) NSMutableArray *infoAboutList;

@end
