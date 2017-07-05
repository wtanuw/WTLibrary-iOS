//
//  WTSwipeModalView.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 2/3/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGWindowView.h"

#define WTSwipeModalView_VERSION 0x00010000

typedef NS_ENUM(NSUInteger, WTSwipeModalAnimation)
{
    WTSwipeModalAnimationNone = 0,
    WTSwipeModalAnimationDefault = 1,
    WTSwipeModalAnimationFade = 1,
    WTSwipeModalAnimationPop = 2,
    WTSwipeModalAnimationBottom,
    WTSwipeModalAnimationSlide,
};

@interface WTSwipeModalView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIView *dimView;
    
    UIScrollView *containerScrollView;
    
    UIView *panGestureView;
    CGPoint speed;
    
    UIView *containerView;
    CGRect containerViewRect;
    
    UIView *originalView;
    CGRect originalViewRect;
    
    CGSize screenSize;
}

@property (nonatomic,assign) float bounceRange;//
@property float doubleTapZoomScale;
@property float maxZoomScale;
@property float minZoomScale;
@property (nonatomic,assign) WTSwipeModalAnimation showAnimation;
@property (nonatomic,assign) WTSwipeModalAnimation hideAnimation;
@property (nonatomic,readonly,getter=isShow) BOOL show;
@property (nonatomic,assign) BOOL hideOriginalView;
@property (nonatomic,readonly,getter=isOriginalHidden) BOOL originalViewHidden;
@property (nonatomic,readonly) AGWindowView *parentViewWindow;
@property (nonatomic,assign) BOOL dimViewAlphaChange;
@property (nonatomic,assign) float dimViewAlphaMax;
@property (nonatomic,copy) void (^hideCompletionBlock)();

- (id)initWithInitialFrame:(CGRect)frame;

- (void)addGesture;
- (void)removeGesture;

- (void)addContent:(UIView*)contentView;

- (void)showInToScreen;
- (void)showFromViewInToScreen:(UIView*)fromView;
- (void)showFromView:(UIView*)fromView inToView:(UIView*)toView;

- (void)hideToOriginalView;
- (void)hideToView:(UIView*)toView;
- (void)hideToFade;
@end

@protocol WTSwipeModalViewProtocal <NSObject>

- (void)loadView;
- (void)showFromView:(UIView*)view;
- (void)hide;

@end
