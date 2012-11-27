//
//  IVGEarthquakeAPISpecs.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "IVGEarthquakeAPI.h"
#import "IVGEarthquakeDataService.h"
#import "IVGEarthquake.h"

@interface IVGEarthquakeAPI()
- (NSDictionary *) columnPositionsFromHeaderRow:(NSArray *) headerRow;
@end

SPEC_BEGIN(IVGEarthquakeAPISpecs)

describe(@"earthquakeAPI", ^{
    __block IVGEarthquakeAPI *earthquakeAPI;
    __block id earthquakeDataServiceMock = [IVGEarthquakeDataService mock];

    beforeEach(^{
        earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];
    });

/*
 Sample data from USGS site, http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt
 
 Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region
 ci,11209834,0,"Tuesday, November 27, 2012 20:05:54 UTC",32.8848,-115.5358,1.6,8.80,21,"Southern California"
 ci,11209826,0,"Tuesday, November 27, 2012 19:47:58 UTC",,,1.3,26.30,11,"Greater Los Angeles area, California"
 ak,10607472,1,"Tuesday, November 27, 2012 19:34:03 UTC",61.1337,-151.3224,1.8,86.60,10,"Southern Alaska"
 nc,71894851,1,"Tuesday, November 27, 2012 19:02:28 UTC",36.5857,-121.2245,2.0,9.60,25,"Central California"
 ...

 */

    it(@"should retrieve data from server", ^{
        NSArray *mockEarthquakeDataDictionaries = @[
        @{@"Src":@"ci",@"Eqid":@11209834,@"Version":@0,@"Datetime":@"Tuesday, November 27, 2012 20:05:54 UTC",
        @"Lat":@32.8848,@"Lon":@-115.5358,@"Magnitude":@1.6,@"Depth":@8.80,@"NST":@21,@"Region":@"Southern California"},
        @{@"Src":@"ci",@"Eqid":@11209826,@"Version":@0,@"Datetime":@"Tuesday, November 27, 2012 19:47:58 UTC",
        @"Lat":@34.0323,@"Lon":@-118.3822,@"Magnitude":@1.3,@"Depth":@26.30,@"NST":@11,@"Region":@"Greater Los Angeles area, California"},
        ];
        [[earthquakeDataServiceMock should] receive:@selector(loadData) andReturn:mockEarthquakeDataDictionaries];

        NSArray *currentData = [earthquakeAPI retrieveCurrentData];
        [currentData shouldNotBeNil];
        [[currentData should] have:[mockEarthquakeDataDictionaries count]];
        for (id item in currentData) {
            [[item should] beKindOfClass:[IVGEarthquake class]];
        }
    });

});

SPEC_END
