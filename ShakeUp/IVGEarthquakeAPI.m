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
        // Tuesday, November 27, 2012 20:05:54 UTC
        _dateFormatter.dateFormat = @"EEEE, MMMM dd, yyyy HH:mm:ss z";
    }
    return self;
}

- (NSDate *) parseDatetimeString:(NSString *) value;
{
    return [self.dateFormatter dateFromString:value];
}

- (IVGEarthquake *) createEarthquakeFromDictionary:(NSDictionary *) dict;
{
    IVGEarthquake *earthquake = [[IVGEarthquake alloc] init];
    //Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region
    earthquake.source = [dict objectForKey:@"Src"];
    earthquake.earthquakeId = [[dict objectForKey:@"Eqid"] longValue];
    earthquake.version = [[dict objectForKey:@"Version"] integerValue];
    earthquake.datetime = [self parseDatetimeString:[dict objectForKey:@"Datetime"]];
    earthquake.latitude = [[dict objectForKey:@"Lat"] doubleValue];
    earthquake.longitude = [[dict objectForKey:@"Lon"] doubleValue];
    earthquake.magnitude = [[dict objectForKey:@"Magnitude"] doubleValue];
    earthquake.depth = [[dict objectForKey:@"Depth"] doubleValue];
    earthquake.nst = [[dict objectForKey:@"NST"] integerValue];
    earthquake.region = [dict objectForKey:@"Region"];
    return earthquake;
}

- (void) retrieveCurrentData:(IVGAPIRetrieveDataBlock) retrieveDataBlock;
{
    [self.earthquakeDataService loadData:^(NSArray *dictItems) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[dictItems count]];
        for (NSDictionary *dict in dictItems) {
            [result addObject:[self createEarthquakeFromDictionary:dict]];
        }
        retrieveDataBlock(result);
    }];
}

@end
