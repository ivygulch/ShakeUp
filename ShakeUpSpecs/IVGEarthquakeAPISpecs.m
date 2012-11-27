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
- (IVGEarthquake *) createEarthquakeWithDictionary:(NSDictionary *) dict;
@end

SPEC_BEGIN(IVGEarthquakeAPISpecs)

describe(@"earthquakeAPI", ^{
    __block IVGEarthquakeAPI *earthquakeAPI;
    __block id earthquakeDataServiceMock = [IVGEarthquakeDataService mock];

    __block NSDictionary *mockEarthquakeDict1;
    __block NSDictionary *mockEarthquakeDict2;

    __block NSInteger mockEq1EarthquakeId = 11209834;
    __block NSInteger mockEq1Version = 0;
    __block NSString *mockEq1Source = @"ci";
    __block NSString *mockEq1DatetimeStr = @"Tuesday, November 27, 2012 20:05:54 UTC";

    NSDateComponents *mockEq1DatetimeComponents = [[NSDateComponents alloc] init];
    mockEq1DatetimeComponents.year = 2012;
    mockEq1DatetimeComponents.month = 11;
    mockEq1DatetimeComponents.day = 27;
    mockEq1DatetimeComponents.hour = 20;
    mockEq1DatetimeComponents.minute = 05;
    mockEq1DatetimeComponents.second = 54;
    mockEq1DatetimeComponents.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    __block NSDate *mockEq1Datetime = [mockEq1DatetimeComponents date];
    __block double mockEq1Latitude = 32.8848;
    __block double mockEq1Longitude = -115.5358;
    __block double mockEq1Magnitude = 1.6;
    __block double mockEq1Depth = 8.80;
    __block NSInteger mockEq1NST = 21;
    __block NSString *mockEq1Region = @"Southern California";


    beforeEach(^{
        earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];

        mockEarthquakeDict1 =
        @{@"Src":mockEq1Source,
        @"Eqid":[NSNumber numberWithInteger:mockEq1EarthquakeId],
        @"Version":[NSNumber numberWithInteger:mockEq1Version],
        @"Datetime":mockEq1DatetimeStr,
        @"Lat":[NSNumber numberWithDouble:mockEq1Latitude],
        @"Lon":[NSNumber numberWithDouble:mockEq1Longitude],
        @"Magnitude":[NSNumber numberWithDouble:mockEq1Magnitude],
        @"Depth":[NSNumber numberWithDouble:mockEq1Depth],
        @"NST":[NSNumber numberWithInteger:mockEq1NST],
        @"Region":mockEq1Region};

        mockEarthquakeDict2 =
        @{@"Src":@"ci",@"Eqid":@11209826,@"Version":@0,@"Datetime":@"Tuesday, November 27, 2012 19:47:58 UTC",
        @"Lat":@34.0323,@"Lon":@-118.3822,@"Magnitude":@1.3,@"Depth":@26.30,@"NST":@11,@"Region":@"Greater Los Angeles area, California"};

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

    context(@"private", ^{

        it(@"should create valid earthquake object from dictionary", ^{
            IVGEarthquake *earthquake1 = [earthquakeAPI createEarthquakeWithDictionary:mockEarthquakeDict1];

            [earthquake1 shouldNotBeNil];
            [[theValue(earthquake1.earthquakeId) should] equal:theValue(mockEq1EarthquakeId)];
            [[theValue(earthquake1.version) should] equal:theValue(mockEq1Version)];
            [[theValue(earthquake1.latitude) should] equal:theValue(mockEq1Latitude)];
            [[theValue(earthquake1.longitude) should] equal:theValue(mockEq1Longitude)];
            [[theValue(earthquake1.magnitude) should] equal:theValue(mockEq1Magnitude)];
            [[theValue(earthquake1.depth) should] equal:theValue(mockEq1Depth)];
            [[theValue(earthquake1.nst) should] equal:theValue(mockEq1NST)];
            [[earthquake1.datetime should] equal:mockEq1Datetime];
            [[earthquake1.source should] equal:mockEq1Source];
            [[earthquake1.region should] equal:mockEq1Region];
        });
    });


    context(@"public", ^{
        it(@"should retrieve data from server", ^{
            NSArray *mockEarthquakeDataDictionaries = @[mockEarthquakeDict1, mockEarthquakeDict2];
            [[earthquakeDataServiceMock should] receive:@selector(loadData) andReturn:mockEarthquakeDataDictionaries];

            NSArray *currentData = [earthquakeAPI retrieveCurrentData];
            [currentData shouldNotBeNil];
            [[currentData should] have:[mockEarthquakeDataDictionaries count]];
            for (id item in currentData) {
                [[item should] beKindOfClass:[IVGEarthquake class]];
            }
        });
    });
    
});

SPEC_END
