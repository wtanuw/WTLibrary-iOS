//
//  WTMacro.h
//  Wat Wongtanuwat
//
//  Created by Wat Wongtanuwat on 8/31/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTMacro_VERSION 0x00020003

#ifndef WATLOG_DEBUG
#define WATLOG_DEBUG
#endif

// show "WatLog()" only when define both WATLOG_DEBUG and DEBUG
#ifdef WATLOG_DEBUG
#define WATLOG_DEBUG_ENABLE DEBUG
#endif

#ifdef WATNICOLOG_DEBUG
#define WATNICOLOG_DEBUG_ENABLE DEBUG
#endif

///<--------------------------------------------------!>

//build setting->prefix header->path ($(SRCROOT)/filename.pch)

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
