//
//  ShakeUpSpecs.m
//  ShakeUpSpecs
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import "ShakeUpSpecs.h"
#import "Kiwi.h"

@implementation ShakeUpSpecs

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testKiwiLink;
{
    id test = [KWNull null];
    NSLog(@"test = %@", test);
    STAssertNotNil(test, @"Should be able to compile and link something from libKiwi");
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in ShakeUpSpecs");
}

@end
