//
//  SPDeviceInfo.h
//  WorthPoint
//
//  Created by Shardul on 11/10/12.
//  Copyright (c) 2012 The Sunflower Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPDeviceInfo : NSObject

//defs
typedef enum {
    SPDeviceModelUnknown = 0,
    SPDeviceModeliPhone,
    SPDeviceModeliPhone3G,
    SPDeviceModeliPhone3GS,
    SPDeviceModeliPhone4,
    SPDeviceModeliPhone4S,
    SPDeviceModeliPhone5,
    SPDeviceModeliPad,
    SPDeviceModeliPad2,
    SPDeviceModeliPad3,
    SPDeviceModeliPod,
    SPDeviceModeliPod2,
    SPDeviceModeliPod3,
    SPDeviceModeliPod4,
    SPDeviceModeliPod5,
} SPDeviceModel;

typedef enum {
    SPDeviceFamilyUnknown = 0,
    SPDeviceFamilyiPhone,
    SPDeviceFamilyiPad,
    SPDeviceFamilyiPod,
} SPDeviceFamily;

typedef enum {
    SPDeviceDisplayUnknown = 0,
    SPDeviceDisplayiPad,
    SPDeviceDisplayiPhone35Inch,
    SPDeviceDisplayiPhone4Inch,
} SPDeviceDisplay;

typedef struct {
    SPDeviceModel           model;
    SPDeviceFamily          family;
    SPDeviceDisplay         display;
    NSUInteger              bigModel;
    NSUInteger              smallModel;
} SPDeviceDetails;

//public API
+(SPDeviceDetails)deviceDetails;
+(NSString *)rawSystemInfoString;

@end
