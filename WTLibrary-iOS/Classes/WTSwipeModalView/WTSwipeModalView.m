//
//  WTSwipeModalView.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 2/3/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

//#define WATLOG_DEBUG
#import "WTSwipeModalView.h"
#import "WTMacro.h"
#import <AGWindowView/AGWindowView.h>
#import <WTLibrary_iOS/WTWatLog.h>

@interface WTSwipeModalView ()
{
    
    NSNotification          *_kbShowNotification;
    CGSize                   _kbSize;
}
@property(nonatomic, assign, readonly, getter = isKeyboardShowing) BOOL  keyboardShowing;

@property (nonatomic,strong) AGWindowView *agWindow;
@property (nonatomic,assign) BOOL isShareWindow;
@property (nonatomic,getter=isShow) BOOL show;
@property (nonatomic,getter=isOriginalViewHidden) BOOL originalViewHidden;
@property (nonatomic,assign) BOOL version2;
@property (nonatomic,assign) CGSize initialContentSize;

//- (void)showFromView:(UIView*)fromView inToView:(UIView*)toView;

@end

#pragma mark -

@implementation WTSwipeModalView

+ (instancetype)BlankView
{
    WTSwipeModalView *v = [[self alloc] initView];
    v.useAdaptiveSize = NO;
    v.version2 = YES;
    return v;
}

+ (instancetype)SwipeView
{
    WTSwipeModalView *v = [[self alloc] initView];
    [v addGesture];
    v.version2 = YES;
    return v;
}

- (id)initView
{
    if(self = [super initWithFrame:CGRectZero]){
        [self setup];
        [self initialize];
        [self addUI];
    }
    return self;
}

+ (instancetype)initWithInitialFrame:(CGRect)frame
{
    return [[self alloc] initWithInitialFrame:frame];
}

- (id)initWithInitialFrame:(CGRect)frame
{
    if(self = [super initWithFrame:CGRectZero]){
        
        [self setup];
        
        // Default settings
        _bounceRange = 100;
        
        // Initial setting
        //        hidden = YES;
        //        originalImageViewHidden = YES;
        _originalViewHidden = YES;
        _showAnimation = WTSwipeModalAnimationNone;
        _hideAnimation = WTSwipeModalAnimationNone;
        _dimViewAlphaChange = YES;
        _dimViewAlphaMax = 0.5;
        
        
        [self addUI];
        [self addGesture];
    }
    
    return self;
}

- (void)setup
{
    // Initialization
//    UIScreen *screen = [UIScreen mainScreen];
//    UIWindowScene *winscene = [UIScreen mainScreen];
//    UIWindow *window = [UIScreen mainScreen];
//    view.window.windowScene.screen
    if (NO) {
//        AGWindowView *windowView = [[AGWindowView alloc] initAndAddToWindow:<#(UIWindow *)#>];
//        windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskAll;
//        _agWindow = windowView;
//        _agWindow.hidden = YES;
//        _isShareWindow = NO;
    } else {
        
        if([[AGWindowView allActiveWindowViews] count]>0){
            ;
            //            AGWindowView *windowView = [[AGWindowView alloc] initAndAddToKeyWindow];
            //            windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskLandscape;
            AGWindowView *a = [[AGWindowView allActiveWindowViews] firstObject];
            //            _agWindow = a;
            AGWindowView *windowView =  [[AGWindowView alloc] initAndAddToWindow:a.window];
            _agWindow = windowView;
            //            _agWindow.hidden = YES;
            //            _isShareWindow = YES;
        }else{
            AGWindowView *windowView = [[AGWindowView alloc] initAndAddToKeyWindow];
            windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskAll;
            _agWindow = windowView;
            _agWindow.hidden = YES;
            _isShareWindow = NO;
        }
        
    }
    
    _parentViewWindow = _agWindow;
    
    [self registerAllNotifications];
}

- (void)initialize
{
    // Default settings
    _bounceRange = 100;
    _shouldHideSourceView = NO;
    
    // Initial setting
    //        hidden = YES;
    //        originalImageViewHidden = YES;
    _originalViewHidden = YES;
    _showAnimation = WTSwipeModalAnimationNone;
    _hideAnimation = WTSwipeModalAnimationNone;
    _dimViewAlphaChange = YES;
    _dimViewAlphaMax = 0.5;
    
    _useAdaptiveSize = YES;
    _useForceMargin = NO;
    _outerMargin = UIEdgeInsetsMake(40, 40, 40, 40);
    _initialContentSize = CGSizeZero;
}

- (void)addUI
{
    // Set device height and width variables
    screenSize = self.frame.size;
    
    // Set up dim view
    dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
//    dimView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    dimView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    dimView.backgroundColor = [UIColor colorWithRed:50/255.0 green:0 blue:0 alpha:1];
    dimView.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
    dimView.userInteractionEnabled = YES;
    dimView.alpha = _dimViewAlphaMax;
    [self addSubview:dimView];
    
    // Set up scroll view
    containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
//    containerScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    containerScrollView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [containerScrollView setBounces:NO];
    [containerScrollView setShowsHorizontalScrollIndicator:YES];
    [containerScrollView setShowsVerticalScrollIndicator:YES];
    [containerScrollView setScrollEnabled:NO];
    containerScrollView.maximumZoomScale = 2;
    containerScrollView.minimumZoomScale = 0.5;
    containerScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerScrollView];
//    containerScrollView.delegate = self;
    containerScrollView.clipsToBounds = NO;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
//    containerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    containerView.backgroundColor = [UIColor clearColor];
    containerView.userInteractionEnabled = YES;
    [containerView setContentMode:UIViewContentModeScaleToFill];
    [containerScrollView addSubview:containerView];
    
    // Set up detail view
//    panGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
//    panGestureView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    panGestureView.backgroundColor = UIColorMakeWithAlpha(0, 0, 0, 0);
//    panGestureView.userInteractionEnabled = NO;
//    [panGestureView setContentMode:UIViewContentModeScaleToFill];
//    [self addSubview:panGestureView];
    
    containerScrollView.contentSize = screenSize;
}

- (void)addGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setDelaysTouchesBegan:TRUE];
    [panGesture setDelaysTouchesEnded:TRUE];
    [panGesture setCancelsTouchesInView:TRUE];
    [self addGestureRecognizer:panGesture];
    [panGesture setDelegate:self];
    
//    panGesture.cancelsTouchesInView = NO;
}
- (void)removeGesture
{
    for(UIGestureRecognizer *gesture in self.gestureRecognizers){
        [self removeGestureRecognizer:gesture];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) { //Do not override UIButton touches
        return NO;
    }
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:containerView]){
        if (touch.view.isUserInteractionEnabled && [touch.view respondsToSelector:@selector(touchesBegan:withEvent:)]){
            return NO;
        }
    }
    return YES;
}
#pragma mark - scrollview

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return imageView;
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    UIView *subView = [scrollView.subviews objectAtIndex:0];
//    
//    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
//    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
//    
//    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
//    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
//    
//    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                 scrollView.contentSize.height * 0.5 + offsetY);
//    
//    scrollView.bounces = YES;
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    if (scale == 1.0) {
//        scrollView.bounces = NO;
//        
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             photoDetailView.alpha = 1;
//                         }];
//    }
//}
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
//{
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         photoDetailView.alpha = 0;
//                     }];
//}

#pragma mark - container

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)addContent:(UIView*)contentView
{
    if (_version2) {
        containerView.autoresizesSubviews = YES;
        contentView.autoresizesSubviews = YES;
        containerView.bounds = contentView.bounds;
//        contentView.backgroundColor = UIColorMakeWithAlpha(0, 0, 0, 0);
        [containerView addSubview:contentView];
        _initialContentSize = contentView.bounds.size;
        if (_useAdaptiveSize) {
            contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        }
    } else {
        containerView.autoresizesSubviews = YES;
        contentView.autoresizesSubviews = YES;
        containerView.frame = contentView.frame;
        contentView.backgroundColor = UIColorMakeWithAlpha(0, 0, 0, 0);
        [containerView addSubview:contentView];
    }
}

- (void)bounceBackToOrigin
{
    //    CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    //    bounceAnimation.duration = 0.7;
    //    bounceAnimation.repeatCount = 0;
    //    bounceAnimation.autoreverses = YES;
    //    bounceAnimation.fillMode = kCAFillModeBackwards;
    //    bounceAnimation.removedOnCompletion = YES;
    //    bounceAnimation.additive = NO;
    //    [containerView.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    //
    //    [UIView animateWithDuration:0.1
    //                     animations:^{
//    panGestureView.alpha = 1;
    dimView.alpha = _dimViewAlphaMax;
    //                     }];
    
    //    [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.1]; // TEST
}

#pragma mark gesture

// Swipe photo up or down to close
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         panGestureView.alpha = 0;
//                     }];
    
    CGPoint translation = [recognizer translationInView:containerView];
    
    containerView.center = CGPointMake(containerView.center.x, containerView.center.y+ translation.y);
    
    speed = [recognizer velocityInView:containerView];
    [recognizer setTranslation:CGPointMake(0, 0) inView:containerView];
    
    // Fade on swipe up/down
    float rangeMax = 150.0;
    float startImageViewY = containerViewRect.origin.y;
    float containerViewY = containerView.frame.origin.y;
    float dimViewAlpha = (rangeMax - ABS(startImageViewY - containerViewY)) / rangeMax;
    dimView.alpha = _dimViewAlphaMax*dimViewAlpha;
    
    //    [self showStatusBar];// TEST
    
    // Close photo view or bounce back depending on how far picture got swiped up/down
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (containerView.frame.origin.y > containerViewRect.origin.y - _bounceRange && containerView.frame.origin.y < containerViewRect.origin.y + _bounceRange) {
            
            [UIView beginAnimations:@"RIGHT-WITH-RIGHT" context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            // Reset the frame view size
            containerView.center = CGPointMake(containerScrollView.bounds.size.width*0.5, containerScrollView.bounds.size.height*0.5);
//            containerView.frame = CGRectMake(containerViewRect.origin.x, containerViewRect.origin.y, containerViewRect.size.width, containerViewRect.size.height);
            dimView.alpha = _dimViewAlphaMax;
            
            [UIView setAnimationDelegate:self];
            
            //  Call bounce animation method
            [UIView setAnimationDidStopSelector:@selector(bounceBackToOrigin)];
            [UIView commitAnimations];
        } else {
            if (_version2) {
                if (originalView
                    &&
                    ((speed.y > 0 && CGRectGetMidY(originalViewRect)-containerView.center.y > 0)
                     || (speed.y < 0 && containerView.center.y-CGRectGetMidY(originalViewRect) > 0))) {
                    [self hideSwipeWithAnimation:WTSwipeModalAnimationTranslate];
                } else {
                    [self hideSwipeWithAnimation:WTSwipeModalAnimationPop];
                }
            } else {
//                [self hideToView:nil];
            }
            
            speed = CGPointZero;
//            if (isModal) {
//                
//                CGFloat endY;
//                
//                if (imageView.frame.origin.y < contentViewRect.origin.y - 100) {
//                    endY = 0 - contentViewRect.size.height;
//                } else {
//                    endY = deviceHeight;
//                }
//                
//                [UIView animateWithDuration:0.3
//                                 animations:^{
//                                     dimView.alpha = 0;
//                                     imageView.frame = CGRectMake(imageView.frame.origin.x, endY, imageView.frame.size.width, imageView.frame.size.height);
//                                 }];
//            } else {
//                panGestureView.alpha = 0;
//                
//                //                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//                //                animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
//                //                animation.fromValue = [NSNumber numberWithFloat:0.0f];
//                //                animation.toValue = [NSNumber numberWithFloat:startPhotoRadius];
//                //                animation.duration = 0.4;
//                //                [imageView.layer setCornerRadius:startPhotoRadius];
//                //                [imageView.layer addAnimation:animation forKey:@"cornerRadius"];
//                
//                [UIView animateWithDuration:0.4
//                                 animations:^{
//                                     dimView.alpha = 0;
//                                     containerView.frame = CGRectMake(originalViewRect.origin.x, originalViewRect.origin.y, originalViewRect.size.width, originalViewRect.size.height);
//                                 }];
            
//                [self performSelector:@selector(toggleOriginalImageView) withObject:nil afterDelay:0.4];
//            }
            
//            [self performSelector:@selector(removeSelfFromSuperview) withObject:nil afterDelay:0.4];
        }
    }
}

#pragma mark -

- (void)setOriginalViewHide:(BOOL)hide
{
//    if(self.hideOriginalView){
//        originalView.hidden = _originalViewHidden;
//        _originalViewHidden = !_originalViewHidden;
//    }else{
//        originalView.hidden = _originalViewHidden;
//        _originalViewHidden = !_originalViewHidden;
//    }
    
    if(_shouldHideSourceView){
        if(hide){
            originalView.hidden = YES;
            _originalViewHidden = originalView.hidden;
        }else{
            originalView.hidden = NO;
            _originalViewHidden = originalView.hidden;
        }
    }else{
        _originalViewHidden = originalView.hidden;
    }
}

//- (void)calculateOriginalViewInfoFromView:(UIView *)view
//{
//    originalView = view;
//
//    CGPoint origin = [view.superview convertPoint:view.frame.origin toView:_agWindow];
//
//    originalViewRect = CGRectMake(origin.x, origin.y, view.frame.size.width, view.frame.size.height);
////    originalViewRect = CGRectMake(origin.x-view.frame.size.width*0.5, origin.y-view.frame.size.height*0.5, view.frame.size.width, view.frame.size.height);
//}

- (void)calculateContainerViewInfoFromView:(UIView *)view
{
//    originalView = view;
//    
//    CGPoint origin = [view.superview convertPoint:view.frame.origin toView:nil];
//    
//    containerViewRect = CGRectMake(origin.x, origin.y, view.frame.size.width, view.frame.size.height);
    
//    containerViewRect = CGRectMake(150, 150, containerView.frame.size.width, containerView.frame.size.height);
    
    if (_version2) {
        
//        CGRect transformedFrame = CGRectApplyAffineTransform(_agWindow.frame, _agWindow.transform);
//
//        containerViewRect = CGRectMake((CGRectGetWidth(transformedFrame)-containerView.frame.size.width)*0.5,
//                                       ((CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5<20)?20:(CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5,
//                                       containerView.frame.size.width,
//                                       containerView.frame.size.height);
        
        if (_useAdaptiveSize) {
            containerView.frame = containerScrollView.bounds;
            containerScrollView.contentSize = containerView.bounds.size;
        } else {
            
        }
        containerView.backgroundColor = [UIColor orangeColor];
    } else {
        CGRect transformedFrame = CGRectApplyAffineTransform(_agWindow.frame, _agWindow.transform);
        
        containerViewRect = CGRectMake((CGRectGetWidth(transformedFrame)-containerView.frame.size.width)*0.5,
                                       ((CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5<20)?20:(CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5,
                                       containerView.frame.size.width,
                                       containerView.frame.size.height);
    }
}

#pragma mark -

//- (void)showInToScreen
//{
//    if(!_isShareWindow){
//        _agWindow.hidden = NO;
//    }
//    UIView *toView = _agWindow;
//
//    self.frame = toView.bounds;
//
//    [self setOriginalViewHide:YES];
//
//    [self calculateContainerViewInfoFromView:containerView];
//    originalView = nil;
//    originalViewRect = containerViewRect;
//
//    containerView.frame = originalViewRect;
//    containerView.alpha = 0;
//    dimView.alpha = 0;
//
//    [toView addSubview:self];
//    [toView bringSubviewToFront:self];
//    [_agWindow.superview bringSubviewToFront:_agWindow];
////    self.parentViewWindow = _agWindow;
//
//    //    [self performBlock:^{
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         self->dimView.alpha = _dimViewAlphaMax;
//                         self->containerView.alpha = 1;
//                         self->containerView.frame = containerViewRect;
//                     }
//                     completion:^(BOOL finished) {
//                         self.show = YES;
//                     }];
//}
//
//- (void)showFromViewInToScreen:(UIView*)fromView
//{
//    if(!_isShareWindow){
//    _agWindow.hidden = NO;
//    }
//    [self showFromView:fromView inToView:_agWindow];
//}
//
//- (void)showFromView:(UIView*)fromView inToView:(UIView*)toView
//{
//    self.frame = toView.bounds;
//
//    [self setOriginalViewHide:YES];
//
//    [self calculateOriginalViewInfoFromView:fromView];
//    [self calculateContainerViewInfoFromView:containerView];
//
//    containerView.frame = originalViewRect;
//    containerView.alpha = 0;
//    dimView.alpha = 0;
//
//    [toView addSubview:self];
//    [toView bringSubviewToFront:self];
//
////    [self performBlock:^{
//        [UIView animateWithDuration:0.4
//                         animations:^{
//                             self->dimView.alpha = _dimViewAlphaMax;
//                             self->containerView.alpha = 1;
//                             self->containerView.frame = containerViewRect;
//                         }
//                         completion:^(BOOL finished) {
//                             self.show = YES;
//                         }];
////    } afterDelay:0];
//}
//
//- (void)hideToOriginalView
//{
//    switch (_hideAnimation) {
//        case WTSwipeModalAnimationBottom:
//        {
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 dimView.alpha = 0;
//                                 containerView.frame = CGRectMake(containerView.frame.origin.x, screenSize.height, containerView.frame.size.width, containerView.frame.size.height);
//                             }
//                             completion:^(BOOL finished) {
//                                 _show = NO;
//                                 [self setOriginalViewHide:NO];
//                                 [self removeFromSuperview];
//                                 if(!_isShareWindow){
//                                     _agWindow.hidden = YES;
//                                 }
//                                 containerView.frame = containerViewRect;
//                                 if(_hideCompletionBlock){
//                                     _hideCompletionBlock();
//                                 }
//                             }];
//
//        }
//            break;
//        default:
//        {
//            [UIView animateWithDuration:0.4
//                             animations:^{
//                                 dimView.alpha = 0;
//                                 containerView.alpha = 0;
//                                 containerView.frame = originalViewRect;
//                             }
//                             completion:^(BOOL finished) {
//                                 _show = NO;
//                                 [self setOriginalViewHide:NO];
//                                 [self removeFromSuperview];
//                                 if(!_isShareWindow){
//                                     _agWindow.hidden = YES;
//                                 }
//                                 containerView.frame = containerViewRect;
//                                 if(_hideCompletionBlock){
//                                     _hideCompletionBlock();
//                                 }
//                             }];
//        }
//            break;
//    }
//
////    [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.1];
//}
//- (void)hideToView:(UIView*)toView
//{
//    switch (_hideAnimation) {
//        case WTSwipeModalAnimationBottom:
//        {
//            [UIView animateWithDuration:0.3
//                             animations:^{
//                                 dimView.alpha = 0;
//                                 containerView.frame = CGRectMake(containerView.frame.origin.x, screenSize.height, containerView.frame.size.width, containerView.frame.size.height);
//                             }
//                             completion:^(BOOL finished) {
//                                 [self setOriginalViewHide:NO];
//                                 [self removeFromSuperview];
//                                 if(!_isShareWindow){
//                                     _agWindow.hidden = YES;
//                                 }
//                                 containerView.frame = containerViewRect;
//                                 if(_hideCompletionBlock){
//                                     _hideCompletionBlock();
//                                 }
//                             }];
//
//        }
//            break;
//        default:
//        {
//            CGPoint calculateOrigin = CGPointMake(containerView.frame.origin.x, containerView.frame.origin.y+speed.y*0.4);
//            [UIView animateWithDuration:0.4
//                             animations:^{
//                                 dimView.alpha = 0;
//                                 containerView.alpha = 0;
//
//                                 containerView.frame = CGRectMake(calculateOrigin.x, calculateOrigin.y, originalViewRect.size.width, originalViewRect.size.height);
//
//                             }
//                             completion:^(BOOL finished) {
//                                 [self setOriginalViewHide:NO];
//                                 [self removeFromSuperview];
//                                 if(!_isShareWindow){
//                                     _agWindow.hidden = YES;
//                                 }
//                                 containerView.frame = containerViewRect;
//                                 if(_hideCompletionBlock){
//                                     _hideCompletionBlock();
//                                 }
//                             }];
//        }
//            break;
//    }
//}
//
//- (void)hideToFade
//{
//    CGPoint calculateOrigin = CGPointMake(containerView.frame.origin.x, containerView.frame.origin.y+speed.y*0.4);
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         self->dimView.alpha = 0;
//                         self->containerView.alpha = 0;
//
//                         self->containerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
//
//                     }
//                     completion:^(BOOL finished) {
//                         [self setOriginalViewHide:NO];
//                         [self removeFromSuperview];
//                         if(!_isShareWindow){
//                             _agWindow.hidden = YES;
//                         }
//                         self->containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                         self->containerView.frame = containerViewRect;
//                         if(_hideCompletionBlock){
//                             _hideCompletionBlock();
//                         }
//                     }];
//}

#pragma mark -

- (void)showSwipeFromView:(UIView*)sourceView
{
    [self showSwipeFromView:sourceView withAnimation:_showAnimation];
}

- (void)hideSwipe
{
    [self hideSwipeWithAnimation:_hideAnimation];
}

- (void)preAnimationPosition
{
    [self adjustPosition];
    
    UIView *toView = _agWindow;
    
    if (self.superview) {
        [self removeFromSuperview];
    }
    [toView addSubview:self];
    [toView bringSubviewToFront:self];
}

-(void)adjustPosition
{
    UIView *toView = _agWindow;
    
    CGRect screenRect = toView.bounds;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = toView.safeAreaInsets;
        CGRect insetScreen = UIEdgeInsetsInsetRect(screenRect, safeAreaInsets);
        screenRect = insetScreen;
    } else {
        // Fallback on earlier versions
    }
    screenRect = CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.width, screenRect.size.height - _kbSize.height);
    
    CGRect safeAreaMarginRect = UIEdgeInsetsInsetRect(screenRect, _outerMargin);
    
    self.frame = toView.bounds; // should be full screen
    CGRect safeAreaMarginBound = CGRectMake(0, 0, safeAreaMarginRect.size.width, safeAreaMarginRect.size.height);
    CGRect contentBound = CGRectMake(0, 0, _initialContentSize.width, _initialContentSize.height);
    
    BOOL isInsideInsetRect = CGRectContainsRect(safeAreaMarginBound, contentBound);
    if (_useAdaptiveSize && isInsideInsetRect) {
        containerScrollView.frame = safeAreaMarginRect; // should be inside safearea and outer margin
        containerView.frame = containerScrollView.bounds;
        containerScrollView.contentSize = containerView.bounds.size;
    } else if (_useForceMargin) {
        containerScrollView.frame = safeAreaMarginRect; // should be inside safearea and outer margin
        containerView.frame = containerScrollView.bounds;
        containerScrollView.contentSize = containerView.bounds.size;
    } else {
        containerScrollView.frame = screenRect; // should be inside safearea
        CGRect transformedFrame = screenRect;//CGRectApplyAffineTransform(_agWindow.frame, _agWindow.transform);
        containerViewRect = CGRectMake((CGRectGetWidth(transformedFrame)-containerView.frame.size.width)*0.5,
                                       ((CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5<20)?20:(CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5,
                                       containerView.frame.size.width,
                                       containerView.frame.size.height);
        containerView.frame = containerViewRect;
        containerScrollView.contentSize = containerScrollView.bounds.size;
    }
}

- (void)showSwipeFromView:(UIView*)sourceView withAnimation:(WTSwipeModalAnimation)animation
{
    if(!_isShareWindow){
        _agWindow.hidden = NO;
    }
    
    [self preAnimationPosition];
    originalView = sourceView;
    originalViewRect = [originalView.superview convertRect:originalView.frame toView:_agWindow];
    [self setOriginalViewHide:YES];
    
    if (animation == WTSwipeModalAnimationNone) {
        
        self.show = YES;
        self->dimView.alpha = self.dimViewAlphaMax;
        self->containerView.alpha = 1;
        
    } else if (animation == WTSwipeModalAnimationFade) {
        
        self.show = YES;
        self->dimView.alpha = 0;
        self->containerView.alpha = 0;
        
        [UIView animateWithDuration:0.3
                         animations:
         ^{
             self->dimView.alpha = self.dimViewAlphaMax;
             self->containerView.alpha = 1;
         }
                         completion:
         ^(BOOL finished) {
         }];
        
    } else if (animation == WTSwipeModalAnimationPop) {
        
        self.show = YES;
        self->dimView.alpha = 0;
        self->containerView.alpha = 0;
        self->containerView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        [UIView animateWithDuration:0.3
                         animations:
         ^{
             self->dimView.alpha = self.dimViewAlphaMax;
             self->containerView.alpha = 1;
             self->containerView.transform = CGAffineTransformIdentity;
         }
                         completion:
         ^(BOOL finished) {
         }];
        
    } else if (animation == WTSwipeModalAnimationTranslate) {
        
        CGPoint destinationCenter = self->containerView.center;
        CGPoint calculateCenter = [originalView.superview convertPoint:originalView.center toView:_agWindow];
        
        self.show = YES;
        self->dimView.alpha = 0;
        self->containerView.alpha = 0;
        self->containerView.center = calculateCenter;
        
        [UIView animateWithDuration:0.3
                         animations:
         ^{
             self->dimView.alpha = self.dimViewAlphaMax;
             self->containerView.alpha = 1;
             self->containerView.center = destinationCenter;
         }
                         completion:
         ^(BOOL finished) {
         }];
        
    } else {
        WatLog(@"show animation not implemented.");
    }
}

- (void)hideSwipeWithAnimation:(WTSwipeModalAnimation)animation
{
    if (animation == WTSwipeModalAnimationNone) {
        
        self.show = NO;
        self->dimView.alpha = 0;
        self->containerView.alpha = 0;
        
        [self setOriginalViewHide:NO];
        [self removeFromSuperview];
        if(!self.isShareWindow){
            self.agWindow.hidden = YES;
        }
        //self->containerView.frame = containerViewRect;
        if(self.hideCompletionBlock){
            self.hideCompletionBlock();
        }
        
    } else if (animation == WTSwipeModalAnimationFade) {
        
        self.show = NO;
        [UIView animateWithDuration:0.3
                         animations:
         ^{
             self->dimView.alpha = 0;
             self->containerView.alpha = 0;
             self->containerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
         }
                         completion:
         ^(BOOL finished) {
             [self setOriginalViewHide:NO];
             [self removeFromSuperview];
             if(!self.isShareWindow){
                 self.agWindow.hidden = YES;
             }
             self->containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
             //self->containerView.frame = containerViewRect;
             if(self.hideCompletionBlock){
                 self.hideCompletionBlock();
             }
         }];
        
    } else if (animation == WTSwipeModalAnimationPop) {
        
        [UIView animateWithDuration:0.3
                         animations:
         ^{
             self->dimView.alpha = 0;
             self->containerView.alpha = 0;
             self->containerView.transform = CGAffineTransformMakeScale(0.9, 0.9);
         }
                         completion:
         ^(BOOL finished) {
             self->containerView.transform = CGAffineTransformIdentity;
             [self setOriginalViewHide:NO];
             [self removeFromSuperview];
             if(!self.isShareWindow){
                 self.agWindow.hidden = YES;
             }
             //self->containerView.frame = containerViewRect;
             if(self.hideCompletionBlock){
                 self.hideCompletionBlock();
             }
         }];
        
    } else if (animation == WTSwipeModalAnimationTranslate) {
        
        CGPoint calculateCenter = CGPointMake(containerView.frame.origin.x, containerView.frame.origin.y+speed.y*0.4);
        if (originalView) {
            calculateCenter = [originalView.superview convertPoint:originalView.center toView:_agWindow];
        }
        
        [UIView animateWithDuration:0.3
                         animations:
         ^{
             self->dimView.alpha = 0;
             self->containerView.alpha = 0;
             self->containerView.center = calculateCenter;
         }
                         completion:
         ^(BOOL finished) {
             [self setOriginalViewHide:NO];
             [self removeFromSuperview];
             if(!self.isShareWindow){
                 self.agWindow.hidden = YES;
             }
             //containerView.frame = containerViewRect;
             if(self.hideCompletionBlock){
                 self.hideCompletionBlock();
             }
         }];
        
    } else {
        WatLog(@"hide animation not implemented.");
    }
}

-(void)registerAllNotifications
{
    //  Registering for keyboard notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //  Registering for UITextField notification.
//    [self registerTextFieldViewClass:[UITextField class]
//     didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
//       didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
//
//    //  Registering for UITextView notification.
//    [self registerTextFieldViewClass:[UITextView class]
//     didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification
//       didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
//
//    //  Registering for orientation changes notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarOrientation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:[UIApplication sharedApplication]];
}

#pragma mark - UIKeyboad Notification methods
/*  UIKeyboardWillShowNotification. */
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    _kbShowNotification = aNotification;
    
    //  Boolean to know keyboard is showing/hiding
    _keyboardShowing = YES;
    
    //  Getting keyboard animation.
//    NSInteger curve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    _animationCurve = curve<<16;
    
//    //  Getting keyboard animation duration
//    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    //Saving animation duration
//    if (duration != 0.0)    _animationDuration = duration;
    
//    CGSize oldKBSize = _kbSize;
//
    //  Getting UIKeyboardSize.
    CGRect kbFrame = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
    CGRect intersectRect = CGRectIntersection(kbFrame, screenSize);
    
    if (CGRectIsNull(intersectRect))
    {
        _kbSize = CGSizeMake(screenSize.size.width, 0);
    }
    else
    {
        _kbSize = intersectRect.size;
    }
    
//    if ([self privateIsEnabled] == NO)    return;
    
//    CFTimeInterval startTime = CACurrentMediaTime();
//    [self showLog:[NSString stringWithFormat:@"****** %@ started ******",NSStringFromSelector(_cmd)]];
    
//    UIView *textFieldView = _textFieldView;
//
//    if (textFieldView && CGPointEqualToPoint(_topViewBeginOrigin, kIQCGPointInvalid))    //  (Bug ID: #5)
//    {
//        //  keyboard is not showing(At the beginning only). We should save rootViewRect.
//        UIViewController *rootController = [textFieldView parentContainerViewController];
//        _rootViewController = rootController;
//
//        if (_rootViewControllerWhilePopGestureRecognizerActive == _rootViewController)
//        {
//            _topViewBeginOrigin = _topViewBeginOriginWhilePopGestureRecognizerActive;
//        }
//        else
//        {
//            _topViewBeginOrigin = rootController.view.frame.origin;
//        }
//
//        _rootViewControllerWhilePopGestureRecognizerActive = nil;
//        _topViewBeginOriginWhilePopGestureRecognizerActive = kIQCGPointInvalid;
//
//        [self showLog:[NSString stringWithFormat:@"Saving %@ beginning origin: %@",[rootController _IQDescription] ,NSStringFromCGPoint(_topViewBeginOrigin)]];
//    }
//
//    //If last restored keyboard size is different(any orientation accure), then refresh. otherwise not.
//    if (!CGSizeEqualToSize(_kbSize, oldKBSize))
//    {
//        //If _textFieldView is inside UIAlertView then do nothing. (Bug ID: #37, #74, #76)
//        //See notes:- https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html If it is UIAlertView textField then do not affect anything (Bug ID: #70).
//        if (_keyboardShowing == YES &&
//            textFieldView &&
//            [textFieldView isAlertViewTextField] == NO)
//        {
//            [self optimizedAdjustPosition];
//        }
//    }
//
//    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
//    [self showLog:[NSString stringWithFormat:@"****** %@ ended: %g seconds ******\n",NSStringFromSelector(_cmd),elapsedTime]];
}

/*  UIKeyboardDidShowNotification. */
- (void)keyboardDidShow:(NSNotification*)aNotification
{
//    if ([self privateIsEnabled] == NO)    return;
    
//    CFTimeInterval startTime = CACurrentMediaTime();
//    [self showLog:[NSString stringWithFormat:@"****** %@ started ******",NSStringFromSelector(_cmd)]];
    
//    UIView *textFieldView = _textFieldView;
    
    //  Getting topMost ViewController.
//    UIViewController *controller = [textFieldView topMostController];
    
    //If _textFieldView viewController is presented as formSheet, then adjustPosition again because iOS internally update formSheet frame on keyboardShown. (Bug ID: #37, #74, #76)
//    if (_keyboardShowing == YES &&
//        textFieldView &&
//        (controller.modalPresentationStyle == UIModalPresentationFormSheet || controller.modalPresentationStyle == UIModalPresentationPageSheet) &&
//        [textFieldView isAlertViewTextField] == NO)
//    {
//        [self optimizedAdjustPosition];
    
    
//    originalView = sourceView;
//    originalViewRect = [originalView.superview convertRect:originalView.frame toView:_agWindow];;
    
//    CGPoint calculateCenter = [originalView.superview convertPoint:originalView.center toView:_agWindow];
    
    self.show = YES;
//    self->containerView.center = calculateCenter;
    
    [UIView animateWithDuration:0.3
                     animations:
     ^{
         [self adjustPosition];
         CGPoint destinationCenter = self->containerView.center;
         self->containerView.center = destinationCenter;
     }
                     completion:
     ^(BOOL finished) {
     }];
    
//    }
    
//    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
//    [self showLog:[NSString stringWithFormat:@"****** %@ ended: %g seconds ******\n",NSStringFromSelector(_cmd),elapsedTime]];
}

/*  UIKeyboardWillHideNotification. So setting rootViewController to it's default frame. */
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    //If it's not a fake notification generated by [self setEnable:NO].
    if (aNotification)    _kbShowNotification = nil;
    
    //  Boolean to know keyboard is showing/hiding
    _keyboardShowing = NO;
    
    //  Getting keyboard animation duration
    CGFloat aDuration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (aDuration!= 0.0f)
    {
//        _animationDuration = aDuration;
    }
    
    //If not enabled then do nothing.
//    if ([self privateIsEnabled] == NO)    return;
    
//    CFTimeInterval startTime = CACurrentMediaTime();
//    [self showLog:[NSString stringWithFormat:@"****** %@ started ******",NSStringFromSelector(_cmd)]];
    
    //Commented due to #56. Added all the conditions below to handle UIWebView's textFields.    (Bug ID: #56)
    //  We are unable to get textField object while keyboard showing on UIWebView's textField.  (Bug ID: #11)
    //    if (_textFieldView == nil)   return;
    
    //Restoring the contentOffset of the lastScrollView
//    if (_lastScrollView)
//    {
//        __weak typeof(self) weakSelf = self;
//
//        [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
//
//            __strong typeof(self) strongSelf = weakSelf;
//
//            strongSelf.lastScrollView.contentInset = strongSelf.startingContentInsets;
//            strongSelf.lastScrollView.scrollIndicatorInsets = strongSelf.startingScrollIndicatorInsets;
//
//            if (strongSelf.lastScrollView.shouldRestoreScrollViewContentOffset)
//            {
//                strongSelf.lastScrollView.contentOffset = strongSelf.startingContentOffset;
//            }
//
//            [self showLog:[NSString stringWithFormat:@"Restoring %@ contentInset to : %@ and contentOffset to : %@",[strongSelf.lastScrollView _IQDescription],NSStringFromUIEdgeInsets(strongSelf.startingContentInsets),NSStringFromCGPoint(strongSelf.startingContentOffset)]];
//
//            // TODO: restore scrollView state
//            // This is temporary solution. Have to implement the save and restore scrollView state
//            UIScrollView *superscrollView = strongSelf.lastScrollView;
//            do
//            {
//                CGSize contentSize = CGSizeMake(MAX(superscrollView.contentSize.width, CGRectGetWidth(superscrollView.frame)), MAX(superscrollView.contentSize.height, CGRectGetHeight(superscrollView.frame)));
//
//                CGFloat minimumY = contentSize.height-CGRectGetHeight(superscrollView.frame);
//
//                if (minimumY<superscrollView.contentOffset.y)
//                {
//                    superscrollView.contentOffset = CGPointMake(superscrollView.contentOffset.x, minimumY);
//
//                    [self showLog:[NSString stringWithFormat:@"Restoring %@ contentOffset to : %@",[superscrollView _IQDescription],NSStringFromCGPoint(superscrollView.contentOffset)]];
//                }
//            } while ((superscrollView = (UIScrollView*)[superscrollView superviewOfClassType:[UIScrollView class]]));
//
//        } completion:NULL];
//    }
//
//    [self restorePosition];
//
//    //Reset all values
//    _lastScrollView = nil;
//    _kbSize = CGSizeZero;
//    _startingContentInsets = UIEdgeInsetsZero;
//    _startingScrollIndicatorInsets = UIEdgeInsetsZero;
//    _startingContentOffset = CGPointZero;
//
//    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
//    [self showLog:[NSString stringWithFormat:@"****** %@ ended: %g seconds ******\n",NSStringFromSelector(_cmd),elapsedTime]];
}

/*  UIKeyboardDidHideNotification. So topViewBeginRect can be set to CGRectZero. */
- (void)keyboardDidHide:(NSNotification*)aNotification
{
//    CFTimeInterval startTime = CACurrentMediaTime();
//    [self showLog:[NSString stringWithFormat:@"****** %@ started ******",NSStringFromSelector(_cmd)]];
    
//    _topViewBeginOrigin = kIQCGPointInvalid;
    
    _kbSize = CGSizeZero;
    
    [self adjustPosition];
    
//    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
//    [self showLog:[NSString stringWithFormat:@"****** %@ ended: %g seconds ******\n",NSStringFromSelector(_cmd),elapsedTime]];
}

//#pragma mark - UITextFieldView Delegate methods
///**  UITextFieldTextDidBeginEditingNotification, UITextViewTextDidBeginEditingNotification. Fetching UITextFieldView object. */
//-(void)textFieldViewDidBeginEditing:(NSNotification*)notification
//{
//    CFTimeInterval startTime = CACurrentMediaTime();
//    [self showLog:[NSString stringWithFormat:@"****** %@ started ******",NSStringFromSelector(_cmd)]];
//
//    //  Getting object
//    _textFieldView = notification.object;
//
//    UIView *textFieldView = _textFieldView;
//
//    if (_overrideKeyboardAppearance == YES)
//    {
//        UITextField *textField = (UITextField*)textFieldView;
//
//        if ([textField respondsToSelector:@selector(keyboardAppearance)])
//        {
//            //If keyboard appearance is not like the provided appearance
//            if (textField.keyboardAppearance != _keyboardAppearance)
//            {
//                //Setting textField keyboard appearance and reloading inputViews.
//                textField.keyboardAppearance = _keyboardAppearance;
//                [textField reloadInputViews];
//            }
//        }
//    }
//
//    //If autoToolbar enable, then add toolbar on all the UITextField/UITextView's if required.
//    if ([self privateIsEnableAutoToolbar])
//    {
//        //UITextView special case. Keyboard Notification is firing before textView notification so we need to reload it's inputViews.
//        if ([textFieldView isKindOfClass:[UITextView class]] &&
//            textFieldView.inputAccessoryView == nil)
//        {
//            __weak typeof(self) weakSelf = self;
//
//            [UIView animateWithDuration:0.00001 delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
//                [self addToolbarIfRequired];
//            } completion:^(BOOL finished) {
//
//                __strong typeof(self) strongSelf = weakSelf;
//
//                //On textView toolbar didn't appear on first time, so forcing textView to reload it's inputViews.
//                [strongSelf.textFieldView reloadInputViews];
//            }];
//        }
//        //Else adding toolbar
//        else
//        {
//            [self addToolbarIfRequired];
//        }
//    }
//    else
//    {
//        [self removeToolbarIfRequired];
//    }
//
//    //Adding Geture recognizer to window    (Enhancement ID: #14)
//    [_resignFirstResponderGesture setEnabled:[self privateShouldResignOnTouchOutside]];
//    [textFieldView.window addGestureRecognizer:_resignFirstResponderGesture];
//
//    if ([self privateIsEnabled] == YES)
//    {
//        if (CGPointEqualToPoint(_topViewBeginOrigin, kIQCGPointInvalid))    //  (Bug ID: #5)
//        {
//            //  keyboard is not showing(At the beginning only).
//            UIViewController *rootController = [textFieldView parentContainerViewController];
//            _rootViewController = rootController;
//
//            if (_rootViewControllerWhilePopGestureRecognizerActive == _rootViewController)
//            {
//                _topViewBeginOrigin = _topViewBeginOriginWhilePopGestureRecognizerActive;
//            }
//            else
//            {
//                _topViewBeginOrigin = rootController.view.frame.origin;
//            }
//
//            _rootViewControllerWhilePopGestureRecognizerActive = nil;
//            _topViewBeginOriginWhilePopGestureRecognizerActive = kIQCGPointInvalid;
//
//            [self showLog:[NSString stringWithFormat:@"Saving %@ beginning origin: %@",[rootController _IQDescription], NSStringFromCGPoint(_topViewBeginOrigin)]];
//        }
//
//        //If textFieldView is inside UIAlertView then do nothing. (Bug ID: #37, #74, #76)
//        //See notes:- https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html If it is UIAlertView textField then do not affect anything (Bug ID: #70).
//        if (_keyboardShowing == YES &&
//            textFieldView &&
//            [textFieldView isAlertViewTextField] == NO)
//        {
//            //  keyboard is already showing. adjust frame.
//            [self optimizedAdjustPosition];
//        }
//    }
//
//    //    if ([textFieldView isKindOfClass:[UITextField class]])
//    //    {
//    //        [(UITextField*)textFieldView addTarget:self action:@selector(editingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    //    }
//
//    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
//    [self showLog:[NSString stringWithFormat:@"****** %@ ended: %g seconds ******\n",NSStringFromSelector(_cmd),elapsedTime]];
//}
//
///**  UITextFieldTextDidEndEditingNotification, UITextViewTextDidEndEditingNotification. Removing fetched object. */
//-(void)textFieldViewDidEndEditing:(NSNotification*)notification
//{
//    CFTimeInterval startTime = CACurrentMediaTime();
//    [self showLog:[NSString stringWithFormat:@"****** %@ started ******",NSStringFromSelector(_cmd)]];
//
//    UIView *textFieldView = _textFieldView;
//
//    //Removing gesture recognizer   (Enhancement ID: #14)
//    [textFieldView.window removeGestureRecognizer:_resignFirstResponderGesture];
//
//    //    if ([textFieldView isKindOfClass:[UITextField class]])
//    //    {
//    //        [(UITextField*)textFieldView removeTarget:self action:@selector(editingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    //    }
//
//    // We check if there's a change in original frame or not.
//    if(_isTextViewContentInsetChanged == YES &&
//       [textFieldView isKindOfClass:[UITextView class]])
//    {
//        UITextView *textView = (UITextView*)textFieldView;
//
//        __weak typeof(self) weakSelf = self;
//
//        [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
//
//            __strong typeof(self) strongSelf = weakSelf;
//
//            strongSelf.isTextViewContentInsetChanged = NO;
//
//            [self showLog:[NSString stringWithFormat:@"Restoring %@ textView.contentInset to : %@",[strongSelf.textFieldView _IQDescription],NSStringFromUIEdgeInsets(strongSelf.startingTextViewContentInsets)]];
//
//            //Setting textField to it's initial contentInset
//            textView.contentInset = strongSelf.startingTextViewContentInsets;
//            textView.scrollIndicatorInsets = strongSelf.startingTextViewScrollIndicatorInsets;
//
//        } completion:NULL];
//    }
//
//    //Setting object to nil
//    _textFieldView = nil;
//
//    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
//    [self showLog:[NSString stringWithFormat:@"****** %@ ended: %g seconds ******\n",NSStringFromSelector(_cmd),elapsedTime]];
//}

//-(void)editingDidEndOnExit:(UITextField*)textField
//{
//    [self showLog:[NSString stringWithFormat:@"ReturnKey %@",NSStringFromSelector(_cmd)]];
//}

@end
