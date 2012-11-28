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
- (NSDate *) parseDatetimeString:(NSString *) value;
- (IVGEarthquake *) createEarthquakeFromDictionary:(NSDictionary *) dict;
@end

SPEC_BEGIN(IVGEarthquakeAPISpecs)

describe(@"earthquakeAPI", ^{
    __block IVGEarthquakeAPI *earthquakeAPI;
    __block id earthquakeDataServiceMock = [IVGEarthquakeDataService mock];

    __block NSString *testDatetimeStr = @"Tuesday, November 27, 2012 20:05:54 UTC";
    NSDateComponents *testDC = [[NSDateComponents alloc] init];
    testDC.month = 11;
    testDC.day = 27;
    testDC.year = 2012;
    testDC.hour = 20;
    testDC.minute = 5;
    testDC.second = 54;
    testDC.timeZone = [[NSTimeZone alloc] initWithName:@"UTC"];

    __block NSString *testSource = @"testSrc";
    __block NSInteger testEarthquakeId = 12345;
    __block NSInteger testVersion = 1;
    __block NSDate *testDatetime = [[NSCalendar currentCalendar] dateFromComponents:testDC];
    __block double testLatitude = 91.2;
    __block double testLongitude = -123.45;
    __block double testMagnitude = 1.23;
    __block double testDepth = 45.67;
    __block NSInteger testNST = 21;
    __block NSString *testRegion = @"Region";

    __block NSDictionary *testEarthquakeDict = @{
    @"Src":testSource,
    @"Eqid":[NSNumber numberWithInteger:testEarthquakeId],
    @"Version":[NSNumber numberWithInteger:testVersion],
    @"Datetime":testDatetimeStr,
    @"Lat":[NSNumber numberWithDouble:testLatitude],
    @"Lon":[NSNumber numberWithDouble:testLongitude],
    @"Magnitude":[NSNumber numberWithDouble:testMagnitude],
    @"Depth":[NSNumber numberWithDouble:testDepth],
    @"NST":[NSNumber numberWithInteger:testNST],
    @"Region":testRegion
    };

    beforeEach(^{
        earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];
    });

    context(@"private", ^{

        it(@"should parse datetime", ^{
            NSDate *datetime = [earthquakeAPI parseDatetimeString:testDatetimeStr];
            [datetime shouldNotBeNil];
            [[datetime should] equal:testDatetime];
        });

        it(@"should create earthquake from dict", ^{
            IVGEarthquake *earthquake = [earthquakeAPI createEarthquakeFromDictionary:testEarthquakeDict];
            [earthquake shouldNotBeNil];
            [[earthquake.source should] equal:testSource];
            [[theValue(earthquake.earthquakeId) should] equal:theValue(testEarthquakeId)];
            [[theValue(earthquake.version) should] equal:theValue(testVersion)];
            [[earthquake.datetime should] equal:testDatetime];
            [[theValue(earthquake.latitude) should] equal:theValue(testLatitude)];
            [[theValue(earthquake.longitude) should] equal:theValue(testLongitude)];
            [[theValue(earthquake.magnitude) should] equal:theValue(testMagnitude)];
            [[theValue(earthquake.depth) should] equal:theValue(testDepth)];
            [[theValue(earthquake.nst) should] equal:theValue(testNST)];
            [[earthquake.region should] equal:testRegion];
        });

    });

    context(@"public", ^{

        it(@"should retrieve data from server", ^{
            NSDictionary *mockDict = @{@"Src":@"source",@"Eqid":@1234};
            NSArray *mockEarthquakeDataDictionaries = [NSArray arrayWithObject:mockDict];
            [[earthquakeDataServiceMock should] receive:@selector(loadData)
                                              andReturn:mockEarthquakeDataDictionaries];

            NSArray *currentData = [earthquakeAPI retrieveCurrentData];
            [currentData shouldNotBeNil];
            [[currentData should] haveCountOfAtLeast:1];
            for (id item in currentData) {
                [[item should] beKindOfClass:[IVGEarthquake class]];
            }
        });
        
    });
    
});

SPEC_END
