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

        context(@"requests", ^{
            it(@"should request data from data service", ^{
                NSArray *mockEarthquakeDataDictionaries = @[testEarthquakeDict];

                id earthquakeDataServiceMock = [IVGEarthquakeDataService nullMock];
                KWCaptureSpy *spy = [earthquakeDataServiceMock captureArgument:@selector(loadData:) atIndex:0];

                [[earthquakeDataServiceMock should] receive:@selector(loadData:)];

                IVGEarthquakeAPI *earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];
                __block NSArray *currentData = nil;
                [earthquakeAPI retrieveCurrentData:^(NSArray *data) {
                    currentData = data;
                } withFilterCriteria:nil];
                
                IVGEDSLoadDataBlock actualLoadedDataBlock = spy.argument;
                actualLoadedDataBlock(mockEarthquakeDataDictionaries);
                
                [currentData shouldNotBeNil];
                [[currentData should] have:[mockEarthquakeDataDictionaries count]];
                for (id item in currentData) {
                    [[item should] beKindOfClass:[IVGEarthquake class]];
                }
            });
        });
        
        context(@"filters", ^{
            __block id earthquakeDataServiceMock;
            __block IVGEarthquakeAPI *earthquakeAPI;
            __block NSArray *exampleData;

            beforeAll(^{
                exampleData =
                @[
                  @{@"Eqid":@"1",@"Lat":@"1.0",@"Lon":@"1.0",@"Magnitude":@"1.0",@"Datetime":@"Friday, March 22, 2013 01:00:00 UTC"},
                  @{@"Eqid":@"2",@"Lat":@"2.0",@"Lon":@"2.0",@"Magnitude":@"2.0",@"Datetime":@"Friday, March 22, 2013 02:00:00 UTC"},
                  @{@"Eqid":@"3",@"Lat":@"3.0",@"Lon":@"3.0",@"Magnitude":@"3.0",@"Datetime":@"Friday, March 22, 2013 03:00:00 UTC"},
                  @{@"Eqid":@"4",@"Lat":@"4.0",@"Lon":@"4.0",@"Magnitude":@"4.0",@"Datetime":@"Friday, March 22, 2013 04:00:00 UTC"},
                  @{@"Eqid":@"5",@"Lat":@"5.0",@"Lon":@"5.0",@"Magnitude":@"5.0",@"Datetime":@"Friday, March 22, 2013 05:00:00 UTC"},
                  @{@"Eqid":@"6",@"Lat":@"6.0",@"Lon":@"6.0",@"Magnitude":@"6.0",@"Datetime":@"Friday, March 22, 2013 06:00:00 UTC"},
                  @{@"Eqid":@"7",@"Lat":@"7.0",@"Lon":@"7.0",@"Magnitude":@"7.0",@"Datetime":@"Friday, March 22, 2013 07:00:00 UTC"},
                  @{@"Eqid":@"8",@"Lat":@"8.0",@"Lon":@"8.0",@"Magnitude":@"8.0",@"Datetime":@"Friday, March 22, 2013 08:00:00 UTC"},
                  @{@"Eqid":@"9",@"Lat":@"9.0",@"Lon":@"9.0",@"Magnitude":@"9.0",@"Datetime":@"Friday, March 22, 2013 09:00:00 UTC"}
                  ];
            });

            beforeEach(^{
                earthquakeDataServiceMock = [IVGEarthquakeDataService nullMock];
                [[earthquakeDataServiceMock should] receive:@selector(loadData:)];
                earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];
            });

            it(@"with no filter, should return all data", ^{
                KWCaptureSpy *spy = [earthquakeDataServiceMock captureArgument:@selector(loadData:) atIndex:0];

                __block NSArray *currentData = nil;
                [earthquakeAPI retrieveCurrentData:^(NSArray *data) {
                    currentData = data;
                } withFilterCriteria:nil];

                IVGEDSLoadDataBlock loadBlock = spy.argument;
                loadBlock(exampleData);

                [currentData shouldNotBeNil];
                [[currentData should] have:[exampleData count]];
                NSMutableSet *earthquakeIds = [NSMutableSet setWithCapacity:[exampleData count]];
                for (id item in currentData) {
                    [[item should] beKindOfClass:[IVGEarthquake class]];
                    [earthquakeIds addObject:@([item earthquakeId])];
                }
                [[earthquakeIds should] containObjectsInArray:@[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9)]];
            });
        });
    });
    
});

SPEC_END
