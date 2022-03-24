//
//  HomeRevealVCT.h
//  ZIONPlayer
//
//  Created by Wat Wongtanuwat on 1/7/13.
//  Copyright (c) 2013 aim. All rights reserved.
//

#import "WTObjC.h"
#import "WTCategoriesExtension.h"

//#import "ZionTabbar.h"
#import "PPRevealSideViewController.h"
//#import "UIView+Toast.h"

@interface HomeRevealVCT : UIViewController<PPRevealSideViewControllerDelegate,WTHudDelegate> {
//        
//    UIView *adsView;
    
    int lastPushViewNumber;
}

+ (instancetype)viewControllerWithStoryboard;

@property (nonatomic, weak) UIView *adsView;

@property (weak, nonatomic) PPRevealSideViewController *revealController;

//@property (retain, nonatomic) ZionTabbar *tabController;
@property (weak ,nonatomic) UINavigationController *navigation0;

@property (strong, nonatomic) UINavigationController *navigation1;//player
@property (strong, nonatomic) UINavigationController *navigation2;//webview
@property (strong, nonatomic) UINavigationController *navigation3;//other
@property (strong, nonatomic) UINavigationController *navigation4;//music

@property (weak, nonatomic) UIProgressView *progress;

@end
