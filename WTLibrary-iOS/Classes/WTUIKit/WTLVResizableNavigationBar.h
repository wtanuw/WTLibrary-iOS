//
//  LVResizableNavigationBar.h
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

#import <UIKit/UIKit.h>

@protocol ResizeableNavigationBar;

typedef void(^colorChanged)();

//extern CGFloat const LVNavigationBarHeight;
//extern CGFloat const LVStatusBarHeight;
//extern CGFloat const LVAnimationDuration;

@interface WTLVResizableNavigationBar : UINavigationBar

@property (nonatomic, assign) CGFloat normalHeight;
@property (nonatomic, assign) BOOL obser;
// These properties and methods should never be accessed externally.  Instead
// refer to the LVResizableNavigationController protocol
@property (nonatomic, assign) CGFloat extraHeight;
@property (nonatomic, weak) UIView *subHeaderView;
@property (nonatomic, copy) void (^colorChanged)(void);

@property (nonatomic,strong) NSObject<ResizeableNavigationBar> *bar;

- (void)adjustLayout;

@end

@protocol ResizeableNavigationBar <NSObject>
@property (nonatomic,weak) WTLVResizableNavigationBar* navigationBar;
- (void)initialize;
- (CGSize)sizeThatFits:(CGSize)size;
//- (void)setExtraHeight:(CGFloat)extraHeight;
- (void)layoutSubviews;
- (void)setBarTintColor:(UIColor *)barTintColor;
- (void)adjustLayout;

@end


@interface iosDefaultBar : NSObject<ResizeableNavigationBar>
@property (nonatomic,weak) WTLVResizableNavigationBar* navigationBar;
@end

@interface ios11Bar : NSObject<ResizeableNavigationBar>
@property (nonatomic,weak) WTLVResizableNavigationBar* navigationBar;
@end

@interface ios9Bar : NSObject<ResizeableNavigationBar>
@property (nonatomic,weak) WTLVResizableNavigationBar* navigationBar;
@end

@interface ios12Bar : NSObject<ResizeableNavigationBar>
@property (nonatomic,weak) WTLVResizableNavigationBar* navigationBar;
@end
