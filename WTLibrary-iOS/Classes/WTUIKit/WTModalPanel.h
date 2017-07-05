//
//  WTModalPanel.h
//  SoundSamplerAPP
//
//  Created by Wat Wongtanuwat on 9/3/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMacro.h"

#define WTModalPanel_VERSION 0x00020002

@class WTModalPanel;

@protocol WTModalPanelDelegate
@optional
- (void)WTModalPanel:(WTModalPanel*)modalPanel panRatioChange:(CGFloat)ratio;
- (void)WTModalPanelWillShow:(WTModalPanel *)modalPanel;
- (void)WTModalPanelDidShow:(WTModalPanel *)modalPanel;
- (BOOL)WTModalPanelShouldClose:(WTModalPanel *)modalPanel;
- (void)WTModalPanelWillClose:(WTModalPanel *)modalPanel;
- (void)WTModalPanelDidClose:(WTModalPanel *)modalPanel;
@end

typedef void (^WTModalDisplayPanelEvent)(WTModalPanel* panel);
typedef void (^WTModalDisplayPanelAnimationComplete)(BOOL finished);

typedef enum {
    WTModalPanelStylePop,
    WTModalPanelStylePanEdgeRight,// slide by touch view from left edge to right
    WTModalPanelStylePanEdgeLeft,
    WTModalPanelStylePanEdgeTop,
    WTModalPanelStylePanEdgeBottom,
    WTModalPanelStylePanCenterRight,// slide by touch view from center to right
    WTModalPanelStylePanCenterLeft,
    WTModalPanelStylePanCenterTop,
    WTModalPanelStylePanCenterBottom,
} WTModalPanelStyle;

@interface WTModalPanel : UIView <UIGestureRecognizerDelegate>{	
	__unsafe_unretained id<WTModalPanelDelegate> delegate;
	
	UIView		*contentContainer;
	UIView		*roundedRect;
	UIButton	*closeButton;
	UIView		*contentView;
	UIView		*dimBgView;
	
	CGPoint		startEndPoint;
	
	CGFloat		outerMargin;
	CGFloat		innerMargin;
	UIColor		*borderColor;
	CGFloat		borderWidth;
	CGFloat		cornerRadius;
	UIColor		*contentColor;
	BOOL		shouldBounce;
    
    //StylePan
    BOOL hideAndRemove;
    
    //StylePanEdge
    WTModalPanelStyle style;
    UIEdgeInsets fingerGrabHandleSize;
    float touchEndRatioToShow;
    float touchEndRatioToHide;
    float showedRatio;
    
    BOOL touchGrab;
    CGPoint touchLocation;
    float touchDistance;
    
    //StylePanCenter
    CGPoint touchOriginal;
    
    UIPanGestureRecognizer *panRecognizer;
}

@property (nonatomic, assign) id<WTModalPanelDelegate> delegate;

@property (nonatomic, retain) UIView		*contentContainer;
@property (nonatomic, retain) UIView		*roundedRect;
@property (nonatomic, retain) UIButton		*closeButton;
@property (nonatomic, retain) UIView		*contentView;
@property (nonatomic, retain) UIView		*dimBgView;

// Margin between edge of container frame and panel. Default = 20.0
@property (nonatomic, assign) CGFloat		outerMargin;
// Margin between edge of panel and the content area. Default = 20.0
@property (nonatomic, assign) CGFloat		innerMargin;
// Border color of the panel. Default = [UIColor whiteColor]
@property (nonatomic, retain) UIColor		*borderColor;
// Border width of the panel. Default = 1.5f
@property (nonatomic, assign) CGFloat		borderWidth;
// Corner radius of the panel. Default = 4.0f
@property (nonatomic, assign) CGFloat		cornerRadius;
// Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
@property (nonatomic, retain) UIColor		*contentColor;
// Shows the bounce animation. Default = YES
@property (nonatomic, assign) BOOL			shouldBounce;

@property (readwrite, copy)	WTModalDisplayPanelEvent onClosePressed;

@property (nonatomic, assign) BOOL hideAndRemove;

@property (nonatomic, assign) WTModalPanelStyle style;
@property (nonatomic, assign) UIEdgeInsets fingerGrabHandleSize;
@property (nonatomic, assign) float touchEndRatioToShow;//from show side
@property (nonatomic, assign) float touchEndRatioToHide;//from hide side
@property (nonatomic, readonly) float showedRatio;

- (void)show;
- (void)showFromPoint:(CGPoint)point;

- (void)showStylePanBottom;
- (void)showStylePanTop;

- (void)hide;
- (void)hideWithOnComplete:(WTModalDisplayPanelAnimationComplete)onComplete;

- (CGRect)roundedRectFrame;
- (CGRect)closeButtonFrame;
- (CGRect)contentViewFrame;

- (BOOL)isShow;

@end