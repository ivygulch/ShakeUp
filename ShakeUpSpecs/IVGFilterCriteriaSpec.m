//
//  IVGFilterCriteriaSpec.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 3/22/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "IVGFilterCriteria.h"

SPEC_BEGIN(IVGFilterCriteriaSpec)

describe(@"filterCriteria", ^{
    __block IVGFilterCriteria *filterCriteria;

    beforeEach(^{
        filterCriteria = [[IVGFilterCriteria alloc] init];
    });

    context(@"when first initialized", ^{

        it(@"should be invalid", ^{
            BOOL valid = [filterCriteria validateCriteriaError:nil];
            [[@(valid) should] equal:@(NO)];
        });
    });

});

SPEC_END
