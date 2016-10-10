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

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.areaName = [decoder decodeObjectForKey:@"areaName"];
        self.country = [decoder decodeObjectForKey:@"country"];
        self.region = [decoder decodeObjectForKey:@"region"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_areaName forKey:@"areaName"];
    [encoder encodeObject:_country forKey:@"country"];
    [encoder encodeObject:_region forKey:@"region"];
}

+ (NSDictionary*)mts_mapping
{
    return @{@"areaName": mts_key(areaName),
             @"country": mts_key(country),
             @"region": mts_key(region)
             };
}

@end
