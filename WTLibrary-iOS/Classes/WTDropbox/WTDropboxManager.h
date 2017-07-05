//
//  WTDropboxManager.h
//  MTankSoundSamplerSS
//
//  Created by Wat Wongtanuwat on 1/12/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTDropboxManager_VERSION 0x00020000

#if WTDropboxManager_VERSION >= 0x00020000

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface WTDropboxManager : NSObject

@property (nonatomic, copy) void (^beginSessionCompletion)(BOOL linkSuccess);

+ (instancetype)sharedManager;

- (void)beginSessionForRootAppFolderWithAppKey:(NSString*)appkey withCompletion:(void(^)(BOOL linkSuccess))completion;
- (BOOL)isLogin;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)linkFromViewController:(UIViewController*)vct;
- (void)unlink;

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

- (void)downloadFromPath:(NSString*)dropboxPath toFolderPath:(NSString*)localFolderPath;
- (void)downloadFromArray:(NSArray*)array toFolderPath:(NSString*)localFolderPath;
- (void)downloadCancel;


@property (nonatomic, copy) void (^uploadProgressBlock)(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded);
@property (nonatomic, copy) void (^uploadCompleteBlock)(BOOL success, DBFILESUploadError *routeError, DBRequestError *networkError);

- (void)uploadFromPath:(NSString*)localPath toPath:(NSString*)dropboxPath;
- (void)uploadCancel;



@end



#elif WTDropboxManager_VERSION >= 0x00010000

//#import <DropboxSDK/DropboxSDK.h>
//#import <Dropbox/Dropbox.h>

@protocol WTDropboxManagerDelegate <NSObject>

- (void)restClient:(DBRestClient*)client loadedMetadataArray:(NSArray*)metadataArray;

@end


@interface WTDropboxManager : NSObject<DBSessionDelegate,DBRestClientDelegate>

@property (nonatomic, strong) DBSession *dbSession;
@property (nonatomic, copy) void (^beginSessionCompletion)(BOOL linkSuccess,DBSession *session, NSString *userId);

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) NSMutableDictionary *metadataDictionary;

@property (nonatomic, assign) BOOL recursively;
@property (nonatomic, strong) NSMutableArray *exploreQueue;
@property (nonatomic, strong) NSMutableArray *exploreArrayMetadata;

@property (nonatomic, strong) NSString *downloadFolderPath;
@property (nonatomic, assign) BOOL arrayDownloading;
@property (nonatomic, assign) int downloadArrayIndex;
@property (nonatomic, strong) NSMutableArray *downloadArrayMetadata;
@property (nonatomic, strong) NSMutableArray *downloadSuccessArray;
@property (nonatomic, strong) NSMutableArray *downloadFailArray;


@property (nonatomic, copy) void (^downloadProgressBlock)(BOOL finish, DBMetadata *metadata, float progress);
@property (nonatomic, copy) void (^downloadCompleteBlock)(BOOL success, NSArray *fileSuccess, NSArray *fileFail);


@property (nonatomic, copy) void (^uploadProgressBlock)(BOOL finish, NSString *file, float progress, NSError *error);


@property (nonatomic, copy) void (^loadRevisionBlock)(BOOL finish, NSString *file, NSArray *revisions, NSError *error);

//@property (nonatomic, assign) BOOL login;
@property (nonatomic, assign) id<DBSessionDelegate,DBRestClientDelegate,WTDropboxManagerDelegate> managerDelegate;

+ (instancetype)sharedManager;


- (void)addRevForFile:(DBMetadata*)metadata;
- (DBMetadata*)metadataForPath:(NSString*)path;
- (NSString*)revForFilePath:(NSString*)filePath;
- (NSString*)hashForFolderPath:(NSString*)folderPath;

//core api
// call this function in appdelegate
- (void)beginSessionForRootAppFolderWithAppKey:(NSString*)key appSecrect:(NSString*)secret withCompletion:(void (^)(BOOL linkSuccess,DBSession *session, NSString *userId))completion;
- (void)beginSessionForRootDropboxWithAppKey:(NSString*)key appSecrect:(NSString*)secret withCompletion:(void (^)(BOOL linkSuccess,DBSession *session, NSString *userId))completion;

- (void)linkFromViewController:(UIViewController*)vct;
- (void)unlink;
- (BOOL)isLogin;

- (BOOL)handleOpenURL:(NSURL *)url;
- (void)openDropBoxOnAppStore;
- (NSDateFormatter*)dropboxDateFormat;

//funcion api

- (void)uploadFileFromPath:(NSString*)fromPath;
- (void)uploadFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
- (void)uploadNewFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
- (void)uploadCancel:(NSString*)path;
- (void)uploadCancel;


- (void)listFileFromRootFolder;
- (void)listFileFromFolderPath:(NSString*)path;
- (void)listFileFromFolderPath:(NSString*)path recursive:(BOOL)recursive;

- (void)loadListFileFromRootFolder;
- (void)loadListFileFromFolderPath:(NSString*)path;
- (void)loadListFileFromFolderPath:(NSString*)path recursive:(BOOL)recursive;


//- (void)download;
- (void)downloadFileFromPath:(NSString*)dropboxPath toPath:(NSString*)localPath;
- (void)downloadFileFromPath:(NSString*)dropboxPath toFolderPath:(NSString*)localFolderPath;

- (void)downloadFileFromMetadatas:(NSArray*)dropboxMetadatas toFolderPath:(NSString*)localFolderPath;
- (void)downloadFileFromPaths:(NSArray*)dropboxPaths toFolderPath:(NSString*)localFolderPath;

- (void)downloadCancel;


- (void)loadRevisionsForFile:(NSString *)path;

@end

#endif

//@interface WTDropboxSyncManager : NSObject
//
//@end
