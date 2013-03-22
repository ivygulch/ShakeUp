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
    });
    
});

SPEC_END
