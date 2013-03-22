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

@end
