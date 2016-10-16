//
//  WeatherAppUtils.m
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGWeatherAppUtils.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <NSObject+Motis.h>

@implementation PGWeatherAppUtils

+ (BOOL)isInternetReachable
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    if(reachability == NULL)
        return false;
    
    if (!(SCNetworkReachabilityGetFlags(reachability, &flags)))
        return false;
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
        // if target host is not reachable
        return false;
    
    
    BOOL isReachable = false;
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that your on Wi-Fi
        isReachable = true;
    }
    
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            isReachable = true;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        // ... but WWAN connections are OK if the calling application
        //     is using the CFNetwork (CFSocketStream?) APIs.
        isReachable = true;
    }
    
    
    return isReachable;
    
}

#pragma mark - nil Null Validation Utility functions.

+(BOOL)isNull:(id)value
{
    return value == [NSNull null];
}

+(BOOL)isNilOrNull:(id)value
{
    return !value || [self isNull:value];
}

+(BOOL)isNullOrEmpty:(NSString*)value
{
    return [self isNilOrNull:value] || value.length == 0;
}

#pragma mark - Data Model ORM mapping Utility functions

+ (NSArray*)getArrayFromJsonDataUsingORMModel:(id)jsonData forClassModel:(Class)model
{
    if(![jsonData isKindOfClass:[NSArray class]])
        return [NSArray new];
    
    NSMutableArray *records = [NSMutableArray new];
    
    id modelJsons = jsonData;
    
    if(![self isNilOrNull:modelJsons])
    {
        for (NSDictionary *modelJson in modelJsons)
        {
            id modelClass = [[model alloc] init];
            [modelClass mts_setValuesForKeysWithDictionary:modelJson];
            [records addObject:modelClass];
        }
    }
    return records;
}

#pragma mark - XML to JSON COnverter

+ (void)convertXMLToJSONForResponse:(id)jsonObject
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",jsonString);
    }
}

#pragma mark - Alert Utility

+ (void)showAlertForMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [[self getTopMostViewController] dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [[self getTopMostViewController] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIViewController Utility functions

+ (UIViewController*) getTopMostViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    for (UIView *subView in [window subviews])
    {
        UIResponder *responder = [subView nextResponder];
        
        //added this block of code for iOS 8 which puts a UITransitionView in between the UIWindow and the UILayoutContainerView
        if ([responder isEqual:window])
        {
            //this is a UITransitionView
            if ([[subView subviews] count])
            {
                UIView *subSubView = [subView subviews][0]; //this should be the UILayoutContainerView
                responder = [subSubView nextResponder];
            }
        }
        
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topViewController: (UIViewController *) responder];
        }
    }
    
    return nil;
}

+ (UIViewController*) topViewController: (UIViewController *) controller
{
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}

@end
