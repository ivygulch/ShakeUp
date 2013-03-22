//
//  IVGFilterCriteria.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 3/22/13.
//  Copyright (c) 2013 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGFilterCriteria : NSObject

@property (nonatomic,assign) double minimumLatitude;
@property (nonatomic,assign) double maximumLatitude;
@property (nonatomic,assign) double minimumLongitude;
@property (nonatomic,assign) double maximumLongitude;
@property (nonatomic,assign) double minimumMagnitude;
@property (nonatomic,assign) double maximumMagnitude;
@property (nonatomic,strong) NSDate *minimumDatetime;
@property (nonatomic,strong) NSDate *maximumDatetime;

- (BOOL) validateCriteriaError:(NSError **) error;

@end
