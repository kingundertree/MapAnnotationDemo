//
//  CLLocationManager+RT.m
//  LocServiceIsOpen
//
//  Created by shan xu on 14-3-31.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "CLLocationManager+RT.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation CLLocationManager (RT)
+ (BOOL)isLocationServiceEnabled
{
    //两种定位都打开时，返回YES
    return ([self isSysLocationServiceEnabled] && [self isAppLocationServiceEnabled]);
}

+ (BOOL)isSysLocationServiceEnabled
{
    BOOL serviceEnable;
    serviceEnable = [self locationServicesEnabled];
    return serviceEnable;
}

+ (BOOL)isAppLocationServiceEnabled
{
    BOOL serviceEnable = NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.2")) {
        CLAuthorizationStatus authorizationStatus = [self authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
            //系统弹框通知
            serviceEnable = NO;
        } else if (authorizationStatus == kCLAuthorizationStatusRestricted) {
            //弹框提示打开应用服务
            serviceEnable = NO;
        } else if (authorizationStatus == kCLAuthorizationStatusDenied) {
            //弹框提示打开应用服务
            serviceEnable = NO;
        }
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            if (authorizationStatus >= kCLAuthorizationStatusAuthorizedAlways || authorizationStatus >= kCLAuthorizationStatusAuthorizedWhenInUse) {
                //定位服务已打开
                serviceEnable = YES;
            }
        } else {
            if (authorizationStatus >= kCLAuthorizationStatusAuthorized) {
                //定位服务已打开
                serviceEnable = YES;
            }
        }
    } else {
        return [self isSysLocationServiceEnabled];
    }
    return serviceEnable;
}

@end
