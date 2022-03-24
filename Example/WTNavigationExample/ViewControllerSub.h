//
//  ViewController1.h
//  WTNavigationExample
//
//  Created by Mac on 16/4/2564 BE.
//  Copyright © 2564 BE wtanuw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WTLVResizableNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerSub : UIViewController<WTLVResizableNavigationBarController>


+ (instancetype)viewControllerWithStoryboard;
+ (instancetype)viewControllerWithStoryboard:(int)number;
+ (UINavigationController*)wtNavigationViewControllerWithStoryboard;
+ (UINavigationController*)lvNavigationControllerWithStoryboard;
+ (UINavigationController*)codeNavigationViewControllerWithStoryboard;

@end

NS_ASSUME_NONNULL_END
