//
//  LVResizableNavigationBar.m
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

#import "LVResizableNavigationBar.h"

CGFloat const LVNavigationBarHeight = 44.0;
CGFloat const LVStatusBarHeight = 20.0;
CGFloat const LVAnimationDuration = 0.25;

@implementation LVResizableNavigationBar {
  CGFloat _lastHeight;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  //don't use fat headers with translucency. it messes things up with the layout guides
  self.translucent = NO;
  self.clipsToBounds = NO;
  [self setBackgroundImage:[UIImage new]
            forBarPosition:UIBarPositionAny
                barMetrics:UIBarMetricsDefault];
  //remove shadow border image since we're relying on the navigationcontroller.view, and the line is a little ugly in flat design
  [self setShadowImage:[UIImage new]];
  self.backgroundColor = [UIColor clearColor];
}

- (CGSize)sizeThatFits:(CGSize)size {
  
  CGSize amendedSize = [super sizeThatFits:size];
  amendedSize.height += _extraHeight;
  return amendedSize;
}

- (void)setExtraHeight:(CGFloat)extraHeight {
  _lastHeight = _extraHeight;
  _extraHeight = extraHeight;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect frame = self.frame;
  frame.origin.y = ([[UIApplication sharedApplication] isStatusBarHidden] ? 0 : LVStatusBarHeight) - _extraHeight;
  self.frame = frame;
  NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
  
  for (UIView *view in [self subviews]) {
    
    if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
      
      CGRect bounds = [self bounds];
      CGRect frame = [view frame];
      frame.origin.y    = bounds.origin.y - 20.f;
      frame.size.height = bounds.size.height + 20.f;
      [view setFrame:frame];
    }
  }
  
}

- (void)setBarTintColor:(UIColor *)barTintColor {
  [super setBarTintColor:barTintColor];
  if (self.colorChanged) {
    self.colorChanged();
  }
}

- (void)adjustLayout {
  [self sizeToFit];
  CGRect frame = [self frame];
  frame.origin.y = self.translucent ? 0 : LVStatusBarHeight;
  self.frame = frame;
}

@end
