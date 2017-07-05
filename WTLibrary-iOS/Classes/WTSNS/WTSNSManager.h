//
//  WTSNSManager.h
//  StickerCamera
//
//  Created by Wat Wongtanuwat on 6/11/13.
//  Copyright (c) 2013 Wat Wongtanuwat. All rights reserved.
//

#ifdef ANDROID
#else
#import <Foundation/Foundation.h>
#import "WTMacro.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


typedef void (^SNSCompletionBlock)(SLComposeViewController *sheet, BOOL postSuccess);
//typedef id (^SNSComposeSheet)(NSString *text, UIImage *image, NSString *url, SNSCompletion composeCompletion);
typedef SLComposeViewController* (^SNSComposeSheetBlock)(NSString *text, UIImage *image, NSString *url, SNSCompletionBlock composeCompletion);


FOUNDATION_EXPORT NSString * const WTSNSErrorDomain;
enum {
    WTSNSErrorUnknown = -1,
    WTSNSErrorVersion = 1,
    WTSNSErrorAccountSetup = 2,
};


@interface WTSNSManager : NSObject<UIDocumentInteractionControllerDelegate>

+ (instancetype)sharedManager;

//- (void)openFacebookWithParams:(NSDictionary*)param;

- (SNSComposeSheetBlock)sheetTwitterWithError:(NSError **)error;
- (SNSComposeSheetBlock)sheetFacebookWithError:(NSError **)error;
//- (void)viewController:(UIViewController*)sender presentSheet:(id)sheet animated:(BOOL)animated completion:(void (^)(void))completion __deprecated;
//- (BOOL)viewController:(UIViewController*)sender presentSheet:(id)sheet presentAnimated:(BOOL)presentAnimated presentCompletion:(void (^)(void))presentCompletion dismissAnimated:(BOOL)dismissAnimated dismissCompletion:(void (^)(void))dismissCompletion composeCompletion:(SNSCompletionBlock)composeCompletion;


- (BOOL)isTwitterAvailable;
- (BOOL)isFacebookAvailable;
- (BOOL)isInstagramAvailable;
- (BOOL)isLineAvailable;


- (BOOL)isImageCorrectSize:(UIImage*)image;
- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image;
- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image withFileName:(NSString*)fileName;
- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image withCaption:(NSString*)caption;
- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image withFileName:(NSString*)fileName withCaption:(NSString*)caption;


- (void)usePasteBoardName:(NSString*)pasteBoardName;
- (void)openLineAppWithImage:(UIImage*)image;
- (void)openLineAppWithImage:(UIImage*)image pasteBoardName:(NSString*)name;

@end
#endif
