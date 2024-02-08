//
//  WTUIInterface.m
//  Pods
//
//  Created by Wat Wongtanuwat on 1/12/2567 BE.
//
//

#import "WTUIInterfaceBase.h"
#import <AvailabilityVersions.h>
#import "WTMacro.h"
#import "WTVersion.h"

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#define WTLibrary_iOS_WTUIInterfaceBase_VERSION 0x00030024
#define WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13 __IPHONE_13_0
#define WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_16 __IPHONE_16_0

@interface WTUIInterfaceBase()

@end

//#define UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR()  UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
//#define UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR() UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
//#define UI_INTERFACE_ORIENTATION_IS_PORTRAIT()  UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])
//#define UI_INTERFACE_ORIENTATION_IS_LANDSCAPE() UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])
//
//#define UI_INTERFACE_SCALE()               (([[UIScreen mainScreen] respondsToSelector: @selector(scale)])?[UIScreen mainScreen].scale:1.0)
//#define UI_INTERFACE_RETINA()               ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && (UI_INTERFACE_SCALE() >= 2.0)?YES:NO)
//#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!UI_INTERFACE_RETINA())
//#define UI_INTERFACE_SCREEN_IS_RETINA()     (UI_INTERFACE_RETINA())
//
//#define UI_INTERFACE_IDIOM_IS_IPHONE()      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define UI_INTERFACE_IDIOM_IS_IPAD()        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 568*UI_INTERFACE_SCALE())
//#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 667*UI_INTERFACE_SCALE())
//#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 736*UI_INTERFACE_SCALE())
//
//#define UI_INTERFACE_IDIOM_PHONE_PAD(phone,pad) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?phone:pad)
//#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 736*UI_INTERFACE_SCALE())

@implementation WTUIInterfaceBase

+(instancetype)model
{
    return [[WTUIInterfaceBase alloc] init];
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
#endif
    NSAssert(NO, @"UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR");
    return YES;
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
#endif
    NSAssert(NO, @"UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR");
    return YES;
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT
{
    return UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE
{
    return UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
}

-(BOOL)UI_INTERFACE_SCALE
{
    return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)])?[UIScreen mainScreen].scale:1.0);
}
-(BOOL)UI_INTERFACE_RETINA
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && (UI_INTERFACE_SCALE() >= 2.0)?YES:NO);
}
-(BOOL)UI_INTERFACE_SCREEN_IS_NONRETINA
{
    return (!UI_INTERFACE_RETINA());
}
-(BOOL)UI_INTERFACE_SCREEN_IS_RETINA
{
    return (UI_INTERFACE_RETINA());
}

-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
    NSAssert(NO, @"I_INTERFACE_IDIOM_IS_IPHONE");
    return YES;
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPAD
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    NSAssert(NO, @"UI_INTERFACE_IDIOM_IS_IPAD");
    return YES;
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 568*UI_INTERFACE_SCALE());
#endif
    NSAssert(NO, @"UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH");
    return YES;
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 667*UI_INTERFACE_SCALE());
#endif
    NSAssert(NO, @"UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH");
    return YES;
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 736*UI_INTERFACE_SCALE());
#endif
    NSAssert(NO, @"UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH");
    return YES;
}

-(BOOL)UI_INTERFACE_IDIOM_PHONE_PAD
{
    //#define UI_INTERFACE_IDIOM_PHONE_PAD(phone,pad) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?phone:pad);
    return YES;
}

-(BOOL)isStatusBarHidden
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    return [[UIApplication sharedApplication] isStatusBarHidden];
#endif
    NSAssert(NO, @"isStatusBarHidden");
    return YES;
}
-(UIInterfaceOrientation)statusBarOrientation
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return orientation;
#endif
    NSAssert(NO, @"statusBarOrientation");
    return UIInterfaceOrientationPortrait;
}
-(CGRect)statusBarFrame
{
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterfaceBase_API_VERSION_13)
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    return statusBarFrame;
#endif
    NSAssert(NO, @"statusBarFrame");
    return CGRectZero;
}

@end
