//
//  IVGEarthquakeDataService.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/27/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGEarthquakeDataService.h"
#import "IVGUSGSAPIConstants.h"

@interface IVGEarthquakeDataService()
@property (nonatomic,strong) AFHTTPClient *httpClient;
@end

@implementation IVGEarthquakeDataService

- (id) initWithHTTPClient:(AFHTTPClient *) httpClient;
{
    if ((self = [super init])) {
        _httpClient = httpClient;
    }
    return self;
}

- (void) loadData:(IVGEDSLoadDataBlock) loadDataBlock;
{
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:kIVGUSGSEarthquake7DayM1URI parameters:nil];

    AFHTTPRequestOperation *operation = [self.httpClient
                                         HTTPRequestOperationWithRequest:request
                                         success:nil
                                         failure:nil];

    [self.httpClient enqueueHTTPRequestOperation:operation];

}

- (AFNetworkingSuccessBlock) buildSuccessBlockWithLoadDataBlock:(IVGEDSLoadDataBlock) loadDataBlock;
{
    return ^(AFHTTPRequestOperation *operation, id responseObject) {

    };
}

@end
