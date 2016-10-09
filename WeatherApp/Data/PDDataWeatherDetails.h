//
//  PDDataWeatherDetails.h
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDDataWeatherDetails : NSObject

@property (nonatomic, strong) NSString *obvTime;
@property (nonatomic, strong) NSString *weatherDesc;
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *humidity;

@end
