//
//  WTDropboxManager.h
//  MTankSoundSamplerSS
//
//  Created by Wat Wongtanuwat on 1/12/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface WTDropboxManager : NSObject

@property (nonatomic, copy) void (^beginSessionCompletion)(BOOL linkSuccess);

+ (instancetype)sharedManager;

- (BOOL)isSetup;
- (void)beginSessionForRootAppFolderWithAppKey:(NSString*)appkey withCompletion:(void(^)(BOOL linkSuccess))completion;
- (BOOL)isLogin;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)linkFromViewController:(UIViewController*)vct;
- (void)unlink;


@property (nonatomic, copy) void (^accountInfoCompleteBlock)(DBUSERSSpaceUsage *space);

- (void)accountInfo;



@property (nonatomic, assign) BOOL recursively;

@property (nonatomic, copy) void (^loadListCompleteBlock)(NSArray *fileList);

- (void)loadListFileFromRootFolder;
- (void)loadListFileFromFolderPath:(NSString*)path;


@property (nonatomic, strong) NSString *downloadFolderPath;
@property (nonatomic, assign) BOOL downloading;
@property (nonatomic, assign) int downloadArrayIndex;
@property (nonatomic, assign) long long finishDownloadByte;
@property (nonatomic, assign) long long totalDownloadByte;
@property (nonatomic, strong) NSMutableArray *downloadArray;
@property (nonatomic, strong) NSMutableArray *downloadedArray;
@property (nonatomic, strong) NSMutableArray *downloadSuccessArray;
@property (nonatomic, strong) NSMutableArray *downloadFailArray;

@property (nonatomic, copy) void (^downloadProgressBlock)(int64_t bytesDownloaded, int64_t totalBytesDownloaded, int64_t totalBytesExpectedToDownload);
@property (nonatomic, copy) void (^downloadCompleteBlock)(BOOL success, NSArray *fileSuccess, NSArray *fileFail);

- (void)downloadFromPath:(DBFILESMetadata*)metadata toFolderPath:(NSString*)localFolderPath;
- (void)downloadFromArray:(NSArray*)array toFolderPath:(NSString*)localFolderPath;
- (void)downloadCancel;


@property (nonatomic, copy) void (^uploadProgressBlock)(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded);
@property (nonatomic, copy) void (^uploadCompleteBlock)(BOOL success, DBFILESUploadError *routeError, DBRequestError *networkError);

- (void)uploadFromPath:(NSString*)localPath toPath:(NSString*)dropboxPath;
- (void)uploadCancel;



@end
