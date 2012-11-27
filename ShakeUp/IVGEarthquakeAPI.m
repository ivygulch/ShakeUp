//
//  IVGEarthquakeAPI.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGEarthquakeAPI.h"
#import "IVGEarthquake.h"

@interface IVGEarthquakeAPI()
@property (nonatomic,strong) IVGEarthquakeDataService *earthquakeDataService;
@end

@implementation IVGEarthquakeAPI

- (id) initWithDataService:(IVGEarthquakeDataService *) earthquakeDataService;
{
    if ((self = [super init])) {
        _earthquakeDataService = earthquakeDataService;
    }
    return self;
}

- (NSArray *) retrieveCurrentData;
{
    return [NSArray arrayWithObject:[[IVGEarthquake alloc] init]];
}

@end
