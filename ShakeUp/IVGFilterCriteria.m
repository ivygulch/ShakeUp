//
//  IVGFilterCriteria.m
//  ShakeUp
//
//  Created by Douglas Sjoquist on 3/22/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import "IVGFilterCriteria.h"
#import "IVGConstants.h"

@implementation IVGFilterCriteria

- (void) appendMissingCriteriaErrorTo:(NSMutableDictionary *) criteriaErrors
                         withValue:(NSNumber *) value
                        criteriaName:(NSString *) criteriaName;
{
    if (value == nil) {
            [criteriaErrors setObject:@"missing value" forKey:criteriaName];
    }
}

- (void) appendMinMaxCriteriaErrorTo:(NSMutableDictionary *) criteriaErrors
                         withMinimum:(id) minimum
                             maximum:(id) maximum
                        criteriaName:(NSString *) criteriaName;
{
    if ((minimum != nil) &&  (maximum != nil)) {
        NSComparisonResult comparison = [minimum compare:maximum];
        if (comparison == NSOrderedDescending) {
            [criteriaErrors setObject:[NSString stringWithFormat:@"minimum %@ must be less than or equal to maximum %@", criteriaName, criteriaName]
                               forKey:criteriaName];
        }
    }
}

- (BOOL) validateCriteriaError:(NSError **) error;
{
    NSMutableDictionary *criteriaErrors = [NSMutableDictionary dictionary];

    [self appendMissingCriteriaErrorTo:criteriaErrors withValue:self.minimumLatitude criteriaName:@"minimumLatitude"];
    [self appendMissingCriteriaErrorTo:criteriaErrors withValue:self.maximumLatitude criteriaName:@"maximumLatitude"];
    [self appendMissingCriteriaErrorTo:criteriaErrors withValue:self.minimumLongitude criteriaName:@"minimumLongitude"];
    [self appendMissingCriteriaErrorTo:criteriaErrors withValue:self.maximumLongitude criteriaName:@"maximumLongitude"];
    [self appendMinMaxCriteriaErrorTo:criteriaErrors withMinimum:self.minimumLatitude maximum:self.maximumLatitude criteriaName:@"latitude"];
    [self appendMinMaxCriteriaErrorTo:criteriaErrors withMinimum:self.minimumLongitude maximum:self.maximumLongitude criteriaName:@"longitude"];
    [self appendMinMaxCriteriaErrorTo:criteriaErrors withMinimum:self.minimumMagnitude maximum:self.maximumMagnitude criteriaName:@"magnitude"];

    if ([criteriaErrors count] > 0) {
        if (error != nil) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:@"Invalid filterCritieria",
                                       @"criteriaErrors":criteriaErrors
                                       };
            *error = [NSError errorWithDomain:kIVGErrorDomain
                                         code:kIVGError_invalidFilterCriteria
                                     userInfo:userInfo];
        }
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) value:(id) value matchesMinimum:(id) minimum withRequired:(BOOL) required;
{
    if ((value == nil) || (minimum == nil)) {
        return !required;
    } else if ([value respondsToSelector:@selector(compare:)]){
        NSComparisonResult comparisonResult = [value compare:minimum];
        return comparisonResult != NSOrderedAscending;
    } else {
        return NO;
    }
}

- (BOOL) value:(id) value matchesMaximum:(id) maximum withRequired:(BOOL) required;
{
    if ((value == nil) || (maximum == nil)) {
        return !required;
    } else if ([value respondsToSelector:@selector(compare:)]){
        NSComparisonResult comparisonResult = [value compare:maximum];
        return comparisonResult != NSOrderedDescending;
    } else {
        return NO;
    }
}


- (BOOL) matches:(IVGEarthquake *) earthquake;
{
    return [self value:@(earthquake.latitude) matchesMinimum:self.minimumLatitude withRequired:YES]
    && [self value:@(earthquake.latitude) matchesMaximum:self.maximumLatitude withRequired:YES]
    && [self value:@(earthquake.longitude) matchesMinimum:self.minimumLongitude withRequired:YES]
    && [self value:@(earthquake.longitude) matchesMaximum:self.maximumLongitude withRequired:YES]
    && [self value:@(earthquake.magnitude) matchesMinimum:self.minimumMagnitude withRequired:NO]
    && [self value:@(earthquake.magnitude) matchesMaximum:self.maximumMagnitude withRequired:NO]
    && [self value:earthquake.datetime matchesMinimum:self.minimumDatetime withRequired:NO]
    && [self value:earthquake.datetime matchesMaximum:self.maximumDatetime withRequired:NO]
    ;
}

@end
