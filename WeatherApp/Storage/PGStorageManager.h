//
//  PGStorageManager.h
//  WeatherApp
//
//  Created by Puneet Sharma on 10/10/16.
//  Copyright © 2016 Puneet Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGStorageManager : NSObject

+ (PGStorageManager *)storageManager;
- (NSArray*)getLastSearchResults;
- (NSString *)dataFilePath;
- (BOOL)addSearchStringToStorage:(NSString*)searchString;
- (NSArray*)filteredArray:(NSArray*)inputArray forSearchString:(NSString*)searchString;

@end
