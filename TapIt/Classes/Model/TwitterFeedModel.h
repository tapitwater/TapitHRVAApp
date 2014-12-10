//
//  TwitterFeedModel.h
//  TapIt
//
//  Created by Admin on 7/24/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterFeedModel : NSObject <NSCoding, NSCopying>
{
    
}
@property (nonatomic) int ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *distance,*url;
@property (nonatomic, retain) NSString *dataUntil, *feedhtml;

@end
