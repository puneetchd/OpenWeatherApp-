//
//  PGDetailsPageTests.m
//  WeatherApp
//
//  Created by Puneet Sharma on 17/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGWeatherDetailsViewController.h"
#import "PGAPICaller.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface PGDetailsPageTests : XCTestCase

@end

@implementation PGDetailsPageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDetailsLoading {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"http://api.worldweatheronline.com/premium/v1/"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:[[NSBundle mainBundle] pathForResource:@"invalid" ofType:@"json"] statusCode:200 headers:nil];
    }];
    
    PGWeatherDetailsViewController *detailsVC = [[PGWeatherDetailsViewController alloc]init];
    detailsVC.locationString = nil;
    
    [PGAPICaller fetchWeatherDetailForLocation:@"" successCallback:^(NSDictionary *detailsDict) {
        XCTAssertNotNil(detailsDict, @"Valid value is expected");
    } errorCallback:^(NSError *error, NSString *errorMsg) {
        XCTAssertNotNil(nil, @"Valid value is expected");
    }];
}

@end
