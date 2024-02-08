//
//  WTSwipeModalView.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 2/3/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGWindowView/AGWindowView.h>

#define WTSwipeModalView_VERSION 0x00010000

typedef NS_ENUM(NSUInteger, WTSwipeModalAnimation)
{
    WTSwipeModalAnimationNone = 0,
//    WTSwipeModalAnimationDefault = 1,
    WTSwipeModalAnimationFade = 1, //FadeIn, FadeOut
    WTSwipeModalAnimationPop = 2, //
    WTSwipeModalAnimationBottom, //
//    WTSwipeModalAnimationSlide,
//    WTSwipeModalAnimationTransformScale, //
    WTSwipeModalAnimationTranslate, //
};

@interface WTSwipeModalView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIView *dimView;
    
    UIScrollView *containerScrollView;
    
//    UIView *panGestureView;
    CGPoint speed;
    
    UIView *containerView;
    CGRect containerViewRect;
    
    UIView *originalView;
    CGRect originalViewRect;
    
    CGSize screenSize;
}

@property (nonatomic,assign) float bounceRange;//
//@property float doubleTapZoomScale;
//@property float maxZoomScale;
//@property float minZoomScale;
@property (nonatomic,assign) WTSwipeModalAnimation showAnimation;
@property (nonatomic,assign) WTSwipeModalAnimation hideAnimation;
@property (nonatomic,readonly,getter=isShow) BOOL show;

@property (nonatomic,assign) BOOL shouldHideSourceView;
@property (nonatomic,readonly,getter=isOriginalViewHidden) BOOL originalViewHidden;
@property (nonatomic,readonly) AGWindowView *parentViewWindow;
@property (nonatomic,assign) BOOL dimViewAlphaChange;
@property (nonatomic,assign) float dimViewAlphaMax;
@property (nonatomic,copy) void (^hideCompletionBlock)(void);

@property (nonatomic,assign) BOOL useAdaptiveSize;
@property (nonatomic,assign) BOOL useForceMargin;
@property (nonatomic,assign) UIEdgeInsets outerMargin;

+ (instancetype)BlankView; //without gesture
+ (instancetype)SwipeView; //with gesture
- (id)initWithInitialFrame:(CGRect)frame;

- (void)addGesture;
- (void)removeGesture;

- (void)showSwipeFromView:(UIView*)sourceView;
- (void)hideSwipe;
- (void)showSwipeFromView:(UIView*)sourceView withAnimation:(WTSwipeModalAnimation)animation;
- (void)hideSwipeWithAnimation:(WTSwipeModalAnimation)animation;

- (void)addContent:(UIView*)contentView;

//- (void)showInToScreen DEPRECATED_MSG_ATTRIBUTE("Use show or show: instead.");
//- (void)showFromViewInToScreen:(UIView*)fromView DEPRECATED_MSG_ATTRIBUTE("Use show or show: instead.");
//
//- (void)hideToOriginalView DEPRECATED_MSG_ATTRIBUTE("Use hide or hide: instead.");
//- (void)hideToView:(UIView*)toView DEPRECATED_MSG_ATTRIBUTE("Use hide or hide: instead.");
//- (void)hideToFade DEPRECATED_MSG_ATTRIBUTE("Use hide or hide: instead.");

@end

@protocol WTSwipeModalViewProtocal <NSObject>

- (void)loadView;
- (void)showFromView:(UIView*)view;
- (void)hide;

@end
