//
//  IVGEarthquakeDataServiceSpecs.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "AFNetworking.h"
#import "IVGEarthquakeDataService.h"
#import "IVGUSGSAPIConstants.h"
#import "IVGEarthquake.h"

@interface IVGEarthquakeDataService()
- (AFNetworkingSuccessBlock) buildSuccessBlockWithLoadDataBlock:(IVGEDSLoadDataBlock) loadDataBlock;
@end;

SPEC_BEGIN(IVGEarthquakeDataServiceSpecs)

describe(@"earthquakeDataService", ^{
    __block id httpClientMock = [AFHTTPClient nullMock];
    __block IVGEarthquakeDataService *earthquakeDataService;

    beforeEach(^{
        earthquakeDataService = [[IVGEarthquakeDataService alloc] initWithHTTPClient:httpClientMock];
    });

    context(@"loadData", ^{

        it(@"should call 7day URI", ^{
            [[httpClientMock should] receive:@selector(requestWithMethod:path:parameters:)];
            [[httpClientMock should] receive:@selector(HTTPRequestOperationWithRequest:success:failure:)];
            [[httpClientMock should] receive:@selector(enqueueHTTPRequestOperation:)];

            KWCaptureSpy *spy = [httpClientMock captureArgument:@selector(requestWithMethod:path:parameters:) atIndex:1];

            [earthquakeDataService loadData:nil];

            [[spy.argument should] equal:kIVGUSGSEarthquake7DayM1URI];
        });

    });

    context(@"successBlock", ^{
        __block AFNetworkingSuccessBlock successBlock;

        it(@"should not be nil", ^{
            successBlock = [earthquakeDataService buildSuccessBlockWithLoadDataBlock:nil];
            [successBlock shouldNotBeNil];
        });

        it(@"should call loadDataBlock", ^{
            __block BOOL loadDataBlockCalled = NO;
            IVGEDSLoadDataBlock dummyLoadDataBlock = ^(NSArray *data) {
                loadDataBlockCalled = YES;
            };
            successBlock = [earthquakeDataService buildSuccessBlockWithLoadDataBlock:dummyLoadDataBlock];
            successBlock(nil,nil);
            [[@(loadDataBlockCalled) should] equal:@(YES)];
        });

        context(@"with sample USGS data", ^{
            __block NSData *exampleUSGSData;
            __block NSArray *loadedData;
            __block IVGEDSLoadDataBlock dummyLoadDataBlock;
            __block NSDictionary *exampleDictionary1;
            __block NSDictionary *exampleDictionary2;

            beforeEach(^{
                NSString *exampleUSGSDataString = @""\
                "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region" \
                "\nak,10679205,1,\"Friday, March 22, 2013 04:48:46 UTC\",60.4056,-150.9621,2.2,47.80, 7,\"Kenai Peninsula, Alaska\"" \
                "\nnc,71958305,0,\"Friday, March 22, 2013 04:24:39 UTC\",35.5412,-120.7735,1.2,5.10,10,\"Central California\"";

                exampleDictionary1 =
                @{
                  @"Src":@"ak",
                  @"Eqid":@"10679205",
                  @"Version":@"1",
                  @"Datetime":@"Friday, March 22, 2013 04:48:46 UTC",
                  @"Lat":@"60.4056",
                  @"Lon":@"-150.9621",
                  @"Magnitude":@"2.2",
                  @"Depth":@"47.80",
                  @"NST":@"7",
                  @"Region":@"Kenai Peninsula, Alaska"
                  };

                exampleDictionary2 =
                @{
                  @"Src":@"nc",
                  @"Eqid":@"71958305",
                  @"Version":@"0",
                  @"Datetime":@"Friday, March 22, 2013 04:24:39 UTC",
                  @"Lat":@"35.5412",
                  @"Lon":@"-120.7735",
                  @"Magnitude":@"1.2",
                  @"Depth":@"5.10",
                  @"NST":@"10",
                  @"Region":@"Central California"
                  };

                exampleUSGSData = [exampleUSGSDataString dataUsingEncoding:NSUTF8StringEncoding];
                loadedData = nil;
                dummyLoadDataBlock = ^(NSArray *data) {
                    loadedData = data;
                };
                successBlock = [earthquakeDataService buildSuccessBlockWithLoadDataBlock:dummyLoadDataBlock];
                successBlock(nil,exampleUSGSData);
            });

            it(@"should create array of dictionaries with earthquake data built from network request results", ^{
                [[loadedData should] haveCountOf:2];
                for (id item in loadedData) {
                    [[item should] beKindOfClass:[NSDictionary class]];
                }
            });

            it(@"first item should match exampleDictionary1", ^{
                NSDictionary *actionDictionary1 = [loadedData objectAtIndex:0];
                [[actionDictionary1 should] equal:exampleDictionary1];
            });

            it(@"second item should match exampleDictionary2", ^{
                NSDictionary *actionDictionary2 = [loadedData objectAtIndex:1];
                [[actionDictionary2 should] equal:exampleDictionary2];
            });
        });
    });
    
});

SPEC_END
