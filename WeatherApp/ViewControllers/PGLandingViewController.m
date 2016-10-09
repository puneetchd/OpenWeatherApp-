//
//  ViewController.m
//  WeatherApp
//
//  Created by Puneet Sharma on 09/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGLandingViewController.h"
#import "PGWeatherDetailsViewController.h"
#import "PGConstants.h"
#import "PGAPICaller.h"
#import "PGDataLocation.h"

@interface PGLandingViewController ()<UISearchBarDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    
    NSArray *locSuggestionsArray;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *locTableView;

@end

@implementation PGLandingViewController

#pragma mark - UIViewController Life Cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Search Weather";
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 40, 40, 40)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addProgressIndicator];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length >= 4) {
        [activityIndicator startAnimating];
        [[PGAPICaller sharedSessionManager].operationQueue cancelAllOperations];
        [PGAPICaller fetchAutoSuggestionsForText:searchText successCallback:^(NSArray *locationsArray) {
            [activityIndicator stopAnimating];
            locSuggestionsArray = nil;
            locSuggestionsArray = locationsArray;
            [_locTableView reloadData];
        } errorCallback:^(NSError *error, NSString *errorMsg) {
            [activityIndicator stopAnimating];
            Show_ErrorMessage(errorMsg);
        }];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UITableViewCellDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locSuggestionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifer = @"CellIdentifier";
    UITableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifer];
    }
    
    PGDataLocation *dataLocation = [locSuggestionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[dataLocation.areaName firstObject] objectForKey:@"value"]];
    cell.detailTextLabel.text = [[dataLocation.country firstObject] objectForKey:@"value"];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGDataLocation *dataLocation = [locSuggestionsArray objectAtIndex:indexPath.row];
    PGWeatherDetailsViewController *weatherDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherDetailsIdentifier"];
    NSString *locationName = [[dataLocation.areaName firstObject] objectForKey:@"value"];
    weatherDetailsVC.title = locationName;
    weatherDetailsVC.locationString = locationName;
    [self.navigationController pushViewController:weatherDetailsVC animated:YES];
}

#pragma mark - Misc Functions

- (void)addProgressIndicator
{
    UIBarButtonItem *progress_indicator = [[UIBarButtonItem alloc]
                                           initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = progress_indicator;
    
    [activityIndicator stopAnimating];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
