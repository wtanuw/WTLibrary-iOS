//
//  RumexCustomTabBar.h
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTMacro.h"

#define nHideTabFooterWithPushAnimationNotification @"hideTab"
#define nShowTabFooterWithPopAnimationNotification @"showTab"

typedef enum {
    TabbarPositionMiddle,//middle
    TabbarPositionLeft,//left
    TabbarPositionRight//right
} TabbarPosition;

@interface WTTabbarController : UITabBarController {
    TabbarPosition tabbarPosition;
    UIView *tabbarView;
}

@property (nonatomic, assign) TabbarPosition tabbarPosition;
@property (nonatomic, retain) UIView *tabbarView;

- (CGSize)screenSize;
- (CGSize)tabbarSize;//Override
- (void)addCustomElements;//Override

- (void)makeHighLightToButtonIndex:(int)index;//Override
- (void)selectTab:(int)tabID;//Override

- (void)hideNewTabBar;//Override
- (void)showNewTabBar;//Override
- (void)adjustTabbar;//Override

- (void)buttonClicked:(id)sender;//Override
@end
