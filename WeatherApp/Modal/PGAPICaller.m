//
//  PGAPICaller.m
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGAPICaller.h"
#import "PGWeatherAppUtils.h"
#import "PGConstants.h"
#import "PGDataLocation.h"

#define kDefaultErrorMessage                @"Something went wrong!"
#define kJSONFormat                         @"json"
#define kXMLFormat                          @"xml"
#define kSearchAPI                          @"search.ashx"
#define kWeatherAPI                         @"weather.ashx"
#define kNOInternetMessage                  @"No Internet Connection."

static AFHTTPSessionManager *sharedInstance = nil;
static NSString *apiKey = nil;
static NSString *baseURL = nil;

@implementation PGAPICaller

#pragma mark - Operation Manager

+ (AFHTTPSessionManager*)sharedSessionManager
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[AFHTTPSessionManager alloc]init];
        sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedInstance.operationQueue setMaxConcurrentOperationCount:5];
        apiKey = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"API_KEY"];
        baseURL = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"API_BASE_URL"];
    }
    return sharedInstance;
}

+ (void)fetchAutoSuggestionsForText:(NSString*)inputText successCallback:(void (^)(NSArray *locationsArray)) successCallback   errorCallback:(void (^)(NSError * error, NSString *errorMsg)) errorCallback
{
    if (![PGWeatherAppUtils isInternetReachable]) {
        [PGWeatherAppUtils showAlertForMessage:kNOInternetMessage];
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [self sharedSessionManager];
    
    NSDictionary *parametersDict = @{@"key":apiKey,@"q":inputText,@"format":kJSONFormat};
    
    [sessionManager GET:[baseURL stringByAppendingString:kSearchAPI] parameters:parametersDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            NSArray *responseArray =  [PGWeatherAppUtils getArrayFromJsonDataUsingORMModel:[[responseObject objectForKey:@"search_api"] objectForKey:@"result"] forClassModel:[PGDataLocation class]];
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

+ (void)fetchWeatherDetailForLocation:(NSString*)locationString successCallback:(void (^)(NSDictionary *detailsDict)) successCallback   errorCallback:(void (^)(NSError * error, NSString *errorMsg)) errorCallback
{
    if (![PGWeatherAppUtils isInternetReachable]) {
        [PGWeatherAppUtils showAlertForMessage:kNOInternetMessage];
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [self sharedSessionManager];
    
    NSDictionary *parametersDict = @{@"key":apiKey,@"q":locationString,@"format":kJSONFormat};
    
    [sessionManager GET:[baseURL stringByAppendingString:kWeatherAPI] parameters:parametersDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject)
        {
            id mainObj = [[[responseObject objectForKey:@"data"] objectForKey:@"current_condition"] firstObject];
            NSMutableDictionary *responseDict = [[NSMutableDictionary alloc]init];
            [responseDict setObject:[mainObj objectForKey:@"observation_time"] forKey:kObvTime];
            [responseDict setObject:[[[mainObj objectForKey:@"weatherIconUrl"] firstObject] objectForKey:@"value"] forKey:kIconURL];
            [responseDict setObject:[[[mainObj objectForKey:@"weatherDesc"] firstObject] objectForKey:@"value"] forKey:kWeatherDescription];
            [responseDict setObject:[mainObj objectForKey:@"humidity"] forKey:kHumidity];
            successCallback(responseDict);
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
