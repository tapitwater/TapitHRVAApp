//
//  FavoriteService.h
//  TapIt
//
//  Created by Admin on 7/25/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPService.h"
#import "FavoritesRequest.h"
#import "FavoritesResponce.h"
#import "FavoriteModel.h"

@interface FavoriteService : SPService
{
    NSString *serviceMethodName;
}

+ (FavoriteService *) getInstance;
- (NSMutableArray *) mapLocation:(FavoritesRequest *)request;

@end
