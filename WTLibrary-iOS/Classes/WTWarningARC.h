//
//  WTMacro.h
//  Wat Wongtanuwat
//
//  Created by Wat Wongtanuwat on 8/31/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTWarningARC_VERSION 0x00040001

///<--------------------------------------------------!>

#pragma mark - NON ARC and ARC

//-fno-objc-arc
//-fobjc-arc

/*
#if __has_feature(objc_arc)
#error This file must be compiled without ARC.
#endif
*/
/*
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif
*/
/*
#if (__has_feature(objc_arc) && (! __has_feature(objc_arc)
#error This file can be compiled with ARC or without ARC.
#endif
*/

#define WT_HAS_ARC ( __has_feature(objc_arc) )
#define WT_REQUIRE_NONARC ( __has_feature(objc_arc) )
#define WT_REQUIRE_ARC ( !__has_feature(objc_arc) )
#define WT_NOT_CONSIDER_ARC ( (__has_feature(objc_arc)) && (!__has_feature(objc_arc)) )

//Example 1
/*
#if WT_REQUIRE_NONARC
#error This file must be compiled without ARC.
#endif
*/

//Example 2
/*
#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif
 */

//Example 3
/*
#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif
*/


///<------------------------------------------------!>

//#pragma mark - Safe ARC
//
//#if !defined(__clang__) || __clang_major__ < 3
//#ifndef __bridge
//#define __bridge
//#endif
//
//#ifndef __bridge_retain
//#define __bridge_retain
//#endif
//
//#ifndef __bridge_retained
//#define __bridge_retained
//#endif
//
//#ifndef __autoreleasing
//#define __autoreleasing
//#endif
//
//#ifndef __strong
//#define __strong
//#endif
//
//#ifndef __unsafe_unretained
//#define __unsafe_unretained
//#endif
//
//#ifndef __weak
//#define __weak
//#endif
//#endif
//
//#if __has_feature(objc_arc)
//#define SAFE_ARC_PROP_RETAIN strong
//#define SAFE_ARC_RETAIN(x) (x)
//#define SAFE_ARC_RELEASE(x)
//#define SAFE_ARC_AUTORELEASE(x) (x)
//#define SAFE_ARC_BLOCK_COPY(x) (x)
//#define SAFE_ARC_BLOCK_RELEASE(x)
//#define SAFE_ARC_SUPER_DEALLOC()
//#define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
//#define SAFE_ARC_AUTORELEASE_POOL_END() }
//#else
//#define SAFE_ARC_PROP_RETAIN retain
//#define SAFE_ARC_RETAIN(x) ([(x) retain])
//#define SAFE_ARC_RELEASE(x) ([(x) release])
//#define SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
//#define SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
//#define SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
//#define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
//#define SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//#define SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
//#endif


#pragma mark - WT_SAFE_ARC

#if !defined(__clang__) || __clang_major__ < 3
//#ifndef __bridge
//#define __bridge
//#endif
//
//#ifndef __bridge_retain
//#define __bridge_retain
//#endif
//
//#ifndef __bridge_retained
//#define __bridge_retained
//#endif
//
//#ifndef __autoreleasing
//#define __autoreleasing
//#endif

#ifndef __strong
#define __strong
#endif

#ifndef __unsafe_unretained
#define __unsafe_unretained
#endif

#ifndef __weak
#define __weak
#endif
#endif

#if __has_feature(objc_arc)
#define WT_SAFE_ARC_PROP_RETAIN strong
#define WT_SAFE_ARC_RETAIN(x) (x)
#define WT_SAFE_ARC_RELEASE(x)
#define WT_SAFE_ARC_AUTORELEASE(x) (x)
//#define WT_SAFE_ARC_BLOCK_COPY(x) (x)
//#define WT_SAFE_ARC_BLOCK_RELEASE(x)
#define WT_SAFE_ARC_SUPER_DEALLOC()
//#define WT_SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
//#define WT_SAFE_ARC_AUTORELEASE_POOL_END() }
#else
#define WT_SAFE_ARC_PROP_RETAIN retain
#define WT_SAFE_ARC_RETAIN(x) ([(x) retain])
#define WT_SAFE_ARC_RELEASE(x) ([(x) release])
#define WT_SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
//#define WT_SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
//#define WT_SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
#define WT_SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
//#define WT_SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//#define WT_SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif

///<------------------------------------------------!>
