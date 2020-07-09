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

#import "WTLVResizableNavigationBar.h"
//#import "LVResizableNavigationBar.h"

//CGFloat const LVNavigationBarHeight = 44.0;
//CGFloat const LVStatusBarHeight = 20.0;
//CGFloat const WLVAnimationDuration = 0.25;

@implementation WTLVResizableNavigationBar {
  CGFloat _lastHeight;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
//    #ifdef __IPHONE_11_0
//        if (@available(iOS 11.0, *)) {
//            self.navigationController.navigationBar.prefersLargeTitles = YES;
//        }
//    #endif
  if (@available(iOS 11.0, *)) {
      ios11Bar *bar = [ios11Bar new];
      bar.navigationBar = self;
      self.bar = bar;
  } else {
      ios9Bar *bar = [ios9Bar new];
      bar.navigationBar = self;
      self.bar = bar;
  }
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (@available(iOS 11.0, *)) {
      ios11Bar *bar = [ios11Bar new];
      bar.navigationBar = self;
      self.bar = bar;
  } else {
      ios9Bar *bar = [ios9Bar new];
      bar.navigationBar = self;
      self.bar = bar;
  }
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
    [self.bar initialize];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize amendedSize = [super sizeThatFits:size];
  return [self.bar sizeThatFits:amendedSize];
}

- (void)setExtraHeight:(CGFloat)extraHeight {
    
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = 20;
    if (@available(iOS 11.0, *)) {
        topPadding = window.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
        topPadding = 0;
    }
    
    _lastHeight = _extraHeight;
    _extraHeight = extraHeight;// > 0 ? extraHeight + topPadding: extraHeight + topPadding;
//[self.bar setExtraHeight:extraHeight];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bar layoutSubviews];
//    [self sizeToFit];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
  [super setBarTintColor:barTintColor];
  if (self.colorChanged) {
    self.colorChanged();
  }
}

- (void)adjustLayout {
    [self.bar adjustLayout];
}

@end

#ifdef __IPHONE_11_0

@implementation ios11Bar

- (void)initialize {
//    self.navigationBar.translatesAutoresizingMaskIntoConstraints = false;
  //don't use fat headers with translucency. it messes things up with the layout guides
  self.navigationBar.translucent = NO;
  self.navigationBar.clipsToBounds = NO;
  [self.navigationBar setBackgroundImage:[UIImage new]
            forBarPosition:UIBarPositionAny
                barMetrics:UIBarMetricsDefault];
  //remove shadow border image since we're relying on the navigationcontroller.view, and the line is a little ugly in flat design
  [self.navigationBar setShadowImage:[UIImage new]];
  self.navigationBar.backgroundColor = [UIColor clearColor];
}

- (CGSize)sizeThatFits:(CGSize)size {

    CGSize amendedSize = size;
  amendedSize.height += self.navigationBar.extraHeight;
  return amendedSize;
}

//- (void)setExtraHeight:(CGFloat)extraHeight {
//}

- (void)layoutSubviews {
//    CGRect frame = self.navigationBar.frame;
//    frame.origin.y = ([[UIApplication sharedApplication] isStatusBarHidden] ? 0 : 20) - self.navigationBar.extraHeight;
//    self.navigationBar.frame = frame;
//    NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
//
//    for (UIView *view in [self.navigationBar subviews]) {
//
//      if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
//
//        CGRect bounds = [self.navigationBar bounds];
//        CGRect frame = [view frame];
//        frame.origin.y    = bounds.origin.y - 20.f;
//        frame.size.height = bounds.size.height + 20.f;
//        [view setFrame:frame];
//      }
//    }
    
    
    

    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
        topPadding = window.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
    } else {
        // Fallback on earlier versions
    }
    
//    self.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationBar.frame = CGRectMake(self.navigationBar.frame.origin.x, topPadding,  self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);

    // title position (statusbar height / 2)
//    [self.navigationBar setTitleVerticalPositionAdjustment:-10 forBarMetrics:UIBarMetricsDefault];
    
    for (UIView *subview in [self.navigationBar subviews]) {
        NSString *stringFromClass = NSStringFromClass(subview.classForCoder);
        if ([stringFromClass containsString:@"BarBackground"]) {
//            subview.frame = CGRectMake(0, 44, self.navigationBar.frame.size.width, 90);
            
            
            CGRect bounds = [self.navigationBar bounds];
            CGRect frame = [subview frame];
            frame.origin.y    = bounds.origin.y - topPadding;
            frame.size.height = 44 + self.navigationBar.extraHeight+topPadding;
            [subview setFrame:frame];
//            subview.backgroundColor = [UIColor yellowColor];
        
        }
        
        stringFromClass = NSStringFromClass(subview.classForCoder);
        if ([stringFromClass containsString:@"BarContent"]) {

//            subview.frame = CGRectMake(subview.frame.origin.x, 20, subview.frame.size.width, 90 - 20);
//            subview.translatesAutoresizingMaskIntoConstraints = NO;
//            subview.backgroundColor = [UIColor greenColor];
//            [subview removeConstraints: ];
//            id a = subview.constraints;
            for (NSLayoutConstraint *con in subview.constraints ){
//                NSLog(@"con %@", [NSString stringWithFormat:@"%@",con]);
//                NSLog(@"%ld %@",(long)con.firstAttribute,NSStringFromClass([con.firstItem class]));
//
//                NSLog(@"%ld %@",(long)con.secondAttribute,NSStringFromClass([con.secondItem class]));
//                NSLog(@"%ld",(long)con.);
                
//                if ([NSStringFromClass([con.secondItem class]) containsString:@"UILayoutGuide"] && con.secondAttribute == NSLayoutAttributeHeight){
//                    con.active = NO;
//                }
                if ([NSStringFromClass([con.firstItem class]) containsString:@"UILayoutGuide"] && con.firstAttribute == NSLayoutAttributeHeight && [[NSString stringWithFormat:@"%@",con] containsString:@"TitleView"]){
//                    conactive = NO;
                    con.constant = 44 + self.navigationBar.extraHeight;
                }
                if ([NSStringFromClass([con.firstItem class]) containsString:@"InView"] && (
//                                                                                            con.firstAttribute == 3
//                                                                                            con.firstAttribute == 4
//                                                                                            con.firstAttribute == 5
//                                                                                            ||con.firstAttribute == 6
//                                                                                            ||
                                                                                            con.firstAttribute == NSLayoutAttributeCenterX
                                                                                            ||con.firstAttribute == NSLayoutAttributeCenterY
                                                                                            )){
//                    con.active = NO;
                    [subview setNeedsUpdateConstraints];
                }
            }
            
//            for (UIView *subSubview in subview.subviews ){
//                NSLog(@"%@", NSStringFromCGRect(subSubview.frame));
//                subSubview.frame = subview.bounds;
//                [subSubview sizeToFit];
//            }
        }
    }
    
    
//  [super layoutSubviews];
//  NSLog(@"layoutSubviews");
//  CGRect frame = self.frame;
//  NSLog(@"self %@", NSStringFromCGRect(frame));
////  frame.origin.y = ([[UIApplication sharedApplication] isStatusBarHidden] ? 0 : LVStatusBarHeight) - _extraHeight;
//  self.frame = frame;
//  NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
//
////  for (UIView *view in [self subviews]) {
////
////    if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
////
////      CGRect bounds = [self bounds];
////      CGRect frame = [view frame];
////      frame.origin.y    = bounds.origin.y - 20.f;
////      frame.size.height = bounds.size.height + 20.f;
////      [view setFrame:frame];
////    }
////  }
//  NSLog(@"self %@", NSStringFromCGRect(self.frame));
//    CGFloat customHeight = LVNavigationBarHeight+_extraHeight;
//    for (UIView *subview in self.subviews ){
//
//        NSLog(@"subView %@", NSStringFromCGRect(subview.frame));
//        NSString* stringFromClass = NSStringFromClass(subview.classForCoder);
//        if( [stringFromClass containsString:(@"UIBarBackground") ]) {
//
//            subview.frame = CGRectMake( 0,  0, self.frame.size.width, customHeight);
//            subview.backgroundColor = [UIColor redColor];
//            NSLog(@"UIBarBackground %@", NSStringFromCGRect(subview.frame));
//            [subview sizeToFit];
//
//        }
//        stringFromClass = NSStringFromClass(subview.classForCoder);
//        //Can't set height of the UINavigationBarContentView
//        if( [stringFromClass containsString:(@"UINavigationBarContentView")]) {
//            //Set Center Y
//            NSLog(@"%@",subview.constraints);
//            CGFloat centerY = (customHeight - customHeight) / 2.0;
//            subview.frame = CGRectMake(0,  centerY,  self.frame.size.width,  customHeight);
//            subview.backgroundColor = [UIColor greenColor];
//            NSLog(@"UINaviBarContent %@", NSStringFromCGRect(subview.frame));
//
//            for (UIView *subSubview in subview.subviews ){
//                subSubview.frame = subview.bounds;
//                [subSubview sizeToFit];
//            }
//        }
//    }
//
//    [self sizeToFit];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
}

- (void)adjustLayout {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
        topPadding = window.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
    } else {
        // Fallback on earlier versions
    }
//  [self sizeToFit];
  CGRect frame = [self.navigationBar frame];
    frame.origin.y = self.navigationBar.translucent ? 0 : topPadding;
  self.navigationBar.frame = frame;
}

@end

#endif

@implementation ios9Bar

- (void)initialize {
  //don't use fat headers with translucency. it messes things up with the layout guides
  self.navigationBar.translucent = NO;
  self.navigationBar.clipsToBounds = NO;
  [self.navigationBar setBackgroundImage:[UIImage new]
            forBarPosition:UIBarPositionAny
                barMetrics:UIBarMetricsDefault];
  //remove shadow border image since we're relying on the navigationcontroller.view, and the line is a little ugly in flat design
  [self.navigationBar setShadowImage:[UIImage new]];
  self.navigationBar.backgroundColor = [UIColor clearColor];
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize amendedSize = size;
  amendedSize.height += self.navigationBar.extraHeight;
  return amendedSize;
}

- (void)setExtraHeight:(CGFloat)extraHeight {
  self.navigationBar.extraHeight = extraHeight;
}

- (void)layoutSubviews {
  CGRect frame = self.navigationBar.frame;
  frame.origin.y = ([[UIApplication sharedApplication] isStatusBarHidden] ? 0 : 20) - self.navigationBar.extraHeight;
  self.navigationBar.frame = frame;
  NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];

  for (UIView *view in [self.navigationBar subviews]) {

    if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {

      CGRect bounds = [self.navigationBar bounds];
      CGRect frame = [view frame];
      frame.origin.y    = bounds.origin.y - 20.f;
      frame.size.height = bounds.size.height + 20.f;
      [view setFrame:frame];
    }
  }

}

- (void)setBarTintColor:(UIColor *)barTintColor {
}

- (void)adjustLayout {
  [self.navigationBar sizeToFit];
  CGRect frame = [self.navigationBar frame];
  frame.origin.y = self.navigationBar.translucent ? 0 : 20;
  self.navigationBar.frame = frame;
}

@end
