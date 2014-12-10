//
//  InfoAboutModel.h
//  TapIt
//
//  Created by Admin on 7/26/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoAboutModel : NSObject  <NSCoding, NSCopying>
{
    
}

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *linkUrl,*detail;

@end
