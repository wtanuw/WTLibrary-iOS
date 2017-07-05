//
//  WTHud.h
//  IkuyokuruyoShame
//
//  Created by Wat Wongtanuwat on 11/5/12.
//  Copyright (c) 2012 Wat Wongtanuwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>
#import "WTMacro.h"

#define WTHud_VERSION VERSIONHEX_FROM_DECIMAL(2,0,0)
//#define WTMacro_VERSION 0x00020001


@class WTHud;

@protocol WTHudDelegate
@optional
- (void)WTHud:(WTHud*)hud isTouchInside:(BOOL)inside;
- (void)WTHudWillShow:(WTHud*)hud;
- (void)WTHudDidShow:(WTHud*)hud;
- (void)WTHudWillHide:(WTHud*)hud;
- (void)WTHudDidHide:(WTHud*)hud;
@end

enum {
    WTHudMaskTypeNone,      // can touch through
    WTHudMaskTypeClear,     // cannot touch through
    WTHudMaskTypeHalfBlack, // cannot touch through
    WTHudMaskTypeGradient,  // cannot touch through
//    WTHudMaskTypeBlur,    //
};
typedef NSUInteger WTHudMaskType;

enum {
    WTHudPositionTypeCenter,// center of screen
//    WTHudPositionTypeCornerNW,
//    WTHudPositionTypeCornerNE,
//    WTHudPositionTypeCornerSW,
//    WTHudPositionTypeCornerSE
    WTHudPositionTypeCustom,// use hudContainerFrame
};
typedef NSUInteger WTHudPositionType;

enum {
    WTHudHudTypeOpaqe,      // can see hudview background
//    WTHudHudTypeTranslucent,//
//    WTHudHudTypeSolid,    //
    WTHudHudTypeClear,      // cannot see hudview background
    WTHudHudTypeCustom,       // cannot see all hudview and use custom
};
typedef NSUInteger WTHudHudType;

enum {
    WTHudAnimationTypeNone,//
    WTHudAnimationTypeZoomOutZoomOut,
//    WTHudAnimationTypeZoomOutZoomIn,
//    WTHudAnimationTypeZoomInZoomOut,
//    WTHudAnimationTypeZoomInZoomOut,
    WTHudAnimationTypeFade,
};
typedef NSUInteger WTHudAnimationType;

@interface WTHud : UIView
{
    UIView *hudContainer;
    UIView *overlayView;
    //////
    BOOL sharedHud;
    
    __unsafe_unretained id<WTHudDelegate> hudDelegate;
    WTHudMaskType hudMaskType;
    WTHudPositionType hudPositionType;
    WTHudHudType hudHudType;
    WTHudAnimationType hudAnimationType;
    CGSize hudSize;
    CGSize cornerOffset; // with WTHudPositionTypeAtCorner
    BOOL callDelegateWhenTouchBegan;
    BOOL callDelegateWhenTouchEnded;
    
    BOOL animation;
    
    
    NSTimer *fadeOutTimer;
    
    UIWindow *overlayWindow;
    UIView *hudView;
    UILabel *stringLabel;
    UIImageView *imageView;
    UIActivityIndicatorView *indicatorView;
    CGFloat visibleKeyboardHeight;
}
@property (nonatomic, retain, readonly) UIView *overlayView;
@property (nonatomic, retain, readonly) UIWindow *overlayWindow;
@property (nonatomic, getter = isAnimation, readonly) BOOL animation;

//+ (id)sharedManager;
+ (WTHud*)sharedManager;

+ (void)showHud;
+ (void)showHudWithDefaultMode;
+ (void)dismissHud;
+ (void)dismissHudAfterDelay:(NSTimeInterval)delay;
// stops the activity indicator, shows a glyph + status, and dismisses HUD 1s later
//+ (void)dismissWithSuccess:(NSString*)string;
//+ (void)dismissWithError:(NSString*)string;

// set
+ (void)setHudDelegate:(NSObject<WTHudDelegate>*)delegate;
+ (void)setHudMaskType:(WTHudMaskType)maskType;
+ (void)setHudPositionType:(WTHudPositionType)positionType;
+ (void)setHudHudType:(WTHudHudType)hudType;
+ (void)setHudAnimationType:(WTHudAnimationType)animationType;
+ (void)setHudSize:(CGSize)hudSize;
+ (void)setCornerOffset:(CGSize)pointOffset;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing
+ (void)setImage:(UIImage*)image; // use 28x28 white pngs
+ (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

// check
+ (BOOL)isVisible;
+ (BOOL)isAnimation;

//////

- (id)initWithView:(UIView*)view;

- (void)showHud;
- (void)showHudWithDefaultMode;
- (void)showHudToView:(UIView*)view;
- (void)dismissHud;
- (void)dismissHudAfterDelay:(NSTimeInterval)delay;

- (void)setHudDelegate:(id<WTHudDelegate>)delegate;
- (void)setHudMaskType:(WTHudMaskType)maskType;
- (void)setHudPositionType:(WTHudPositionType)positionType;
- (void)setHudHudType:(WTHudHudType)hudType;
- (void)setHudAnimationType:(WTHudAnimationType)animationType;
- (void)setHudSize:(CGSize)hudSize;
- (void)setCornerOffset:(CGSize)pointOffset;

- (void)setStatus:(NSString*)string;
- (void)setImage:(UIImage*)image;
- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle;

- (BOOL)isVisible;
- (BOOL)isAnimation;
- (UIView*)hudContainer;//override

////

- (UIView*)hudViewCustom;//override
- (CGRect)hudFrameCustomWhenShow;//override
- (CGRect)hudFrameCustomWhenHide;//override

- (void)startAnimateIndicator;//can override
- (void)stopAnimateIndicator;//can override

@end
