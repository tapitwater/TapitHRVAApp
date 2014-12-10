//
//  FavoriteModel.h
//  TapIt
//
//  Created by Admin on 7/25/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject <NSCoding, NSCopying>
{
    
}
@property (nonatomic) int ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *waterAccessMode;
@property (nonatomic, strong) NSString *waterType;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *businessPhone;
@property (nonatomic) double latitude, longitude, distance;
@property (nonatomic) BOOL error;
@property (nonatomic, retain) NSString *errorHTML;

@end