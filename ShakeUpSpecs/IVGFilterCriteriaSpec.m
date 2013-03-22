//
//  IVGFilterCriteriaSpec.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 3/22/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "IVGFilterCriteria.h"
#import "IVGConstants.h"

SPEC_BEGIN(IVGFilterCriteriaSpec)

describe(@"filterCriteria", ^{
    __block IVGFilterCriteria *filterCriteria;

    beforeEach(^{
        filterCriteria = [[IVGFilterCriteria alloc] init];
    });

    context(@"when first initialized", ^{
        __block NSError *error;
        __block BOOL valid;

        beforeEach(^{
            valid = [filterCriteria validateCriteriaError:&error];
        });

        it(@"should be invalid", ^{
            [[@(valid) should] equal:@(NO)];
        });

        it(@"should produce error when invalid", ^{
            [error shouldNotBeNil];
        });

        it(@"error domain should be set", ^{
            [[[error domain] should] equal:kIVGErrorDomain];
        });

        it(@"error code should be set", ^{
            [[@([error code]) should] equal:@(kIVGError_invalidFilterCriteria)];
        });

        it(@"userInfo should contain criteriaErrors", ^{
            id criteriaErrors = [[error userInfo] objectForKey:@"criteriaErrors"];
            [criteriaErrors shouldNotBeNil];
        });
    });

});

SPEC_END
