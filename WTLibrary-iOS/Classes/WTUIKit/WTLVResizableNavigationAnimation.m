//
//  LVResizableNavigationAnimation.m
//  Level Money
//
//  Created by Todd Anderson on 3/11/15.
//
//  ========================================================================
//  Copyright (c) 2015 Level Money Financial, Inc.
//  ------------------------------------------------------------------------
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Eclipse Public License v1.0
//
//      The Eclipse Public License is available at
//      http://www.eclipse.org/legal/epl-v10.html
//
//
//  You may elect to redistribute this code under this license.
//  ========================================================================
//

#import "WTLVResizableNavigationAnimation.h"
#import "WTLVResizableNavigationBar.h"
#import "WTLVResizableNavigationController.h"

//#import "LVResizableNavigationBar.h"

#define WATLOG_DEBUG
#import "WTMacro.h"

@interface WTLVResizableNavigationAnimation () <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL pushing;

@end


@implementation WTLVResizableNavigationAnimation

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(WTLVResizableNavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    WatLog(@"\n  animation animationControllerForOperation \n");
  if (operation == UINavigationControllerOperationPop) {
    self.pushing = NO;
    return self;
  } else if (operation == UINavigationControllerOperationPush) {
    self.pushing = YES;
    return self;
  }
  return nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.25;
}


//- (UIView *)resizableNavigationBarControllerSubHeaderView{
//
//}
//- (CGFloat)resizableNavigationBarControllerNavigationBarHeight
//{
//
//}
//- (UIColor *)resizableNavigationBarControllerNavigationBarTintColor
//{
//
//}

- (CGFloat)statusBarHeight:(UIViewController*)vct
{
    if (@available(iOS 13.0, *)) {
//        UINavigationController *f = self.navigationController;
//        UIWindow *d = self.navigationController.view.window;
//        UIWindowScene *c = self.navigationController.view.window.windowScene;
//        UIStatusBarManager *b = self.navigationController.view.window.windowScene.statusBarManager;
//        CGRect a = self.navigationController.view.window.windowScene.statusBarManager.statusBarFrame;
        return vct.view.window.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        // Fallback on earlier versions
        return UIApplication.sharedApplication.statusBarFrame.size.height;
    }
}

- (CGFloat)navigationBarHeight:(UIViewController*)vct
{
    WTLVResizableNavigationBar *navBar = (id)vct.navigationController.navigationBar;
    if ([navBar respondsToSelector:@selector(normalHeight)]) {
        return navBar.normalHeight;
    }
    return vct.navigationController.navigationBar.frame.size.height;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    WatLog(@"\n ----animation transitionContext \n");
  UIViewController *toVC = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIViewController *fromVC = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  [[transitionContext containerView] addSubview:toVC.view];
  
  if (toVC.navigationItem.hidesBackButton == NO) {
    [toVC.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
  }
  
//  UIWindow *window = UIApplication.sharedApplication.keyWindow;
  CGFloat topPadding = [self statusBarHeight:toVC];
    
  WTLVResizableNavigationBar *navBar = (id)toVC.navigationController.navigationBar;
  
  UIView *originalSubHeaderView = navBar.subHeaderView;
  UIView *newSubHeaderView;
  if ([toVC respondsToSelector:@selector(resizableNavigationBarControllerSubHeaderView)]) {
      id<WTLVResizableNavigationBarController> resizableVC = (id<WTLVResizableNavigationBarController>)toVC;
    newSubHeaderView = [resizableVC resizableNavigationBarControllerSubHeaderView];
  }
  navBar.subHeaderView = newSubHeaderView;
  
    CGFloat toVCNavHeight = navBar.normalHeight;
  
  if ([toVC respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarHeight)]) {
      id<WTLVResizableNavigationBarController> resizableVC = (id<WTLVResizableNavigationBarController>)toVC;
    toVCNavHeight = [resizableVC resizableNavigationBarControllerNavigationBarHeight];
  }
  
  UIColor *color = navBar.barTintColor;
  UIColor *oldColor = color;
  if ([toVC respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor)]) {
    color = [toVC performSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor) withObject:nil];
  }
  if ([fromVC respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor)]) {
    oldColor = [fromVC performSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor)];
  }
  fromVC.navigationController.view.backgroundColor = oldColor;
  
    
  CGFloat originalExtraHeight = navBar.extraHeight;
    navBar.extraHeight = toVCNavHeight - navBar.normalHeight;
  
  CGRect toVCStartFrame = toVC.view.frame;
  //adjust target view controller to left (pop) or to right (push) of current view controller
  toVCStartFrame.origin.x    = self.pushing ? toVCStartFrame.size.width : -(toVCStartFrame.size.width);
  toVCStartFrame.origin.y    = fromVC.view.frame.origin.y;
  toVCStartFrame.size.height = fromVC.view.frame.size.height;
    WatLog(@"\n ----animation toVC.view.frame = %@",NSStringFromCGRect(toVC.view.frame));
  

    WatLog(@"****002*****");
  //calculate navigation bar frame
  CGRect navFrame      = navBar.frame;
    if (@available(iOS 11.0, *)) {
        navFrame.origin.y    = topPadding ;//- navBar.extraHeight;
        if ( self.navigationController.view.frame.origin.y > 0) {
            WatLog(@"***9999ddd9**  %f  %@",topPadding,self.navigationController.view);
            navFrame.origin.y    =0;
            topPadding = 0;
        }
    } else {
        navFrame.origin.y    = topPadding;// - navBar.extraHeight;
        navFrame.size.height = toVCNavHeight;
    }
  
  //target view controller final frame
  CGRect toVCEndFrame      = toVCStartFrame;
  toVCEndFrame.origin.x    = 0;
    if (@available(iOS 11.0, *)) {
        toVCEndFrame.origin.y    = toVCNavHeight + topPadding - toVC.additionalSafeAreaInsets.top;
        toVCEndFrame.size.height = toVC.navigationController.view.frame.size.height - navBar.normalHeight - topPadding;
    } else {
        toVCEndFrame.origin.y    = toVCNavHeight + topPadding;
        toVCEndFrame.size.height = toVC.navigationController.view.frame.size.height - toVCNavHeight - topPadding;
    }
  
  if (navBar.translucent) {
    toVCStartFrame.origin.y    =
    toVCEndFrame.origin.y      = 0;
    toVCStartFrame.size.height =
    toVCEndFrame.size.height   = toVC.navigationController.view.frame.size.height;
    color = oldColor;
  }
    WatLog(@"\n ----animation toVCStartFrame = %@ -> toVCEndFrame = %@ ",NSStringFromCGRect(toVCStartFrame), NSStringFromCGRect(toVCEndFrame));
  
  toVC.view.frame = toVCStartFrame;
  
  CGRect startFrameForNewSubHeader = [self startNavBarSubHeaderFrameForExtraHeight:navBar.extraHeight originalHeight:originalExtraHeight toVC:toVC fromRight:self.pushing];
  [toVC.navigationController.view addSubview:newSubHeaderView];
  newSubHeaderView.frame = startFrameForNewSubHeader;
  
  //current view controller final frame to right (pop) or to left (push)
  CGRect fromVCEndFrame      = fromVC.view.frame;
  fromVCEndFrame.origin.x    = self.pushing ? -(fromVCEndFrame.size.width) : fromVCEndFrame.size.width;
  fromVCEndFrame.origin.y    = toVCEndFrame.origin.y;
  fromVCEndFrame.size.height = toVCEndFrame.size.height;
  
  /**/
  
  
  
  
  CGRect endFrameForOldHeader = [self endNavBarSubHeaderFrameForOriginalHeight:originalExtraHeight extraHeight:navBar.extraHeight fromVC:fromVC toLeft:self.pushing];
  CGRect endFrameForNewHeader = [self endNavBarSubHeaderFrameForExtraHeight:navBar.extraHeight toVC:toVC];
  WatLog(@"\n ----animation endFrameForOldHeader = %@ \n endFrameForNewHeader = %@ ",NSStringFromCGRect(endFrameForOldHeader), NSStringFromCGRect(endFrameForNewHeader));
  
  NSArray * leftItems    = toVC.navigationItem.leftBarButtonItems;
  NSArray * rightItems   = toVC.navigationItem.rightBarButtonItems;
  NSString * toTitle     = toVC.title;
  NSString * fromTitle   = fromVC.title;
  toVC.navigationItem.leftBarButtonItems = nil;
  toVC.navigationItem.rightBarButtonItems = nil;
  
  NSArray *fromLeftItems = fromVC.navigationItem.leftBarButtonItems;
  NSArray *fromRightItems = fromVC.navigationItem.rightBarButtonItems;
  
  toVC.title = nil;
  fromVC.title = nil;
  fromVC.navigationItem.leftBarButtonItems = nil;
  fromVC.navigationItem.rightBarButtonItems = nil;
    
    BOOL fromVCHidesBackButton = fromVC.navigationItem.hidesBackButton;
    fromVC.navigationItem.hidesBackButton = YES;
    BOOL toVCHidesBackButton = toVC.navigationItem.hidesBackButton;
    toVC.navigationItem.hidesBackButton = YES;
    WatLog(@"animation navbar = %@",NSStringFromCGRect(navBar.frame));
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     originalSubHeaderView.frame = endFrameForOldHeader;
                     newSubHeaderView.frame      = endFrameForNewHeader;
                     //adjust colors
                     navBar.barTintColor                              = color;
                     [navBar sizeToFit];
                     //adjust frames
                     navBar.frame      = navFrame;
                     toVC.view.frame   = toVCEndFrame;
                     fromVC.view.frame = fromVCEndFrame;
                     
                   } completion:^(BOOL finished) {
                     //cleanup
                     [originalSubHeaderView removeFromSuperview];
                     [self setExtraHeightForViewController:toVC];
                     toVC.navigationItem.leftBarButtonItems = leftItems;
                     toVC.navigationItem.rightBarButtonItems = rightItems;
                     fromVC.navigationItem.leftBarButtonItems = fromLeftItems;
                     fromVC.navigationItem.rightBarButtonItems = fromRightItems;
                       fromVC.navigationItem.hidesBackButton = fromVCHidesBackButton;
                       toVC.navigationItem.hidesBackButton = toVCHidesBackButton;
                     toVC.title = toTitle;
                     fromVC.title = fromTitle;
                     [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                   }];
}

- (void)setExtraHeightForViewController:(UIViewController *)viewController {
  CGFloat extraHeight = 0;
  WatLog(@"\n ----animation setExtraHeightForViewController \n");
  WTLVResizableNavigationBar *navBar = (id)viewController.navigationController.navigationBar;
  if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarHeight)]) {
      id<WTLVResizableNavigationBarController> resizableVC = (id<WTLVResizableNavigationBarController>)viewController;
    CGFloat expectHeight = [resizableVC resizableNavigationBarControllerNavigationBarHeight];
      extraHeight = expectHeight - navBar.normalHeight;
  }
  [navBar setExtraHeight:extraHeight];
  [navBar sizeToFit];
}

- (UIView *)subHeaderForViewController:(UIViewController *)viewController {
  UIView *subHeaderView;
  WatLog(@"\n  ----animation subHeaderForViewController \n");
  if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerSubHeaderView)]) {
    subHeaderView = [viewController performSelector:@selector(resizableNavigationBarControllerSubHeaderView) withObject:nil];
  }
  return subHeaderView;
}

- (CGRect)endNavBarSubHeaderFrameForExtraHeight:(CGFloat)extraHeight toVC:(UIViewController *)toVC {
    WatLog(@"\n  animation endNavBarSubHeaderFrameForExtraHeight \n");
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = 20;
    if (@available(iOS 11.0, *)) {
        topPadding = [self statusBarHeight:toVC];
    } else {
    }
      
    WTLVResizableNavigationBar *navBar = (id)toVC.navigationController.navigationBar;
  CGRect toVCFrame = toVC.view.frame;
  CGRect targetNavBarFrame = CGRectZero;
  targetNavBarFrame.origin.x = 0;
  targetNavBarFrame.origin.y =  topPadding;
  targetNavBarFrame.size.width = toVCFrame.size.width;
    targetNavBarFrame.size.height = navBar.normalHeight +extraHeight;

    WatLog(@"\n ----animation toVCFrame = %@   targetFrame = %@",NSStringFromCGRect(toVCFrame),NSStringFromCGRect(targetNavBarFrame));
  return targetNavBarFrame;
}

- (CGRect)startNavBarSubHeaderFrameForExtraHeight:(CGFloat)extraHeight originalHeight:(CGFloat)originalHeight toVC:(UIViewController *)toVC fromRight:(BOOL)fromRight {
    WatLog(@"\n  animation startNavBarSubHeaderFrameForExtraHeight \n");
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = 20;
    if (@available(iOS 11.0, *)) {
        topPadding = [self statusBarHeight:toVC];
    } else {
    }
      
    WTLVResizableNavigationBar *navBar = (id)toVC.navigationController.navigationBar;
  CGRect toVCFrame = toVC.view.frame;
  CGRect targetFrame = CGRectZero;
  targetFrame.origin.x = fromRight ? toVCFrame.size.width : -(toVCFrame.size.width);
    targetFrame.origin.y = navBar.normalHeight + topPadding - (extraHeight - originalHeight);
  targetFrame.size.width = toVCFrame.size.width;
  targetFrame.size.height = extraHeight;
  return targetFrame;
}

- (CGRect)endNavBarSubHeaderFrameForOriginalHeight:(CGFloat)originalHeight extraHeight:(CGFloat)extraHeight fromVC:(UIViewController *)fromVC toLeft:(BOOL)toLeft {
    WatLog(@"\n  animation endNavBarSubHeaderFrameForOriginalHeight \n");
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
        topPadding = window.safeAreaInsets.top;
    } else {
    }
      
    WTLVResizableNavigationBar *navBar = (id)fromVC.navigationController.navigationBar;
  CGRect fromVCFrame = fromVC.view.frame;
  CGRect targetFrame = CGRectZero;
  targetFrame.origin.x = toLeft ? -(fromVCFrame.size.width) : fromVCFrame.size.width;
    targetFrame.origin.y = navBar.normalHeight + topPadding + (extraHeight - originalHeight);
  targetFrame.size.width = fromVCFrame.size.width;
  targetFrame.size.height = originalHeight;
  return targetFrame;
}

//- (CGRect)startNavBarSubHeaderFrameForExtraHeight:(CGFloat)extraHeight fromVC:(UIViewController *)fromVC {
//    UIWindow *window = UIApplication.sharedApplication.keyWindow;
//    CGFloat statusBarHeight = 20;
//    if (@available(iOS 11.0, *)) {
//        statusBarHeight = window.safeAreaInsets.top;
//    } else {
//    }
//  CGRect fromVCFrame = fromVC.view.frame;
//  CGRect targetFrame = CGRectZero;
//  targetFrame.origin.x = - (fromVCFrame.size.width);
//  targetFrame.origin.y = LVNavigationBarHeight + statusBarHeight;
//  targetFrame.size.width = fromVCFrame.size.width;
//  targetFrame.size.height = extraHeight;
//  return targetFrame;
//}

- (void)setBarTintColorForViewController:(UIViewController *)viewController {
    WatLog(@"\n ----animation setBarTintColorForViewController \n");
  if ([viewController respondsToSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor)]) {
    viewController.navigationController.navigationBar.barTintColor = [viewController performSelector:@selector(resizableNavigationBarControllerNavigationBarTintColor) withObject:nil];
  }
}

- (void)updateNavigationBarForViewController:(UIViewController *)viewController {
    WatLog(@"\n\n ----animation updateNavigationBarForViewController \n");
    WTLVResizableNavigationBar *navBar = (id)viewController.navigationController.navigationBar;
  [self setExtraHeightForViewController:viewController];
  [navBar adjustLayout];

  CGRect targetFrame = [self endNavBarSubHeaderFrameForExtraHeight:navBar.extraHeight toVC:viewController];
   WatLog(@"\n ----animation targetFrame = %@",NSStringFromCGRect(targetFrame));
    UIView *subView = [self subHeaderForViewController:viewController];
    WatLog(@"\n ----animation subView = %@",WTBOOL(subView));
  if (subView) {
    [viewController.navigationController.view addSubview:subView];
    subView.frame = targetFrame;
    navBar.subHeaderView = subView;
  }
  [self setBarTintColorForViewController:viewController];
    
  
}

@end
