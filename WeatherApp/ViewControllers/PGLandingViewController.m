//
//  ViewController.m
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGLandingViewController.h"
#import "PGConstants.h"
#import "PGAPICaller.h"

@interface PGLandingViewController ()

@end

@implementation PGLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Search Weather";
    
    [PGAPICaller fetchAutoSuggestionsForText:@"Sing" successCallback:^(NSArray *locationsArray) {
        
    } errorCallback:^(NSError *error, NSString *errorMsg) {
        Show_ErrorMessage(errorMsg);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
