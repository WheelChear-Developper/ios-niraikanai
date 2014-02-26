//
//  Configuration.m
//  Skip
//
//  Created by SMARTTECNO. on 2014/01/03.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

#pragma mark - Synchronize
+ (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - DeviceTokenKey
static NSString *CONFIGURATION_PUSH_DEVICETOKENKEY = @"Configuration.DeviceTokenKey";
+ (NSString*)getDeviceTokenKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_DEVICETOKENKEY : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_DEVICETOKENKEY];
}
+ (void)setDeviceTokenKey:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_DEVICETOKENKEY];
}

#pragma mark - Setting
static NSString *CONFIGURATION_FIRST_START = @"Configuration.FirstStart";
+ (BOOL)getFirstStart
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_FIRST_START : @(YES)}];
    return [userDefaults boolForKey:CONFIGURATION_FIRST_START];
}
+ (void)setFirstStart:(BOOL)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:CONFIGURATION_FIRST_START];
}

#pragma mark - StartScreen
static NSString *CONFIGURATION_STARTSCREEN = @"Configuration.StartScreen";
+ (NSInteger)getStartScreen;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_STARTSCREEN : @(0)}];
    return [userDefaults integerForKey:CONFIGURATION_STARTSCREEN];
}
+ (void)setStartScreen:(NSInteger)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:CONFIGURATION_STARTSCREEN];
}

#pragma mark - PushNotifications
static NSString *CONFIGURATION_PUSH_NOTIFICATIONS = @"Configuration.PushNotifications";
+ (BOOL)getPushNotifications
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_NOTIFICATIONS : @(YES)}];
    return [userDefaults boolForKey:CONFIGURATION_PUSH_NOTIFICATIONS];
}
+ (void)setPushNotifications:(BOOL)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:CONFIGURATION_PUSH_NOTIFICATIONS];
}

#pragma mark - WebURL
static NSString *CONFIGURATION_PUSH_WEBURL = @"Configuration.WebURL";
+ (NSString*)getWebURL
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_WEBURL : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_WEBURL];
}
+ (void)setWebURL:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_WEBURL];
}

#pragma mark - ProfileID
static NSString *CONFIGURATION_PUSH_PROFILEID = @"Configuration.ProfileID";
+ (NSString*)getProfileID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_PROFILEID : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_PROFILEID];
}
+ (void)setProfileID:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_PROFILEID];
}

#pragma mark - ProfileName
static NSString *CONFIGURATION_PUSH_PROFILENAME = @"Configuration.ProfileName";
+ (NSString*)getProfileName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_PROFILENAME : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_PROFILENAME];
}
+ (void)setProfileName:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_PROFILENAME];
}

#pragma mark - ListID
static NSString *CONFIGURATION_LISTID = @"Configuration.ListID";
+ (NSInteger)getListID;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_LISTID : @(0)}];
    return [userDefaults integerForKey:CONFIGURATION_LISTID];
}
+ (void)setListID:(NSInteger)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:CONFIGURATION_LISTID];
}

@end
