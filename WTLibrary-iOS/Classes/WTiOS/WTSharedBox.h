//
//  WTSharedBox.h
//  BushiRoadCardViewer
//
//  Created by Wat Wongtanuwat on 9/19/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <mach/mach.h>
#import <mach/mach_host.h>

#define WTSharedBox_VERSION 0x00020000

@interface WTSharedBox : NSObject

+ (instancetype)sharedManager;


+ (void)fadeDefaultScreenFromWindow:(UIWindow*)window withDuration:(float)duration withDelay:(float)delay andAnimation:(void (^)(UIImageView *imageView))removeAnimation;
+ (void)fadeDefaultScreenFromView:(UIView*)rootView withDuration:(float)duration withDelay:(float)delay andAnimation:(void (^)(UIImageView *imageView))removeAnimation;


+ (NSString*)WTVersionFirstInstallAppVersion;
+ (NSString*)WTVersionPreviousAppVersion;
+ (NSString*)WTVersionCurrentAppVersion;

+ (BOOL)WTVersionFirstInstallVersionIsBefore:(NSString*)ver;//if install app before specified version, then may reward user
+ (BOOL)WTVersionFirstInstallVersionIsBeforeCurrentAppVersion;

+ (BOOL)WTVersionPreviousVersionIsBefore:(NSString*)ver;//if app exists before specified version, then need some change to data inside ifelse
+ (BOOL)WTVersionPreviousVersionIsBeforeCurrentAppVersion;

+ (BOOL)WTVersionWriteCurrentAppVersion;


+ (void)WTWatLogTitle:(NSString*)title message:(NSString*)message;


+ (void)WTPRNGSetFirstSeed:(long)firstSeed;
+ (void)WTPRNGSetRandomFirstSeed;
+ (NSUInteger)WTPRNGGetFirstSeed;
+ (NSUInteger)WTPRNGGetCurrentSeed;
+ (int)WTPRNGGetNumberOfTime;
+ (NSUInteger)WTPRNGRandom;



CGRect FixOriginRotation(CGRect rect, UIInterfaceOrientation orientation, int parentWidth, int parentHeight);

natural_t  freeMemory(void);

+ (void)report_memory;


NSString *WTDeviceSystemVersion();

NSUInteger WTDeviceInterface();

void WTSharedBoxNicoLog(NSString *s);

- (NSArray *)getDataCounters;

@end
