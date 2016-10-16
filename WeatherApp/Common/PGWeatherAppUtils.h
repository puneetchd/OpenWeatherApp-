//
//  WeatherAppUtils.h
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PGWeatherAppUtils : NSObject

+ (BOOL)isInternetReachable;

#pragma mark - Data Model ORM mapping Utility functions

+ (NSArray*)getArrayFromJsonDataUsingORMModel:(id)jsonData forClassModel:(Class)model;

#pragma mark - XML to JSON COnverter

+ (void)convertXMLToJSONForResponse:(id)jsonObject;

#pragma mark - Alert Utility

+ (void)showAlertForMessage:(NSString*)message;

@end
