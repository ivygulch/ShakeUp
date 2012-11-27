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
- (NSDictionary *) columnPositionsFromHeaderRow:(NSArray *) headerRow;
@end

SPEC_BEGIN(IVGEarthquakeAPISpecs)

describe(@"earthquakeAPI", ^{
    __block IVGEarthquakeAPI *earthquakeAPI;
    __block id earthquakeDataServiceMock = [IVGEarthquakeDataService mock];

    beforeEach(^{
        earthquakeAPI = [[IVGEarthquakeAPI alloc] initWithDataService:earthquakeDataServiceMock];
    });

    it(@"should retrieve data from server", ^{
        NSArray *mockEarthquakeDataDictionaries = [NSArray array];
        [[earthquakeDataServiceMock should] receive:@selector(loadData) andReturn:mockEarthquakeDataDictionaries];

        NSArray *currentData = [earthquakeAPI retrieveCurrentData];
        [currentData shouldNotBeNil];
        [[currentData should] haveCountOfAtLeast:1];
        for (id item in currentData) {
            [[item should] beKindOfClass:[IVGEarthquake class]];
        }
    });

});

SPEC_END
