//
//  WTUIInterface.m
//  Pods
//
//  Created by Wat Wongtanuwat on 1/12/2567 BE.
//
//

#import "WTUIInterface13.h"
#import <AvailabilityVersions.h>
#import "WTMacro.h"
#import "WTUIInterface.h"
#import "WTVersion.h"

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#define WTLibrary_iOS_WTUIInterface13_VERSION 0x00030024
#define WTLibrary_iOS_WTUIInterface13_API_VERSION_13 __IPHONE_13_0
#define WTLibrary_iOS_WTUIInterface13_API_VERSION_16 __IPHONE_16_0

#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface13_API_VERSION_16)

@interface WTUIInterface13()

@end
//
////#define UI_INTERFACE_RETINA()               ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))?1:0
////#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!UI_INTERFACE_RETINA())
////#define UI_INTERFACE_SCREEN_IS_RETINA()     (UI_INTERFACE_RETINA())
//
//
//
//
@implementation WTUIInterface13

+(instancetype)model13
{
    return [[WTUIInterface13 alloc] init];
}

-(nullable UIWindowScene*)windowScene
{
    if (@available(iOS 13.0, *)) {
        UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
        if (firstWindow == nil) { return nil; }

        UIWindowScene *windowScene = firstWindow.windowScene;
        if (windowScene == nil){ return nil; }

        return windowScene;
    }
    
    return nil;
}

-(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR
{
    UIWindowScene *windowScene = [self windowScene];
    if (windowScene == nil){ return NO; }
    return UIInterfaceOrientationIsPortrait(windowScene.interfaceOrientation);
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR
{
    UIWindowScene *windowScene = [self windowScene];
    if (windowScene == nil){ return NO; }
    return UIInterfaceOrientationIsLandscape(windowScene.interfaceOrientation);
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
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([self UI_INTERFACE_SCALE] >= 2.0)?YES:NO);
}
-(BOOL)UI_INTERFACE_SCREEN_IS_NONRETINA
{
    return (![self UI_INTERFACE_RETINA]);
}
-(BOOL)UI_INTERFACE_SCREEN_IS_RETINA
{
    return ([self UI_INTERFACE_RETINA]);
}

-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPAD
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH
{
    return [self UI_INTERFACE_IDIOM_IS_IPHONE] && ((CGRectGetHeight([UIScreen mainScreen].bounds) * [self UI_INTERFACE_SCALE]) == 568*[self UI_INTERFACE_SCALE]);
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH
{
    return [self UI_INTERFACE_IDIOM_IS_IPHONE] && ((CGRectGetHeight([UIScreen mainScreen].bounds) * [self UI_INTERFACE_SCALE]) == 667*[self UI_INTERFACE_SCALE]);
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH
{
    return [self UI_INTERFACE_IDIOM_IS_IPHONE] && ((CGRectGetHeight([UIScreen mainScreen].bounds) * [self UI_INTERFACE_SCALE]) == 736*[self UI_INTERFACE_SCALE]);
}

-(BOOL)isStatusBarHidden
{
    return [[[self windowScene] statusBarManager] isStatusBarHidden];
}
-(UIInterfaceOrientation)statusBarOrientation
{
    UIWindowScene *windowScene = [self windowScene];
    if (windowScene == nil){ return NO; }
    return (windowScene.interfaceOrientation);
}
-(CGRect)statusBarFrame
{
    return [[[self windowScene] statusBarManager] statusBarFrame];
}

@end

#endif
