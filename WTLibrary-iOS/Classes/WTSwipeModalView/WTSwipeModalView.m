//
//  WTSwipeModalView.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 2/3/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import "WTSwipeModalView.h"
#import "WTMacro.h"
#import <AGWindowView/AGWindowView.h>

@interface WTSwipeModalView ()

@property (nonatomic,strong) AGWindowView *agWindow;
@property (nonatomic,assign) BOOL isShareWindow;

@end

@implementation WTSwipeModalView

- (id)initWithInitialFrame:(CGRect)frame
{
    if(self = [super initWithFrame:CGRectZero]){
        // Initialization
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
        
        _parentViewWindow = _agWindow;
        
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
    containerScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [containerScrollView setBounces:NO];
    [containerScrollView setShowsHorizontalScrollIndicator:YES];
    [containerScrollView setShowsVerticalScrollIndicator:YES];
    [containerScrollView setScrollEnabled:NO];
    containerScrollView.maximumZoomScale = 2;
    containerScrollView.minimumZoomScale = 0.5;
    containerScrollView.backgroundColor = [UIColor colorWithRed:0.0 green:50/255.0 blue:0 alpha:1];
    containerScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerScrollView];
    containerScrollView.delegate = self;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
//    containerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    containerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:50/255.0 alpha:1];
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

#pragma mark - gesture

// Swipe photo up or down to close
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         panGestureView.alpha = 0;
                     }];
    
    CGPoint translation = [recognizer translationInView:containerView];
    
    containerView.center=CGPointMake(containerView.center.x, containerView.center.y+ translation.y);
    
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
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            // Reset the frame view size
            containerView.frame = CGRectMake(containerViewRect.origin.x, containerViewRect.origin.y, containerViewRect.size.width, containerViewRect.size.height);
            dimView.alpha = _dimViewAlphaMax;
            
            [UIView setAnimationDelegate:self];
            
            //  Call bounce animation method
            [UIView setAnimationDidStopSelector:@selector(bounceBackToOrigin)];
            [UIView commitAnimations];
        } else {
            [self hideToView:nil];
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
                         panGestureView.alpha = 1;
                         dimView.alpha = _dimViewAlphaMax;
//                     }];
    
//    [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.1]; // TEST
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
    
    if(self.hideOriginalView){
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

- (void)calculateOriginalViewInfoFromView:(UIView *)view
{
    originalView = view;
    
    CGPoint origin = [view.superview convertPoint:view.frame.origin toView:_agWindow];
    
    originalViewRect = CGRectMake(origin.x, origin.y, view.frame.size.width, view.frame.size.height);
//    originalViewRect = CGRectMake(origin.x-view.frame.size.width*0.5, origin.y-view.frame.size.height*0.5, view.frame.size.width, view.frame.size.height);
}

- (void)calculateContainerViewInfoFromView:(UIView *)view
{
//    originalView = view;
//    
//    CGPoint origin = [view.superview convertPoint:view.frame.origin toView:nil];
//    
//    containerViewRect = CGRectMake(origin.x, origin.y, view.frame.size.width, view.frame.size.height);
    
//    containerViewRect = CGRectMake(150, 150, containerView.frame.size.width, containerView.frame.size.height);
    
    CGRect transformedFrame = CGRectApplyAffineTransform(_agWindow.frame, _agWindow.transform);
    
    containerViewRect = CGRectMake((CGRectGetWidth(transformedFrame)-containerView.frame.size.width)*0.5,
                                   ((CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5<20)?20:(CGRectGetHeight(transformedFrame)-containerView.frame.size.height)*0.5,
                                   containerView.frame.size.width,
                                   containerView.frame.size.height);
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)addContent:(UIView*)contentView
{
    containerView.autoresizesSubviews = YES;
    contentView.autoresizesSubviews = YES;
    containerView.frame = contentView.frame;
    contentView.backgroundColor = UIColorMakeWithAlpha(0, 0, 0, 0);
    [containerView addSubview:contentView];
//    contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}

- (void)showInToScreen
{
    if(!_isShareWindow){
        _agWindow.hidden = NO;
    }
    UIView *toView = _agWindow;
    
    self.frame = toView.bounds;
    
    [self setOriginalViewHide:YES];
    
    [self calculateContainerViewInfoFromView:containerView];
    originalView = nil;
    originalViewRect = containerViewRect;
    
    containerView.frame = originalViewRect;
    containerView.alpha = 0;
    dimView.alpha = 0;
    
    [toView addSubview:self];
    [toView bringSubviewToFront:self];
    [_agWindow.superview bringSubviewToFront:_agWindow];
//    self.parentViewWindow = _agWindow;
    
    //    [self performBlock:^{
    [UIView animateWithDuration:0.4
                     animations:^{
                         dimView.alpha = _dimViewAlphaMax;
                         containerView.alpha = 1;
                         containerView.frame = containerViewRect;
                     }
                     completion:^(BOOL finished) {
                         _show = YES;
                     }];
}

- (void)showFromViewInToScreen:(UIView*)fromView
{
    if(!_isShareWindow){
    _agWindow.hidden = NO;
    }
    [self showFromView:fromView inToView:_agWindow];
}
- (void)showFromView:(UIView*)fromView inToView:(UIView*)toView
{
    self.frame = toView.bounds;
    
    [self setOriginalViewHide:YES];
    
    [self calculateOriginalViewInfoFromView:fromView];
    [self calculateContainerViewInfoFromView:containerView];
    
    containerView.frame = originalViewRect;
    containerView.alpha = 0;
    dimView.alpha = 0;
    
    [toView addSubview:self];
    [toView bringSubviewToFront:self];
    
//    [self performBlock:^{
        [UIView animateWithDuration:0.4
                         animations:^{
                             dimView.alpha = _dimViewAlphaMax;
                             containerView.alpha = 1;
                             containerView.frame = containerViewRect;
                         }
                         completion:^(BOOL finished) {
                             _show = YES;
                         }];
//    } afterDelay:0];
}

- (void)hideToOriginalView
{
    switch (_hideAnimation) {
        case WTSwipeModalAnimationBottom:
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 dimView.alpha = 0;
                                 containerView.frame = CGRectMake(containerView.frame.origin.x, screenSize.height, containerView.frame.size.width, containerView.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                                 _show = NO;
                                 [self setOriginalViewHide:NO];
                                 [self removeFromSuperview];
                                 if(!_isShareWindow){
                                     _agWindow.hidden = YES;
                                 }
                                 containerView.frame = containerViewRect;
                                 if(_hideCompletionBlock){
                                     _hideCompletionBlock();
                                 }
                             }];
            
        }
            break;
        default:
        {
            [UIView animateWithDuration:0.4
                             animations:^{
                                 dimView.alpha = 0;
                                 containerView.alpha = 0;
                                 containerView.frame = originalViewRect;
                             }
                             completion:^(BOOL finished) {
                                 _show = NO;
                                 [self setOriginalViewHide:NO];
                                 [self removeFromSuperview];
                                 if(!_isShareWindow){
                                     _agWindow.hidden = YES;
                                 }
                                 containerView.frame = containerViewRect;
                                 if(_hideCompletionBlock){
                                     _hideCompletionBlock();
                                 }
                             }];
        }
            break;
    }
    
//    [self performSelector:@selector(toggleStatusBar) withObject:nil afterDelay:0.1];
}
- (void)hideToView:(UIView*)toView
{
    switch (_hideAnimation) {
        case WTSwipeModalAnimationBottom:
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 dimView.alpha = 0;
                                 containerView.frame = CGRectMake(containerView.frame.origin.x, screenSize.height, containerView.frame.size.width, containerView.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                                 [self setOriginalViewHide:NO];
                                 [self removeFromSuperview];
                                 if(!_isShareWindow){
                                     _agWindow.hidden = YES;
                                 }
                                 containerView.frame = containerViewRect;
                                 if(_hideCompletionBlock){
                                     _hideCompletionBlock();
                                 }
                             }];
            
        }
            break;
        default:
        {
            CGPoint calculateOrigin = CGPointMake(containerView.frame.origin.x, containerView.frame.origin.y+speed.y*0.4);
            [UIView animateWithDuration:0.4
                             animations:^{
                                 dimView.alpha = 0;
                                 containerView.alpha = 0;
                                 
                                 containerView.frame = CGRectMake(calculateOrigin.x, calculateOrigin.y, originalViewRect.size.width, originalViewRect.size.height);
                                 
                             }
                             completion:^(BOOL finished) {
                                 [self setOriginalViewHide:NO];
                                 [self removeFromSuperview];
                                 if(!_isShareWindow){
                                     _agWindow.hidden = YES;
                                 }
                                 containerView.frame = containerViewRect;
                                 if(_hideCompletionBlock){
                                     _hideCompletionBlock();
                                 }
                             }];
        }
            break;
    }
}

- (void)hideToFade
{
    CGPoint calculateOrigin = CGPointMake(containerView.frame.origin.x, containerView.frame.origin.y+speed.y*0.4);
    [UIView animateWithDuration:0.4
                     animations:^{
                         dimView.alpha = 0;
                         containerView.alpha = 0;
                         
                         containerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         
                     }
                     completion:^(BOOL finished) {
                         [self setOriginalViewHide:NO];
                         [self removeFromSuperview];
                         if(!_isShareWindow){
                             _agWindow.hidden = YES;
                         }
                         containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         containerView.frame = containerViewRect;
                         if(_hideCompletionBlock){
                             _hideCompletionBlock();
                         }
                     }];
}

#pragma mark -

@end
