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
    @"Eqid":@(testEarthquakeId),
    @"Version":@(testVersion),
    @"Datetime":testDatetimeStr,
    @"Lat":@(testLatitude),
    @"Lon":@(testLongitude),
    @"Magnitude":@(testMagnitude),
    @"Depth":@(testDepth),
    @"NST":@(testNST),
    @"Region":testRegion
    };

    context(@"private", ^{
        __block IVGEarthquakeAPI *earthquakeAPI;
        beforeEach(^{
            // private methods do not need the service
            earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:nil];
        });
        
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

    context(@"earthquakeAPI", ^{

        it(@"should request data from data service", ^{
            NSArray *mockEarthquakeDataDictionaries = @[testEarthquakeDict];

            id earthquakeDataServiceMock = [IVGEarthquakeDataService nullMock];
            KWCaptureSpy *spy = [earthquakeDataServiceMock captureArgument:@selector(loadData:) atIndex:0];

            [[earthquakeDataServiceMock should] receive:@selector(loadData:)];

            IVGEarthquakeAPI *earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];
            __block NSArray *currentData = nil;
            [earthquakeAPI retrieveCurrentData:^(NSArray *data) {
                currentData = data;
            }];

            IVGEDSLoadDataBlock actualLoadedDataBlock = spy.argument;
            actualLoadedDataBlock(mockEarthquakeDataDictionaries);

            [currentData shouldNotBeNil];
            [[currentData should] have:[mockEarthquakeDataDictionaries count]];
            for (id item in currentData) {
                [[item should] beKindOfClass:[IVGEarthquake class]];
            }
        });
        
    });
    
});

SPEC_END
