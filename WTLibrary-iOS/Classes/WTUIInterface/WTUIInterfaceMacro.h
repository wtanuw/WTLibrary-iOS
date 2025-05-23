//
//  WTUIInterface.m
//  Pods
//
//  Created by Wat Wongtanuwat on 1/12/2567 BE.
//
//

//--------------------------------------------------!>

//#define UI_INTERFACE_RETINA()               ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))?1:0
//#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!UI_INTERFACE_RETINA())
//#define UI_INTERFACE_SCREEN_IS_RETINA()     (UI_INTERFACE_RETINA())

#define UI_INTERFACE_ORIENTATION_IS_PORTRAIT_STATUSBAR()  UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define UI_INTERFACE_ORIENTATION_IS_LANDSCAPE_STATUSBAR() UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define UI_INTERFACE_ORIENTATION_IS_PORTRAIT()  UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])
#define UI_INTERFACE_ORIENTATION_IS_LANDSCAPE() UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

#define UI_INTERFACE_SCALE()               (([[UIScreen mainScreen] respondsToSelector: @selector(scale)])?[UIScreen mainScreen].scale:1.0)
#define UI_INTERFACE_RETINA()               ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && (UI_INTERFACE_SCALE() >= 2.0)?YES:NO)
#define UI_INTERFACE_SCREEN_IS_NONRETINA()  (!UI_INTERFACE_RETINA())
#define UI_INTERFACE_SCREEN_IS_RETINA()     (UI_INTERFACE_RETINA())

#define UI_INTERFACE_IDIOM_IS_IPHONE()      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define UI_INTERFACE_IDIOM_IS_IPAD()        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 568*UI_INTERFACE_SCALE())
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN4_7INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 667*UI_INTERFACE_SCALE())
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 736*UI_INTERFACE_SCALE())

#define UI_INTERFACE_IDIOM_PHONE_PAD(phone,pad) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?phone:pad)
#define UI_INTERFACE_IDIOM_IS_IPHONE_SCREEN5_5INCH()      UI_INTERFACE_IDIOM_IS_IPHONE() && ((CGRectGetHeight([UIScreen mainScreen].bounds) * UI_INTERFACE_SCALE()) == 736*UI_INTERFACE_SCALE())






//--------------------------------------------------!>
