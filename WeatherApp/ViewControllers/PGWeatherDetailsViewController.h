//
//  PGWeatherDetailsViewController.h
//  WeatherApp
//
//  Created by Puneet Sharma on 10/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGWeatherDetailsViewController : UIViewController

@property (nonatomic, strong) NSString *locationString;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)fetchWeatherDetails;

@end
