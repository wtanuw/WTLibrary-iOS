//
//  WTModalPanel.m
//  SoundSamplerAPP
//
//  Created by Wat Wongtanuwat on 9/3/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "WTModalPanel.h"
//#import "UARoundedRectView.h"

#define DEFAULT_MARGIN				20.0f
#define DEFAULT_BACKGROUND_COLOR	[UIColor colorWithWhite:0.0 alpha:0.8]
#define DEFAULT_CORNER_RADIUS		4.0f
#define DEFAULT_BORDER_WIDTH		1.5f
#define DEFAULT_BORDER_COLOR		[UIColor whiteColor]
#define DEFAULT_BOUNCE				YES

@interface WTModalPanel ()
//subcalsses override
- (void)panRatioChange:(CGFloat)ratio;
- (void)panIsBegan:(BOOL)began isEnded:(BOOL)ended;
- (void)showAnimationStarting;
- (void)showAnimationPart1Finished;
- (void)showAnimationPart2Finished;
- (void)showAnimationPart3Finished;
- (void)showAnimationFinished;
@end

@implementation WTModalPanel

@synthesize roundedRect, closeButton, delegate, contentView, contentContainer, dimBgView;
@synthesize innerMargin, outerMargin, cornerRadius, borderWidth, borderColor, contentColor, shouldBounce;
@synthesize onClosePressed;
@synthesize hideAndRemove;
@synthesize style, fingerGrabHandleSize, touchEndRatioToShow, touchEndRatioToHide, showedRatio;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		delegate = nil;
		roundedRect = nil;
		closeButton = nil;
		contentView = nil;
        dimBgView = nil;
		startEndPoint = CGPointZero;
		
		outerMargin = DEFAULT_MARGIN;
		innerMargin = DEFAULT_MARGIN;
		cornerRadius = DEFAULT_CORNER_RADIUS;
		borderWidth = DEFAULT_BORDER_WIDTH;
		borderColor = WT_SAFE_ARC_RETAIN(DEFAULT_BORDER_COLOR);
		contentColor = WT_SAFE_ARC_RETAIN(DEFAULT_BACKGROUND_COLOR);
		shouldBounce = DEFAULT_BOUNCE;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;
		
        self.dimBgView = WT_SAFE_ARC_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
		self.dimBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.dimBgView.autoresizesSubviews = YES;
        [self addSubview:self.dimBgView];
        
		self.contentContainer = WT_SAFE_ARC_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
		self.contentContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.contentContainer.autoresizesSubviews = YES;
		[self addSubview:self.contentContainer];
        
		[self.dimBgView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]]; // Fixed value, the background mask.
        
		[contentView setBackgroundColor:[UIColor clearColor]];
		self.delegate = nil;
        
		self.tag = (arc4random() % 32768);
        
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        panRecognizer.minimumNumberOfTouches = 1;
        panRecognizer.maximumNumberOfTouches = 1;
        panRecognizer.delegate = self;
        [self addGestureRecognizer:panRecognizer];
		
        self.hideAndRemove = NO;
        self.style = WTModalPanelStylePop;
        self.fingerGrabHandleSize = UIEdgeInsetsMake(10, 0, 10, 0);
        self.touchEndRatioToShow = 0.33;
        self.touchEndRatioToHide = 0.33;
        
	}
	return self;
}

- (void)dealloc {
	self.roundedRect = nil;
	self.closeButton = nil;
	self.contentContainer = nil;
    self.dimBgView = nil;
	self.borderColor = nil;
	self.contentColor = nil;
    self.onClosePressed = nil;
	delegate = nil;
	WT_SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %ld hidden:%@>", [[self class] description], (long)self.tag, ([self isHidden]?@"YES":@"NO")];
}

#pragma mark - Accessors

- (void)setCornerRadius:(CGFloat)newRadius {
	cornerRadius = newRadius;
	self.roundedRect.layer.cornerRadius = cornerRadius;
}
- (void)setBorderWidth:(CGFloat)newWidth {
	borderWidth = newWidth;
	self.roundedRect.layer.borderWidth = borderWidth;
}
- (void)setBorderColor:(UIColor *)newColor {
	WT_SAFE_ARC_RETAIN(newColor);
	WT_SAFE_ARC_RELEASE(borderColor);
	borderColor = newColor;
	
	self.roundedRect.layer.borderColor = [borderColor CGColor];
}
- (void)setContentColor:(UIColor *)newColor {
    WT_SAFE_ARC_RETAIN(newColor);
    WT_SAFE_ARC_RELEASE(contentColor);
	contentColor = newColor;
	
	self.roundedRect.backgroundColor = contentColor;
}

- (UIView *)roundedRect {
	if (!roundedRect) {
		self.roundedRect = WT_SAFE_ARC_AUTORELEASE([[UIView alloc] initWithFrame:CGRectInset(self.bounds, outerMargin+innerMargin, outerMargin+innerMargin)]);
		roundedRect.layer.masksToBounds = YES;
		roundedRect.backgroundColor = self.contentColor;
		roundedRect.layer.borderColor = [self.borderColor CGColor];
		roundedRect.layer.borderWidth = self.borderWidth;
		roundedRect.layer.cornerRadius = self.cornerRadius;
        
		[self.contentContainer insertSubview:roundedRect atIndex:0];
	}
	return roundedRect;
}
- (UIButton*)closeButton {
	if (!closeButton) {
		self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
		[self.closeButton setFrame:CGRectMake(0, 0, 44, 44)];
		self.closeButton.layer.shadowColor = [[UIColor blackColor] CGColor];
		self.closeButton.layer.shadowOffset = CGSizeMake(0,4);
		self.closeButton.layer.shadowOpacity = 0.3;
		
		[closeButton addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];		
		[self.contentContainer insertSubview:closeButton aboveSubview:self.roundedRect];
	}
	return closeButton;
}
- (UIView *)contentView {
	if (!contentView) {
		self.contentView = WT_SAFE_ARC_AUTORELEASE([[UIView alloc] initWithFrame:CGRectInset(self.bounds, outerMargin+innerMargin, outerMargin+innerMargin)]);
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.contentView.autoresizesSubviews = YES;
//		[self.contentContainer addSubview:contentView];
		[self.contentContainer insertSubview:contentView belowSubview:self.closeButton];
	}
	return contentView;
}

- (CGRect)roundedRectFrame {
	return CGRectMake(self.outerMargin + self.frame.origin.x,
					  self.outerMargin + self.frame.origin.y,
					  self.frame.size.width - 2*self.outerMargin,
					  self.frame.size.height - 2*self.outerMargin);
}

- (CGRect)closeButtonFrame {
	CGRect f = [self roundedRectFrame];
	return CGRectMake(f.origin.x - floor(closeButton.frame.size.width*0.5),
					  f.origin.y - floor(closeButton.frame.size.height*0.5),
					  closeButton.frame.size.width,
					  closeButton.frame.size.height);
//	return CGRectMake(f.origin.x - floor(44*0.5),
//					  f.origin.y - floor(44*0.5),
//					  44,
//					  44);
}

- (CGRect)contentViewFrame {
	CGRect rect = CGRectInset([self roundedRectFrame], self.innerMargin, self.innerMargin);
	return rect;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.roundedRect.frame = [self roundedRectFrame];
	self.closeButton.frame = [self closeButtonFrame];
	self.contentView.frame = [self contentViewFrame];
    
	//UADebugLog(@"roundedRect frame: %@", NSStringFromCGRect(self.roundedRect.frame));
	//UADebugLog(@"contentView frame: %@", NSStringFromCGRect(self.contentView.frame));
}

- (void)closePressed:(id)sender {
	
	// Using Delegates
	if ([(NSObject*)delegate respondsToSelector:@selector(WTModalPanelShouldClose:)]) {
		if ([delegate WTModalPanelShouldClose:self]) {
			//UADebugLog(@"Closing using delegates for modalPanel: %@", self);
			[self hide];
		}
		
        
        // Using blocks
	} else if (self.onClosePressed) {
		//UADebugLog(@"Closing using blocks for modalPanel: %@", self);
		self.onClosePressed(self);
		
        // No delegate or blocks. Just close myself
	} else {
		//UADebugLog(@"Closing modalPanel: %@", self);
		[self hide];
	}
}

-(float)touchEndRatioToShow
{
    if(touchEndRatioToShow+touchEndRatioToHide>1.0)
    {
        float sum = (touchEndRatioToShow+touchEndRatioToHide);
        touchEndRatioToShow = touchEndRatioToShow/sum;
        touchEndRatioToHide = touchEndRatioToHide/sum;
    }
    return touchEndRatioToShow;
}

-(float)touchEndRatioToHide
{
    if(touchEndRatioToShow+touchEndRatioToHide>1.0)
    {
        float sum = (touchEndRatioToShow+touchEndRatioToHide);
        touchEndRatioToShow = touchEndRatioToShow/sum;
        touchEndRatioToHide = touchEndRatioToHide/sum;
    }
    return touchEndRatioToHide;
}

#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == panRecognizer && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)changeContentContainerViewFrame
{
    CGRect rect = contentContainer.frame;
    rect.origin.y = touchDistance;
    contentContainer.frame = rect;
//    [self layoutSubviews];
    
    CGFloat spaceSize = 1;
    CGFloat spacePositionY = 1;
    switch (style) {
        case WTModalPanelStylePanEdgeBottom:
            spaceSize =         CGRectGetHeight(self.frame) - CGRectGetMinY(self.roundedRect.frame);
            spacePositionY =    touchLocation.y - CGRectGetMinY(self.roundedRect.frame);
            break;
        case WTModalPanelStylePanEdgeTop:
            spaceSize =         CGRectGetHeight(self.roundedRect.frame) + CGRectGetMinY(self.roundedRect.frame);
            spacePositionY =    CGRectGetHeight(self.roundedRect.frame) + CGRectGetMinY(self.roundedRect.frame) - touchLocation.y;
            break;
        default:
            break;
    }
    showedRatio = MIN(1,MAX(0,(spaceSize-spacePositionY)/spaceSize));
    
//	[self.dimBgView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5*showedRatio]];
    
    [self panRatioChange:showedRatio];
    if ([(NSObject*)delegate respondsToSelector:@selector(WTModalPanel:panRatioChange:)])
        [delegate WTModalPanel:self panRatioChange:showedRatio];

}

-(void)changeDistance:(CGFloat)distance
{
    switch (style) {
        case WTModalPanelStylePanEdgeBottom:
            touchDistance = distance;
            touchLocation = CGPointMake(0, touchDistance + self.contentView.frame.origin.y);
            break;
        case WTModalPanelStylePanEdgeTop:
            touchDistance = distance;
            touchLocation = CGPointMake(0, touchDistance + self.roundedRectFrame.origin.y + self.roundedRectFrame.size.height);
            break;
        default:
            break;
    }
    [self changeContentContainerViewFrame];
}

-(void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if(style != WTModalPanelStylePanEdgeRight &&
       style != WTModalPanelStylePanEdgeLeft &&
       style != WTModalPanelStylePanEdgeBottom &&
       style != WTModalPanelStylePanEdgeTop &&
       style != WTModalPanelStylePanCenterRight &&
       style != WTModalPanelStylePanCenterLeft &&
       style != WTModalPanelStylePanCenterBottom &&
       style != WTModalPanelStylePanCenterTop){
        return;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];  
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    
    touchLocation = location;
    
    switch (style) {
        case WTModalPanelStylePanEdgeBottom:
        {
        
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
            touchOriginal = location;
        }
            
        if(!touchGrab &&
           location.y > CGRectGetMinY(self.roundedRect.frame) - fingerGrabHandleSize.top &&
           location.y < CGRectGetMinY(self.roundedRect.frame) + fingerGrabHandleSize.bottom){
            touchGrab = YES;
            [self panIsBegan:YES isEnded:NO];
//            return;
        }
        
        if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
            if(touchGrab){
                if (location.y < self.contentView.frame.origin.y + self.contentView.frame.size.height*self.touchEndRatioToShow) {
                    [self show];
                }else if(location.y > self.contentView.frame.origin.y + self.contentView.frame.size.height*(1.0-self.touchEndRatioToHide)) {
                    [self hide];
                }else {
                    if (velocity.y > 0) {
                        [self hide];
                    }else{
                        [self show];
                    }
                }
            }
            touchGrab = NO;
            [self panIsBegan:NO isEnded:YES];
            return;
        }
        
        if(touchGrab){
            CGFloat newY = touchLocation.y - CGRectGetMinY(self.roundedRect.frame);
            touchDistance = MAX(newY, 0);
            [self changeContentContainerViewFrame];
        }
        
        }
            break;
            
        case WTModalPanelStylePanEdgeTop:
        {
        
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
            touchOriginal = location;
        }
            
        if(!touchGrab &&
           location.y > CGRectGetMaxY(self.roundedRect.frame) - fingerGrabHandleSize.top &&
           location.y < CGRectGetMaxY(self.roundedRect.frame) + fingerGrabHandleSize.bottom){
            touchGrab = YES;
            [self panIsBegan:YES isEnded:NO];
//            return;
        }
        
        if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
            if(touchGrab){
                if (location.y < self.contentView.frame.origin.y + self.contentView.frame.size.height*self.touchEndRatioToShow) {
                    [self hide];
                }else if(location.y > self.contentView.frame.origin.y + self.contentView.frame.size.height*(1.0-self.touchEndRatioToHide)) {
                    [self show];
                }else {
                    if (velocity.y > 0) {
                        [self show];
                    }else{
                        [self hide];
                    }
                }
            }
            touchGrab = NO;
            [self panIsBegan:NO isEnded:YES];
            return;
        }
        
        if(touchGrab){
            CGFloat newY = touchLocation.y - CGRectGetMinY(self.roundedRect.frame) - CGRectGetHeight(self.roundedRect.frame);
            touchDistance = MIN(newY, 0);
            [self changeContentContainerViewFrame];
        }
        
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - subcalsses override

- (void)panRatioChange:(CGFloat)ratio {};
- (void)panIsBegan:(BOOL)began isEnded:(BOOL)ended {};
- (void)showAnimationStarting {};		//subcalsses override
- (void)showAnimationPart1Finished {};	//subcalsses override
- (void)showAnimationPart2Finished {};	//subcalsses override
- (void)showAnimationPart3Finished {};	//subcalsses override
- (void)showAnimationFinished {};		//subcalsses override

#pragma mark -

- (void)show {
	if ([(NSObject*)delegate respondsToSelector:@selector(WTModalPanelWillShow:)])
		[delegate WTModalPanelWillShow:self];
	
	[self showAnimationStarting];
    switch (style) {
        case WTModalPanelStylePanEdgeBottom:
        case WTModalPanelStylePanEdgeTop:
            break;
        case WTModalPanelStylePop:
        default:
            self.alpha = 0.0;
            self.contentContainer.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
            break;
    }
	
	void (^animationBlock)(BOOL) = ^(BOOL finished) {
		[self showAnimationPart1Finished];
		// Wait one second and then fade in the view
		[UIView animateWithDuration:0.1
						 animations:^{
                             switch (style) {
                                 case WTModalPanelStylePanEdgeBottom:
                                     [self changeDistance:2];
                                     break;
                                 case WTModalPanelStylePanEdgeTop:
                                     [self changeDistance:2];
                                     break;
                                 case WTModalPanelStylePop:
                                 default:
                                     self.contentContainer.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                     break;
                             }
						 }
						 completion:^(BOOL finished){
							 
							 [self showAnimationPart2Finished];
							 // Wait one second and then fade in the view
							 [UIView animateWithDuration:0.1
											  animations:^{
                                                  switch (style) {
                                                      case WTModalPanelStylePanEdgeBottom:
                                                          [self changeDistance:-1];
                                                          break;
                                                      case WTModalPanelStylePanEdgeTop:
                                                          [self changeDistance:-1];
                                                          break;
                                                      case WTModalPanelStylePop:
                                                      default:
                                                          self.contentContainer.transform = CGAffineTransformMakeScale(1.02, 1.02);
                                                          break;
                                                  }
											  }
											  completion:^(BOOL finished){
												  
												  [self showAnimationPart3Finished];
												  // Wait one second and then fade in the view
												  [UIView animateWithDuration:0.1
																   animations:^{
                                                                       switch (style) {
                                                                           case WTModalPanelStylePanEdgeBottom:
                                                                               [self changeDistance:0];
                                                                               break;
                                                                           case WTModalPanelStylePanEdgeTop:
                                                                               [self changeDistance:0];
                                                                               break;
                                                                           case WTModalPanelStylePop:
                                                                           default:
                                                                               self.contentContainer.transform = CGAffineTransformIdentity;
                                                                               break;
                                                                       }
																   }
																   completion:^(BOOL finished){
																	   [self showAnimationFinished];
																	   if ([(NSObject*)delegate respondsToSelector:@selector(WTModalPanelDidShow:)])
																		   [delegate WTModalPanelDidShow:self];
																   }];
											  }];
						 }];
	};
	
	// Show the view right away
    [UIView animateWithDuration:0.15
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
                         switch (style) {
                             case WTModalPanelStylePanEdgeBottom:
                                 self.alpha = 1.0;
                                 [self changeDistance:(shouldBounce)?-4:0];
                                 break;
                             case WTModalPanelStylePanEdgeTop:
                                 self.alpha = 1.0;
                                 [self changeDistance:(shouldBounce)?-4:0];
                                 break;
                             case WTModalPanelStylePop:
                             default:
                                 self.alpha = 1.0;
                                 self.contentContainer.center = self.center;
                                 self.contentContainer.transform = CGAffineTransformMakeScale((shouldBounce ? 1.05 : 1.0), (shouldBounce ? 1.05 : 1.0));
                                 break;
                         }
					 }
					 completion:(shouldBounce ? animationBlock : ^(BOOL finished) {
                        [self showAnimationFinished];
                        if ([(NSObject*)delegate respondsToSelector:@selector(WTModalPanelDidShow:)])
                            [delegate WTModalPanelDidShow:self];
                    })
     ];
    
}

- (void)showFromPoint:(CGPoint)point {
	startEndPoint = point;
	self.contentContainer.center = point;
	[self show];
}

- (void)showStylePanBottom{
    style = WTModalPanelStylePanEdgeBottom;
    [self show];
}

- (void)showStylePanTop{
    style = WTModalPanelStylePanEdgeTop;
    [self show];
}

- (void)hide {	
	// Hide the view right away
	if ([(NSObject*)delegate respondsToSelector:@selector(WTModalPanelWillClose:)])
		[delegate WTModalPanelWillClose:self];
	
    [UIView animateWithDuration:0.3
					 animations:^{
                         switch (style) {
                             case WTModalPanelStylePanEdgeBottom:
                                 [self changeDistance:CGRectGetHeight(self.frame)];
                                 self.alpha = 0;
                                 break;
                             case WTModalPanelStylePanEdgeTop:
                                 [self changeDistance:-CGRectGetHeight(self.frame)];
                                 self.alpha = 0;
                                 break;
                             case WTModalPanelStylePop:
                             default:
                                 self.alpha = 0;
                                 if (startEndPoint.x != CGPointZero.x || startEndPoint.y != CGPointZero.y) {
                                     self.contentContainer.center = startEndPoint;
                                 }
                                 self.contentContainer.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                                 break;
                         }
					 }
					 completion:^(BOOL finished){
						 if ([(NSObject*)delegate respondsToSelector:@selector(WTModalPanelDidClose:)]) {
							 [delegate WTModalPanelDidClose:self];
						 }
                         if(hideAndRemove && self.alpha == 0){
                             [self removeFromSuperview];
                         }
					 }];
}


- (void)hideWithOnComplete:(WTModalDisplayPanelAnimationComplete)onComplete {
	// Hide the view right away
    [UIView animateWithDuration:0.3
					 animations:^{
                         switch (style) {
                             case WTModalPanelStylePanEdgeBottom:
                                 [self changeDistance:CGRectGetHeight(self.frame)];
                                 self.alpha = 0;
                                 break;
                             case WTModalPanelStylePanEdgeTop:
                                 [self changeDistance:-CGRectGetHeight(self.frame)];
                                 self.alpha = 0;
                                 break;
                             default:
                             case WTModalPanelStylePop:
                                 self.alpha = 0;
                                 if (startEndPoint.x != CGPointZero.x || startEndPoint.y != CGPointZero.y) {
                                     self.contentContainer.center = startEndPoint;
                                 }
                                 self.contentContainer.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                                 break;
                         }
					 }
					 completion:^(BOOL finished){
						 if (onComplete){
                             onComplete(finished);
                         }
                         if(hideAndRemove && self.alpha == 0){
                             [self removeFromSuperview];
                         }
					 }];
}

- (BOOL)isShow
{
    if(self.alpha==0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end