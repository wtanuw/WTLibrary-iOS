//
//  WTMacro.h
//  Wat Wongtanuwat
//
//  Created by Wat Wongtanuwat on 8/31/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTMacroVersion_VERSION 0x00040001

///<------------------------------------------------!>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_BUT_LESS_THAN(v,w)  (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) && SYSTEM_VERSION_LESS_THAN(w))


///<------------------------------------------------!>

#pragma mark - Compile

//use to prevent compile error when use new APIs on old SDK
//and in case newest target did not show in list of target, so we use previous target instead
//base sdk is greater than __target
#define IS_IOS_BASE_SDK_EXCEED(__target) (__IPHONE_OS_VERSION_MAX_ALLOWED > __target)
//use to prevent deprecated warning when use deprecated APIs on newer SDK
//and in case newest target did not show in list of target, so we use previous target instead
//deployment target is equal to __target
#define IS_IOS_DEPLOY_TARGET_BELOW_OR_EQUAL(__target) (__IPHONE_OS_VERSION_MIN_REQUIRED <= __target)

//
//deployment target is greater than or equals to __target
//
#define IS_IOS_DEPLOY_TARGET_MINIMUM(__target) (__IPHONE_OS_VERSION_MIN_REQUIRED >= __target)

//use to prevent compile error when use new APIs on old SDK
//
#define IS_IOS_BASE_SDK_ATLEAST(__target) (__IPHONE_OS_VERSION_MAX_ALLOWED >= __target)
//use to prevent deprecated warning when use deprecated APIs on newer SDK
//
#define IS_IOS_DEPLOY_TARGET_BELOW(__target) (__IPHONE_OS_VERSION_MIN_REQUIRED < __target)


//example1
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  if (![object respondsToSelector:@selector(methodStartAt_8_0)])
//  {
//#endif
//    [object methodDeprecateAt_8_0];
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  }
//  else
//#endif
//#endif
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  {
//    [object methodStartAt_8_0];
//  }
//#endif

//result deploy7.0 sdk7.0
//    [object methodDeprecateAt_8_0];
//  {
//  }

//result deploy7.0 sdk8.0
//  if (![object respondsToSelector:@selector(methodOnlyAt_8_0)])
//  {
//    [object methodDeprecateAt_8_0];
//  }
//else
//  {
//    [object methodStartAt_8_0];
//  }

//result deploy8.0 sdk8.0
//  {
//    [object methodStartAt_8_0];
//  }

//example2.1
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  if ([object respondsToSelector:@selector(methodStartAt_8_0)])
//  {
//#endif
//    [object methodStartAt_8_0];
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  }
//  else
//#endif
//#endif
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  {
//    [object methodDeprecateAt_8_0];
//  }
//#endif

//example2.2
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_8_0)
//  if ([object respondsToSelector:@selector(methodStartAt_8_0)])
//  {
//    [object methodStartAt_8_0];
//  }
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  else
//#endif
//#endif
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_8_0)
//  {
//    [object methodDeprecateAt_8_0];
//  }
//#endif

//result deploy7.0 sdk7.0
//  {
//    [object methodDeprecateAt_8_0];
//  }

//result deploy7.0 sdk8.0
//  if ([object respondsToSelector:@selector(methodStartAt_8_0)])
//    [object methodStartAt_8_0];
//  }
//  else
//  {
//    [object methodDeprecateAt_8_0];
//  }

//result deploy8.0 sdk8.0
//    [object methodStartAt_8_0];

///<------------------------------------------------!>

//if (@available(iOS 13.0, *))



//API_AVAILABLE(ios(13));
//API_DEPRECATED("This property is ignored when using UIButtonConfiguration", ios(8.0,13), tvos(2.0,15.0));                // default is UIEdgeInsetsZero
//API_UNAVAILABLE(tvos) API_DEPRECATED("Use the interfaceOrientation property of the window scene instead.", ios(2.0, 13.0));
