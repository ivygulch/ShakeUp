//
//  IVGFilterCriteria.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 3/22/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGFilterCriteria : NSObject

@property (nonatomic,strong) NSNumber *minimumLatitude;
@property (nonatomic,strong) NSNumber *maximumLatitude;
@property (nonatomic,strong) NSNumber *minimumLongitude;
@property (nonatomic,strong) NSNumber *maximumLongitude;
@property (nonatomic,strong) NSNumber *minimumMagnitude;
@property (nonatomic,strong) NSNumber *maximumMagnitude;
@property (nonatomic,strong) NSDate *minimumDatetime;
@property (nonatomic,strong) NSDate *maximumDatetime;

- (BOOL) validateCriteriaError:(NSError **) error;

@end
