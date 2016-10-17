//
//  WeatherAppTests.m
//  WeatherAppTests
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGAPICaller.h"
#import "PGConstants.h"
#import "PGWeatherAppUtils.h"
#import "PGStorageManager.h"

@interface WeatherAppLandingPageTests : XCTestCase

@end

@implementation WeatherAppLandingPageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStoredString
{
    XCTAssertGreaterThanOrEqual(10, [[PGStorageManager storageManager] getLastSearchResults].count);
}

- (void)testNilStorageOfString
{
    XCTAssertEqual(NO, [[PGStorageManager storageManager] addSearchStringToStorage:nil]);
}

- (void)testNormalStorageOfString
{
    XCTAssertEqual(YES, [[PGStorageManager storageManager] addSearchStringToStorage:@"Sing"]);
}

- (void)testGarbageSearch {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [PGAPICaller fetchAutoSuggestionsForText:@"&^%&^%^&*%*%*%*" successCallback:^(NSArray *locationsArray) {
        XCTAssertEqual([locationsArray count], 1);
    } errorCallback:^(NSError *error, NSString *errorMsg) {
        [PGWeatherAppUtils showAlertForMessage:errorMsg];
    }];
}

- (void)testInvalidJSONResponse
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"invalid" ofType:@"json"];
    
    [PGAPICaller fetchAutoSuggestionsForText:@"Sing" successCallback:^(NSArray *locationsArray) {

    } errorCallback:^(NSError *error, NSString *errorMsg) {

        [PGWeatherAppUtils showAlertForMessage:errorMsg];
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
