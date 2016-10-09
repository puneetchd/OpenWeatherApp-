//
//  PGAPICaller.m
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGAPICaller.h"
#import "WeatherAppUtils.h"
#import "PGConstants.h"
#import "PGDataLocation.h"

#define kDefaultErrorMessage                @"Something went wrong!"

static AFHTTPSessionManager *sharedInstance = nil;

@implementation PGAPICaller

#pragma mark - Operation Manager

+ (AFHTTPSessionManager*)sharedSessionManager
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[AFHTTPSessionManager alloc]init];
        sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedInstance.operationQueue setMaxConcurrentOperationCount:5];
    }
    return sharedInstance;
}

+ (void)fetchAutoSuggestionsForText:(NSString*)inputText successCallback:(void (^)(NSArray *locationsArray)) successCallback   errorCallback:(void (^)(NSError * error, NSString *errorMsg)) errorCallback
{
    if (![WeatherAppUtils isInternetReachable]) {
        Show_ErrorMessage(kNOInternetMessage);
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [self sharedSessionManager];
    
    NSDictionary *parametersDict = @{@"key":kWeatherAPIkey,@"q":inputText,@"format":@"json"};
    
    [sessionManager GET:[kWeatherAPIBaseURL stringByAppendingString:kSearchAPI] parameters:parametersDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            NSArray *responseArray =  [WeatherAppUtils getArrayFromJsonDataUsingORMModel:[[responseObject objectForKey:@"search_api"] objectForKey:@"result"] forClassModel:[PGDataLocation class]];
            successCallback(responseArray);
        }
        else
        {
            errorCallback(nil,kDefaultErrorMessage);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorCallback(nil,kDefaultErrorMessage);
    }];
    
}

+ (void)fetchWeatherDetailForLocation:(NSString*)locationString successCallback:(void (^)(NSArray *locationsArray)) successCallback   errorCallback:(void (^)(NSError * error, NSString *errorMsg)) errorCallback
{
    if (![WeatherAppUtils isInternetReachable]) {
        Show_ErrorMessage(kNOInternetMessage);
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [self sharedSessionManager];
    
    NSDictionary *parametersDict = @{@"key":kWeatherAPIkey,@"q":locationString,@"format":@"json"};
    
    [sessionManager GET:[kWeatherAPIBaseURL stringByAppendingString:kWeatherAPI] parameters:parametersDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
//            NSArray *responseArray =  [WeatherAppUtils getArrayFromJsonDataUsingORMModel:[[responseObject objectForKey:@"search_api"] objectForKey:@"result"] forClassModel:[PGDataLocation class]];
//            successCallback(responseArray);
        }
        else
        {
            errorCallback(nil,kDefaultErrorMessage);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorCallback(nil,kDefaultErrorMessage);
    }];
    
}


@end
