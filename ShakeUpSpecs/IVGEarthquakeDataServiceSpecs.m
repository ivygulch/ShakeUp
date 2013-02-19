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

    context(@"dummy spec", ^{

        it(@"make sure classes are included in appropriate target before we continue", ^{
            AFHTTPClient *dummyClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://example.com"]];
            [dummyClient shouldNotBeNil];

            IVGEarthquakeDataService *dummyDS = [[IVGEarthquakeDataService alloc] init];
            [dummyDS shouldNotBeNil];
        });
        
    });
    
});

SPEC_END
