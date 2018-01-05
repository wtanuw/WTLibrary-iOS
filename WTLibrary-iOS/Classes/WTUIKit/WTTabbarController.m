//
//  RumexCustomTabBar.m
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//
//http://www.rumex.it/2010/07/how-to-customise-the-tab-bar-uitabbar-in-an-iphone-application-part-1-of-2/

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#import "WTTabbarController.h"

@interface WTTabbarController ()
- (void)hideTabBar;
- (void)moveTabbarPositionLeft;
- (void)moveTabbarPositionMiddle;
- (void)moveTabbarPositionRight;
- (void)HideTabbarWithPushAnimation;
- (void)ShowTabbarWithPopAnimation;
- (void)HideTabbarWithPopAnimation;
- (void)ShowTabbarWithPushAnimation;

- (void)buttonClicked:(id)sender;
@end

@implementation WTTabbarController
@synthesize tabbarPosition;
@synthesize tabbarView;

- (void)viewDidLoad
{
    [self hideTabBar];
    [self adjustTabbar];
	
    [self addCustomElements];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(HideTabbarWithPushAnimation)
                                                 name:nHideTabFooterWithPushAnimationNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(ShowTabbarWithPopAnimation) 
                                                 name:nShowTabFooterWithPopAnimationNotification 
                                               object:nil];
    
    [super viewDidLoad];
}

#pragma mark -

- (CGSize)screenSize
{
//    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
//        screenSize = [UIScreen mainScreen].bounds.size;
//    }else{
//        screenSize = [UIScreen mainScreen].bounds.size;
//    }
    return [UIScreen mainScreen].bounds.size;
}

- (CGSize)tabbarSize
{
    return CGSizeMake(320, 49);
}

- (void)addCustomElements
{
    CGSize screenSize = [self screenSize];
    
    tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height-50, screenSize.width, 50+1)];
    tabbarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tabbarView];
    WT_SAFE_ARC_RELEASE(tabbarView);
    
//    // Initialise our two images
//	UIImage *btnImage = [UIImage imageNamed:[arrayOfImageNormal objectAtIndex:0]];
//	UIImage *btnImageSelected = [UIImage imageNamed:[arrayOfImageSelected objectAtIndex:0]];
//	self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
//	btn1.frame = CGRectMake(((screenSize.width*1/5)-screenSize.width/5/2-buttonSize.width/2)*1, 0, buttonSize.width, buttonSize.height); // Set the frame (size and position) of the button)
//	[btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
//	[btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
//    [btn1 setImage:btnImageSelected forState:UIControlStateHighlighted];
//    [btn1 setImage:btnImageSelected forState:(UIControlStateHighlighted|UIControlStateSelected)];
//	[btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
//	[btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
//    
//    // Now we repeat the process for the other buttons
//	btnImage = [UIImage imageNamed:[arrayOfImageNormal objectAtIndex:1]];
//	btnImageSelected = [UIImage imageNamed:[arrayOfImageSelected objectAtIndex:1]];
}

#pragma mark -

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [self makeHighLightToButtonIndex:(int)selectedIndex];
}

- (void)buttonClicked:(id)sender
{
	int tagNum = (int)[sender tag];
	[self selectTab:tagNum];
}

#pragma mark -

-(void)makeHighLightToButtonIndex:(int)index
{
    switch(index)
	{
        default:
            break;
	}
}

- (void)selectTab:(int)tabID
{
	[self makeHighLightToButtonIndex:tabID];
    
    if (self.selectedIndex == tabID) {
        UINavigationController *navController = (UINavigationController *)[self selectedViewController];
        [navController popToRootViewControllerAnimated:YES];
    }else{
        self.selectedIndex = tabID;
    }
}

#pragma mark -

- (void)hideNewTabBar   
{
    
}

- (void)showNewTabBar 
{
    
}

- (void)adjustTabbar
{
    CGSize screenSize = [self screenSize];
    CGSize tabbarSize = [self tabbarSize];
    
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
        {
            view.frame = CGRectMake(0, screenSize.height-tabbarSize.height, screenSize.width, tabbarSize.height);
        }
        else
        {
            view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height-tabbarSize.height);
        }
	}
}

#pragma mark -

- (BOOL)shouldAutorotate
{
    return YES;
}

#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_6_0)
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}
#else
- (NSUInteger)supportedInterfaceOrientations
{
    return (1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationPortraitUpsideDown);
}
#endif

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    UIInterfaceOrientation a = [[UIApplication sharedApplication] statusBarOrientation];
//    return a;
//}

#pragma mark -

- (void)dealloc {
    WT_SAFE_ARC_RELEASE(tabbarView);
    tabbarView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nHideTabFooterWithPushAnimationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nShowTabFooterWithPopAnimationNotification object:nil];
    
    WT_SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark - Private

//- (void)hideTabBar
//{
//    CGSize screenSize = [self screenSize];
//    CGSize tabbarSize = [self tabbarSize];
//    
//	for(UIView *view in self.view.subviews)
//	{
//		if([view isKindOfClass:[UITabBar class]])
//        {
//            view.frame = CGRectMake(0, 480-30, 320, 30); // 30 is the height of my custom TabBar
//            view.hidden = YES;
//            //break;
//        }
//        else
//        {
//            view.frame = CGRectMake(0, 0, 320, 480-30); //450 is the over all height minus height of my custom tabbar
//        }
//	}
//}

- (void)hideTabBar
{
    for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

- (void)moveTabbarPositionLeft{
    
    self.tabbarView.frame = CGRectMake(-[self screenSize].width, tabbarView.frame.origin.y, tabbarView.frame.size.width, tabbarView.frame.size.height);
    
}
- (void)moveTabbarPositionMiddle{
	
    self.tabbarView.frame = CGRectMake(0, tabbarView.frame.origin.y, tabbarView.frame.size.width, tabbarView.frame.size.height);
    
}
- (void)moveTabbarPositionRight{
    
    self.tabbarView.frame = CGRectMake([self screenSize].width, tabbarView.frame.origin.y, tabbarView.frame.size.width, tabbarView.frame.size.height);
    
}
//         ___
//        |   |
//        |___|
// ::1::  |_2_|  ::3::
// left   middle right
- (void)HideTabbarWithPushAnimation{//2to1
    
    if(tabbarPosition == TabbarPositionRight){
        [self moveTabbarPositionLeft];
    }
    
    tabbarPosition = TabbarPositionLeft;
    
    [self hideTabBar];
    [self hideNewTabBar];
    
    [UIView animateWithDuration:0.36f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self moveTabbarPositionLeft];
                         [self adjustTabbar];
                     }
                     completion:nil
     ];
}
- (void)ShowTabbarWithPopAnimation{//1to2
    
    if(tabbarPosition == TabbarPositionRight){
        [self moveTabbarPositionLeft];
    }
    
    tabbarPosition = TabbarPositionMiddle;
    
    [self showNewTabBar];
    
    [UIView animateWithDuration:0.33f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self moveTabbarPositionMiddle];
                         [self adjustTabbar];
                     }
                     completion:nil
     ];
}
- (void)HideTabbarWithPopAnimation{//2to3
    
    if(tabbarPosition == TabbarPositionLeft){
        [self moveTabbarPositionRight];
    }
    
    tabbarPosition = TabbarPositionRight;
    
    [self hideTabBar];
    [self hideNewTabBar];
    
    [UIView animateWithDuration:0.36f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self moveTabbarPositionRight];
                         [self adjustTabbar];
                     }
                     completion:nil
     ];
}
- (void)ShowTabbarWithPushAnimation{//3to2
    
    if(tabbarPosition == TabbarPositionLeft){
        [self moveTabbarPositionRight];
    }
    
    tabbarPosition = TabbarPositionMiddle;
    
    [self showNewTabBar];
    
    [UIView animateWithDuration:0.33f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self moveTabbarPositionMiddle];
                         [self adjustTabbar];
                     }
                     completion:nil
     ];
}

@end
