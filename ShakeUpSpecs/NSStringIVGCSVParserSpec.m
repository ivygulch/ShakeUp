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

    context(@"string with headers and data", ^{
        NSString *csv = @"colA,colB,colC" \
        "\nrow1ColA,row1ColB,row1ColC" \
        "\nrow2ColA,row2ColB,row2ColC";

        it(@"should produce array of dictionaries", ^{
            NSArray *dictionaries = [csv dictionariesFromCSVComponents];
            [dictionaries shouldNotBeNil];
            [[dictionaries should] haveCountOf:2];

            NSDictionary *dictionary1 = [dictionaries objectAtIndex:0];
            [[[dictionary1 should] have:3] allKeys];
            [[[dictionary1 allKeys] should] containObjectsInArray:@[@"colA",@"colB",@"colC"]];
            [[dictionary1 should] haveValue:@"row1ColA" forKey:@"colA"];
            [[dictionary1 should] haveValue:@"row1ColB" forKey:@"colB"];
            [[dictionary1 should] haveValue:@"row1ColC" forKey:@"colC"];

            NSDictionary *dictionary2 = [dictionaries objectAtIndex:1];
            [[[dictionary2 should] have:3] allKeys];
            [[[dictionary2 allKeys] should] containObjectsInArray:@[@"colA",@"colB",@"colC"]];
            [[dictionary2 should] haveValue:@"row2ColA" forKey:@"colA"];
            [[dictionary2 should] haveValue:@"row2ColB" forKey:@"colB"];
            [[dictionary2 should] haveValue:@"row2ColC" forKey:@"colC"];
        });

    });

});

SPEC_END
