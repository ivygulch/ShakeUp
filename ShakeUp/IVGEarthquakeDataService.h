//
//  IVGEarthquakeDataService.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/27/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGEarthquakeDataService : NSObject

/// @return array of dictionaries created from loading CSV data from USGS web service
- (NSArray *) loadData;

@end
