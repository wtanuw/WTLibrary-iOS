//
//  HomeRevealVCT.m
//  ZIONPlayer
//
//  Created by Wat Wongtanuwat on 1/7/13.
//  Copyright (c) 2013 aim. All rights reserved.
//

#import "HomeRevealVCT.h"

#import "ZionShared.h"
#import "ZionTabbar.h"
#import "ZionNavigationBar.h"

#import "HomeCenterVCT.h"

#import "MusicPlayerControl3VCT.h"
#import "WebViewLinkCustomHandler.h"
#import "OtherPageVCT.h"

//#import "inAppHomeArtworkVCT.h"
//#import "iPodHomeArtworkVCT.h"
#import "BothHomeArtworkVCT.h"

#import "WTLVResizableNavigationAnimation.h"
#import "WTLVResizableNavigationBar.h"
#import "WTLVResizableNavigationController.h"
#define revealAnimationTime (1.0f*0.5)

// firstViewNumber : 1 = MusicPlayerControl3VCT, 2 = WebViewLinkCustomHandler, 3 = OtherPageVCT, 4 = BothHomeArtworkVCT
#define firstViewNumber 3

@interface HomeRevealVCT ()

@end

@implementation HomeRevealVCT
//@synthesize adsView = adsView;
@synthesize revealController = _revealController;
//@synthesize tabController = _tabController;
//@synthesize navigation0 = navigation0;
@synthesize navigation1 = navigation1;
@synthesize navigation2 = navigation2;
@synthesize navigation3 = navigation3;
@synthesize navigation4 = navigation4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (instancetype)viewControllerWithStoryboard
{
    id vct = [[UIStoryboard storyboardWithName:@"PlaceHolder" bundle:nil] instantiateViewControllerWithIdentifier:@"reveal"];
    return vct;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [[ZionMenuHud sharedManager] setHudDelegate:self];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(hideAdsTabbar)
//                                                 name:nZionAdsShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(hideAdsTabbar)
//                                                 name:nZionAdsHideNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:nZionAdsHideNotification object:nil];
    
    
    
    
    //2.0 version, combine 2 vct into tabbar
//    inAppHomeArtworkVCT *vct1 = [[inAppHomeArtworkVCT alloc] initWithNibName:@"HomeArtworkVCT" bundle:nil];
//    iPodHomeArtworkVCT *vct2 = [[iPodHomeArtworkVCT alloc] initWithNibName:@"HomeArtworkVCT" bundle:nil];
//    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vct1];
//    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vct2];
//    
//    ZionNavigationBar *navigationBar1 = [[ZionNavigationBar alloc] initWithNavigationController:nav1];
//    [navigationBar1 setBackgroundImage:[UIImage imageNamed:(UI_INTERFACE_IDIOM_IS_IPAD())?@"navigation_bg.png":@"navigation_bg_2.png"]];
//    [navigationBar1 release];
//    
//    ZionNavigationBar *navigationBar2 = [[ZionNavigationBar alloc] initWithNavigationController:nav2];
//    [navigationBar2 setBackgroundImage:[UIImage imageNamed:(UI_INTERFACE_IDIOM_IS_IPAD())?@"navigation_bg.png":@"navigation_bg_2.png"]];
//    [navigationBar2 release];
//    
//    CGRect frame1 = nav1.navigationBar.frame;
//    frame1.origin.y = 0;
//    nav1.navigationBar.frame = frame1;
//    [nav1.navigationBar layoutIfNeeded];
//    CGRect frame2 = nav2.navigationBar.frame;
//    frame2.origin.y = 0;
//    nav2.navigationBar.frame = frame2;
//    
//    self.tabController = [[[ZionTabbar alloc] init] autorelease];
//    [self.tabController.tabBar setHidden:YES];
//    self.tabController.viewControllers = [NSArray arrayWithObjects: nav1, nav2, nil];
//    
//    [vct1 release];
//    [vct2 release];
//    [nav1 release];
//    [nav2 release];
    
    //2.2 version, both artwork in same vct
//    BothHomeArtworkVCT *vct1 = [[BothHomeArtworkVCT alloc] initWithNibName:@"HomeArtworkVCT" bundle:nil];
//    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vct1];
//    
//    ZionNavigationBar *navigationBar1 = [[ZionNavigationBar alloc] initWithNavigationController:nav1];
//    [navigationBar1 setBackgroundImage:[UIImage imageNamed:(UI_INTERFACE_IDIOM_IS_IPAD())?@"navigation_bg.png":@"navigation_bg_2.png"]];
//    [navigationBar1 release];
//    //NSLog(@"%@",NSStringFromCGRect(navigationBar1.frame));
//    CGRect frame1 = nav1.navigationBar.frame;
//    frame1.origin.y = 0;
//    nav1.navigationBar.frame = frame1;
//    [nav1.navigationBar layoutIfNeeded];
//    //NSLog(@"%@",NSStringFromCGRect(navigationBar1.frame));
//    
//    self.navigation0 = nav1;
//    [vct1 release];
//    [nav1 release];
    
    //2.3 version, show webview first
    //2.4.2 version, show player first
    int firstViewControllerNumber = firstViewNumber;
    
    if(firstViewControllerNumber == 1)
    {
        UINavigationController *nav = [MusicPlayerControl3VCT navigationControllerWithStoryboard];
//        MusicPlayerControl3VCT *vct = [[MusicPlayerControl3VCT alloc] initWithNibName:@"MusicPlayerControl3VCT" bundle:nil];
//        WTLVResizableNavigationController *nav = [[WTLVResizableNavigationController alloc] initWithRootViewController:vct];
//        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
//        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg_player.png"]];
//        nav.navigationBar.backgroundColor = UIColorMake(89, 89, 89);
    
        self.navigation1 = nav;
        
//        [vct release];
//        [nav release];
//        [navigationBar release];
        
        self.navigation0 = self.navigation1;
        lastPushViewNumber = firstViewControllerNumber;
        
    }
    else if(firstViewControllerNumber == 2)
    {
        UINavigationController *nav = [WebViewLinkCustomHandler navigationControllerWithStoryboard];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vct];
//        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
//        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
        
        self.navigation2 = nav;
        
//        [vct release];
//        [nav release];
//        [navigationBar release];
        
        self.navigation0 = self.navigation2;
        lastPushViewNumber = firstViewControllerNumber;
    }
    else if(firstViewControllerNumber == 3)
    {
        UINavigationController *nav = [OtherPageVCT navigationControllerWithStoryboard];
//        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
//        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
        
        self.navigation3 = nav;
        
//        [nav release];
//        [navigationBar release];
        
        self.navigation0 = self.navigation3;
        lastPushViewNumber = firstViewControllerNumber;
    }
    else if(firstViewControllerNumber == 4)
    {
        UINavigationController *nav = [BothHomeArtworkVCT navigationControllerWithStoryboard];
//        UINavigationController *nav = [[WTLVResizableNavigationController alloc] initWithRootViewController:vct];
//        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
//        [navigationBar setBackgroundImage:[UIImage imageNamed:(UI_INTERFACE_IDIOM_IS_IPAD())?@"navigation_bg.png":@"navigation_bg_2.png"]];
        
        self.navigation4 = nav;
        
//        [vct release];
//        [nav release];
//        [navigationBar release];
        
        self.navigation0 = self.navigation4;
        lastPushViewNumber = firstViewControllerNumber;
    }
    
    CGRect frame = self.navigation0.navigationBar.frame;
    frame.origin.y = 0;
    self.navigation0.navigationBar.frame = frame;
    [self.navigation0.navigationBar layoutIfNeeded];
    
    
    CGRect a = self.view.frame;
    
    HomeCenterVCT *centerVCT = [HomeCenterVCT viewControllerWithStoryboard];
    
    self.revealController = [[PPRevealSideViewController alloc] initWithRootViewController:centerVCT];
    
//    [centerVCT release];
    
    self.view.frame = a;
    self.revealController.view.frame = a;
    
    [self.view addSubview:self.revealController.view];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        [self addChildViewController:self.revealController];
    }
    
    self.revealController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.revealController.delegate = self;
    
    [self.revealController setDirectionsToShowBounce:PPRevealSideDirectionNone];
    
    PPRevealSideInteractions inter1 = PPRevealSideInteractionNone;
    self.revealController.panInteractionsWhenClosed = inter1;
    
    PPRevealSideInteractions inter2 = PPRevealSideInteractionNavigationBar | PPRevealSideInteractionContentView;
    self.revealController.panInteractionsWhenOpened = inter2;
    
    PPRevealSideInteractions inter3 = PPRevealSideInteractionNavigationBar | PPRevealSideInteractionContentView;
    self.revealController.tapInteractionsWhenOpened = inter3;
    
    [self.revealController resetOption:PPRevealSideOptionsShowShadows];
    [self.revealController resetOption:PPRevealSideOptionsCloseCompletlyBeforeOpeningNewDirection];
    [self.revealController setOption:PPRevealSideOptionsKeepOffsetOnRotation];
    
//    [self.revealController pushViewController:self.tabController onDirection:PPRevealSideDirectionRight withOffset:0.0f animated:NO forceToPopPush:NO];
    [self.revealController preloadViewController:self.navigation0 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
    
    [self.revealController resetOption:PPRevealSideOptionsiOS7StatusBarFading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowPlayerPageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowFreePageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowOtherPageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowMusicPageNotification
                                               object:nil];
    
    
    _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    if(UI_INTERFACE_IDIOM_IS_IPAD()){
        _progress.frame = CGRectMake(0, 0, 400, 40);
    }
    
    _progress.center = CGPointMake(self.view.center.x, self.view.center.y+80);
    
    [self.view addSubview:_progress];
    
//    [_progress release];
    
    __block int songAppDocCount = 0;
    
//    dispatch_async(<#dispatch_queue_t queue#>, ^{
//        
//        [[ZionShared sharedManager] updateAutoMyMusicPlaylist];
//        [self.revealController openCompletelySide:PPRevealSideDirectionRight animated:NO];
//    })
    
    
//    CLS_LOG(@"CLS-before query all song");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
//        CLS_LOG(@"CLS-query app song");
        [[ZionShared sharedManager] firstQueryAllSongAppDocWithBlock:^(int current, int total) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                _progress.progress = current*1.0/total;
                songAppDocCount = current;
            });
        }];
//        CLS_LOG(@"CLS-query ipod song");
        [[ZionShared sharedManager] firstQueryAllSongiPodWithBlock:^(int current, int total) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                _progress.progress = (songAppDocCount + current)*1.0/total;
            });
        }];
        
        [[ZionShared sharedManager] updateAutoMyMusicPlaylist];
        [[ZionShared sharedManager] readLastPlayedPlaylist];
//        NSMutableArray *array = [NSMutableArray array];
//        [array addObjectsFromArray:[[ZionShared sharedManager] queryAllSongAppDoc]];
//        [array addObjectsFromArray:[[ZionShared sharedManager] queryAllSongiPod]];
//        self.albumArray = [self separateToArtworkAlbumFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
//            [UIView animateWithDuration:0.3 animations:^{
//                self.revealController.view.alpha = 0.0;
//            } completion:^(BOOL finished) {
//                self.revealController.view.alpha = 1.0;
//            }];
            
            [UIView animateWithDuration:0.3 animations:^{
                _progress.alpha = 0;
            } completion:^(BOOL finished) {
                _progress.hidden = YES;
                
                [self.revealController openCompletelySide:PPRevealSideDirectionLeft animated:NO];
//                CLS_LOG(@"CLS-after query all song");
            }];
            
        });
    });
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
//    [adsView release];
//    [_revealController release];
////    [_tabController release];
//    [navigation0 release];
//    [navigation1 release];
//    [navigation2 release];
//    [navigation3 release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nZionAdsShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nZionAdsHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowPlayerPageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowFreePageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowOtherPageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowMusicPageNotification object:nil];
//    [super dealloc];
}

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(UI_INTERFACE_IDIOM_IS_IPHONE()){
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);;
    }else{
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if(UI_INTERFACE_IDIOM_IS_IPHONE()){
        return (1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationPortraitUpsideDown);
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

#pragma mark -

- (CGSize)screenSize
{
    //    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
    //        screenSize = [UIScreen mainScreen].bounds.size;
    //    }else{
    //        screenSize = [UIScreen mainScreen].bounds.size;
    //    }
    return [[UIScreen mainScreen] bounds].size;
}

- (CGSize)adsSize
{
//    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
//        return GAD_SIZE_728x90;
//    }else{
//        if((UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH())){
//            return GAD_SIZE_320x50;
//        }else{
//            return GAD_SIZE_320x50;
//        }
//    }
    return CGSizeZero;
}

- (void)showAdsTabbar
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.adsView.alpha = 1;
                         self.adsView.frame = CGRectMake(0,
                                                         0+(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?20:0),
                                                         [self adsSize].width,
                                                         [self adsSize].height);
                         self.revealController.view.frame = CGRectMake(0,
                                                                       [self adsSize].height,
                                                                       [self screenSize].width,
                                                                       [self screenSize].height-[self adsSize].height+(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?20:0));
                         WatLog(@"showAds %@",NSStringFromCGRect(self.revealController.view.frame));
                         
                     }];
}

- (void)hideAdsTabbar
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.adsView.alpha = 0;
                         self.adsView.frame = CGRectMake(0,
                                                         -[self adsSize].height,
                                                         [self adsSize].width,
                                                         [self adsSize].height);
                         self.revealController.view.frame = CGRectMake(0,
                                                                       0,
                                                                       [self screenSize].width,
                                                                       [self screenSize].height+(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?20:0));
                         WatLog(@"hideAds %@",NSStringFromCGRect(self.revealController.view.frame));
                     }];
}

#pragma mark -

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willChangeCenterController:(UIViewController*)oldCenterController
{
    if([oldCenterController isKindOfClass:[UITabBarController class]]){
        
    }else if([oldCenterController isKindOfClass:[UINavigationController class]]){
        ZionNavigationBar* customNavigationBar = (ZionNavigationBar*)((UINavigationController*)oldCenterController).navigationBar;
        if([customNavigationBar respondsToSelector:@selector(setBackgroundImage:)])
        {
            customNavigationBar.navigationController = nil;
        }
    }
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didChangeCenterController:(UIViewController*)newCenterController
{
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController
{
    if(pushedController == [controller controllerForSide:PPRevealSideDirectionRight]){
        UIViewController *a = [controller controllerForSide:PPRevealSideDirectionLeft];
        a.view.alpha = 0.0f;
        UIViewController *b = [controller controllerForSide:PPRevealSideDirectionRight];
        b.view.alpha = 1.0f;
    }else{
        UIViewController *a = [controller controllerForSide:PPRevealSideDirectionLeft];
        a.view.alpha = 1.0f;
        UIViewController *b = [controller controllerForSide:PPRevealSideDirectionRight];
        b.view.alpha = 0.0f;
    }
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController
{
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController
{
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController
{
    
}

#pragma mark -

- (void)WTHud:(WTHud *)hud isTouchInside:(BOOL)inside
{
    if(hud == [ZionMenuHud sharedManager])
    {
        if([(ZionMenuHud*)hud isGrowAnimation]){
            return;
        }
        if([hud isVisible] && !inside){
            
            [[ZionMenuHud sharedManager] hide];
            
        }else if([hud isVisible] && inside){
            
            [[ZionMenuHud sharedManager] hide];
            
        }
    }
}

#pragma mark -

- (void)menuPressedNotification:(NSNotification*)notification
{
//    NSNumber *number = (NSNumber*)[notification object];
    
    NSNumber *number = [NSNumber numberWithInt:0];
    if([[notification name] isEqualToString:nRevealShowPlayerPageNotification]){
        number = [NSNumber numberWithInt:1];
    }else if([[notification name] isEqualToString:nRevealShowFreePageNotification]){
        number = [NSNumber numberWithInt:2];
    }else if([[notification name] isEqualToString:nRevealShowOtherPageNotification]){
        number = [NSNumber numberWithInt:3];
    }else if([[notification name] isEqualToString:nRevealShowMusicPageNotification]){
        number = [NSNumber numberWithInt:4];
    }
    
    if(lastPushViewNumber != [number intValue]){
        
        switch ([number intValue]) {
            case 1:
            {
                if(!navigation1){
                    MusicPlayerControl3VCT *nav1 = [MusicPlayerControl3VCT navigationControllerWithStoryboard];
//                    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vct1];
//                    ZionNavigationBar *navigationBar1 = [[ZionNavigationBar alloc] initWithNavigationController:nav1];
//                    [navigationBar1 setBackgroundImage:[UIImage imageNamed:@"navigation_bg_player.png"]];
                    
                    self.navigation1 = nav1;
                    
//                    [vct1 release];
//                    [nav1 release];
//                    [navigationBar1 release];
                }
                
                [UIView animateWithDuration:revealAnimationTime*0.7
                                 animations:^{
                                     [self.revealController preloadViewController:navigation1 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
                                     self.revealController.view.alpha = 0.0f;
                                 }
                                 completion:^(BOOL finished){
                                     //[self.revealController popViewControllerWithNewCenterController:navigation1 animated:NO];
                                     [self.revealController pushViewController:navigation1 onDirection:PPRevealSideDirectionLeft withOffset:0.0f animated:NO forceToPopPush:YES];
                                     [UIView animateWithDuration:revealAnimationTime*0.3
                                                      animations:^{
                                                          self.revealController.view.alpha = 1.0f;
                                                          [self.revealController openCompletelySide:PPRevealSideDirectionLeft animated:NO];
                                                      }
                                                      completion:^(BOOL finished){
                                                      }];
                                 }];
            }
                break;
            case 2:
            {
                if(!navigation2){
                    UIViewController *nav2 = [WebViewLinkCustomHandler navigationControllerWithStoryboard];
//                    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vct2];
//                    ZionNavigationBar *navigationBar2 = [[ZionNavigationBar alloc] initWithNavigationController:nav2];
//                    [navigationBar2 setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
                    
                    self.navigation2 = nav2;
                                        
//                    [vct2 release];
//                    [nav2 release];
//                    [navigationBar2 release];
                }
                
                CGRect frame = self.navigation2.navigationBar.frame;
                frame.origin.y = 0;
                self.navigation2.navigationBar.frame = frame;
                [self.navigation2.navigationBar layoutIfNeeded];
                
                [UIView animateWithDuration:revealAnimationTime*0.7
                                 animations:^{
                                     [self.revealController preloadViewController:navigation2 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
                                     self.revealController.view.alpha = 0.0f;
                                 }
                                 completion:^(BOOL finished){
                                     //[self.revealController popViewControllerWithNewCenterController:navigation2 animated:NO];
                                     [self.revealController pushViewController:navigation2 onDirection:PPRevealSideDirectionLeft withOffset:0.0f animated:NO forceToPopPush:YES];
                                     [UIView animateWithDuration:revealAnimationTime*0.3
                                                      animations:^{
                                                          self.revealController.view.alpha = 1.0f;
                                                          [self.revealController openCompletelySide:PPRevealSideDirectionLeft animated:NO];
                                                      }
                                                      completion:^(BOOL finished){
                                                          [self.navigationController.navigationBar sizeToFit];
                                                      }];
                                 }];
            }
                break;
                
            case 3:
            {
                if(!navigation3){
                    UIViewController *nav3 = [OtherPageVCT navigationControllerWithStoryboard];
//                    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vct3];
//                    ZionNavigationBar *navigationBar3 = [[ZionNavigationBar alloc] initWithNavigationController:nav3];
//                    [navigationBar3 setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
                    
                    self.navigation3 = nav3;
                    
//                    [vct3 release];
//                    [nav3 release];
//                    [navigationBar3 release];
                }
                
                [navigation3 popToRootViewControllerAnimated:NO];
                
                [UIView animateWithDuration:revealAnimationTime*0.7
                                 animations:^{
                                     [self.revealController preloadViewController:navigation3 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
                                     self.revealController.view.alpha = 0.0f;
                                 }
                                 completion:^(BOOL finished){
                                     //[self.revealController popViewControllerWithNewCenterController:navigation3 animated:NO];
                                     [self.revealController pushViewController:navigation3 onDirection:PPRevealSideDirectionLeft withOffset:0.0f animated:NO forceToPopPush:YES];
                                     [UIView animateWithDuration:revealAnimationTime*0.3
                                                      animations:^{
                                                          self.revealController.view.alpha = 1.0f;
                                                          [self.revealController openCompletelySide:PPRevealSideDirectionLeft animated:NO];
                                                      }
                                                      completion:^(BOOL finished){
                                                      }];
                                 }];
            }
                break;
            case 4:
            default:
            {
                if(!navigation4){
                    UIViewController *nav4 = [BothHomeArtworkVCT navigationControllerWithStoryboard];
//                    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:vct4];
//                    ZionNavigationBar *navigationBar4 = [[ZionNavigationBar alloc] initWithNavigationController:nav4];
//                    [navigationBar4 setBackgroundImage:[UIImage imageNamed:(UI_INTERFACE_IDIOM_IS_IPAD())?@"navigation_bg.png":@"navigation_bg_2.png"]];
                    
                    self.navigation4 = nav4;
                    
//                    [vct4 release];
//                    [nav4 release];
//                    [navigationBar4 release];
                }
                
                CGRect frame = self.navigation4.navigationBar.frame;
                frame.origin.y = 0;
                self.navigation4.navigationBar.frame = frame;
                [self.navigation4.navigationBar layoutIfNeeded];
                
                [UIView animateWithDuration:revealAnimationTime*0.7
                                 animations:^{
                                     [self.revealController preloadViewController:navigation4 forSide:PPRevealSideDirectionRight withOffset:0.0f];
                                     self.revealController.view.alpha = 0.0f;
                                 }
                                 completion:^(BOOL finished){
                                     //[self.revealController popViewControllerAnimated:YES];
                                     //[self.revealController popViewControllerWithNewCenterController:self.tabController animated:NO];
                                     [self.revealController pushViewController:navigation4 onDirection:PPRevealSideDirectionRight withOffset:0.0f animated:NO forceToPopPush:YES];
                                     [UIView animateWithDuration:revealAnimationTime*0.6
                                                      animations:^{
                                                          self.revealController.view.alpha = 1.0f;
                                                          [self.revealController openCompletelySide:PPRevealSideDirectionRight animated:NO];
                                                      }
                                                      completion:^(BOOL finished){
                                                      }];
                                 }];
            }
                break;
        }
        
    }
    
    lastPushViewNumber = [number intValue];
    
    if([[ZionMenuHud sharedManager] isVisible]){
        
        [[ZionMenuHud sharedManager] hide];
        
        [self performBlock:^{
            [[ZionMenuHud sharedManager] dismissHud];
        } afterDelay:[[ZionMenuHud sharedManager] animationTime]];
        
    }
}

@end
