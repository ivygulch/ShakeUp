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
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@end

@implementation IVGEarthquakeAPI

- (id) initWithDataService:(IVGEarthquakeDataService *) earthquakeDataService;
{
    if ((self = [super init])) {
        _earthquakeDataService = earthquakeDataService;
        _dateFormatter = [[NSDateFormatter alloc] init];
        // parse "Tuesday, November 27, 2012 15:40:56 UTC"
        _dateFormatter.dateFormat = @"ddd, MMM dd, yyyy HH:mm:ss Z";
    }
    return self;
}

- (IVGEarthquake *) createEarthquakeWithDictionary:(NSDictionary *) dict;
{
    IVGEarthquake *earthquake = [[IVGEarthquake alloc] init];
    earthquake.earthquakeId = [[dict objectForKey:@"Eqid"] longValue];
    earthquake.version = [[dict objectForKey:@"Version"] integerValue];
    earthquake.source = [dict objectForKey:@"Src"];
    earthquake.datetime = [self.dateFormatter dateFromString:[dict objectForKey:@"Datetime"]];
    earthquake.latitude = [[dict objectForKey:@"Lat"] doubleValue];
    earthquake.longitude = [[dict objectForKey:@"Lon"] doubleValue];
    earthquake.magnitude = [[dict objectForKey:@"Magnitude"] doubleValue];
    earthquake.depth = [[dict objectForKey:@"Depth"] doubleValue];
    earthquake.nst = [[dict objectForKey:@"NST"] integerValue];
    earthquake.region = [dict objectForKey:@"Region"];

    return earthquake;
}

- (NSArray *) retrieveCurrentData;
{
    NSArray *dictionaryEntries = [self.earthquakeDataService loadData];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[dictionaryEntries count]];
    for (NSDictionary *dict in dictionaryEntries) {
        IVGEarthquake *earthquake = [self createEarthquakeWithDictionary:dict];
        [result addObject:earthquake];
    }
    return result;
}

@end
