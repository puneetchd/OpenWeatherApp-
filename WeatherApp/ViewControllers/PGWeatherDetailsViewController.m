//
//  PGWeatherDetailsViewController.m
//  WeatherApp
//
//  Created by Puneet Sharma on 10/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGWeatherDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGWeatherAppUtils.h"
#import "PGAPICaller.h"
#import "PGConstants.h"

@interface PGWeatherDetailsViewController ()
{
    UIActivityIndicatorView *activityIndicator;
    UIRefreshControl *refresh;
    NSDictionary *weatherDetailsDict;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PGWeatherDetailsViewController

@synthesize locationString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 40, 40, 40)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addProgressIndicator];
    
    refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(fetchWeatherDetails) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refresh];
    
    [self fetchWeatherDetails];
}

#pragma mark - Fetch Details of Weather

- (void)fetchWeatherDetails
{
    if (locationString.length > 0) {
        [activityIndicator startAnimating];
        [PGAPICaller fetchWeatherDetailForLocation:locationString successCallback:^(NSDictionary *detailsDict) {
            [activityIndicator stopAnimating];
            if (detailsDict) {
                [refresh endRefreshing];
                weatherDetailsDict = detailsDict;
                [_tableView reloadData];
            }
        } errorCallback:^(NSError *error, NSString *errorMsg) {
            [activityIndicator stopAnimating];
            [PGWeatherAppUtils showAlertForMessage:errorMsg];
        }];
    }
}

#pragma mark - UITableViewCellDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifer];
    }
    
    if (weatherDetailsDict) {
        UIImageView *_iconImageView = [cell viewWithTag:1111];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[weatherDetailsDict objectForKey:kIconURL]] placeholderImage:nil];
        
        UILabel *_lblWeatherDescription = [cell viewWithTag:2222];
        _lblWeatherDescription.text = [weatherDetailsDict objectForKey:kWeatherDescription];
        
        UILabel *_lblHumidity = [cell viewWithTag:3333];
        _lblHumidity.text = [NSString stringWithFormat:@"Humidity : %@%%",[weatherDetailsDict objectForKey:kHumidity]];
        
        UILabel *_lblObvTime = [cell viewWithTag:4444];
        _lblObvTime.text = [weatherDetailsDict objectForKey:kObvTime];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)addProgressIndicator
{
    UIBarButtonItem *progress_indicator = [[UIBarButtonItem alloc]
                                           initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = progress_indicator;
    
    [activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
