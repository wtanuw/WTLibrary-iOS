//
//  WTUIInterface.m
//  Pods
//
//  Created by Wat Wongtanuwat on 1/12/2567 BE.
//
//

#import "WTUIInterface.h"
#import <AvailabilityVersions.h>
#import "WTMacro.h"
#import "WTUIInterfaceBase.h"
#import "WTUIInterface13.h"
#import "WTUIInterface16.h"
#import "WTVersion.h"

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#define WTLibrary_iOS_WTUIInterface_VERSION 0x00030024
#define WTLibrary_iOS_WTUIInterface_API_VERSION_16 __IPHONE_16_0
#define WTLibrary_iOS_WTUIInterface_API_VERSION_13 __IPHONE_13_0

@interface WTUIInterface()

@property (nonatomic, strong) WTUIInterfaceBase<WTUIInterfaceProtocol> *sub;

@end
//
////#define UI_INTERFACE_RETINA()               ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))?1:0
////#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!UI_INTERFACE_RETINA())
////#define UI_INTERFACE_SCREEN_IS_RETINA()     (UI_INTERFACE_RETINA())
//
//
//
//
@implementation WTUIInterface

+ (instancetype)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

//+ (instancetype)bundleInfoWithBundle:(NSBundle*)bundle
//{
//    return [[self alloc] initWithBundle:bundle];
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize2];
    }
    return self;
}

- (void)initialize {
#if IS_IOS_BASE_SDK_ATLEAST(WTLibrary_iOS_WTUIInterface_API_VERSION_16)
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_16)
    if (@available(iOS 16.0, *))
#endif
    {
      self.sub = [WTUIInterface16 model16];
    }
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_16)
    else
#endif
#endif
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_16)
#if IS_IOS_BASE_SDK_ATLEAST(WTLibrary_iOS_WTUIInterface_API_VERSION_13)
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_13)
    if (@available(iOS 13.0, *))
#endif
    {
        self.sub = [WTUIInterface13 model13];
    }
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_13)
    else
#endif
#endif
#endif
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_13)
    {
        self.sub = [WTUIInterfaceBase model];
    }
#endif
}
- (void)initialize2 {
#if IS_IOS_BASE_SDK_ATLEAST(WTLibrary_iOS_WTUIInterface_API_VERSION_16)
    if (@available(iOS 16.0, *))
    {
      self.sub = [WTUIInterface16 model16];
    }
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_16)
    else
#endif
#endif
        
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_16)
#if IS_IOS_BASE_SDK_ATLEAST(WTLibrary_iOS_WTUIInterface_API_VERSION_13)
    if (@available(iOS 13.0, *))
    {
        self.sub = [WTUIInterface13 model13];
    }
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_13)
    else
#endif
#endif
#endif
        
#if IS_IOS_DEPLOY_TARGET_BELOW(WTLibrary_iOS_WTUIInterface_API_VERSION_13)
    {
        self.sub = [WTUIInterfaceBase model];
    }
#endif
}

+(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR];
}
+(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR];
}
+(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_PORTRAIT];
}
+(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_LANDSCAPE];
}

+(BOOL)UI_INTERFACE_SCALE
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_LANDSCAPE];
}
+(BOOL)UI_INTERFACE_RETINA
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_LANDSCAPE];
}
+(BOOL)UI_INTERFACE_SCREEN_IS_NONRETINA
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_LANDSCAPE];
}
+(BOOL)UI_INTERFACE_SCREEN_IS_RETINA
{
    return [[self sharedManager] UI_INTERFACE_ORIENTATION_IS_LANDSCAPE];
}

+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE
{
    return [[self sharedManager] UI_INTERFACE_IDIOM_IS_IPHONE];
}
+(BOOL)UI_INTERFACE_IDIOM_IS_IPAD
{
    return [[self sharedManager] UI_INTERFACE_IDIOM_IS_IPAD];
}
+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH
{
    return [[self sharedManager] UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH];
}
+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH
{
    return [[self sharedManager] UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH];
}
+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH
{
    return [[self sharedManager] UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH];
}

+(id)UI_INTERFACE_IDIOM_PHONE:(id)phone PAD:(id)pad;
{
    return [self UI_INTERFACE_IDIOM_IS_IPHONE] ? phone : pad;
}

+(BOOL)isStatusBarHidden
{
    return [[self sharedManager] isStatusBarHidden];
}
+(UIInterfaceOrientation)statusBarOrientation
{
    return [[self sharedManager] statusBarOrientation];
}
+(CGRect)statusBarFrame
{
    return [[self sharedManager] statusBarFrame];
}

-(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR
{
    return [self.sub UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR];
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR
{
    return [self.sub UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR];
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT
{
    return [self.sub UI_INTERFACE_ORIENTATION_IS_PORTRAIT];
}
-(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE
{
    return [self.sub UI_INTERFACE_ORIENTATION_IS_LANDSCAPE];
}

-(BOOL)UI_INTERFACE_SCALE
{
    return [self.sub UI_INTERFACE_SCALE];
}
-(BOOL)UI_INTERFACE_RETINA
{
    return [self.sub UI_INTERFACE_RETINA];
}
-(BOOL)UI_INTERFACE_SCREEN_IS_NONRETINA
{
    return [self.sub UI_INTERFACE_SCREEN_IS_NONRETINA];
}
-(BOOL)UI_INTERFACE_SCREEN_IS_RETINA
{
    return [self.sub UI_INTERFACE_SCREEN_IS_RETINA];
}

-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE
{
    return [self.sub UI_INTERFACE_IDIOM_IS_IPHONE];
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPAD
{
    return [self.sub UI_INTERFACE_IDIOM_IS_IPAD];
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH
{
    return [self.sub UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH];
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH
{
    return [self.sub UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH];
}
-(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH
{
    return [self.sub UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH];
}

-(BOOL)isStatusBarHidden
{
    return [self.sub isStatusBarHidden];
}
-(UIInterfaceOrientation)statusBarOrientation
{
    return [self.sub statusBarOrientation];
}
-(CGRect)statusBarFrame
{
    return [self.sub statusBarFrame];
}

@end
