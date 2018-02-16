//
//  WTBox.m
//  BushiRoadCardViewer
//
//  Created by Wat Wongtanuwat on 8/31/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#import "WTBox.h"
#import "WTMacro.h"
#import <objc/runtime.h>

@implementation WTBox

static Method origNibNamedMethod = nil;

+ (void)swizzleNib{
    origNibNamedMethod = class_getInstanceMethod([UIViewController class], @selector(initWithNibName:bundle:));
    method_exchangeImplementations(origNibNamedMethod,
                                   class_getInstanceMethod([UIViewController class], @selector(retina4InitWithNibName:bundle:)));
}

@end


#pragma mark - UINavigationBar_Dropshadow
#ifdef UINavigationBar_Dropshadow

@implementation UINavigationBar (Dropshadow)

-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    
    if(self.showDropShadow){
        // add the drop shadow
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.layer.masksToBounds = NO;
        self.layer.shouldRasterize = YES;
    }
}

-(void)setNeedsDisplay{
    [super setNeedsDisplay];
    
    if(self.showDropShadow){
        // add the drop shadow
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.layer.masksToBounds = NO;
        self.layer.shouldRasterize = YES;
    }
}

static char showDropShadowKey;

- (void) setShowDropShadow:(BOOL)showDropShadowx {
    NSNumber *showDropShadowInt = [NSNumber numberWithBool:showDropShadowx];
    objc_setAssociatedObject( self, 
                             &showDropShadowKey,
                             showDropShadowInt,
                             OBJC_ASSOCIATION_ASSIGN );
    [self setNeedsDisplay];
}

- (BOOL) showDropShadow {
    NSNumber *showDropShadowInt =  objc_getAssociatedObject( self, 
                                                      &showDropShadowKey );
    return [showDropShadowInt boolValue];
}

@end

#endif


#pragma mark - UIImage_Retina4
#ifdef UIImage_Retina4

static Method origImageNamedMethod = nil;

@implementation UIImage (Retina4)

+ (void)initialize {
    origImageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    method_exchangeImplementations(origImageNamedMethod,
                                   class_getClassMethod(self, @selector(retina4ImageNamed:)));
}

+ (UIImage *)retina4ImageNamed:(NSString *)imageName {
    //WatLog(@"Loading image named => %@", imageName);
    NSMutableString *imageNameMutable = [[imageName mutableCopy] autorelease];
    NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
    if (retinaAtSymbol.location != NSNotFound) {
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    } else {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            NSRange dot = [imageName rangeOfString:@"."];
            if (dot.location != NSNotFound) {
                [imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
            } else {
                [imageNameMutable appendString:@"-568h@2x"];
            }
        }
    }
    NSString *imageName568 = imageNameMutable;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName568 ofType:@"png"];
//    [imageNameMutable release];
    if (imagePath) {
        return [UIImage retina4ImageNamed:imageName568];
    } else {
        return [UIImage retina4ImageNamed:imageName];
    }
    return nil;
}

@end

#endif


#pragma mark - UINavigationController_iOS6OrientationFix
#ifdef UINavigationController_iOS6OrientationFix

@implementation UINavigationController (iOS6OrientationFix)

-(BOOL)shouldAutorotate
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        if([self.topViewController respondsToSelector:@selector(shouldAutorotate)])
            return (BOOL)[self.topViewController performSelector:@selector(shouldAutorotate)];
    }
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations {
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        if([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
            return (NSUInteger)[self.topViewController performSelector:@selector(supportedInterfaceOrientations)];
    }
    if(UI_INTERFACE_IDIOM_IS_IPHONE())
        return (1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationLandscapeLeft | 1 << UIInterfaceOrientationLandscapeRight);//UIInterfaceOrientationMaskPortraitUpsideDown
    else
        return (1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationLandscapeLeft | 1 << UIInterfaceOrientationLandscapeRight | 1 << UIInterfaceOrientationPortraitUpsideDown);//UIInterfaceOrientationMaskAll
}

@end

#endif


#pragma mark - UITabBarController_iOS6OrientationFix
#ifdef UITabBarController_iOS6OrientationFix

@implementation UITabBarController (iOS6OrientationFix)

-(BOOL)shouldAutorotate
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        if([self.selectedViewController respondsToSelector:@selector(shouldAutorotate)])
            return (BOOL)[self.selectedViewController performSelector:@selector(shouldAutorotate)];
    }
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations {
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        if([self.selectedViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
            return (NSUInteger)[self.selectedViewController performSelector:@selector(supportedInterfaceOrientations)];
    }
    if(UI_INTERFACE_IDIOM_IS_IPHONE())
        return (1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationLandscapeLeft | 1 << UIInterfaceOrientationLandscapeRight);//UIInterfaceOrientationMaskPortraitUpsideDown
    else
        return (1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationLandscapeLeft | 1 << UIInterfaceOrientationLandscapeRight | 1 << UIInterfaceOrientationPortraitUpsideDown);//UIInterfaceOrientationMaskAll
}

@end

#endif


#pragma mark - NSString_SpaceString
#ifdef NSString_SpaceString

@implementation NSString (SpaceString)

- (BOOL)isSpace{
    if(self == nil || [self isEqualToString:@""] || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isNotSpace{
    if(self && ![self isEqualToString:@""] && ![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        return YES;
    }else{
        return NO;
    }
}

@end

#endif


#pragma mark - UIImage_TPAdditions
#ifdef UIImage_TPAdditions

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage);
CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    if (offscreenContext != NULL) {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return retVal;
}


@implementation UIImage (TPAdditions)


- (UIImage*)imageByMaskingUsingImage:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef source = [self CGImage];
    
    NSInteger alphaInfo = CGImageGetAlphaInfo(source);
    if ( alphaInfo == kCGImageAlphaNone || alphaInfo == kCGImageAlphaNoneSkipLast || alphaInfo == kCGImageAlphaNoneSkipFirst ) {
        source = CopyImageAndAddAlphaChannel(source);
    }
    
    CGImageRef masked = CGImageCreateWithMask(source, mask);
    CGImageRelease(mask);
    
    if ( source != [self CGImage] ) {
        CGImageRelease(source);
    }
    
    UIImage *result;
    if ( [UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)] ) {
        result = [UIImage imageWithCGImage:masked scale:self.scale orientation:self.imageOrientation];
    } else {
        result = [UIImage imageWithCGImage:masked];
    }
    
    CGImageRelease(masked);
    
    return result;
}

@end

#endif


#pragma mark - UINavigationController_WTTransition
#ifdef UINavigationController_WTTransition

#define WTTransitionDuration 0.3

static Method origPushNamedMethod = nil;
static Method origPopNamedMethod = nil;
static Method origPopRootNamedMethod = nil;
@implementation UINavigationController (WTTransition)

+ (void)initialize {
    origPushNamedMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    method_exchangeImplementations(origPushNamedMethod,
                                   class_getInstanceMethod(self, @selector(fadePushViewController:animated:)));
    
    origPopNamedMethod = class_getInstanceMethod(self, @selector(popViewControllerAnimated:));
    method_exchangeImplementations(origPopNamedMethod,
                                   class_getInstanceMethod(self, @selector(fadePopViewControllerAnimated:)));
    
    origPopRootNamedMethod = class_getInstanceMethod(self, @selector(popToRootViewControllerAnimated:));
    method_exchangeImplementations(origPopRootNamedMethod,
                                   class_getInstanceMethod(self, @selector(fadeRootPopViewControllerAnimated:)));
}

- (void) fadePushViewController:(UIViewController*)controller animated:(BOOL)animated
{
//    float navigationHeight = self.navigationBar.bounds.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
//
//    controller.view.frame = CGRectMake(0, navigationHeight, controller.view.frame.size.width, controller.view.frame.size.height);
//    controller.view.alpha = 0;
//    [self.view addSubview:controller.view];
////    [self.view insertSubview:controller.view aboveSubview:[self.view.subviews objectAtIndex:0]];
//    [UIView animateWithDuration:WTTransitionDuration
//                          delay:0
//                        options:UIViewAnimationCurveLinear
//                     animations:^{
//                         controller.view.alpha = 1;
//                     }
//                     completion:^(BOOL finished){
//                         [controller.view removeFromSuperview];
//                         [self fadePushViewController:controller animated:NO];
////                         [self performBlock:^{
////                             [self.navigationController.navigationBar.topItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem animated:YES];
////                         } afterDelay:2.0];
//                     }
//     ];
    
    
    [CATransaction begin];
    
    CATransition *transition;
    transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    transition.duration = WTTransitionDuration;
    
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    
//    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    
	[self.view.window.layer addAnimation:transition forKey:nil];
    
    [self fadePushViewController:controller animated:YES];
    
    [CATransaction commit];
    
    controller.view.alpha = 0.0f;
    
    [self performBlock:^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             controller.view.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                             controller.view.alpha = 1.0f;
                         }];
        
        [UIView animateWithDuration:0.0f
                              delay:0.5f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                         }
                         completion:^(BOOL finished){
                             controller.view.alpha = 1.0f;
                         }];
    }
            afterDelay:0.3f];
}

- (UIViewController *)fadePopViewControllerAnimated:(BOOL)animated
{
    if([self.viewControllers count]<=1) return nil;
    
//    float navigationHeight = self.navigationBar.bounds.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
//
//    UIViewController *controller = self.topViewController;
//    UIViewController *vct = [self fadePopViewControllerAnimated:NO];
//    controller.view.frame = CGRectMake(0, navigationHeight, controller.view.frame.size.width, controller.view.frame.size.height);
//    [self.view addSubview:controller.view];
////    [self.view insertSubview:controller.view aboveSubview:[self.view.subviews objectAtIndex:0]];
//    [UIView animateWithDuration:WTTransitionDuration
//                          delay:0
//                        options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         controller.view.alpha = 0;
//                     }
//                     completion:^(BOOL finished){
//                         controller.view.alpha = 1;
//                         [controller.view removeFromSuperview];
//                     }
//     ];
//
//    return vct;
    
    
    [CATransaction begin];
    
    CATransition *transition;
    transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = WTTransitionDuration;
    
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    
//    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    
	[self.view.window.layer addAnimation:transition forKey:nil];
    
    UIViewController *vct = [self fadePopViewControllerAnimated:NO];
    
    self.topViewController.view.alpha = 0.0f;
    
    [CATransaction commit];
    
    self.topViewController.view.alpha = 0.0f;
    
    [self performBlock:^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.topViewController.view.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                             self.topViewController.view.alpha = 1.0f;
                         }];
    }
            afterDelay:0.3f];
    
    return vct;
}

- (UIViewController *)fadeRootPopViewControllerAnimated:(BOOL)animated
{
    if([self.viewControllers count]<=1) return nil;
    
    [CATransaction begin];
    
    CATransition *transition;
    transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = WTTransitionDuration;
    
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    
//    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    
	[self.view.layer addAnimation:transition forKey:nil];
    
    UIViewController *vct = [self fadeRootPopViewControllerAnimated:NO];
    
    self.topViewController.view.alpha = 0.0f;
    
    [CATransaction commit];
    
    [self performBlock:^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.topViewController.view.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                             self.topViewController.view.alpha = 1.0f;
                         }];
    }
            afterDelay:0.3f];
    
    return vct;
}

- (void) slideWONavigationBarPushViewController:(UIViewController*)controller animated:(BOOL)animated
{
    float navigationHeight = self.navigationBar.bounds.size.height;
    
    controller.view.frame = CGRectMake(controller.view.frame.size.width, navigationHeight, controller.view.frame.size.width, controller.view.frame.size.height);
    [self.view insertSubview:controller.view aboveSubview:[self.view.subviews objectAtIndex:0]];
    [UIView animateWithDuration:WTTransitionDuration
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         controller.view.frame = CGRectMake(0, navigationHeight, controller.view.frame.size.width, controller.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [controller.view removeFromSuperview];
                         [self slideWONavigationBarPushViewController:controller animated:NO];
                     }
     ];
    
//    [CATransaction begin];
//    
//    CATransition *transition;
//    transition = [CATransition animation];
//    transition.type = kCATransitionMoveIn;
//    transition.subtype = kCATransitionFromRight;
//    transition.duration = WTTransitionDuration;
//    
//    [CATransaction setValue:(id)kCFBooleanTrue
//                     forKey:kCATransactionDisableActions];
//    
//    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
//    
//    [self  pushViewController:controller animated:YES];
//    
//    [CATransaction commit];
}

- (UIViewController *)slideWONavigationBarPopViewControllerAnimated:(BOOL)animated
{
    float navigationHeight = self.navigationBar.bounds.size.height;
    
    UIViewController *controller = self.topViewController;
    UIViewController *vct = [self slideWONavigationBarPopViewControllerAnimated:NO];
    controller.view.frame = CGRectMake(0, navigationHeight, controller.view.frame.size.width, controller.view.frame.size.height);
    [self.view insertSubview:controller.view aboveSubview:[self.view.subviews objectAtIndex:0]];
    [UIView animateWithDuration:WTTransitionDuration
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         controller.view.frame = CGRectMake(controller.view.frame.size.width, navigationHeight, controller.view.frame.size.width, controller.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [controller.view removeFromSuperview];
                     }
     ];
    
    return vct;
    
//    [CATransaction begin];
//    
//    CATransition *transition;
//    transition = [CATransition animation];
//    transition.type = kCATransitionReveal;
//    transition.subtype = kCATransitionFromLeft;
//    transition.duration = WTTransitionDuration;
//    
//    [CATransaction setValue:(id)kCFBooleanTrue
//                     forKey:kCATransactionDisableActions];
//    
//    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
//    
//    UIViewController *vct = [self popViewControllerAnimated:NO];
//    
//    [CATransaction commit];
//    
//    return vct;
}

@end

#endif


#pragma mark - UIViewController_Retina4
#ifdef UIViewController_Retina4

@implementation UIViewController (Retina4)

//static Method origNibNamedMethod = nil;
//
//+ (void)initialize {
//    origNibNamedMethod = class_getInstanceMethod(self, @selector(initWithNibName:bundle:));
//    method_exchangeImplementations(origNibNamedMethod,
//                                   class_getInstanceMethod(self, @selector(retina4InitWithNibName:bundle:)));
//}

- (id)retina4InitWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSMutableString *nibNameMutable = [[nibNameOrNil mutableCopy] autorelease];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        NSRange dot = [nibNameOrNil rangeOfString:@"."];
        if (dot.location != NSNotFound) {
            [nibNameMutable insertString:@"-568h" atIndex:dot.location];
        } else {
            [nibNameMutable appendString:@"-568h"];
        }
    }
    NSString *nibName568 = nibNameMutable;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:nibName568 ofType:@"nib"];
//    [nibNameMutable release];
    if (imagePath) {
        return [self retina4InitWithNibName:nibName568 bundle:nibBundleOrNil];
    } else {
        return [self retina4InitWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    return nil;
}

@end

#endif

