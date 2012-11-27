//
//  IVGEarthquakeAPISpecs.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "IVGEarthquakeAPI.h"
#import "IVGEarthquake.h"

@interface IVGEarthquakeAPI()
- (NSDictionary *) columnPositionsFromHeaderRow:(NSArray *) headerRow;
@end

SPEC_BEGIN(IVGEarthquakeAPISpecs)

describe(@"earthquakeAPI", ^{
    __block IVGEarthquakeAPI *earthquakeAPI;

    beforeEach(^{
        earthquakeAPI = [[IVGEarthquakeAPI alloc] init];
    });

    it(@"should retrieve data from server", ^{
        NSArray *currentData = [earthquakeAPI retrieveCurrentData];
        [currentData shouldNotBeNil];
        [[currentData should] haveCountOfAtLeast:1];
        for (id item in currentData) {
            [[item should] beKindOfClass:[IVGEarthquake class]];
        }
    });

});

SPEC_END
