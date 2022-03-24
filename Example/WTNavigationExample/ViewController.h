//
//  ViewController.h
//  WTNavigationExample
//
//  Created by Mac on 9/4/2564 BE.
//  Copyright © 2564 BE wtanuw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end


//
//  HomeRevealVCT.h
//  ZIONPlayer
//
//  Created by Wat Wongtanuwat on 1/7/13.
//  Copyright (c) 2013 aim. All rights reserved.
//

//#import "WTObjC.h"
#import "WTCategoriesExtension.h"

//#import "ZionTabbar.h"
#import "PPRevealSideViewController.h"
//#import "UIView+Toast.h"

#define nRevealShowTopNotification @"playerNotification"
#define nRevealShowLeftNotification @"freeNotification"
#define nRevealShowBottomNotification @"otherNotification"
#define nRevealShowRightNotification @"homeMusicNotification"
#define nRevealShowCenterNotification @"center"

@interface HomeRevealVCT : UIViewController<PPRevealSideViewControllerDelegate> {
}

+ (instancetype)viewControllerWithStoryboard;


@end

