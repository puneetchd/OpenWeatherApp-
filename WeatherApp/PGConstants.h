//
//  PGConstants.h
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#ifndef PGConstants_h
#define PGConstants_h

#define kWeatherAPIkey             @"9b92138967754e629ea121816160910"

#define Show_ErrorMessage(Message) UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Message message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];[alert show];
#define kNOInternetMessage         @"No Internet Connection."

#define kWeatherAPIBaseURL         @"http://api.worldweatheronline.com/premium/v1/"
#define kSearchAPI                 @"search.ashx"
#define kWeatherAPI                @"weather.ashx"

#define kIconURL            @"IconURL"
#define kObvTime            @"ObsvTime"
#define kWeatherDescription @"WeatherDesc"
#define kHumidity           @"Humidity"

#endif /* PGConstants_h */
