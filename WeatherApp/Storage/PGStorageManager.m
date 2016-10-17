//
//  PGStorageManager.m
//  WeatherApp
//
//  Created by Puneet Sharma on 10/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import "PGStorageManager.h"
#import "PGDataLocation.h"
#import <NSArray+Collection.h>

#define kStoredSearchQueries                            @"StoredSearches"

@implementation PGStorageManager

static NSString* filePath = nil;

+ (PGStorageManager *)storageManager
{
    static PGStorageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PGStorageManager alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"PGSearchList"];
    });
    return sharedInstance;
}

- (NSString *)dataFilePath {
    return filePath;
}

- (NSArray*)getLastSearchResults
{
    /*if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
        return array;
    }*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *rawArray = [defaults objectForKey:kStoredSearchQueries];
    NSMutableArray *resultsArray = [[NSMutableArray alloc]init];
    for (id dataObj in rawArray) {
        [resultsArray insertObject:[NSKeyedUnarchiver unarchiveObjectWithData:dataObj] atIndex:0];
    }
    
    if (resultsArray.count > 10) {
        resultsArray = [[NSMutableArray alloc]initWithArray:[resultsArray subarrayWithRange:NSMakeRange(0, 10)]];
    }
    else
    {
        resultsArray = resultsArray;
    }
    
    return resultsArray;
}

- (BOOL)addSearchStringToStorage:(NSString*)searchString
{
    if (searchString.length == 0) {
        return NO;
    }
    NSArray* matchesArray = [[self getLastSearchResults] filter:^BOOL(PGDataLocation *locationData) {
        return [[[locationData.areaName.firstObject objectForKey:@"value"] uppercaseString] isEqualToString:[searchString uppercaseString]];
    }];

    if (matchesArray.count == 0) {
        PGDataLocation *dataLocation = [[PGDataLocation alloc]init];
        dataLocation.areaName = @[@{@"value":searchString}];
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataLocation];
        
        NSMutableArray *storedSearches = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kStoredSearchQueries]];
        [storedSearches addObject:encodedObject];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:storedSearches forKey:kStoredSearchQueries];
        [defaults synchronize];
    }

    return YES;
    
    /*BOOL writeStatus = FALSE;
    
    NSMutableArray *plistArray = [[NSMutableArray alloc]initWithArray:[self getLastSearchResults]];
    
    if (![plistArray containsObject:searchString]) {
        [plistArray addObject:searchString];
    }
    
    writeStatus = [plistArray writeToFile:[self dataFilePath] atomically:YES];
    
    return writeStatus;*/
}

- (NSArray*)filteredArray:(NSArray*)inputArray forSearchString:(NSString*)searchString
{
    NSArray* matchesArray = [inputArray filter:^BOOL(PGDataLocation *locationData) {
        return [[[locationData.areaName.firstObject objectForKey:@"value"] uppercaseString] isEqualToString:[searchString uppercaseString]];
    }];
    
    return matchesArray;
}

@end
