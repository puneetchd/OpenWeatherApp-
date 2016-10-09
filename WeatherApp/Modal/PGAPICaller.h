//
//  PGAPICaller.h
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface PGAPICaller : NSObject

#pragma mark - Operation Manager

+ (AFHTTPSessionManager*)sharedSessionManager;
+ (void)fetchAutoSuggestionsForText:(NSString*)inputText successCallback:(void (^)(NSArray *locationsArray)) successCallback   errorCallback:(void (^)(NSError * error, NSString *errorMsg)) errorCallback;

@end
