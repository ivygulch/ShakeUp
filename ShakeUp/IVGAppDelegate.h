//
//  IVGAppDelegate.h
//  ShakeUp
//
//  Created by Douglas Sjoquist on 11/15/12.
//  Copyright (c) 2012 Ivy Gulch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IVGViewController;

@interface IVGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IVGViewController *viewController;

@end
