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

SPEC_BEGIN(IVGEarthquakeDataServiceSpecs)

describe(@"earthquakeDataService", ^{
    __block id httpClientMock = [AFHTTPClient mock];
    __block IVGEarthquakeDataService *earthquakeDataService;

    beforeEach(^{
        earthquakeDataService = [[IVGEarthquakeDataService alloc] initWithHTTPClient:httpClientMock];
    });

    context(@"loadData", ^{

        it(@"should call 7day URI", ^{
            [[httpClientMock should] receive:@selector(test)];

            [earthquakeDataService loadData:nil];
        });
        
    });
    
});

SPEC_END
