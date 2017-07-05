//
//  WTSNSManager.m
//  StickerCamera
//
//  Created by Wat Wongtanuwat on 6/11/13.
//  Copyright (c) 2013 Wat Wongtanuwat. All rights reserved.
//

#ifdef ANDROID
#else

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#ifndef __IPHONE_5_0
#warning "uses (Twitter.framework) only available in iOS SDK 5.0 and later."
#endif

#ifndef __IPHONE_6_0
#warning "uses (Social.framework) only available in iOS SDK 6.0 and later."
#endif

#import "WTSNSManager.h"


NSString *const WTSNSErrorDomain = @"wt.sns.manager";
NSString *const WTSNSErrorTwitterVersionDescription = @"Device version must greater than or equal to 5.0";
NSString *const WTSNSErrorFacebookVersionDescription = @"Device version must greater than or equal to 6.0";
NSString *const WTSNSErrorAccountSetupDescription = @"Account is not setup";


@interface WTSNSManager()
{
    TWTweetComposeViewController *twComposeSheet;
    SLComposeViewController *twslComposeSheet;
    SLComposeViewController *fbslComposeSheet;
    
    UIDocumentInteractionController *diCT;
}

@property (nonatomic,retain) NSString *pasteBoardName;

@end


@implementation WTSNSManager

+ (instancetype)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

#pragma mark -

//- (SNSComposeBlock)presentSheetTwitterFrom:(UIViewController*)sender animated:(BOOL)animated completion:(void (^)(void))completion error:(NSError **)error
//{
//    UIViewController *vct = (UIViewController*)sender;
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
//    {
//#ifdef __IPHONE_6_0
////        if([self isTwitterAvailable])
//        {
//            if(!slComposeSheet){
//                slComposeSheet = [[SLComposeViewController alloc] init];
//            }
//            
//            slComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//            [slComposeSheet removeAllImages];
//            [slComposeSheet removeAllURLs];
//            
//            __weak SNSComposeBlock block = ^(NSString* text, UIImage* image, NSString* url, SNSCompletionBlock composeCompletion){
//                
//                SLComposeViewControllerCompletionHandler slComposeCompletion = ^(SLComposeViewControllerResult result) {
//                    switch (result) {
//                        case SLComposeViewControllerResultCancelled:
//                            composeCompletion(NO);
//                            break;
//                        case SLComposeViewControllerResultDone:
//                            composeCompletion(YES);
//                            break;
//                        default:
//                            break;
//                    }
//                    [vct dismissViewControllerAnimated:YES completion:nil];
//                };
//                
//                if(text) [slComposeSheet setInitialText:text];
//                if(image) [slComposeSheet addImage:image];
//                if(url) [slComposeSheet addURL:[NSURL URLWithString:url]];
//                if(composeCompletion) [slComposeSheet setCompletionHandler:slComposeCompletion];
//                [vct presentViewController:slComposeSheet animated:animated completion:completion];
//                return YES;
//            };
//            return [[block copy] autorelease];
//        }
////        else
////        {
////            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
////            [userInfo setValue:WTSNSErrorAccountSetupDescription forKey:NSLocalizedDescriptionKey];
////            if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorAccountSetup userInfo:userInfo];
////            return nil;
////        }
//#endif
//    }
//    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
//    {
//#ifdef __IPHONE_5_0
////        if([self isTwitterAvailable])
//        {
//            if(!twComposeSheet){
//                twComposeSheet = [[TWTweetComposeViewController alloc] init];
//            }
//            
//            [twComposeSheet removeAllImages];
//            [twComposeSheet removeAllURLs];
//            
//            __weak SNSComposeBlock block = ^(NSString* text, UIImage* image, NSString* url, SNSCompletionBlock composeCompletion){
//                
//                TWTweetComposeViewControllerCompletionHandler slComposeCompletion = ^(TWTweetComposeViewControllerResult result) {
//                    switch (result) {
//                        case TWTweetComposeViewControllerResultCancelled:
//                            composeCompletion(NO);
//                            break;
//                        case TWTweetComposeViewControllerResultDone:
//                            composeCompletion(YES);
//                            break;
//                        default:
//                            break;
//                    }
//                    [vct dismissViewControllerAnimated:YES completion:nil];
//                };
//                
//                if(text) [twComposeSheet setInitialText:text];
//                if(image) [twComposeSheet addImage:image];
//                if(url) [slComposeSheet addURL:[NSURL URLWithString:url]];
//                if(composeCompletion) [twComposeSheet setCompletionHandler:slComposeCompletion];
//                [vct presentViewController:twComposeSheet animated:animated completion:completion];
//                return YES;
//            };
//            return [[block copy] autorelease];
//        }
////        else
////        {
////            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
////            [userInfo setValue:WTSNSErrorAccountSetupDescription forKey:NSLocalizedDescriptionKey];
////            if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorAccountSetup userInfo:userInfo];
////            return nil;
////        }
//#endif
//    }
//    else
//    {
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        [userInfo setValue:WTSNSErrorTwitterVersionDescription forKey:NSLocalizedDescriptionKey];
//        if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorVersion userInfo:userInfo];
//        return nil;
//    }
//    return nil;
//}
//
//- (SNSComposeBlock)presentSheetFacebookFrom:(UIViewController*)sender animated:(BOOL)animated completion:(void (^)(void))completion error:(NSError **)error
//{
//    UIViewController *vct = (UIViewController*)sender;
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
//    {
//#ifdef __IPHONE_6_0
////        if([self isFacebookAvailable])
//        {
//            if(!slComposeSheet){
//                slComposeSheet = [[SLComposeViewController alloc] init];
//            }
//            
//            slComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//            [slComposeSheet removeAllImages];
//            [slComposeSheet removeAllURLs];
//            
//            SNSComposeBlock block = ^(NSString* text, UIImage* image, NSString* url, SNSCompletionBlock composeCompletion){
//                
//                SLComposeViewControllerCompletionHandler slComposeCompletion = ^(SLComposeViewControllerResult result) {
//                    switch (result) {
//                        case SLComposeViewControllerResultCancelled:
//                            composeCompletion(NO);
//                            break;
//                        case SLComposeViewControllerResultDone:
//                            composeCompletion(YES);
//                            break;
//                        default:
//                            break;
//                    }
//                };
//                
//                if(text) [slComposeSheet setInitialText:text];
//                if(image) [slComposeSheet addImage:image];
//                if(url) [slComposeSheet addURL:[NSURL URLWithString:url]];
//                if(composeCompletion) [slComposeSheet setCompletionHandler:slComposeCompletion];
//                [vct presentViewController:slComposeSheet animated:animated completion:completion];
//                return YES;
//            };
//            return [[block copy] autorelease];
//        }
////        else
////        {
////            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
////            [userInfo setValue:WTSNSErrorAccountSetupDescription forKey:NSLocalizedDescriptionKey];
////            if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorAccountSetup userInfo:userInfo];
////            return nil;
////        }
//#endif
//    }
//    else
//    {
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        [userInfo setValue:WTSNSErrorFacebookVersionDescription forKey:NSLocalizedDescriptionKey];
//        if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorVersion userInfo:userInfo];
//        return nil;
//    }
//    return nil;
//}

- (SNSComposeSheetBlock)sheetTwitterWithError:(NSError **)error
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
#ifdef __IPHONE_6_0
    //        if([self isTwitterAvailable])
        {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
                twslComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            }else{
                if(!twslComposeSheet){
                    twslComposeSheet = WT_SAFE_ARC_RETAIN([SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter]);
                }
            }
            
            [twslComposeSheet removeAllImages];
            [twslComposeSheet removeAllURLs];
            
            SNSComposeSheetBlock block = ^(NSString *text, UIImage *image, NSString *url, SNSCompletionBlock composeCompletion){
                
                SLComposeViewControllerCompletionHandler slComposeCompletion = ^(SLComposeViewControllerResult result) {
                    switch (result) {
                        case SLComposeViewControllerResultCancelled:
                            composeCompletion(twslComposeSheet,NO);
                            break;
                        case SLComposeViewControllerResultDone:
                            composeCompletion(twslComposeSheet,YES);
                            break;
                        default:
                            break;
                    }
                };
                
                if(text) [twslComposeSheet setInitialText:text];
                if(image) [twslComposeSheet addImage:image];
                if(url) [twslComposeSheet addURL:[NSURL URLWithString:url]];
                if(composeCompletion) [twslComposeSheet setCompletionHandler:slComposeCompletion];
                
                return twslComposeSheet;
            };
            
            return WT_SAFE_ARC_AUTORELEASE([block copy]);
        }
//        else
//        {
//            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//            [userInfo setValue:WTSNSErrorAccountSetupDescription forKey:NSLocalizedDescriptionKey];
//            if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorAccountSetup userInfo:userInfo];
//            return nil;
//        }
#endif
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
    {
#ifdef __IPHONE_5_0
//        if([self isTwitterAvailable])
        {
            if(!twComposeSheet){
                twComposeSheet = [[TWTweetComposeViewController alloc] init];
            }
            
            [twComposeSheet removeAllImages];
            [twComposeSheet removeAllURLs];
            
            SNSComposeSheetBlock block = ^(NSString *text, UIImage *image, NSString *url, SNSCompletionBlock composeCompletion){
                
                TWTweetComposeViewControllerCompletionHandler slComposeCompletion = ^(TWTweetComposeViewControllerResult result) {
                    switch (result) {
                        case TWTweetComposeViewControllerResultCancelled:
                            composeCompletion((SLComposeViewController*)twComposeSheet,NO);
                            break;
                        case TWTweetComposeViewControllerResultDone:
                            composeCompletion((SLComposeViewController*)twComposeSheet,YES);
                            break;
                        default:
                            break;
                    }
                };
                
                if(text) [twComposeSheet setInitialText:text];
                if(image) [twComposeSheet addImage:image];
                if(url) [twComposeSheet addURL:[NSURL URLWithString:url]];
                if(composeCompletion) [twComposeSheet setCompletionHandler:slComposeCompletion];
                
                return (SLComposeViewController*)twComposeSheet;
            };
            
            return WT_SAFE_ARC_AUTORELEASE([block copy]);
        }
//        else
//        {
//            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//            [userInfo setValue:WTSNSErrorAccountSetupDescription forKey:NSLocalizedDescriptionKey];
//            if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorAccountSetup userInfo:userInfo];
//            return nil;
//        }
#endif
    }
    else
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:WTSNSErrorTwitterVersionDescription forKey:NSLocalizedDescriptionKey];
        if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorVersion userInfo:userInfo];
        return nil;
    }
    return nil;
}

//- (SNSComposeBlock)presentSheetFacebookFrom:(UIViewController*)sender animated:(BOOL)animated completion:(void (^)(void))completion error:(NSError **)error
//{
//    UIViewController *vct = (UIViewController*)sender;
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
//    {
//#ifdef __IPHONE_6_0
////        if([self isFacebookAvailable])
//        {
//            if(!slComposeSheet){
//                slComposeSheet = [[SLComposeViewController alloc] init];
//            }
//            
//            slComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//            [slComposeSheet removeAllImages];
//            [slComposeSheet removeAllURLs];
//            
//            SNSComposeBlock block = ^(NSString* text, UIImage* image, NSString* url, SNSCompletionBlock composeCompletion){
//                
//                SLComposeViewControllerCompletionHandler slComposeCompletion = ^(SLComposeViewControllerResult result) {
//                    switch (result) {
//                        case SLComposeViewControllerResultCancelled:
//                            composeCompletion(NO);
//                            break;
//                        case SLComposeViewControllerResultDone:
//                            composeCompletion(YES);
//                            break;
//                        default:
//                            break;
//                    }
//                };
//                
//                if(text) [slComposeSheet setInitialText:text];
//                if(image) [slComposeSheet addImage:image];
//                if(url) [slComposeSheet addURL:[NSURL URLWithString:url]];
//                if(composeCompletion) [slComposeSheet setCompletionHandler:slComposeCompletion];
//                [vct presentViewController:slComposeSheet animated:animated completion:completion];
//                return YES;
//            };
//            return [[block copy] autorelease];
//        }
////        else
////        {
////            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
////            [userInfo setValue:WTSNSErrorAccountSetupDescription forKey:NSLocalizedDescriptionKey];
////            if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorAccountSetup userInfo:userInfo];
////            return nil;
////        }
//#endif
//    }
//    else
//    {
//        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        [userInfo setValue:WTSNSErrorFacebookVersionDescription forKey:NSLocalizedDescriptionKey];
//        if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorVersion userInfo:userInfo];
//        return nil;
//    }
//    return nil;
//}

- (SNSComposeSheetBlock)sheetFacebookWithError:(NSError **)error
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
#ifdef __IPHONE_6_0
//        if([self isFacebookAvailable])
        {
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
                fbslComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            }else{
                fbslComposeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            }
            
            [fbslComposeSheet removeAllImages];
            [fbslComposeSheet removeAllURLs];
            
            SNSComposeSheetBlock block = ^(NSString *text, UIImage *image, NSString *url, SNSCompletionBlock composeCompletion){
                
                SLComposeViewControllerCompletionHandler slComposeCompletion = ^(SLComposeViewControllerResult result) {
                    switch (result) {
                        case SLComposeViewControllerResultCancelled:
                            composeCompletion(fbslComposeSheet,NO);
                            break;
                        case SLComposeViewControllerResultDone:
                            composeCompletion(fbslComposeSheet,YES);
                            break;
                        default:
                            break;
                    }
                };
            
                if(text) [fbslComposeSheet setInitialText:text];
                if(image) [fbslComposeSheet addImage:image];
                if(url) [fbslComposeSheet addURL:[NSURL URLWithString:url]];
                if(composeCompletion) [fbslComposeSheet setCompletionHandler:slComposeCompletion];
                
                return fbslComposeSheet;
            };
            
            return WT_SAFE_ARC_AUTORELEASE([block copy]);
        }
//        else
//        {
//            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//            [userInfo setValue:WTSNSErrorAccountSetupDescription forKey:NSLocalizedDescriptionKey];
//            if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorAccountSetup userInfo:userInfo];
//            return nil;
//        }
#endif
    }
    else
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:WTSNSErrorFacebookVersionDescription forKey:NSLocalizedDescriptionKey];
        if (error) *error = [NSError errorWithDomain:WTSNSErrorDomain code:WTSNSErrorVersion userInfo:userInfo];
        return nil;
    }
    return nil;
}

#pragma mark -

- (void)viewController:(UIViewController*)sender presentSheet:(id)sheet animated:(BOOL)animated completion:(void (^)(void))completion;
{
    UIViewController *vct = (UIViewController*)sender;
    
    [vct presentViewController:sheet animated:animated completion:completion];
}

- (BOOL)viewController:(UIViewController*)sender presentSheet:(id)sheet presentAnimated:(BOOL)presentAnimated presentCompletion:(void (^)(void))presentCompletion dismissAnimated:(BOOL)dismissAnimated dismissCompletion:(void (^)(void))dismissCompletion composeCompletion:(SNSCompletionBlock)composeCompletion{
//    UIViewController *vct = (UIViewController*)sender;
//    
//    if(![sheet isKindOfClass:[SLComposeViewController class]] && ![sheet isKindOfClass:[TWTweetComposeViewController class]]){
//        return NO;
//    }
//    
//    SLComposeViewControllerCompletionHandler slComposeCompletion = ^(SLComposeViewControllerResult result) {
//        switch (result) {
//            case SLComposeViewControllerResultCancelled:
//                composeCompletion(sheet,NO);
//                break;
//            case SLComposeViewControllerResultDone:
//                composeCompletion(sheet,YES);
//                break;
//            default:
//                break;
//        }
//        [sheet dismissViewControllerAnimated:dismissAnimated completion:dismissCompletion];
//    };
//    
//    [twComposeSheet setCompletionHandler:slComposeCompletion];
//    
//    [vct presentViewController:sheet animated:presentAnimated completion:presentCompletion];
    
    return YES;
}

//- (void)login:(id)sender {
//    [FBSession openActiveSessionWithPermissions:nil allowLoginUI:YES
//                              completionHandler:^(FBSession *session,
//                                                  FBSessionState status,
//                                                  NSError *error) {
//                                  // session might now be open.
//                              }];
//}
//
//- (void)loginFacebookAndPost:(id)sender {
//    [FBSession openActiveSessionWithPermissions:nil allowLoginUI:YES
//                              completionHandler:^(FBSession *session,
//                                                  FBSessionState status,
//                                                  NSError *error) {
//                                  // session might now be open.
//                                  
//                                  if (session.isOpen) {
//                                      
//                                      
//                                  }
//                                  
//                              }];
//}
//
//- (void)openFacebookWithParams:(NSDictionary*)param
//{
//    if ([[FBSession activeSession] isOpen]){
//        //        FacebookPostImageController *fbViewController = [[FacebookPostImageController alloc] initWithInitialText:text Image:image];
//        //        [[self navController] presentModalViewController:fbViewController animated:YES];
//    }
//    else{
//        NSArray *permissions = [[NSArray alloc] initWithObjects:
//                                @"publish_actions", nil];
//        [FBSession openActiveSessionWithPermissions:permissions
//                                       allowLoginUI:YES
//                                  completionHandler:^(FBSession *session,
//                                                      FBSessionState state,
//                                                      NSError *error)
//         {
//             if (session.isOpen){
//                 //                 FacebookPostImageController *fbViewController = [[FacebookPostImageController alloc] initWithInitialText:text Image:image];
//                 //                 [[self navController] presentModalViewController:fbViewController animated:YES];
//             }
//         }];
//    }
//}
//
//
//- (void)postFacebookWithInitialText:(NSString *)text image:(UIImage *)image
//{
//    //    text = [text stringByAppendingString:[self addMoreLink]];
//    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                   UIImagePNGRepresentation(image), @"picture", text, @"message", nil];
//    
//    [FBRequestConnection startWithGraphPath:@"me/photos"
//                                 parameters:params
//                                 HTTPMethod:@"POST"
//                          completionHandler:^(FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error)
//     {
//         NSString *alertText;
//         if (error) {
//             alertText = @"投稿できませんでした。";
//         } else {
//             alertText = @"Facebookに投稿しました。";
//         }
//         // Show the result in an alert
//         [[[UIAlertView alloc] initWithTitle:@"Facebook"
//                                     message:alertText
//                                    delegate:self
//                           cancelButtonTitle:@"OK!"
//                           otherButtonTitles:nil] show];
//     }];
//}
//
//- (void)closePostFacebookView
//{
//    //    [[self navController] dismissModalViewControllerAnimated:YES];
//}
//
//- (void)sessionStateChanged:(FBSession *)session
//                      state:(FBSessionState) state
//                      error:(NSError *)error
//{
//    switch (state) {
//        case FBSessionStateOpen: {
//            //            UIViewController *topViewController =
//            //            [self.navController topViewController];
//            //            if ([[topViewController modalViewController]
//            //                 isKindOfClass:[SCLoginViewController class]]) {
//            //                [topViewController dismissModalViewControllerAnimated:YES];
//            //            }
//        }
//            break;
//        case FBSessionStateClosed:
//        case FBSessionStateClosedLoginFailed:
//            // Once the user has logged in, we want them to
//            // be looking at the root view.
//            //            [self.navController popToRootViewControllerAnimated:NO];
//            
//            [FBSession.activeSession closeAndClearTokenInformation];
//            
//            //            [self showLoginView];
//            [self openSession];
//            break;
//        default:
//            break;
//    }
//    
//    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//}
//
//- (void)openSession
//{
//    if ([[FBSession activeSession] isOpen]){
//    }else{
//        [FBSession openActiveSessionWithReadPermissions:nil
//                                           allowLoginUI:YES
//                                      completionHandler:
//         ^(FBSession *session,
//           FBSessionState state, NSError *error) {
//             [self sessionStateChanged:session state:state error:error];
//         }];
//    }
//}

#pragma mark -

- (BOOL)isTwitterAvailable
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
#ifdef __IPHONE_6_0
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])//bug in iphone simulator6.0, SLComposeViewController always return YES
        {
            return YES;
        }
#endif
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
    {
#ifdef __IPHONE_5_0
        if([TWTweetComposeViewController canSendTweet])
        {
            return YES;
        }
#endif
    }
    return NO;
}

- (BOOL)isFacebookAvailable
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
#ifdef __IPHONE_6_0
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])//bug in iphone simulator6.0, SLComposeViewController always return YES
        {
            return YES;
        }
#endif
    }
    return NO;
}

- (BOOL)isInstagramAvailable
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        return YES;
    }
    return NO;
}

- (BOOL)isLineAvailable
{
    NSURL *lineURL = [NSURL URLWithString:@"line://"];
    if ([[UIApplication sharedApplication] canOpenURL:lineURL])
    {
        return YES;
    }
    return NO;
}

#pragma mark -
- (BOOL)isImageCorrectSize:(UIImage*)image
{
    CGImageRef cgImage = [image CGImage];
    return (CGImageGetWidth(cgImage) >= 612 && CGImageGetHeight(cgImage) >= 612);
}

- (NSString*)saveImage:(UIImage*)image
{
    return [self saveImage:image withFileName:@"temp_image.igo"];
}

- (NSString*)saveImage:(UIImage*)image withFileName:(NSString*)fileName
{
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libDir = [dirs objectAtIndex:0];
    
    NSString *instagramFolder = [libDir stringByAppendingPathComponent:@"instagram"];
    BOOL isFolder = NO;
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:instagramFolder isDirectory:&isFolder];
    if(!folderExists || !isFolder){
        if(!isFolder){
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:instagramFolder error:&error];
        }
        NSError *error;
        if(![[NSFileManager defaultManager] createDirectoryAtPath:instagramFolder withIntermediateDirectories:YES attributes:nil error:&error]){
            return nil;
        }
    }
    
    NSString *file = [fileName stringByAppendingPathExtension:@".igo"];
    
    NSString *path = [instagramFolder stringByAppendingPathComponent:file];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if(fileExists){
        NSError *error;
        if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error]){
            return nil;
        }
    }
    
    if(![[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(image, 1) attributes:nil]){
        return nil;
    }
    return path;
}

- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image
{
    return [self openInstagramAppFromView:view withImage:image withFileName:@"" withCaption:@""];
}

- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image withFileName:(NSString *)fileName
{
    return [self openInstagramAppFromView:view withImage:image withFileName:fileName withCaption:@""];
}

- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image withCaption:(NSString *)caption
{
    return [self openInstagramAppFromView:view withImage:image withFileName:@"" withCaption:caption];
}

- (BOOL)openInstagramAppFromView:(UIView*)view withImage:(UIImage*)image withFileName:(NSString *)fileName withCaption:(NSString *)caption
{
    if(!image){
        return NO;
    }
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        NSString *imagePath = [self saveImage:image];
        
        if(!imagePath){
            return NO;
        }
        
        NSURL *igImageHookFile = [NSURL fileURLWithPath:imagePath isDirectory:NO];
        
        if(!diCT){
            diCT = WT_SAFE_ARC_RETAIN([UIDocumentInteractionController interactionControllerWithURL:igImageHookFile]);
            diCT.delegate = (id<UIDocumentInteractionControllerDelegate>)self;
        }
        
        diCT.UTI = @"com.instagram.exclusivegram";
        
        if(fileName)diCT.name = fileName;
        
        if(caption)diCT.annotation = [NSDictionary dictionaryWithObject:caption forKey:@"InstagramCaption"];
        
        BOOL isOpen = [diCT presentOpenInMenuFromRect:CGRectZero inView:view animated:YES];
        
        if(!isOpen){
            WT_SAFE_ARC_RELEASE(diCT);
            diCT = nil;
        }
        
        return isOpen;
    }
    
    return NO;
}
//- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{NSLog(@"id 1");}
//
//// If preview is supported, these provide the view and rect that will be used as the starting point for the animation to the full screen preview.
//// The actual animation that is performed depends upon the platform and other factors.
//// If documentInteractionControllerRectForPreview is not implemented, the specified view's bounds will be used.
//// If documentInteractionControllerViewForPreview is not implemented, the preview controller will simply fade in instead of scaling up.
//- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{NSLog(@"id 2");}
//- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{NSLog(@"id 3");}
//
//// Preview presented/dismissed on document.  Use to set up any HI underneath.
//- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller{NSLog(@"id 4");}
//- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller{NSLog(@"id 5");}
//
//// Options menu presented/dismissed on document.  Use to set up any HI underneath.
//- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller{NSLog(@"id 6");}
//- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{NSLog(@"id 7");}
//
//// Open in menu presented/dismissed on document.  Use to set up any HI underneath.
//- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller{NSLog(@"id 8");}
//
//// Synchronous.  May be called when inside preview.  Usually followed by app termination.  Can use willBegin... to set annotation.
//- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application{NSLog(@"id 10");}	 // bundle ID
//- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{NSLog(@"id 11");}
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
//    NSLog(@"id 9");
    if(diCT==controller){
        WT_SAFE_ARC_RELEASE(diCT);
        diCT = nil;
    }
}

#pragma mark -

- (void)usePasteBoardName:(NSString*)name
{
    self.pasteBoardName = name;
}

- (void)openLineAppWithImage:(UIImage*)image
{
    [self openLineAppWithImage:image pasteBoardName:self.pasteBoardName];
}

- (void)openLineAppWithImage:(UIImage*)image pasteBoardName:(NSString*)name
{
    if(!name){
        //log some error
    }
    
    NSString *pasteBoardName = name;
    NSURL *lineURL = [NSURL URLWithString:[NSString stringWithFormat:@"line://msg/image/%@",pasteBoardName]];
    if ([[UIApplication sharedApplication] canOpenURL:lineURL])
    {
        UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:pasteBoardName create:YES];
//        [pasteboard setPersistent:YES];
        [pasteboard setImage:image];
        
        [[UIApplication sharedApplication] openURL:lineURL];
    }
}

@end
#endif
