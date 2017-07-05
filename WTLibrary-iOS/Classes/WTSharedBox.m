//
//  WTSharedBox.m
//  BushiRoadCardViewer
//
//  Created by Wat Wongtanuwat on 9/19/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#import "WTSharedBox.h"
#import "WTMacro.h"

#import <mach/mach.h>
#import <mach/mach_host.h>

#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@interface WTSharedBox()

@property (nonatomic,assign,readwrite) NSUInteger WTPRNG_FirstSeed;
@property (nonatomic,assign,readwrite) NSUInteger WTPRNG_CurrentSeed;
@property (nonatomic,assign,readwrite) int WTPRNG_NumberOfTime;

void initRandomSeed(long firstSeed);
void initRandomSeedFromTime(void);
float nextRandomFloat(void);

@end

@implementation WTSharedBox
@synthesize WTPRNG_FirstSeed;
@synthesize WTPRNG_CurrentSeed;
@synthesize WTPRNG_NumberOfTime;

#pragma mark - Block Singleton Methods

////block macro
//#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
//static dispatch_once_t pred = 0; \
//__strong static id _sharedObject = nil; \
//dispatch_once(&pred, ^{ \
//_sharedObject = block(); \
//}); \
//return _sharedObject; \
//
//+ (id)sharedManager
//{
//    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
//        return [[self alloc] init];
//    });
//}

//block
+ (instancetype)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

#pragma mark Normal Singleton Methods

//static WTSharedManagerKit *sharedMyManager = nil;

////for Automatic Reference Counting (ARC)
//+ (id)sharedManager {
//    @synchronized(self) {
//        if (sharedMyManager == nil)
//            sharedMyManager = [[self alloc] init];
//    }
//    return sharedMyManager;
//}
//- (void)dealloc {
//    // Should never be called, but just here for clarity really.
//}

////for non ARC
//+ (id)sharedManager {
//    @synchronized(self) {
//        if(sharedMyManager == nil)
//            sharedMyManager = [[super allocWithZone:NULL] init];
//    }
//    return sharedMyManager;
//}
//+ (id)allocWithZone:(NSZone *)zone {
//    return [[self sharedManager] retain];
//}
//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}
//- (id)retain {
//    return self;
//}
//- (unsigned)retainCount {
//    return UINT_MAX; //denotes an object that cannot be released
//}
//- (oneway void)release {
//    // never release
//}
//- (id)autorelease {
//    return self;
//}
//- (void)dealloc {
//    // Should never be called, but just here for clarity really.
//    [super dealloc];
//}
//
//#pragma mark -
//
//- (id)init {
//    if (self = [super init]) {
//        
//    }
//    return self;
//}

#pragma mark - fadeDefaultScreen

+ (void)fadeDefaultScreenFromWindow:(UIWindow*)window withDuration:(float)duration withDelay:(float)delay andAnimation:(void (^)(UIImageView *imageView))removeAnimation 
{
    [self fadeDefaultScreenFromView:window withDuration:duration withDelay:delay andAnimation:removeAnimation];
}

+ (void)fadeDefaultScreenFromView:(UIView*)rootView withDuration:(float)duration withDelay:(float)delay andAnimation:(void(^)(UIImageView *imageView))removeAnimation 
{
    NSString *fadeDefaultName;
    if(UI_INTERFACE_IDIOM_IS_IPHONE()){
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            fadeDefaultName = @"Default-568h@2x.png";
        }else{
            fadeDefaultName = @"Default.png";
        }
    }else{
        if(UI_INTERFACE_ORIENTATION_IS_PORTRAIT()){
            fadeDefaultName = @"Default-Portrait.png";
        }else{
            fadeDefaultName = @"Default-Landscape.png";
        }
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fadeDefaultName]];
    
    if(UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH())
    {
        CGRect newFrame = imgView.frame;
        newFrame.size.width = newFrame.size.width / [UIScreen mainScreen].scale;
        newFrame.size.height = newFrame.size.height / [UIScreen mainScreen].scale;
        imgView.frame = newFrame;
    }
    else
    {
//        if([[UIApplication sharedApplication] statusBarStyle] != UIStatusBarStyleBlackTranslucent){
//            CGRect newFrame = imgView.frame;
//            newFrame.origin.y = newFrame.origin.y-20;
//            imgView.frame = newFrame;
//        }
    }
    
    [rootView addSubview:imgView];
    WT_SAFE_ARC_RELEASE(imgView);
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(){
                         removeAnimation(imgView);
                     } 
                     completion:^(BOOL finished){
                         [imgView removeFromSuperview];
                     } 
     ];
}

//CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:expandRotation],[NSNumber numberWithFloat:0.0f], nil];
//rotateAnimation.duration = 5.5f;
//rotateAnimation.keyTimes = [NSArray arrayWithObjects:
//                            [NSNumber numberWithFloat:.3], 
//                            [NSNumber numberWithFloat:.4], nil]; 
//
//CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//positionAnimation.duration = 5.5f;
//CGMutablePathRef path = CGPathCreateMutable();
//CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
//CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
//CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
//CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
//positionAnimation.path = path;
//CGPathRelease(path);
//
//CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
//animationgroup.duration = 5.5f;
//animationgroup.fillMode = kCAFillModeForwards;
//animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//[item.layer addAnimation:animationgroup forKey:@"Expand"];
//item.center = item.endPoint;

#pragma mark - WTVersion

#define kWTVersionFirst @"WTFirst"
#define kWTVersionNow @"WTSaved"
//#define kWTVersionCurrent @"CFBundleVersion"
#define kWTVersionCurrent @"CFBundleShortVersionString"

+ (NSString*)WTVersionFirstInstallAppVersion{
    NSString *firstVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kWTVersionFirst];
    return firstVersion;
}

+ (NSString*)WTVersionPreviousAppVersion{
    NSString *savedVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kWTVersionNow];
    return savedVersion;
}

+ (NSString*)WTVersionCurrentAppVersion{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:kWTVersionCurrent];
    return currentVersion;
}

+ (BOOL)WTVersionFirstInstallVersionIsBefore:(NSString*)ver{
    NSString *firstVersion = [WTSharedBox WTVersionFirstInstallAppVersion];
    if (firstVersion == nil){
        return YES;
    }
    return [firstVersion compare:ver options:NSNumericSearch] == NSOrderedAscending;
}

+ (BOOL)WTVersionFirstInstallVersionIsBeforeCurrentAppVersion{
    NSString *version = [WTSharedBox WTVersionCurrentAppVersion];
    return [WTSharedBox WTVersionFirstInstallVersionIsBefore:version];
}

+ (BOOL)WTVersionPreviousVersionIsBefore:(NSString*)ver{
    NSString *savedVersion = [WTSharedBox WTVersionPreviousAppVersion];
    if (savedVersion == nil){
        return YES;
    }
    return [savedVersion compare:ver options:NSNumericSearch] == NSOrderedAscending;
}

+ (BOOL)WTVersionPreviousVersionIsBeforeCurrentAppVersion{
    NSString *version = [WTSharedBox WTVersionCurrentAppVersion];
    return [WTSharedBox WTVersionPreviousVersionIsBefore:version];
}

+ (BOOL)WTVersionWriteCurrentAppVersion{
    NSString *currentVersion = [WTSharedBox WTVersionCurrentAppVersion];
    
    NSString *firstVersion = [WTSharedBox WTVersionFirstInstallAppVersion];
    if (firstVersion == nil){
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:kWTVersionFirst];
    }
    
    NSString *savedVersion = [WTSharedBox WTVersionPreviousAppVersion];
    if (savedVersion == nil || ![savedVersion isEqualToString:currentVersion]){
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:kWTVersionNow];
    }
    
    return [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
}
/*
 if([WTSharedBox WTVersionPreviousVersionIsBeforeCurrentAppVersion]){
 
    if([WTSharedBox WTVersionFirstInstallIsBefore:@""]){
        //reward something
    }
    
    if([WTSharedBox WTVersionPreviousSavedIsBefore:@""]){
        //change some data
    }
    
    [WTSharedBox WTVersionWriteCurrentVersion];
 }
 */

#pragma mark - WatLog Alert

#define WATLOG_ALERT_TYPE 1
+ (void)WTWatLogTitle:(NSString*)title message:(NSString*)message
{
//#if WATLOG_DEBUG_ENABLE
//    #if WATLOG_ALERT_TYPE == 1
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"WatLog" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//    #endif
//    #if WATLOG_ALERT_TYPE == 0
//    #endif
//#endif
}

#pragma mark - WTPRNG

static unsigned long seed;

void initRandomSeed(long firstSeed)
{ 
    seed = firstSeed;
}

void initRandomSeedFromTime(void)
{ 
    seed = (long)[[NSDate date] timeIntervalSince1970];
}

float nextRandomFloat(void)
{
    return (((seed= 1664525*seed + 1013904223)>>16) / (float)0x10000);
}


+ (void)WTPRNGSetFirstSeed:(long)firstSeed
{
    [[WTSharedBox sharedManager] setWTPRNG_FirstSeed: firstSeed % ((NSInteger)pow(2, 31)-1) ];
    [[WTSharedBox sharedManager] setWTPRNG_CurrentSeed:[WTSharedBox WTPRNGGetFirstSeed]];
    [[WTSharedBox sharedManager] setWTPRNG_NumberOfTime:0];
}

+ (void)WTPRNGSetRandomFirstSeed{[WTSharedBox WTPRNGSetFirstSeed:(long)[[NSDate date] timeIntervalSince1970]];}

+ (NSUInteger)WTPRNGGetFirstSeed{return [[WTSharedBox sharedManager] WTPRNG_FirstSeed];}

+ (NSUInteger)WTPRNGGetCurrentSeed{return [[WTSharedBox sharedManager] WTPRNG_CurrentSeed];}

+ (int)WTPRNGGetNumberOfTime{return [[WTSharedBox sharedManager] WTPRNG_NumberOfTime];}

+ (NSUInteger)WTPRNGRandom
{
    //Linear Congruential Generators
//    int a = 1103515245, c = 12345, m = (NSInteger)pow(2, 31);
    int a = 16807, c = 0; NSInteger m = ((NSInteger)pow(2, 31)-1);
    
    NSUInteger newRandom = ( ((a*[WTSharedBox WTPRNGGetCurrentSeed]) + c) % m );
    [[WTSharedBox sharedManager] setWTPRNG_CurrentSeed:newRandom];
    [[WTSharedBox sharedManager] setWTPRNG_NumberOfTime:[WTSharedBox WTPRNGGetNumberOfTime]+1];
    return [[WTSharedBox sharedManager] WTPRNG_CurrentSeed];
}

#pragma mark -

CGRect FixOriginRotation(CGRect rect, UIInterfaceOrientation orientation, int parentWidth, int parentHeight) {
    CGRect newRect;
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), rect.origin.y, rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationLandscapeRight:
            newRect = CGRectMake(rect.origin.x, parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationPortrait:
            newRect = rect;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
        default:
            break;
    }
    return newRect;
}

#pragma - mark

//#import <mach/mach.h>
//#import <mach/mach_host.h>

natural_t  freeMemory(void) {
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    //natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t   mem_free = vm_stat.free_count * pagesize;
    //natural_t   mem_total = mem_used + mem_free;
    
    return mem_free;
}

+ (void)report_memory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %lu", (unsigned long)info.resident_size);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}

#pragma - mark

NSString *WTDeviceSystemVersion() {
    static NSString *_wt_deviceSystemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _wt_deviceSystemVersion = WT_SAFE_ARC_RETAIN([[UIDevice currentDevice] systemVersion]);
    });
    return _wt_deviceSystemVersion;
}

NSUInteger WTDeviceInterface() {
    static BOOL _wt_deviceInterface = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat scale = (([[UIScreen mainScreen] respondsToSelector:@selector(scale)])?[UIScreen mainScreen].scale:1.0);
        _wt_deviceInterface = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && (scale >= 2.0)?YES:NO);
    });
    return _wt_deviceInterface;
}

#pragma mark -

void WTSharedBoxNicoLog(NSString *s) {
    [[WTSharedBox sharedManager] printLog:s];
}

- (void)printLog:(NSString*)text
{
    float screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    float duration = 7;
    if(UI_INTERFACE_ORIENTATION_IS_PORTRAIT()){
        screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
        duration = 7;
    }else{
        screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
        duration = 10;
    }
    
    
    UILabel *label = WT_SAFE_ARC_AUTORELEASE([[UILabel alloc] initWithFrame:CGRectZero]);
    label.text = text;
    label.font = [label.font fontWithSize:RANDOM_BOUNDARY(18, 30)];
//    label.font = [UIFont systemFontOfSize:RANDOM_BOUNDARY(18, 30)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    CGSize expectSize = CGSizeZero;
#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_7_0)
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
//        CGSize maximumLabelSize = CGSizeMake(boundsRect.size.width, CGFLOAT_MAX);
        NSDictionary *attributesDict = @{NSFontAttributeName:label.font,
                                         NSForegroundColorAttributeName:label.textColor};
        expectSize = [label.text sizeWithAttributes:attributesDict];
//        CGRect valueStringRect = [valueString boundingRectWithSize:maximumLabelSize
//                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                                        attributes:attributesDict
//                                        [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]                   context:nil];
//        [valueString drawInRect:CGRectMake(floorf((boundsRect.size.width - valueStringRect.size.width) / 2.0 + self.labelOffset.x),
//                                           floorf((boundsRect.size.height - valueStringRect.size.height) / 2.0 + self.labelOffset.y),
//                                           valueStringRect.size.width,
//                                           valueStringRect.size.height)
//                 withAttributes:attributesDict];
    }
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
    else
#endif
#endif
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
    {
        expectSize = [label.text sizeWithFont:label.font];
//        CGSize valueStringSize = [valueString sizeWithFont:label.font
//                                                  forWidth:boundsRect.size.width
//                                             lineBreakMode:UILineBreakModeTailTruncation];
//        [valueString drawInRect:CGRectMake(floorf((boundsRect.size.width - valueStringSize.width) / 2.0 + self.labelOffset.x),
//                                           floorf((boundsRect.size.height - valueStringSize.height) / 2.0 + self.labelOffset.y),
//                                           valueStringSize.width,
//                                           valueStringSize.height)
//                       withFont:self.labelFont
//                  lineBreakMode:UILineBreakModeTailTruncation];
    }
#endif
    float textWidth = (expectSize.width>700)?700:expectSize.width;
    float randomY = RANDOM_BOUNDARY(0, 8)*15;
    float textHeight = expectSize.height;
    
    UIView *topView = [[UIApplication sharedApplication] keyWindow];
    [topView addSubview:label];
    label.frame = CGRectMake(screenWidth, randomY, textWidth, textHeight);
    [topView bringSubviewToFront:label];
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             label.frame = CGRectMake(-textWidth, randomY, textWidth, textHeight);
                         } completion:^(BOOL finished) {
                             [label removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             label.frame = CGRectMake(-textWidth, randomY, textWidth, textHeight);
                         } completion:^(BOOL finished) {
                             [label removeFromSuperview];
                         }];
    }
}

#pragma - mark

//#include <arpa/inet.h>
//#include <net/if.h>
//#include <ifaddrs.h>
//#include <net/if_dl.h>

- (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    [self performSelector:@selector(getDataCounters) withObject:nil afterDelay:5];
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
}

- (void)as
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:[NSDate date]];
}

@end
