//
//  PGDataLocation.m
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGDataLocation.h"
#import <NSObject+Motis.h>

@implementation PGDataLocation

+ (NSDictionary*)mts_mapping
{
    return @{@"areaName": mts_key(areaName),
             @"country": mts_key(country),
             @"region": mts_key(region)
             };
}

@end
