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
#import "IVGFilterCriteria.h"

@interface IVGEarthquakeAPI()
- (NSDate *) parseDatetimeString:(NSString *) value;
- (IVGEarthquake *) createEarthquakeFromDictionary:(NSDictionary *) dict;
@end

NSSet *extractEarthquakeIds(NSArray *earthquakeRecords) {
    NSMutableSet *earthquakeIds = [NSMutableSet setWithCapacity:[earthquakeRecords count]];
    for (id item in earthquakeRecords) {
        [earthquakeIds addObject:@([item earthquakeId])];
    }
    return [NSSet setWithSet:earthquakeIds];
}

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
                } withFilterCriteria:nil error:nil];

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
                  @{@"Eqid":@"1",@"Lat":@"11.0",@"Lon":@"21.0",@"Magnitude":@"31.0",@"Datetime":@"Friday, March 22, 2013 01:00:00 UTC"},
                  @{@"Eqid":@"2",@"Lat":@"12.0",@"Lon":@"22.0",@"Magnitude":@"32.0",@"Datetime":@"Friday, March 22, 2013 02:00:00 UTC"},
                  @{@"Eqid":@"3",@"Lat":@"13.0",@"Lon":@"23.0",@"Magnitude":@"33.0",@"Datetime":@"Friday, March 22, 2013 03:00:00 UTC"},
                  @{@"Eqid":@"4",@"Lat":@"14.0",@"Lon":@"24.0",@"Magnitude":@"34.0",@"Datetime":@"Friday, March 22, 2013 04:00:00 UTC"},
                  @{@"Eqid":@"5",@"Lat":@"15.0",@"Lon":@"25.0",@"Magnitude":@"35.0",@"Datetime":@"Friday, March 22, 2013 05:00:00 UTC"},
                  @{@"Eqid":@"6",@"Lat":@"16.0",@"Lon":@"26.0",@"Magnitude":@"36.0",@"Datetime":@"Friday, March 22, 2013 06:00:00 UTC"},
                  @{@"Eqid":@"7",@"Lat":@"17.0",@"Lon":@"27.0",@"Magnitude":@"37.0",@"Datetime":@"Friday, March 22, 2013 07:00:00 UTC"},
                  @{@"Eqid":@"8",@"Lat":@"18.0",@"Lon":@"28.0",@"Magnitude":@"38.0",@"Datetime":@"Friday, March 22, 2013 08:00:00 UTC"},
                  @{@"Eqid":@"9",@"Lat":@"19.0",@"Lon":@"29.0",@"Magnitude":@"39.0",@"Datetime":@"Friday, March 22, 2013 09:00:00 UTC"}
                  ];
            });

            beforeEach(^{
                earthquakeDataServiceMock = [IVGEarthquakeDataService nullMock];
                earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];
            });

            it(@"with no filter, should return all data", ^{
                [[earthquakeDataServiceMock should] receive:@selector(loadData:)];

                KWCaptureSpy *spy = [earthquakeDataServiceMock captureArgument:@selector(loadData:) atIndex:0];

                __block NSArray *currentData = nil;
                BOOL valid = [earthquakeAPI
                              retrieveCurrentData:^(NSArray *data) {
                                  currentData = data;
                              }
                              withFilterCriteria:nil
                              error:nil];
                [[@(valid) should] equal:@(YES)];

                IVGEDSLoadDataBlock loadBlock = spy.argument;
                loadBlock(exampleData);

                [currentData shouldNotBeNil];
                [[currentData should] have:[exampleData count]];
                for (id item in currentData) {
                    [[item should] beKindOfClass:[IVGEarthquake class]];
                }

                NSSet *earthquakeIds = extractEarthquakeIds(currentData);
                [[earthquakeIds should] containObjectsInArray:@[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9)]];
            });

            it(@"with invalid filter, should fail", ^{
                [[earthquakeDataServiceMock shouldNot] receive:@selector(loadData:)];

                IVGFilterCriteria *filterCriteria = [[IVGFilterCriteria alloc] init];
                [[@([filterCriteria validateCriteriaError:nil]) should] equal:@(NO)];

                NSError *error;
                BOOL valid = [earthquakeAPI
                              retrieveCurrentData:^(NSArray *data) {
                              }
                              withFilterCriteria:filterCriteria
                              error:&error];
                [[@(valid) should] equal:@(NO)];
                [error shouldNotBeNil];
            });

            it(@"with lat/lon filter, should return proper subset", ^{
                [[earthquakeDataServiceMock should] receive:@selector(loadData:)];

                KWCaptureSpy *spy = [earthquakeDataServiceMock captureArgument:@selector(loadData:) atIndex:0];

                IVGFilterCriteria *filterCriteria = [[IVGFilterCriteria alloc] init];
                filterCriteria.minimumLatitude = @(15.0);
                filterCriteria.maximumLatitude = @(18.0);
                filterCriteria.minimumLongitude = @(27.0);
                filterCriteria.maximumLongitude = @(29.0);

                __block NSArray *currentData = nil;

                BOOL valid = [earthquakeAPI
                              retrieveCurrentData:^(NSArray *data) {
                                  currentData = data;
                              }
                              withFilterCriteria:filterCriteria
                              error:nil];
                [[@(valid) should] equal:@(YES)];

                IVGEDSLoadDataBlock loadBlock = spy.argument;
                loadBlock(exampleData);

                NSArray *expectedIds = @[@(7),@(8)];
                [[currentData should] haveCountOf:[expectedIds count]];

                NSSet *earthquakeIds = extractEarthquakeIds(currentData);
                [[earthquakeIds should] containObjectsInArray:expectedIds];
            });

            it(@"with full lat/lon filter, should return all items", ^{
                [[earthquakeDataServiceMock should] receive:@selector(loadData:)];

                KWCaptureSpy *spy = [earthquakeDataServiceMock captureArgument:@selector(loadData:) atIndex:0];

                IVGFilterCriteria *filterCriteria = [[IVGFilterCriteria alloc] init];
                filterCriteria.minimumLatitude = @(-90.0);
                filterCriteria.maximumLatitude = @(90.0);
                filterCriteria.minimumLongitude = @(-180.0);
                filterCriteria.maximumLongitude = @(180.0);

                __block NSArray *currentData = nil;

                BOOL valid = [earthquakeAPI
                              retrieveCurrentData:^(NSArray *data) {
                                  currentData = data;
                              }
                              withFilterCriteria:filterCriteria
                              error:nil];
                [[@(valid) should] equal:@(YES)];

                IVGEDSLoadDataBlock loadBlock = spy.argument;
                loadBlock(exampleData);

                NSArray *expectedIds = @[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9)];
                [[currentData should] haveCountOf:[expectedIds count]];

                NSSet *earthquakeIds = extractEarthquakeIds(currentData);
                [[earthquakeIds should] containObjectsInArray:expectedIds];
            });

            it(@"with magnitude filter, should return proper subset", ^{
                [[earthquakeDataServiceMock should] receive:@selector(loadData:)];

                KWCaptureSpy *spy = [earthquakeDataServiceMock captureArgument:@selector(loadData:) atIndex:0];

                IVGFilterCriteria *filterCriteria = [[IVGFilterCriteria alloc] init];
                filterCriteria.minimumLatitude = @(-90.0);
                filterCriteria.maximumLatitude = @(90.0);
                filterCriteria.minimumLongitude = @(-180.0);
                filterCriteria.maximumLongitude = @(180.0);
                filterCriteria.minimumMagnitude = @(22.0);
                filterCriteria.maximumMagnitude = @(25.0);

                __block NSArray *currentData = nil;

                BOOL valid = [earthquakeAPI
                              retrieveCurrentData:^(NSArray *data) {
                                  currentData = data;
                              }
                              withFilterCriteria:filterCriteria
                              error:nil];
                [[@(valid) should] equal:@(YES)];

                IVGEDSLoadDataBlock loadBlock = spy.argument;
                loadBlock(exampleData);

                NSArray *expectedIds = @[@(2),@(3),@(4),@(5)];
                [[currentData should] haveCountOf:[expectedIds count]];

                NSSet *earthquakeIds = extractEarthquakeIds(currentData);
                [[earthquakeIds should] containObjectsInArray:expectedIds];
            });
        });
    });
    
});

SPEC_END
