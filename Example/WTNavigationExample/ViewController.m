//
//  ViewController.m
//  WTNavigationExample
//
//  Created by Mac on 9/4/2564 BE.
//  Copyright © 2564 BE wtanuw. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerSub.h"
#import "WTMacro.h"
#import "ViewControllerResizeScroll.h"



//#import "HomeRevealVCT.h"
//
//#import "ZionShared.h"
//#import "ZionTabbar.h"
//#import "ZionNavigationBar.h"
//
//#import "HomeCenterVCT.h"
//
//#import "MusicPlayerControl3VCT.h"
//#import "WebViewLinkCustomHandler.h"
//#import "OtherPageVCT.h"
//
////#import "inAppHomeArtworkVCT.h"
////#import "iPodHomeArtworkVCT.h"
//#import "BothHomeArtworkVCT.h"
//
//#import "WTLVResizableNavigationAnimation.h"
//#import "WTLVResizableNavigationBar.h"
//#import "WTLVResizableNavigationController.h"
#define revealAnimationTime (1.0f*0.5)
//
// firstViewNumber : 1 = MusicPlayerControl3VCT, 2 = WebViewLinkCustomHandler, 3 = OtherPageVCT, 4 = BothHomeArtworkVCT
#define firstViewNumber 2
const int numb = firstViewNumber;
@interface ViewController ()


@property (nonatomic, assign) int lastPushViewNumber;

@property (nonatomic, weak) UIView *adsView;

@property (weak, nonatomic) PPRevealSideViewController *revealController;

//@property (retain, nonatomic) ZionTabbar *tabController;
@property (weak ,nonatomic) UINavigationController *navigation0;

@property (strong, nonatomic) UINavigationController *navigation1;//player
@property (strong, nonatomic) UINavigationController *navigation2;//webview
@property (strong, nonatomic) UINavigationController *navigation3;//other
@property (strong, nonatomic) UINavigationController *navigation4;//music

@end

@implementation ViewController

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
    id vct = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reveal"];
    return vct;
}

- (UINavigationController*)navigation1
{
    if (!_navigation1) {
        UINavigationController *nav = [ViewControllerSub viewControllerWithStoryboard];
        //        MusicPlayerControl3VCT *vct = [[MusicPlayerControl3VCT alloc] initWithNibName:@"MusicPlayerControl3VCT" bundle:nil];
        //        WTLVResizableNavigationController *nav = [[WTLVResizableNavigationController alloc] initWithRootViewController:vct];
        //        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
        //        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg_player.png"]];
        //        nav.navigationBar.backgroundColor = UIColorMake(89, 89, 89);
        _navigation1 = nav;
    }
    return _navigation1;
}

- (UINavigationController*)navigation2
{
    if (!_navigation2) {
        UINavigationController *nav = [ViewControllerSub wtNavigationViewControllerWithStoryboard];
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vct];
        //        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
        //        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
        _navigation2 = nav;
    }
    return _navigation2;
}

- (UINavigationController*)navigation3
{
    if (!_navigation3) {
        UINavigationController *nav = [ViewControllerSub lvNavigationControllerWithStoryboard];
        //        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
        //        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg.png"]];
        _navigation3 = nav;
    }
    return _navigation3;
}

- (UINavigationController*)navigation4
{
    if (!_navigation4) {
        UINavigationController *nav = [ViewControllerSub codeNavigationViewControllerWithStoryboard];
        //        UINavigationController *nav = [[WTLVResizableNavigationController alloc] initWithRootViewController:vct];
        //        ZionNavigationBar *navigationBar = [[ZionNavigationBar alloc] initWithNavigationController:nav];
        //        [navigationBar setBackgroundImage:[UIImage imageNamed:(UI_INTERFACE_IDIOM_IS_IPAD())?@"navigation_bg.png":@"navigation_bg_2.png"]];
        _navigation4 = nav;
        
//        _navigation4 = [ViewControllerResizeScroll  navigationControllerWithStoryboard];
    }
    return _navigation4;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    int firstViewControllerNumber = numb;

    self.lastPushViewNumber = firstViewControllerNumber;
    
    if(firstViewControllerNumber == 1)
    {
        self.navigation0 = self.navigation1;
    }
    else if(firstViewControllerNumber == 2)
    {
        self.navigation0 = self.navigation2;
    }
    else if(firstViewControllerNumber == 3)
    {
        self.navigation0 = self.navigation3;
    }
    else if(firstViewControllerNumber == 4)
    {
        self.navigation0 = self.navigation4;
    }
    
//    CGRect frame = self.navigation0.navigationBar.frame;
//    frame.origin.y = 0;
//    self.navigation0.navigationBar.frame = frame;
//    [self.navigation0.navigationBar layoutIfNeeded];
    
    
    CGRect a = self.view.frame;
    
    ViewControllerSub *centerVCT = [ViewControllerSub viewControllerWithStoryboard];
    
    self.revealController = [[PPRevealSideViewController alloc] initWithRootViewController:centerVCT];
    
    self.view.frame = a;
    self.revealController.view.frame = a;
    
    [self.view addSubview:self.revealController.view];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        [self addChildViewController:self.revealController];
    }
    
    self.revealController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.revealController.delegate = self;
    self.revealController.fakeiOS7StatusBarColor = [UIColor purpleColor];
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
    [self.revealController setOption:PPRevealSideOptionsiOS7StatusBarFading];
    
    self.revealController.fakeiOS7StatusBarColor = [UIColor magentaColor];
    
//    [self.revealController pushViewController:self.tabController onDirection:PPRevealSideDirectionRight withOffset:0.0f animated:NO forceToPopPush:NO];
    [self.revealController preloadViewController:self.navigation0 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
    
    [self.revealController resetOption:PPRevealSideOptionsiOS7StatusBarFading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowTopNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowLeftNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowBottomNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuPressedNotification:)
                                                 name:nRevealShowRightNotification
                                               object:nil];

//
//    _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//
//    if(UI_INTERFACE_IDIOM_IS_IPAD()){
//        _progress.frame = CGRectMake(0, 0, 400, 40);
//    }
//
//    _progress.center = CGPointMake(self.view.center.x, self.view.center.y+80);
//
//    [self.view addSubview:_progress];
//
////    [_progress release];
//
//    __block int songAppDocCount = 0;
//
////    dispatch_async(<#dispatch_queue_t queue#>, ^{
////
////        [[ZionShared sharedManager] updateAutoMyMusicPlaylist];
////        [self.revealController openCompletelySide:PPRevealSideDirectionRight animated:NO];
////    })
//
//
////    CLS_LOG(@"CLS-before query all song");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//        //Background Thread
////        CLS_LOG(@"CLS-query app song");
//        [[ZionShared sharedManager] firstQueryAllSongAppDocWithBlock:^(int current, int total) {
//            dispatch_async(dispatch_get_main_queue(), ^(void){
//                _progress.progress = current*1.0/total;
//                songAppDocCount = current;
//            });
//        }];
////        CLS_LOG(@"CLS-query ipod song");
//        [[ZionShared sharedManager] firstQueryAllSongiPodWithBlock:^(int current, int total) {
//            dispatch_async(dispatch_get_main_queue(), ^(void){
//                _progress.progress = (songAppDocCount + current)*1.0/total;
//            });
//        }];
//
//        [[ZionShared sharedManager] updateAutoMyMusicPlaylist];
//        [[ZionShared sharedManager] readLastPlayedPlaylist];
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
//                _progress.alpha = 0;
            } completion:^(BOOL finished) {
//                _progress.hidden = YES;
                
                [self.revealController openCompletelySide:PPRevealSideDirectionLeft animated:NO];
//                CLS_LOG(@"CLS-after query all song");
            }];
            
        });
    });
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self setNeedsStatusBarAppearanceUpdate];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)dealloc
//{
////    [adsView release];
////    [_revealController release];
//////    [_tabController release];
////    [navigation0 release];
////    [navigation1 release];
////    [navigation2 release];
////    [navigation3 release];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nZionAdsShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nZionAdsHideNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowPlayerPageNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowFreePageNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowOtherPageNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nRevealShowMusicPageNotification object:nil];
////    [super dealloc];
//}
//
//-(UIStatusBarStyle) preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
//
//#pragma mark -
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    if(UI_INTERFACE_IDIOM_IS_IPHONE()){
//        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);;
//    }else{
//        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
//    }
//}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    if(UI_INTERFACE_IDIOM_IS_IPHONE()){
//        return (1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationPortraitUpsideDown);
//    }else{
//        return (UIInterfaceOrientationMaskPortrait);
//    }
//}
//
//#pragma mark -
//
//- (CGSize)screenSize
//{
//    //    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
//    //        screenSize = [UIScreen mainScreen].bounds.size;
//    //    }else{
//    //        screenSize = [UIScreen mainScreen].bounds.size;
//    //    }
//    return [[UIScreen mainScreen] bounds].size;
//}
//
//- (CGSize)adsSize
//{
////    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
////        return GAD_SIZE_728x90;
////    }else{
////        if((UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH())){
////            return GAD_SIZE_320x50;
////        }else{
////            return GAD_SIZE_320x50;
////        }
////    }
//    return CGSizeZero;
//}
//
//- (void)showAdsTabbar
//{
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         self.adsView.alpha = 1;
//                         self.adsView.frame = CGRectMake(0,
//                                                         0+(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?20:0),
//                                                         [self adsSize].width,
//                                                         [self adsSize].height);
//                         self.revealController.view.frame = CGRectMake(0,
//                                                                       [self adsSize].height,
//                                                                       [self screenSize].width,
//                                                                       [self screenSize].height-[self adsSize].height+(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?20:0));
//                         WatLog(@"showAds %@",NSStringFromCGRect(self.revealController.view.frame));
//                         
//                     }];
//}
//
//- (void)hideAdsTabbar
//{
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         self.adsView.alpha = 0;
//                         self.adsView.frame = CGRectMake(0,
//                                                         -[self adsSize].height,
//                                                         [self adsSize].width,
//                                                         [self adsSize].height);
//                         self.revealController.view.frame = CGRectMake(0,
//                                                                       0,
//                                                                       [self screenSize].width,
//                                                                       [self screenSize].height+(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?20:0));
//                         WatLog(@"hideAds %@",NSStringFromCGRect(self.revealController.view.frame));
//                     }];
//}
//
//#pragma mark -
//
//- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willChangeCenterController:(UIViewController*)oldCenterController
//{
//    if([oldCenterController isKindOfClass:[UITabBarController class]]){
//        
//    }else if([oldCenterController isKindOfClass:[UINavigationController class]]){
//        ZionNavigationBar* customNavigationBar = (ZionNavigationBar*)((UINavigationController*)oldCenterController).navigationBar;
//        if([customNavigationBar respondsToSelector:@selector(setBackgroundImage:)])
//        {
//            customNavigationBar.navigationController = nil;
//        }
//    }
//}
//
//- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didChangeCenterController:(UIViewController*)newCenterController
//{
//    
//}
//
//- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController
//{
//    if(pushedController == [controller controllerForSide:PPRevealSideDirectionRight]){
//        UIViewController *a = [controller controllerForSide:PPRevealSideDirectionLeft];
//        a.view.alpha = 0.0f;
//        UIViewController *b = [controller controllerForSide:PPRevealSideDirectionRight];
//        b.view.alpha = 1.0f;
//    }else{
//        UIViewController *a = [controller controllerForSide:PPRevealSideDirectionLeft];
//        a.view.alpha = 1.0f;
//        UIViewController *b = [controller controllerForSide:PPRevealSideDirectionRight];
//        b.view.alpha = 0.0f;
//    }
//    
//}
//
//- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController
//{
//    
//}
//
//- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController
//{
//    
//}
//
//- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController
//{
//    
//}
//
//#pragma mark -
//
//- (void)WTHud:(WTHud *)hud isTouchInside:(BOOL)inside
//{
//    if(hud == [ZionMenuHud sharedManager])
//    {
//        if([(ZionMenuHud*)hud isGrowAnimation]){
//            return;
//        }
//        if([hud isVisible] && !inside){
//            
//            [[ZionMenuHud sharedManager] hide];
//            
//        }else if([hud isVisible] && inside){
//            
//            [[ZionMenuHud sharedManager] hide];
//            
//        }
//    }
//}
//
//#pragma mark -
//
- (void)menuPressedNotification:(NSNotification*)notification
{
//    NSNumber *number = (NSNumber*)[notification object];
    
    NSNumber *number = [NSNumber numberWithInt:0];
    if([[notification name] isEqualToString:nRevealShowTopNotification]){
        number = [NSNumber numberWithInt:1];
    }else if([[notification name] isEqualToString:nRevealShowLeftNotification]){
        number = [NSNumber numberWithInt:2];
    }else if([[notification name] isEqualToString:nRevealShowBottomNotification]){
        number = [NSNumber numberWithInt:3];
    }else if([[notification name] isEqualToString:nRevealShowRightNotification]){
        number = [NSNumber numberWithInt:4];
    }
    
    if(_lastPushViewNumber == [number intValue]){
        return;
    }

        switch ([number intValue]) {
        case 1:
        {
            [UIView animateWithDuration:revealAnimationTime*0.7
                             animations:^{
                [self.revealController preloadViewController:self.navigation1 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
                self.revealController.view.alpha = 0.0f;
                }
                             completion:^(BOOL finished){
                //[self.revealController popViewControllerWithNewCenterController:navigation1 animated:NO];
                [self.revealController pushViewController:self.navigation1 onDirection:PPRevealSideDirectionLeft withOffset:0.0f animated:NO forceToPopPush:YES];
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
            CGRect frame = self.navigation2.navigationBar.frame;
            frame.origin.y = 0;
            self.navigation2.navigationBar.frame = frame;
            [self.navigation2.navigationBar layoutIfNeeded];
            
            [UIView animateWithDuration:revealAnimationTime*0.7
                             animations:^{
                [self.revealController preloadViewController:self.navigation2 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
                self.revealController.view.alpha = 0.0f;
                }
                             completion:^(BOOL finished){
                    //[self.revealController popViewControllerWithNewCenterController:navigation2 animated:NO];
                [self.revealController pushViewController:self.navigation2 onDirection:PPRevealSideDirectionLeft withOffset:0.0f animated:NO forceToPopPush:YES];
                [UIView animateWithDuration:revealAnimationTime*0.3
                                 animations:^{
                    self.revealController.view.alpha = 1.0f;
                    [self.revealController openCompletelySide:PPRevealSideDirectionLeft animated:NO];
                }
                                 completion:^(BOOL finished){
//                    [self.navigationController.navigationBar sizeToFit];
                }];
            }];
        }
    break;
    case 3:
    {
//        [self.navigation3 popToRootViewControllerAnimated:NO];
        [UIView animateWithDuration:revealAnimationTime*0.7
                         animations:^{
            [self.revealController preloadViewController:self.navigation3 forSide:PPRevealSideDirectionLeft withOffset:0.0f];
            self.revealController.view.alpha = 0.0f;
            }
                         completion:^(BOOL finished){
            //[self.revealController popViewControllerWithNewCenterController:navigation3 animated:NO];
            [self.revealController pushViewController:self.navigation3 onDirection:PPRevealSideDirectionLeft withOffset:0.0f animated:NO forceToPopPush:YES];
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
//        CGRect frame = self.navigation4.navigationBar.frame;
//        frame.origin.y = 0;
//        self.navigation4.navigationBar.frame = frame;
//        [self.navigation4.navigationBar layoutIfNeeded];
        
        [UIView animateWithDuration:revealAnimationTime*0.7
                         animations:^{
            [self.revealController preloadViewController:self.navigation4 forSide:PPRevealSideDirectionRight withOffset:0.0f];
            self.revealController.view.alpha = 0.0f;
            }
                         completion:^(BOOL finished){
            //[self.revealController popViewControllerAnimated:YES];
            //[self.revealController popViewControllerWithNewCenterController:self.tabController animated:NO];
            [self.revealController pushViewController:self.navigation4 onDirection:PPRevealSideDirectionRight withOffset:0.0f animated:NO forceToPopPush:YES];
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
        
    
    
    self.lastPushViewNumber = [number intValue];
    
//    if([[ZionMenuHud sharedManager] isVisible]){
//
//        [[ZionMenuHud sharedManager] hide];
//
//        [self performBlock:^{
//            [[ZionMenuHud sharedManager] dismissHud];
//        } afterDelay:[[ZionMenuHud sharedManager] animationTime]];
//
//    }
}

@end
