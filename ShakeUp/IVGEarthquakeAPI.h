//
//  IVGEarthquakeAPI.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGEarthquakeDataService.h"

@interface IVGEarthquakeAPI : NSObject

- (id) initWithDataService:(IVGEarthquakeDataService *) earthquakeDataService;

- (NSArray *) retrieveCurrentData;

@end
