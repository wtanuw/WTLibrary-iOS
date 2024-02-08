//
//  WTMacro.h
//  Wat Wongtanuwat
//
//  Created by Wat Wongtanuwat on 8/31/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTMacro_VERSION 0x00020003

//#ifndef WATLOG_DEBUG
//#define WATLOG_DEBUG
//#endif

// show "WatLog()" only when define both WATLOG_DEBUG and DEBUG
#ifdef WATLOG_DEBUG
#define WATLOG_DEBUG_ENABLE DEBUG
#endif

#ifdef WATNICOLOG_DEBUG
#define WATNICOLOG_DEBUG_ENABLE DEBUG
#endif

///<--------------------------------------------------!>

//build setting->prefix header->path ($(SRCROOT)/filename.pch)

///<--------------------------------------------------!>

#pragma mark - NON ARC and ARC

//-fno-objc-arc
//-fobjc-arc

/*
#if __has_feature(objc_arc)
#error This file must be compiled without ARC.
#endif
*/
/*
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif
*/
/*
#if (__has_feature(objc_arc) && (! __has_feature(objc_arc)
#error This file can be compiled with ARC or without ARC.
#endif
*/

#define WT_HAS_ARC ( __has_feature(objc_arc) )
#define WT_REQUIRE_NONARC ( __has_feature(objc_arc) )
#define WT_REQUIRE_ARC ( !__has_feature(objc_arc) )
#define WT_NOT_CONSIDER_ARC ( (__has_feature(objc_arc)) && (!__has_feature(objc_arc)) )

/*
#if WT_REQUIRE_NONARC
#error This file must be compiled without ARC.
#endif
*/
/*
#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif
 */
/*
#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif
*/

///<------------------------------------------------!>

//#pragma mark - Safe ARC
//
//#if !defined(__clang__) || __clang_major__ < 3
//#ifndef __bridge
//#define __bridge
//#endif
//
//#ifndef __bridge_retain
//#define __bridge_retain
//#endif
//
//#ifndef __bridge_retained
//#define __bridge_retained
//#endif
//
//#ifndef __autoreleasing
//#define __autoreleasing
//#endif
//
//#ifndef __strong
//#define __strong
//#endif
//
//#ifndef __unsafe_unretained
//#define __unsafe_unretained
//#endif
//
//#ifndef __weak
//#define __weak
//#endif
//#endif
//
//#if __has_feature(objc_arc)
//#define SAFE_ARC_PROP_RETAIN strong
//#define SAFE_ARC_RETAIN(x) (x)
//#define SAFE_ARC_RELEASE(x)
//#define SAFE_ARC_AUTORELEASE(x) (x)
//#define SAFE_ARC_BLOCK_COPY(x) (x)
//#define SAFE_ARC_BLOCK_RELEASE(x)
//#define SAFE_ARC_SUPER_DEALLOC()
//#define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
//#define SAFE_ARC_AUTORELEASE_POOL_END() }
//#else
//#define SAFE_ARC_PROP_RETAIN retain
//#define SAFE_ARC_RETAIN(x) ([(x) retain])
//#define SAFE_ARC_RELEASE(x) ([(x) release])
//#define SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
//#define SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
//#define SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
//#define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
//#define SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//#define SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
//#endif


#pragma mark - WT_SAFE_ARC

#if !defined(__clang__) || __clang_major__ < 3
//#ifndef __bridge
//#define __bridge
//#endif
//
//#ifndef __bridge_retain
//#define __bridge_retain
//#endif
//
//#ifndef __bridge_retained
//#define __bridge_retained
//#endif
//
//#ifndef __autoreleasing
//#define __autoreleasing
//#endif

#ifndef __strong
#define __strong
#endif

#ifndef __unsafe_unretained
#define __unsafe_unretained
#endif

#ifndef __weak
#define __weak
#endif
#endif

#if __has_feature(objc_arc)
#define WT_SAFE_ARC_PROP_RETAIN strong
#define WT_SAFE_ARC_RETAIN(x) (x)
#define WT_SAFE_ARC_RELEASE(x)
#define WT_SAFE_ARC_AUTORELEASE(x) (x)
//#define WT_SAFE_ARC_BLOCK_COPY(x) (x)
//#define WT_SAFE_ARC_BLOCK_RELEASE(x)
#define WT_SAFE_ARC_SUPER_DEALLOC()
//#define WT_SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
//#define WT_SAFE_ARC_AUTORELEASE_POOL_END() }
#else
#define WT_SAFE_ARC_PROP_RETAIN retain
#define WT_SAFE_ARC_RETAIN(x) ([(x) retain])
#define WT_SAFE_ARC_RELEASE(x) ([(x) release])
#define WT_SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
//#define WT_SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
//#define WT_SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
#define WT_SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
//#define WT_SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//#define WT_SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif

///<------------------------------------------------!>

#pragma mark - WatLog

#if WATLOG_DEBUG_ENABLE
    #define WatLog( s, ... ) NSLog( @"WatLog <%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
    #define WatLog( s, ... )
#endif

//void WTSharedBoxNicoLog(NSString *s);//in WTSharedBox
//#if WATNICOLOG_DEBUG_ENABLE
//#define WatNicoLog( s, ... ) \
//NSLog( @"WatNicoLog <%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] );\
//WTSharedBoxNicoLog([NSString stringWithFormat:(s), ##__VA_ARGS__]);\
////        WatLog(@"%@",[NSString stringWithFormat:(s), ##__VA_ARGS__]);
//#else
//#define WatNicoLog( s, ... )
//#endif
//
//void WTSharedBoxNicoLog(NSString *s);//in WTSharedBox

#ifdef WTSharedBox_VERSION
#if WATNICOLOG_DEBUG_ENABLE
    #define WatNicoLog( s, ... ) NSLog( @"WatNicoLog <%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] );\
                                 WTSharedBoxNicoLog([NSString stringWithFormat:(s), ##__VA_ARGS__]);\
        //        WatLog(@"%@",[NSString stringWithFormat:(s), ##__VA_ARGS__]);
#else
    #define WatNicoLog( s, ... )
#endif
#endif


//Preprocesser Macro [not set] or [set = 0] is same when use with #if
//          [not set]   [set?]  [set=0] [set=1]
//#if           NO       Error    NO      YES
//#ifdef        NO        YES     YES     YES

//Define Macro
//          [not set]   [set?]  [set=0] [set=1]
//#if           NO      Error     NO      YES
//#ifdef        NO       YES      YES     YES

///<------------------------------------------------!>

#pragma mark - Trivia

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#define UIColorMake(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorMakeWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CGColorMake(r,g,b) [UIColorMake(r,g,b) CGColor]
#define CGColorMakeWithAlpha(r,g,b,a) [UIColorMake(r,g,b,a) CGColor]
#define CGColorAlphaMake(r,g,b,a) [UIColorMake(r,g,b,a) CGColor]

#define NSStringFromBoolean(bool) ((bool)?@"YES":@"NO")
#define WTBOOL(bool) NSStringFromBoolean(bool)
#define ___ 

///<------------------------------------------------!>
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//NSArray *linkedNodes = [startNode performSelector:nodesArrayAccessor];
//#pragma clang diagnostic pop

#pragma mark - Device

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_BUT_LESS_THAN(v,w)  (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) && SYSTEM_VERSION_LESS_THAN(w))


//#define UI_INTERFACE_RETINA()               ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))?1:0
//#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!UI_INTERFACE_RETINA())
//#define UI_INTERFACE_SCREEN_IS_RETINA()     (UI_INTERFACE_RETINA())

#define UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR()  UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR() UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define UI_INTERFACE_ORIENTATION_IS_PORTRAIT()  UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])
#define UI_INTERFACE_ORIENTATION_IS_LANDSCAPE() UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

#define UI_INTERFACE_SCALE()               (([[UIScreen mainScreen] respondsToSelector: @selector(scale)])?[UIScreen mainScreen].scale:1.0)
#define UI_INTERFACE_RETINA()               ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && (UI_INTERFACE_SCALE() >= 2.0)?YES:NO)
#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!UI_INTERFACE_RETINA())
#define UI_INTERFACE_SCREEN_IS_RETINA()     (UI_INTERFACE_RETINA())

#define UI_INTERFACE_IDIOM_IS_IPHONE()      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define UI_INTERFACE_IDIOM_IS_IPAD()        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 568*UI_INTERFACE_SCALE())
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 667*UI_INTERFACE_SCALE())
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 736*UI_INTERFACE_SCALE())

#define UI_INTERFACE_IDIOM_PHONE_PAD(phone,pad) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?phone:pad)
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 736*UI_INTERFACE_SCALE())

///<------------------------------------------------!>

#pragma mark - Other

#ifdef __OBJC__
//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define UIColorAlphaFromRGB(rgbValue,a) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
            blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#endif

///<------------------------------------------------!>

#define DEGREE_FROM_RADIAN(rad)         (rad) * (180.0 / M_PI)
#define RADIAN_FROM_DEGREE(deg)         (deg) * (M_PI / 180.0)
#define ROTATIONNUMBER_FROM_RADIAN(rad) (rad) / (2.0 * M_PI)
#define RADIAN_FROM_ROTATIONNUMBER(num) (num) * (2.0 * M_PI)

#define DEGREE_CLOCKWISE_ONE_QUARTER           (90)
#define DEGREE_CLOCKWISE_THREE_QUARTER         (270)
#define DEGREE_ANTI_CLOCKWISE_ONE_QUARTER      (-90)
#define DEGREE_ANTI_CLOCKWISE_THREE_QUARTER    (-270)

#define RADIAN_CLOCKWISE_ONE_QUARTER           ((90) * (M_PI / 180.0))
#define RADIAN_CLOCKWISE_THREE_QUARTER         ((270) * (M_PI / 180.0))
#define RADIAN_ANTI_CLOCKWISE_ONE_QUARTER      ((-90) * (M_PI / 180.0))
#define RADIAN_ANTI_CLOCKWISE_THREE_QUARTER    ((-270) * (M_PI / 180.0))

///<------------------------------------------------!>

#define BOUNDARY(value,low,high)     MIN(MAX(value, low), high)
#define BOUNDARY2(low,value,high)    MIN(MAX(low, value), high)

///<------------------------------------------------!>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

///<------------------------------------------------!>

//note: maximum of arc4random  = 0x100000000 (4294967296)

//return random int within range from low to high (include high)
//#define RANDOM_BOUNDARY(low,high) ((arc4random()%(high-low+1))+low)
#define RANDOM_BOUNDARY(low,high) ((arc4random_uniform((high-low+1))%(high-low+1))+low)

//return random float within range from low to high (include high)
#define _frandom_ ((float)arc4random()/UINT64_C(0x100000000))
#define FRANDOM_BOUNDARY(low,high) (((high-low)*_frandom_)+low)

//return bool from random chance 0-99 (100 will alway TRUE)
#define RANDOM_CHANCE(chance) (RANDOM_BOUNDARY(0, 99)<chance)

///<------------------------------------------------!>

#pragma mark - Compile

//use to prevent compile error when use new APIs on old SDK
//and in case newest target did not show in list of target, so we use previous target instead
//base sdk is greater than __target
#define IS_IOS_BASE_SDK_EXCEED(__target) (__IPHONE_OS_VERSION_MAX_ALLOWED > __target)
//use to prevent deprecated warning when use deprecated APIs on newer SDK
//and in case newest target did not show in list of target, so we use previous target instead
//deployment target is equal to __target
#define IS_IOS_DEPLOY_TARGET_BELOW_OR_EQUAL(__target) (__IPHONE_OS_VERSION_MIN_REQUIRED <= __target)

//
//deployment target is greater than or equals to __target
#define IS_IOS_DEPLOY_TARGET_MINIMUM(__target) (__IPHONE_OS_VERSION_MIN_REQUIRED >= __target)

//use to prevent compile error when use new APIs on old SDK
//
#define IS_IOS_BASE_SDK_ATLEAST(__target) (__IPHONE_OS_VERSION_MAX_ALLOWED >= __target)
//use to prevent deprecated warning when use deprecated APIs on newer SDK
//
#define IS_IOS_DEPLOY_TARGET_BELOW(__target) (__IPHONE_OS_VERSION_MIN_REQUIRED < __target)


//example1
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  if (![object respondsToSelector:@selector(methodStartAt_8_0)])
//  {
//#endif
//    [object methodDeprecateAt_8_0];
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  }
//  else
//#endif
//#endif
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  {
//    [object methodStartAt_8_0];
//  }
//#endif

//result deploy7.0 sdk7.0
//    [object methodDeprecateAt_8_0];
//  {
//  }

//result deploy7.0 sdk8.0
//  if (![object respondsToSelector:@selector(methodOnlyAt_8_0)])
//  {
//    [object methodDeprecateAt_8_0];
//  }
//else
//  {
//    [object methodStartAt_8_0];
//  }

//result deploy8.0 sdk8.0
//  {
//    [object methodStartAt_8_0];
//  }

//example2.1
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  if ([object respondsToSelector:@selector(methodStartAt_8_0)])
//  {
//#endif
//    [object methodStartAt_8_0];
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  }
//  else
//#endif
//#endif
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  {
//    [object methodDeprecateAt_8_0];
//  }
//#endif

//example2.2
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  if ([object respondsToSelector:@selector(methodStartAt_8_0)])
//  {
//    [object methodStartAt_8_0];
//  }
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  else
//#endif
//#endif
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  {
//    [object methodDeprecateAt_8_0];
//  }
//#endif

//result deploy7.0 sdk7.0
//  {
//    [object methodDeprecateAt_8_0];
//  }

//result deploy7.0 sdk8.0
//  if ([object respondsToSelector:@selector(methodStartAt_8_0)])
//    [object methodStartAt_8_0];
//  }
//  else
//  {
//    [object methodDeprecateAt_8_0];
//  }

//result deploy8.0 sdk8.0
//    [object methodStartAt_8_0];

///<------------------------------------------------!>
//
//#pragma mark - New not expensive UIDevice SystemVersion (Apple Transition Guide iOS7)
//
////NSUInteger DeviceSystemMajorVersion();
////NSUInteger DeviceSystemMajorVersion() {
////    static NSUInteger _deviceSystemMajorVersion = -1;
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
////                                       componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
////    });
////    return _deviceSystemMajorVersion;
////}
//
//NSString *WTDeviceSystemVersion();//in WTSharedBox
//
//#define SYSTEM_VERSION_EQUAL_TO(v)                  ([WTDeviceSystemVersion() compare:v options:NSNumericSearch] == NSOrderedSame)
//#define SYSTEM_VERSION_GREATER_THAN(v)              ([WTDeviceSystemVersion() compare:v options:NSNumericSearch] == NSOrderedDescending)
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([WTDeviceSystemVersion() compare:v options:NSNumericSearch] != NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN(v)                 ([WTDeviceSystemVersion() compare:v options:NSNumericSearch] == NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([WTDeviceSystemVersion() compare:v options:NSNumericSearch] != NSOrderedDescending)
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_BUT_LESS_THAN(v,w)  (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) && SYSTEM_VERSION_LESS_THAN(w))
//
////<--------------------------------------------------!>
//
//#pragma mark - New not expensive UIDevice Interface
//
//NSUInteger WTDeviceInterface();//in WTSharedBox
//
//#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!WTDeviceInterface())
//#define UI_INTERFACE_SCREEN_IS_RETINA()     (WTDeviceInterface())
//
//#define UI_INTERFACE_IDIOM_IS_IPHONE()      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define UI_INTERFACE_IDIOM_IS_IPAD()        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && (CGRectGetHeight([UIScreen mainScreen].bounds) == 568)
//
////<--------------------------------------------------!>

#define VERSIONHEX_FROM_DECIMAL(a,b,c) ( a<<16+b<<8+c )

///<------------------------------------------------!>

///<------------------------------------------------!>
//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define ASYNC(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ __VA_ARGS__ })
#define ASYNC_MAIN(...) dispatch_async(dispatch_get_main_queue(), ^{ __VA_ARGS__ })

// TODO: Midhun

// FIXME: Midhun

// ???: Midhun

// !!!: Midhun

// MARK: Midhun

//--------------------------------------------------!>






//--------------------------------------------------!>
