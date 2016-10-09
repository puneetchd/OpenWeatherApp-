//
//  WeatherAppUtils.h
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherAppUtils : NSObject

+ (BOOL)isInternetReachable;

#pragma mark - Data Model ORM mapping Utility functions

+ (NSArray*)getArrayFromJsonDataUsingORMModel:(id)jsonData forClassModel:(Class)model;

@end
