//
//  NSStringIVGCSVParserSpec.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 03/21/13
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "Kiwi.h"
#import "NSString+IVGCSVParser.h"

SPEC_BEGIN(NSStringIVGCSVParserSpec)

describe(@"parser category", ^{

    context(@"empty string", ^{
        NSString *csv = @"";

        it(@"should produce empty array", ^{
            NSArray *dictionaries = [csv dictionariesFromCSVComponents];
            [dictionaries shouldNotBeNil];
            [[dictionaries should] haveCountOf:0];
        });

    });
    
    context(@"string with just headers", ^{
        NSString *csv = @"colA,colB,colC";

        it(@"should produce empty array", ^{
            NSArray *dictionaries = [csv dictionariesFromCSVComponents];
            [dictionaries shouldNotBeNil];
            [[dictionaries should] haveCountOf:0];
        });

    });
    
});

SPEC_END
