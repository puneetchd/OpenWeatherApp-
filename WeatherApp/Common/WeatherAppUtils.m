//
//  WeatherAppUtils.m
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "WeatherAppUtils.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <NSObject+Motis.h>

@implementation WeatherAppUtils

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

@end
