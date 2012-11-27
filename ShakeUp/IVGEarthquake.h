//
//  IVGEarthquake.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/26/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVGEarthquake : NSObject

@property (nonatomic,assign) NSInteger earthquakeId;
@property (nonatomic,assign) NSInteger version;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSDate *datetime;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,assign) double magnitude;
@property (nonatomic,assign) double depth;
@property (nonatomic,assign) NSInteger nst;
@property (nonatomic,strong) NSString *region;

@end
