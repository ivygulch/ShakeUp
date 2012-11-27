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
    NSArray *dictionaryEntries = [self.earthquakeDataService loadData];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[dictionaryEntries count]];
    for (NSDictionary *dict in dictionaryEntries) {
        IVGEarthquake *earthquake = [[IVGEarthquake alloc] init];
        [result addObject:earthquake];
    }
    return result;
}

@end
