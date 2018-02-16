//
//  WTBox.h
//  BushiRoadCardViewer
//
//  Created by Wat Wongtanuwat on 8/31/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


//#define NSObject_PWObject
//#define UINavigationBar_Dropshadow
//#define UIImage_Retina4
//#define UINavigationController_iOS6OrientationFix
//#define UITabBarController_iOS6OrientationFix
//#define NSString_SpaceString
//#define UINavigationController_WTTransition
//#define UIViewController_Retina4

@interface WTBox : NSObject

+ (void)swizzleNib;

@end


#pragma mark - UINavigationBar_Dropshadow
#ifdef UINavigationBar_Dropshadow

@interface UINavigationBar (Dropshadow)
@property (nonatomic, assign) BOOL showDropShadow;
@end

#endif


#pragma mark - NSString_SpaceString
#ifdef NSString_SpaceString

@interface NSString (SpaceString)
- (BOOL)isSpace;
- (BOOL)isNotSpace;
@end

#endif


#pragma mark - UIImage_TPAdditions
#ifdef UIImage_TPAdditions

@interface UIImage (TPAdditions)
- (UIImage*)imageByMaskingUsingImage:(UIImage *)maskImage;
@end

#endif

//#define UIImage_NSCoding
#pragma mark - UIImage_NSCoding
#ifdef UIImage_NSCoding

/* UIImage-NSCoding.h */
//
//#import <Foundation/Foundation.h>
//

#endif

