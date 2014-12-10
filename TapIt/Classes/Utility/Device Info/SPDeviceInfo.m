//
//  SPDeviceInfo.m
//  WorthPoint
//
//  Created by Shardul on 11/10/12.
//  Copyright (c) 2012 The Sunflower Lab. All rights reserved.
//

#import "SPDeviceInfo.h"
#import <sys/utsname.h>

@implementation SPDeviceInfo

+(SPDeviceDetails)deviceDetails {
    SPDeviceDetails details;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *systemInfoString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //get data
    if ([[systemInfoString substringToIndex:6] isEqualToString:@"iPhone"]) {
        details.family = SPDeviceFamilyiPhone;
        details.bigModel = [[systemInfoString substringWithRange:NSMakeRange(6, 1)] intValue];
        details.smallModel = [[systemInfoString substringWithRange:NSMakeRange(8, 1)] intValue];
        
        if (details.bigModel == 1) {
            if (details.smallModel == 1) {
                details.model = SPDeviceModeliPhone;
            }
            else if (details.smallModel == 2) {
                details.model = SPDeviceModeliPhone3G;
            }
            else {
                details.model = SPDeviceModelUnknown;
            }
        }
        else if (details.bigModel == 2) {
            details.model = SPDeviceModeliPhone3GS;
        }
        else if (details.bigModel == 3) {
            details.model = SPDeviceModeliPhone4;
        }
        else if (details.bigModel == 4) {
            details.model = SPDeviceModeliPhone4S;
        }
        else if (details.bigModel == 5) {
            details.model = SPDeviceModeliPhone5;
        }
        else {
            details.model = SPDeviceModelUnknown;
        }
    }
    else if ([[systemInfoString substringToIndex:4] isEqualToString:@"iPad"]) {
        details.family = SPDeviceFamilyiPad;
        details.bigModel = [[systemInfoString substringWithRange:NSMakeRange(4, 1)] intValue];
        details.smallModel = [[systemInfoString substringWithRange:NSMakeRange(6, 1)] intValue];
        
        switch (details.bigModel) {
            case 1:
                details.model = SPDeviceModeliPad;
                break;
                
            case 2:
                details.model = SPDeviceModeliPad2;
                break;
                
            case 3:
                details.model = SPDeviceModeliPad3;
                break;
                
            default:
                details.model = SPDeviceModelUnknown;
                break;
        }
    }
    else if ([[systemInfoString substringToIndex:4] isEqualToString:@"iPod"]) {
        details.family = SPDeviceFamilyiPod;
        details.bigModel = [[systemInfoString substringWithRange:NSMakeRange(4, 1)] intValue];
        details.smallModel = [[systemInfoString substringWithRange:NSMakeRange(6, 1)] intValue];
        
        switch (details.bigModel) {
            case 1:
                details.model = SPDeviceModeliPod;
                break;
                
            case 2:
                details.model = SPDeviceModeliPod2;
                break;
                
            case 3:
                details.model = SPDeviceModeliPod3;
                break;
                
            case 4:
                details.model = SPDeviceModeliPod4;
                break;
                
            case 5:
                details.model = SPDeviceModeliPod5;
                break;
                
            default:
                details.model = SPDeviceModelUnknown;
                break;
        }
    }
    else {
        details.family = SPDeviceFamilyUnknown;
        details.bigModel = 0;
        details.smallModel = 0;
        details.model = SPDeviceModelUnknown;
    }
    
    //get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //ipad old
    if ((screenWidth == 768) && (screenHeight == 1024)) {
        details.display = SPDeviceDisplayiPad;
    }
    //iphone
    else if ((screenWidth == 320) && (screenHeight == 480)) {
        details.display = SPDeviceDisplayiPhone35Inch;
    }
    //iphone 4 inch
    else if ((screenWidth == 320) && (screenHeight == 568)) {
        details.display = SPDeviceDisplayiPhone4Inch;
    }
    //unknown
    else {
        details.display = SPDeviceDisplayUnknown;
    }
    
    return details;
}

+(NSString *)rawSystemInfoString {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end
