//
//  WTHud.m
//  IkuyokuruyoShame
//
//  Created by Wat Wongtanuwat on 11/5/12.
//  Copyright (c) 2012 Wat Wongtanuwat. All rights reserved.
//

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#import "WTHud.h"
#import <QuartzCore/QuartzCore.h>

@interface WTHud ()

@property (nonatomic, getter = isSharedHud) BOOL sharedHud;

@property (nonatomic, unsafe_unretained) id<WTHudDelegate> hudDelegate;
@property (nonatomic, assign) WTHudMaskType hudMaskType;
@property (nonatomic, assign) WTHudPositionType hudPositionType;
@property (nonatomic, assign) WTHudHudType hudHudType;
@property (nonatomic, assign) WTHudAnimationType hudAnimationType;
@property (nonatomic, assign) CGSize hudSize;
@property (nonatomic, assign) CGSize cornerOffset; // with WTHudPositionTypeAtCorner
@property (nonatomic, getter = isAnimation) BOOL animation;


@property (nonatomic, retain, readonly) NSTimer *fadeOutTimer;

//@property (nonatomic, retain) UIWindow *overlayWindow;
@property (nonatomic, retain, readonly) UIView *hudView;
@property (nonatomic, retain, readonly) UILabel *stringLabel;
@property (nonatomic, retain, readonly) UIImageView *imageView;
@property (nonatomic, retain, readonly) UIActivityIndicatorView *indicatorView;

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

- (void)updatePosition;
- (void)registerNotifications;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;

@end

@implementation WTHud
@synthesize sharedHud;
@synthesize hudDelegate,hudMaskType,hudPositionType,hudHudType,hudAnimationType,overlayView,hudSize,cornerOffset,animation;
@synthesize overlayWindow, hudView, fadeOutTimer, stringLabel, imageView, indicatorView, visibleKeyboardHeight;

#pragma mark - Shared Methods

+ (WTHud*)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[WTHud alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return _sharedObject;
}

#pragma mark - Set Methods

+ (void)setHudDelegate:(id<WTHudDelegate>)delegate {
	[[WTHud sharedManager] setHudDelegate:delegate];
}
+ (void)setHudMaskType:(WTHudMaskType)maskType {
	[[WTHud sharedManager] setHudMaskType:maskType];
}
+ (void)setHudPositionType:(WTHudPositionType)positionType {
	[[WTHud sharedManager] setHudPositionType:positionType];
}
+ (void)setHudHudType:(WTHudHudType)hudType {
	[[WTHud sharedManager] setHudHudType:hudType];
}
+ (void)setHudAnimationType:(WTHudAnimationType)animationType {
	[[WTHud sharedManager] setHudAnimationType:animationType];
}
+ (void)setHudSize:(CGSize)hudSize {
	[[WTHud sharedManager] setHudSize:hudSize];
}
+ (void)setCornerOffset:(CGSize)pointOffset {
	[[WTHud sharedManager] setCornerOffset:pointOffset];
}
+ (void)setStatus:(NSString *)string {
	[[WTHud sharedManager] setStatus:string];
}
+ (void)setImage:(UIImage*)image {
	[[WTHud sharedManager] setImage:image];
}
+ (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle {
	[[WTHud sharedManager] setIndicatorStyle:indicatorStyle];
}


#pragma mark - Show Methods

+ (void)showHud {
    [[WTHud sharedManager] showHud];
}

+ (void)showHudWithDefaultMode {
    [WTHud setHudMaskType:WTHudMaskTypeGradient];
    [WTHud setHudPositionType:WTHudPositionTypeCenter];
    [WTHud setHudHudType:WTHudHudTypeOpaqe];
    [WTHud setHudSize:CGSizeMake(100, 100)];
    [WTHud setCornerOffset:CGSizeZero];
    [WTHud setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [WTHud showHud];
}

#pragma mark - Dismiss Methods

+ (void)dismissHud {
	[[WTHud sharedManager] dismissHud];
}

+ (void)dismissHudAfterDelay:(NSTimeInterval)delay {
    [[WTHud sharedManager] dismissHudAfterDelay:delay];
}

+ (void)dismissHudWithSuccess:(NSString*)string {
    [WTHud setImage:[UIImage imageNamed:@"SVProgressHUD.bundle/success.png"]];
    [WTHud setStatus:string];
    [WTHud dismissHudAfterDelay:1.0];
}

+ (void)dismissHudWithError:(NSString*)string {
    [WTHud setImage:[UIImage imageNamed:@"SVProgressHUD.bundle/error.png"]];
    [WTHud setStatus:string];
    [WTHud dismissHudAfterDelay:1.0];
}

#pragma mark - Utilities

+ (BOOL)isVisible {
    return ([[WTHud sharedManager] isVisible]);
}

+ (BOOL)isAnimation {
    return ([[WTHud sharedManager] isAnimation]);
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        sharedHud = YES;
        hudDelegate = nil;
        hudMaskType = WTHudMaskTypeGradient;
        hudPositionType = WTHudPositionTypeCenter;
        hudHudType = WTHudHudTypeOpaqe;
        hudAnimationType = WTHudAnimationTypeZoomOutZoomOut;
        hudSize = CGSizeMake(100, 100);
        cornerOffset = CGSizeZero;
        callDelegateWhenTouchBegan = NO;
        callDelegateWhenTouchEnded = YES;
    }
	
    return self;
}

- (id)initWithView:(UIView*)view {
	
    if ((self = [super initWithFrame:view.bounds])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        sharedHud = NO;
        [self setHudDelegate:nil];
        [self setHudMaskType:WTHudMaskTypeGradient];
        [self setHudPositionType:WTHudPositionTypeCenter];
        [self setHudHudType:WTHudHudTypeOpaqe];
        [self setHudAnimationType:WTHudAnimationTypeZoomOutZoomOut];
        [self setHudSize:CGSizeMake(100, 100)];
        [self setCornerOffset:CGSizeZero];
        callDelegateWhenTouchBegan = NO;
        callDelegateWhenTouchEnded = YES;
        
        [self setStatus:nil];
        [self setImage:nil];
        [self setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
	
    return self;
}

- (void)dealloc {
    WT_SAFE_ARC_SUPER_DEALLOC();
    WT_SAFE_ARC_RELEASE(hudContainer);
    WT_SAFE_ARC_RELEASE(overlayView);
    hudDelegate = nil;
    WT_SAFE_ARC_RELEASE(fadeOutTimer);
    WT_SAFE_ARC_RELEASE(overlayWindow);
    WT_SAFE_ARC_RELEASE(hudView);
    WT_SAFE_ARC_RELEASE(stringLabel);
    WT_SAFE_ARC_RELEASE(imageView);
    WT_SAFE_ARC_RELEASE(indicatorView);
    WT_SAFE_ARC_RELEASE(fadeOutTimer);
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.hudMaskType) {
            
        case WTHudMaskTypeHalfBlack: {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case WTHudMaskTypeGradient: {
            
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)updatePosition {
    CGFloat hudWidth = self.hudSize.width;
    CGFloat hudHeight = self.hudSize.height;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    NSString *string = self.stringLabel.text;
    
    BOOL imageUsed = (self.imageView.image) || (self.imageView.hidden);
    
//    if(string) {
//        CGSize stringSize = [string sizeWithFont:self.stringLabel.font constrainedToSize:CGSizeMake(200, 300)];
//        stringWidth = stringSize.width;
//        stringHeight = stringSize.height;
//        hudHeight = 80+stringHeight;
//        
//        if(stringWidth > hudWidth)
//            hudWidth = ceil(stringWidth/2)*2;
//        
//        if(hudHeight > 100) {
//            labelRect = CGRectMake(12, 66, hudWidth, stringHeight);
//            hudWidth+=24;
//        } else {
//            hudWidth+=24;
//            labelRect = CGRectMake(0, 66, hudWidth, stringHeight);
//        }
//    }
	if(string) {
        CGSize stringSize;
        CGSize expectSize = CGSizeZero;
        UIFont *font = self.stringLabel.font;
#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_7_0)
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
            NSDictionary *attributesDict = @{NSFontAttributeName:font};
            expectSize = [string boundingRectWithSize:CGSizeMake(200, 300) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributesDict context:nil].size;
        }
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
        else
#endif
#endif
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
        {
            expectSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(200, 300)];
        }
#endif
        stringSize = expectSize;
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        if (imageUsed)
            hudHeight = 80+stringHeight;
        else
            hudHeight = 20+stringHeight;
        
        if(stringWidth > hudWidth)
            hudWidth = ceil(stringWidth/2)*2;
        
        CGFloat labelRectY = imageUsed ? 66 : 9;
        
        if(hudHeight > 100) {
            labelRect = CGRectMake(12, labelRectY, hudWidth, stringHeight);
            hudWidth+=24;
        } else {
            hudWidth+=24;
            labelRect = CGRectMake(0, labelRectY, hudWidth, stringHeight);
        }
    }
    
    switch (hudPositionType) {
        case WTHudPositionTypeCustom:
        {
            CGRect a = [self isVisible]?[self hudFrameCustomWhenShow]:[self hudFrameCustomWhenHide];
            
            [self hudContainer].bounds = CGRectMake(0, 0, CGRectGetWidth(a), CGRectGetHeight(a));
        }
            break;
        case WTHudPositionTypeCenter:
        default:
        {
            if(hudHudType == WTHudHudTypeCustom){
                [self hudContainer].bounds = CGRectMake(0, 0, [self hudFrameCustomWhenShow].size.width, [self hudFrameCustomWhenShow].size.height);
            }else
            [self hudContainer].bounds = CGRectMake(0, 0, hudWidth, hudHeight);
            
            if(string)
                self.imageView.center = CGPointMake(CGRectGetWidth([self hudContainer].bounds)/2, 36);
            else
                self.imageView.center = CGPointMake(CGRectGetWidth([self hudContainer].bounds)/2, CGRectGetHeight([self hudContainer].bounds)/2);
            
            self.stringLabel.hidden = NO;
            self.stringLabel.frame = labelRect;
            
            if(string)
                self.indicatorView.center = CGPointMake(ceil(CGRectGetWidth([self hudContainer].bounds)/2)+0.5, 40.5);
            else
                self.indicatorView.center = CGPointMake(ceil(CGRectGetWidth([self hudContainer].bounds)/2)+0.5, ceil([self hudContainer].bounds.size.height/2)+0.5);
        }
            break;
    }
}

- (void)setFadeOutTimer:(NSTimer *)newTimer {
    if(fadeOutTimer)
        [fadeOutTimer invalidate], fadeOutTimer = nil;
    
    if(newTimer)
        fadeOutTimer = newTimer;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]){
//        CGRect oldFrame = CGRectNull;
//        CGRect newFrame = CGRectNull;
//        if([change objectForKey:@"old"] != [NSNull null]) {
//            oldFrame = [[change objectForKey:@"old"] CGRectValue];
//        }
//        if([object valueForKeyPath:keyPath] != [NSNull null]) {
//            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
//        }
//        
//        WatLog(@"old %@",NSStringFromCGRect(oldFrame));
//        WatLog(@"new %@",NSStringFromCGRect(newFrame));
        //        if(verticalAxis){
        //            closedCenter.x = self.center.x;
        //            openedCenter.x = self.center.x;
        //        }
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)registerNotifications {
    [[self hudContainer] addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}


- (void)positionHUD:(NSNotification*)notification {
    if(![self isSharedHud]){
        switch (hudPositionType) {
            case WTHudPositionTypeCustom:
            {
                [self hudContainer].frame = [self isVisible]?[self hudFrameCustomWhenShow]:[self hudFrameCustomWhenHide];
            }
                break;
            case WTHudPositionTypeCenter:
            default:
            {
                CGRect orientationFrame = self.bounds;
                CGFloat posY = floor(orientationFrame.size.height*0.45);
                CGFloat posX = orientationFrame.size.width/2;
                
                CGPoint newCenter;
                CGFloat rotateAngle;
                
                UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
                
                switch (orientation) {
                    case UIInterfaceOrientationPortraitUpsideDown:
                        rotateAngle = M_PI;
                        newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
                        break;
                    case UIInterfaceOrientationLandscapeLeft:
                        rotateAngle = -M_PI/2.0f;
                        newCenter = CGPointMake(posY, posX);
                        break;
                    case UIInterfaceOrientationLandscapeRight:
                        rotateAngle = M_PI/2.0f;
                        newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
                        break;
                    default: // as UIInterfaceOrientationPortrait
                        rotateAngle = 0.0;
                        newCenter = CGPointMake(posX, posY);
                        break;
                }
                
//                CGPoint newCenter = CGPointMake(posX, posY);
//                CGFloat rotateAngle  = 0.0;
                
                [self moveToPoint:newCenter rotateAngle:rotateAngle];
                self.transform = CGAffineTransformMakeRotation(rotateAngle);
//                hudContainer].center = newCenter;
            }
                break;
        }
        return;
    }
    
    CGFloat keyboardHeight;
    double animationDuration = 0.3;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight*0.45);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    }
    
    else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {//
    [self hudContainer].transform = CGAffineTransformMakeRotation(angle);
    [self hudContainer].center = newCenter;
}

#pragma mark - Master Set methods

//- (void)setHudDelegate:(NSObject*)delegate {
//    
//}

- (void)setHudMaskType:(WTHudMaskType)maskType {
    hudMaskType = maskType;
    [self setNeedsDisplay];
}

- (void)setHudPositionType:(WTHudPositionType)positionType {
    hudPositionType = positionType;
    //[self setPosition];
}

- (void)setHudHudType:(WTHudHudType)hudType {
    hudHudType = hudType;
    switch (hudHudType) {
        case WTHudHudTypeCustom:
            self.hudView.hidden = YES;
            break;
        case WTHudHudTypeClear:
            self.hudView.hidden = NO;
            self.hudView.backgroundColor = [UIColor clearColor];
            break;
        case WTHudHudTypeOpaqe:
            self.hudView.hidden = NO;
            self.hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
            break;
        default:
            break;
    }
}

//- (void)setHudAnimationType:(WTHudAnimationType)animationType {
//    
//}
//
//- (void)setHudSize:(CGSize)hudSize {
//    
//}
//
//- (void)setCornerOffset:(CGSize)pointOffset {
//    
//}

- (void)setStatus:(NSString *)string {
    if(string==nil){
        self.stringLabel.hidden = YES;
        self.stringLabel.text = nil;
        
        self.accessibilityLabel = nil;
        self.hudView.isAccessibilityElement = NO;
    }else{
        self.stringLabel.hidden = NO;
        self.stringLabel.text = string;
        
        self.accessibilityLabel = string;
        self.hudView.isAccessibilityElement = YES;
    }
    [self updatePosition];
}

- (void)setImage:(UIImage *)image {
    if(image==nil){
        self.imageView.image = nil;
        self.imageView.hidden = YES;
        self.indicatorView.hidden = NO;
    }else{
        self.imageView.image = image;
        self.imageView.hidden = NO;
        self.indicatorView.hidden = YES;
    }
    [self updatePosition];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle {
    self.indicatorView.activityIndicatorViewStyle = indicatorStyle;
    [self updatePosition];
}

#pragma mark - Master Show/Dismiss methods
- (void)showHud{
    if([self isSharedHud]){
        [self showHudToView:self.overlayWindow];
    }else{
        [self showHudToView:nil];
    }
}

- (void)showHudWithDefaultMode {
    [self setHudMaskType:WTHudMaskTypeGradient];
    [self setHudPositionType:WTHudPositionTypeCenter];
    [self setHudHudType:WTHudHudTypeOpaqe];
    [self setHudSize:CGSizeMake(100, 100)];
    [self setCornerOffset:CGSizeZero];
    [self setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self showHud];
}
    
- (void)showHudToView:(UIView*)view {
    if([self isVisible]){
        return;
    }else{
        if([(NSObject*)hudDelegate respondsToSelector:@selector(WTHudWillShow:)]){
            [hudDelegate WTHudWillShow:self];
        }
    }
    
    if([self isSharedHud]){
        if(!self.superview){
            [self.overlayWindow addSubview:self];
        }
    }else{
        if(self.superview){
            [self.superview bringSubviewToFront:self];
        }else{
            [view addSubview:self];
        }
    }
    
    [self updatePosition];
    
    self.fadeOutTimer = nil;
    self.hudMaskType = hudMaskType;
    
    [self startAnimateIndicator];
    
    if([self isSharedHud]){
        if(self.hudMaskType != WTHudMaskTypeNone) {
            self.overlayWindow.userInteractionEnabled = YES;
            self.overlayView.userInteractionEnabled = YES;
            self.userInteractionEnabled = YES;
        } else {
            self.overlayWindow.userInteractionEnabled = NO;
            self.overlayView.userInteractionEnabled = NO;
            self.userInteractionEnabled = NO;
        }
    }else{
        if(self.hudMaskType != WTHudMaskTypeNone) {
            self.overlayView.userInteractionEnabled = YES;
            self.userInteractionEnabled = YES;
        } else {
            self.overlayView.userInteractionEnabled = NO;
            self.userInteractionEnabled = NO;
        }
    }
    
    if([self isSharedHud]){
        [self.overlayWindow setHidden:NO];
        [self.overlayView setHidden:NO];
    }else{
        [self.overlayView setHidden:NO];
    }
    [self positionHUD:nil];
    
    if(self.alpha != 1) {
        animation = YES;
        [self registerNotifications];
        switch (hudAnimationType) {
            case WTHudAnimationTypeNone:
            {
                self.alpha = 1;
                animation = NO;
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.stringLabel.text);
            }
                break;
                
            case WTHudAnimationTypeFade:
            {
                [UIView animateWithDuration:0.15
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     self.alpha = 1;
                                 }
                                 completion:^(BOOL finished){
                                     animation = NO;
                                     UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.stringLabel.text);
                                 }];
            }
                break;
                
            case WTHudAnimationTypeZoomOutZoomOut:
            default:
            {
                [self hudContainer].transform = CGAffineTransformScale(self.hudContainer.transform, 1.3, 1.3);
                
                [UIView animateWithDuration:0.15
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     [self hudContainer].transform = CGAffineTransformScale([self hudContainer].transform, 1/1.3, 1/1.3);
                                     self.alpha = 1;
                                 }
                                 completion:^(BOOL finished){
                                     animation = NO;
                                     UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.stringLabel.text);
                                 }];
            }
                break;
        }
    }
    
    
    [self setNeedsDisplay];
}


- (void)dismissHudAfterDelay:(NSTimeInterval)delay {
//    if(![self isVisible]){
//        [self show];
//    }
    if(![self isVisible]){
        return;
    }
    
    self.fadeOutTimer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(dismissHud) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
}


- (void)dismissHud {
    if(![self isVisible]){
        return;
    }else{
        if([(NSObject*)hudDelegate respondsToSelector:@selector(WTHudWillHide:)]){
            [hudDelegate WTHudWillHide:self];
        }
    }
    
    if(fadeOutTimer)
        [fadeOutTimer invalidate], fadeOutTimer = nil;
    
    [self stopAnimateIndicator];
    
    animation = YES;
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         switch (hudAnimationType) {
                             case WTHudAnimationTypeNone:
                             {
                                 self.alpha = 0;
                             }
                                 break;
                             case WTHudAnimationTypeFade:
                             {
                                 self.alpha = 0;
                             }
                                 break;
                             case WTHudAnimationTypeZoomOutZoomOut:
                             default:
                             {
                                 [self hudContainer].transform = CGAffineTransformScale([self hudContainer].transform, 0.8, 0.8);
                                 self.alpha = 0;
                             }
                                 break;
                         }
                     }
                     completion:^(BOOL finished){
                         if(self.alpha == 0) {
                             [[NSNotificationCenter defaultCenter] removeObserver:self];
                             
//                             if([self isSharedHud]){
//                                 [hudContainer removeFromSuperview];
//                                 [hudContainer release];
//                                 hudContainer = nil;
//                             }else{
////                                 [hudContainer removeFromSuperview];
////                                 [hudContainer release];
////                                 hudContainer = nil;
//                             }
                             
                             if([self isSharedHud]){
                                 [overlayWindow removeFromSuperview];
                                 WT_SAFE_ARC_RELEASE(overlayWindow);
                                 overlayWindow = nil;
//                                 [overlayView removeFromSuperview];
//                                 [overlayView release];
//                                 overlayView = nil;
                             }else{
//                                 [overlayView removeFromSuperview];
//                                 [overlayView release];
//                                 overlayView = nil;
                             }
                             
                             animation = NO;
                             UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                             
                             // uncomment to make sure UIWindow is gone from app.windows
                             //NSLog(@"%@", [UIApplication sharedApplication].windows);
                             //NSLog(@"keyWindow = %@", [UIApplication sharedApplication].keyWindow);
                         }
                     }];
}

#pragma mark - Master Utilities

- (BOOL)isVisible {
    return (self.alpha == 1);
}

- (BOOL)isAnimation {
    return (animation);
}

- (UIView *)hudContainer {
    switch (hudHudType) {
        case WTHudHudTypeCustom:
            return [self hudViewCustom];
            break;
        default:
            return [self hudView];
            break;
    }
}

#pragma mark - Getters

- (UIView *)overlayView {
    if(!overlayView) {
        overlayView = [[UIView alloc] initWithFrame:self.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor clearColor];
        overlayView.userInteractionEnabled = NO;
        
        [self addSubview:overlayView];
    }
    return overlayView;
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
    }
    return overlayWindow;
}

- (UIView *)hudView {
    if(!hudView) {
        hudView = [[UIView alloc] initWithFrame:CGRectZero];
        hudView.layer.cornerRadius = 10;
		hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:hudView];
    }
    return hudView;
}

- (UILabel *)stringLabel {
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        stringLabel.textAlignment = UITextAlignmentCenter;
#else
        stringLabel.textAlignment = NSTextAlignmentCenter;
#endif
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:16];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview)
        [self.hudView addSubview:stringLabel];
    
    return stringLabel;
}

- (UIImageView *)imageView {
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    }
    
    if(!imageView.superview)
        [self.hudView addSubview:imageView];
    
    return imageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicatorView.hidesWhenStopped = YES;
		indicatorView.bounds = CGRectMake(0, 0, 37, 37);
    }
    
    if(!indicatorView.superview)
        [self.hudView addSubview:indicatorView];
    
    return indicatorView;
}

- (CGFloat)visibleKeyboardHeight {
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
            return possibleKeyboard.bounds.size.height;
    }
    
    return 0;
}

#pragma mark - Delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!callDelegateWhenTouchBegan){
        return;
    }
    
	if([self isAnimation]){
        return;
    }
    
    UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:[self hudContainer]];
    
    UIView *hitView = [[self hudContainer] hitTest:touchPoint withEvent:event];
    
    BOOL hitHud = NO;
    if(hitView){
        hitHud = YES;
    }
    
    if([(NSObject*)hudDelegate respondsToSelector:@selector(WTHud:isTouchInside:)]){
        [hudDelegate WTHud:self isTouchInside:hitHud];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if(!callDelegateWhenTouchEnded || callDelegateWhenTouchBegan){
        return;
    }
    
    if([self isAnimation]){
        return;
    }
    
    UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:[self hudContainer]];
    
    UIView *hitView = [[self hudContainer] hitTest:touchPoint withEvent:event];
    
    BOOL hitHud = NO;
    if(hitView){
        hitHud = YES;
    }
    
    if([(NSObject*)hudDelegate respondsToSelector:@selector(WTHud:isTouchInside:)]){
        [hudDelegate WTHud:self isTouchInside:hitHud];
    }
}

#pragma mark -

- (UIView*)hudViewCustom {
    return nil;
}

- (CGRect)hudFrameCustomWhenShow {
	CGRect rect = CGRectZero;
	return rect;
}

- (CGRect)hudFrameCustomWhenHide {
	CGRect rect = CGRectZero;
	return rect;
}

- (void)startAnimateIndicator {
    [self.indicatorView startAnimating];
}

- (void)stopAnimateIndicator {
    [self.indicatorView stopAnimating];
}

@end
