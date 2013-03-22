//
//  IVGEarthquakeAPI.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVGEarthquakeDataService.h"
#import "IVGFilterCriteria.h"

typedef void(^IVGAPIRetrieveDataBlock)(NSArray *data);

@interface IVGEarthquakeAPI : NSObject

- (id) initWithDataService:(IVGEarthquakeDataService *) earthquakeDataService;

- (void) retrieveCurrentData:(IVGAPIRetrieveDataBlock) retrieveDataBlock withFilterCriteria:(IVGFilterCriteria *) filterCriteria;

@end
