//
//  LVResizableNavigationController.m
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

#import "WTLVResizableNavigationController.h"
#import "WTLVResizableNavigationBar.h"
#import "WTLVResizableNavigationAnimation.h"

#define WATLOG_DEBUG
#import "WTMacro.h"

@interface WTLVResizableNavigationController ()

@property (nonatomic) BOOL pushing;
@property (nonatomic) WTLVResizableNavigationAnimation *animationObject;

@end

@implementation WTLVResizableNavigationController


- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
  self = [super initWithNavigationBarClass:[WTLVResizableNavigationBar class] toolbarClass:nil];
  if (self) {
    [self initialize];
    self.viewControllers = @[rootViewController];
  }
  return self;
}

- (id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
  self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:nil];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize2 {
  self.animationObject = nil;
  self.delegate = self.animationObject;
  self.animationObject.navigationController = self;
}

- (void)initialize {
  self.animationObject = [WTLVResizableNavigationAnimation new];
  self.delegate = self.animationObject;
    self.animationObject.navigationController = self;
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
  [super setDelegate:delegate];
}

- (void)viewDidLoad {
    WatLog(@"\n controller viewDidLoad\n");
  [super viewDidLoad];
  self.view.clipsToBounds = YES;
  UIViewController *topViewController = self.topViewController;
  [self.animationObject updateNavigationBarForViewController:topViewController];
  WTLVResizableNavigationBar *bar = (id)self.navigationBar;
  __weak WTLVResizableNavigationController *weak = self;
  bar.colorChanged = ^{
    weak.view.backgroundColor = weak.navigationBar.barTintColor;
  };
}

- (void)resetNavigationDelegate {
    WatLog(@"\n controller resetNavigationDelegate\n");
  self.delegate = self.animationObject;
}

- (void)viewWillAppear:(BOOL)animated {
    WatLog(@"\n controller viewWillAppear\n");
  [super viewWillAppear:animated];
  self.view.backgroundColor = self.navigationBar.barTintColor;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    WatLog(@"\n controller setViewControllers\n");
  [super setViewControllers:viewControllers];
  UIViewController *viewController = self.viewControllers[0];
  [self.animationObject updateNavigationBarForViewController:viewController];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    WatLog(@"\n controller setViewControllers:animated\n");
  [super setViewControllers:viewControllers animated:animated];
  UIViewController *viewController = self.viewControllers[0];
  [self.animationObject updateNavigationBarForViewController:viewController];
}




@end
