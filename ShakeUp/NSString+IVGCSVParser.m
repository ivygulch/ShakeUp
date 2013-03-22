//
//  NSString+IVGCSVParser.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 3/22/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "NSString+IVGCSVParser.h"
#import "CHCSVParser.h"

@implementation NSString (IVGCSVParser)

- (NSArray *) dictionariesFromCSVComponents;
{
    NSArray *rows = [self CSVComponents];
    if ([rows count] < 2) {
        return [NSArray array];
    }

    NSArray *header = [rows objectAtIndex:0];
    NSMutableArray *dictionaries = [NSMutableArray arrayWithCapacity:[rows count]-1];
    for (NSUInteger rowIdx=1; rowIdx<[rows count]; rowIdx++) {
        NSArray *values = [rows objectAtIndex:rowIdx];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[header count]];
        for (NSUInteger colIdx=0; (colIdx<[header count]) && (colIdx<[values count]); colIdx++) {
            [dictionary setObject:[values objectAtIndex:colIdx] forKey:[header objectAtIndex:colIdx]];
        }
        [dictionaries addObject:[NSDictionary dictionaryWithDictionary:dictionary]];
    }
    return [NSArray arrayWithArray:dictionaries];
}

@end
