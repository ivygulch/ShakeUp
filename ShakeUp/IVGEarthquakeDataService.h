//
//  IVGEarthquakeDataService.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/27/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^IVGEDSLoadDataBlock)(NSArray *data);

@interface IVGEarthquakeDataService : NSObject

- (id) initWithHTTPClient:(AFHTTPClient *) httpClient;

/// @return array of dictionaries created from loading CSV data from USGS web service
- (void) loadData:(IVGEDSLoadDataBlock) loadDataBlock;

@end
