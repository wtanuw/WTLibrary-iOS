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

#define WATLOG_DEBUG
#import "WTMacro.h"


@interface iosxxBar : NSObject<ResizeableNavigationBar>
@property (nonatomic,weak) WTLVResizableNavigationBar* navigationBar;
@end

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
      NSObject<ResizeableNavigationBar> *bar = [ios11Bar new];
      bar.navigationBar = self;
      self.bar = bar;
  } else {
      NSObject<ResizeableNavigationBar> *bar = [ios9Bar new];
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
      NSObject<ResizeableNavigationBar> *bar = [ios11Bar new];
      bar.navigationBar = self;
      self.bar = bar;
  } else {
      NSObject<ResizeableNavigationBar> *bar = [ios9Bar new];
      bar.navigationBar = self;
      self.bar = bar;
  }
  if (self) {
    [self initialize];
  }
  return self;
}

- (CGFloat)normalHeight {
    static CGFloat _anormalHeight;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _anormalHeight = self.frame.size.height;
    });
    return _anormalHeight;
}

- (void)initialize {
    _normalHeight = self.frame.size.height;
    [self.bar initialize];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize amendedSize = [super sizeThatFits:size];
  return [self.bar sizeThatFits:amendedSize];
}

- (void)setExtraHeight:(CGFloat)extraHeight {
    
    WatLog(@"\n\n  bar setExtraHeight \n");
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = 20;
    if (@available(iOS 11.0, *)) {
        topPadding = window.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
        topPadding = 0;
    }
    WatLog(@"\n  bar extraHeight = %f \n",extraHeight);
    WatLog(@"\n  bar topPadding = %f \n",topPadding);
    WatLog(@"\n  bar _lastHeight = %f \n",_lastHeight);
    WatLog(@"\n  bar _extraHeight = %f \n",_extraHeight);
    
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

@implementation iosDefaultBar

- (void)initialize {}
- (void)adjustLayout {}

- (void)layoutSubviews {}


- (void)setBarTintColor:(UIColor *)barTintColor {}


- (CGSize)sizeThatFits:(CGSize)size {return size;}


@end

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
//        topPadding = self.navigationBar.safeAreaInsets.top;
//        NSLog(@"window %f    vs navbar %f ", topPadding, self.navigationBar.safeAreaInsets.top);
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
    } else {
        // Fallback on earlier versions
    }
    
//    self.navigationBar.tintColor = [UIColor blackColor];
    
    WatLog(@"self.navigationBar.frame %@  ",NSStringFromCGRect(self.navigationBar.frame), topPadding);
    self.navigationBar.frame = CGRectMake(self.navigationBar.frame.origin.x, topPadding,  self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    WatLog(@"self.navigationBar.frame %@  ",NSStringFromCGRect(self.navigationBar.frame), topPadding);

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
WatLog(@"bounds.origin %@  - toppad %.2f",NSStringFromCGRect(bounds), topPadding);
WatLog(@"frame %@  ",NSStringFromCGRect(frame), topPadding);
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

@implementation ios12Bar

- (void)initialize {
//    self.navigationBar.translatesAutoresizingMaskIntoConstraints = false;
  //don't use fat headers with translucency. it messes things up with the layout guides
    WatLog(@"\n\n   bar initialize \n");
  self.navigationBar.translucent = NO;
  self.navigationBar.clipsToBounds = NO;
  [self.navigationBar setBackgroundImage:[UIImage new]
            forBarPosition:UIBarPositionAny
                barMetrics:UIBarMetricsDefault];
  //remove shadow border image since we're relying on the navigationcontroller.view, and the line is a little ugly in flat design
  [self.navigationBar setShadowImage:[UIImage new]];
  self.navigationBar.backgroundColor = [UIColor clearColor];
//    [self.navigationBar ];
}
         
         -(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
             
             CGRect oframe = [[change valueForKey:NSKeyValueChangeOldKey] CGRectValue];
             CGRect nframe = [[change valueForKey:NSKeyValueChangeNewKey] CGRectValue];
             WatLog(@"\nobserve %@ -> %@", NSStringFromCGRect(oframe), NSStringFromCGRect(nframe));
        }

- (CGSize)sizeThatFits:(CGSize)size {
    WatLog(@"\n\n   bar sizeThatFits \n");
    WatLog(@"\n   bar size = %@ \n",NSStringFromCGSize(size));
    WatLog(@"\n   bar amendedSize.height + extraHeight = %f +%f = %f \n",size.height, self.navigationBar.extraHeight, size.height + self.navigationBar.extraHeight);

    CGSize amendedSize = size;
  amendedSize.height += self.navigationBar.extraHeight;
  return amendedSize;
}

//- (void)setExtraHeight:(CGFloat)extraHeight {
//}

- (void)layoutSubviews {
    WatLog(@"\n\n   bar layoutSubviews \n");
    
    if (self.navigationBar.obser == NO) {
        
    for (UIView* subView in self.navigationBar.subviews) {
        
        NSString *stringFromClass = NSStringFromClass(subView.classForCoder);
        if ([stringFromClass containsString:@"BarBackground"]) {
            
        [subView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        }}
        self.navigationBar.obser = YES;
    }
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
//        topPadding = self.navigationBar.safeAreaInsets.top;
//        NSLog(@"window %f    vs navbar %f ", topPadding, self.navigationBar.safeAreaInsets.top);
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
    } else {
        // Fallback on earlier versions
    }
    
//    self.navigationBar.tintColor = [UIColor blackColor];
    
    WatLog(@"\n   bar topPadding %f  ",topPadding);
    WatLog(@"\n   bar self.navigationBar.frame %@  ",NSStringFromCGRect(self.navigationBar.frame));
//    self.navigationBar.frame = CGRectMake(self.navigationBar.frame.origin.x, topPadding,  self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    WatLog(@"\n   bfar self.navigationBar.frame %@  ",NSStringFromCGRect(self.navigationBar.frame), topPadding);

    // title position (statusbar height / 2)
//    [self.navigationBar setTitleVerticalPositionAdjustment:-10 forBarMetrics:UIBarMetricsDefault];
    
    for (UIView *subview in [self.navigationBar subviews]) {
        NSString *stringFromClass = NSStringFromClass(subview.classForCoder);

        WatLog(@"\n -------bar %@ = %@",stringFromClass, NSStringFromCGRect(subview.frame));
        self.navigationBar.layer.borderColor = [UIColor grayColor].CGColor;
        self.navigationBar.layer.borderWidth = 4;
//        subview.translatesAutoresizingMaskIntoConstraints = NO;
        if ([stringFromClass containsString:@"BarBackground"]) {
            subview.layer.borderColor = [UIColor orangeColor].CGColor;
            subview.layer.borderWidth = 4;
            
        }
        
        if ([stringFromClass containsString:@"BarContent"]) {
            subview.layer.borderColor = [UIColor purpleColor].CGColor;
            subview.layer.borderWidth = 4;
            
        }
        
        if ([stringFromClass containsString:@"BarBackground"]) {
//            subview.frame = CGRectMake(0, 44, self.navigationBar.frame.size.width, 90);
            
            CGRect bounds = [self.navigationBar bounds];
            CGRect frame = [subview frame];
            frame.origin.y    = bounds.origin.y - topPadding;
            frame.size.height = 44 + self.navigationBar.extraHeight+topPadding;
            [subview setFrame:frame];
//            subview.backgroundColor = [UIColor yellowColor];
WatLog(@"\n ---bar bounds.origin - toppad = %@ - %.2f",NSStringFromCGRect(bounds), topPadding);
WatLog(@"\n -++-bar frame = %@  ",NSStringFromCGRect(frame), topPadding);
        }
        
        stringFromClass = NSStringFromClass(subview.classForCoder);
//        if ([stringFromClass containsString:@"BarContent"]) {
//
////            subview.frame = CGRectMake(subview.frame.origin.x, 20, subview.frame.size.width, 90 - 20);
////            subview.translatesAutoresizingMaskIntoConstraints = NO;
////            subview.backgroundColor = [UIColor greenColor];
////            [subview removeConstraints: ];
//            id a = subview.constraints;
            for (NSLayoutConstraint *con in subview.constraints ){
////                NSLog(@"con %@", [NSString stringWithFormat:@"%@",con]);
////                NSLog(@"%ld %@",(long)con.firstAttribute,NSStringFromClass([con.firstItem class]));
////
////                NSLog(@"%ld %@",(long)con.secondAttribute,NSStringFromClass([con.secondItem class]));
////                NSLog(@"%ld",(long)con.);
//
////                if ([NSStringFromClass([con.secondItem class]) containsString:@"UILayoutGuide"] && con.secondAttribute == NSLayoutAttributeHeight){
////                    con.active = NO;
////                }
//                if ([NSStringFromClass([con.firstItem class]) containsString:@"UILayoutGuide"] && con.firstAttribute == NSLayoutAttributeHeight && [[NSString stringWithFormat:@"%@",con] containsString:@"TitleView"]){
////                    conactive = NO;
////                    con.constant = 44 + self.navigationBar.extraHeight;
//                }
//                if ([NSStringFromClass([con.firstItem class]) containsString:@"InView"] && (
////                                                                                            con.firstAttribute == 3
////                                                                                            con.firstAttribute == 4
////                                                                                            con.firstAttribute == 5
////                                                                                            ||con.firstAttribute == 6
////                                                                                            ||
//                                                                                            con.firstAttribute == NSLayoutAttributeCenterX
//                                                                                            ||con.firstAttribute == NSLayoutAttributeCenterY
//                                                                                            )){
////                    con.active = NO;
//                    [subview setNeedsUpdateConstraints];
//                }
            }
            
//            for (UIView *subSubview in subview.subviews ){
//                NSLog(@"%@", NSStringFromCGRect(subSubview.frame));
//                subSubview.frame = subview.bounds;
//                [subSubview sizeToFit];
//            }
//        }
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
    WatLog(@"\n\n   bar setBarTintColor \n");
}

- (void)adjustLayout {
    WatLog(@"\n\n   bar adjustLayout \n");
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat topPadding = 0;
    if (@available(iOS 11.0, *)) {
        topPadding = self.navigationBar.normalHeight;
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.0, *)) {
    } else {
        // Fallback on earlier versions
    }
    WatLog(@"\n   bar topPadding = %f \n",topPadding);
//  [self sizeToFit];
  CGRect frame = [self.navigationBar frame];
  WatLog(@"\n   bar navigationBar.frame = %f \n",NSStringFromCGRect(frame));
    frame.origin.y = self.navigationBar.translucent ? 0 : topPadding;
  self.navigationBar.frame = frame;
  WatLog(@"\n   bar navigationBar.frame = %f \n",NSStringFromCGRect(frame));
}

@end

@implementation iosxxBar

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFit = size;//[super sizeThatFits:size];
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        if (sizeThatFit.height < 64.f) {
            sizeThatFit.height = 264.f;
        }
    }
    return sizeThatFit;
}

- (void)setFrame:(CGRect)frame {
    if ([UIApplication sharedApplication].isStatusBarHidden) {
//        frame.size.height = 64;
    }
//    [super setFrame:frame];
}

- (void)layoutSubviews
{
//    [super layoutSubviews];

    for (UIView *subview in self.navigationBar.subviews) {
        if ([NSStringFromClass([subview class]) containsString:@"BarBackground"]) {
            CGRect subViewFrame = subview.frame;
            subViewFrame.origin.y = 0;
            subViewFrame.size.height = 264;
            [subview setFrame: subViewFrame];
        }
        if ([NSStringFromClass([subview class]) containsString:@"BarContentView"]) {
            CGRect subViewFrame = subview.frame;
            subViewFrame.origin.y = 20;
            subViewFrame.size.height = 244;
            [subview setFrame: subViewFrame];
        }
    }
}

- (void)adjustLayout {
    
}


- (void)initialize {
    
}


- (void)setBarTintColor:(UIColor *)barTintColor {
    
}


@end
