//
//  WTUIInterface.m
//  Pods
//
//  Created by Wat Wongtanuwat on 1/12/2567 BE.
//
//

#import <Foundation/Foundation.h>

@interface WTUIInterfaceShared : NSObject

+(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR;
+(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR;
+(BOOL)UI_INTERFACE_ORIENTATION_IS_PORTRAIT;
+(BOOL)UI_INTERFACE_ORIENTATION_IS_LANDSCAPE;

+(BOOL)UI_INTERFACE_SCALE;
+(BOOL)UI_INTERFACE_RETINA;
+(BOOL)UI_INTERFACE_SCREEN_IS_NONRETINA;
+(BOOL)UI_INTERFACE_SCREEN_IS_RETINA;

+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE;
+(BOOL)UI_INTERFACE_IDIOM_IS_IPAD;
+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH;
+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH;
+(BOOL)UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH;

+(BOOL)UI_INTERFACE_IDIOM_PHONE_PAD;

+(BOOL)isStatusBarHidden;
+(UIInterfaceOrientation)statusBarOrientation;
+(CGRect)statusBarFrame;

@end


///<------------------------------------------------!>

//--------------------------------------------------!>






//--------------------------------------------------!>
