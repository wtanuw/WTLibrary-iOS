//
//  WTDropboxManager.m
//  MTankSoundSamplerSS
//
//  Created by Wat Wongtanuwat on 1/12/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import "WTDropboxManager.h"

#import "WTMacro.h"
#import <WTLibrary_iOS/WTStoreKit.h>
#import <WTLibrary_iOS/WTWatLog.h>

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#define WTLibrary_iOS_WTDropboxManager_VERSION 0x00070000
#define _WTLibrary_iOS_WTDropboxManager_API_VERSION_10 __IPHONE_10_0

#define WTDropboxManager_TEST_METHOD 0

#if WTDropboxManager_TEST_METHOD
//#define APP_KEY @"gchrvot3quxsaxn"
//#define APP_SECRET @"z8rohagbdf4fbi6"
#endif

//dropbox version 7.0.0

@interface WTDropboxManager()

@property (nonatomic,strong) DBUploadTask *uploadTask;
@property (nonatomic,strong) DBDownloadUrlTask *downloadTask;

@end

@implementation WTDropboxManager

+ (instancetype)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    //        _metadataDictionary = [NSMutableDictionary dictionary];
    //        _exploreQueue = [NSMutableArray array];
    _downloadArray = [NSMutableArray array];
    _downloadedArray = [NSMutableArray array];
    _downloadSuccessArray = [NSMutableArray array];
    _downloadFailArray = [NSMutableArray array];
}

//- (void)addRevForFile:(DBMetadata*)metadata
//{
//    if(!_metadataDictionary){
//        _metadataDictionary = [NSMutableDictionary dictionary];
//    }
//    _metadataDictionary[metadata.path] = metadata;
//}
//
//- (DBMetadata*)metadataForPath:(NSString*)path
//{
//    DBMetadata* metadata = _metadataDictionary[path];
//    if(metadata){
//        return metadata;
//    }else{
//        return nil;
//    }
//}
//
//- (NSString*)revForFilePath:(NSString*)filePath
//{
//    DBMetadata* metadata = _metadataDictionary[filePath];
//    if(metadata.rev){
//        return metadata.rev;
//    }else{
//        return metadata.rev;
//    }
//}
//
//- (NSString*)hashForFolderPath:(NSString*)folderPath
//{
//    DBMetadata* metadata = _metadataDictionary[folderPath];
//    if(metadata.isDirectory){
//        return metadata.hash;
//    }else{
//        return nil;
//    }
//}

#pragma mark - core api

- (BOOL)isSetup
{
    if ([DBClientsManager appKey]) {
        return YES;
    }
    return NO;
}

- (void)beginSessionForRootAppFolderWithAppKey:(NSString*)key withCompletion:(void (^)(BOOL linkSuccess))completion
{
    if (![self isSetup]) {
        [DBClientsManager setupWithAppKey:key];
    }
    
    self.beginSessionCompletion = completion;
    
//    NSString* appKey = key;
//    NSString* appSecret = secret;
//    NSString *root = kDBRootAppFolder;
//
//    DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey
//                                                   appSecret:appSecret
//                                                        root:root]; // either kDBRootAppFolder or kDBRootDropbox
//    dbSession.delegate = self;
//    [DBSession setSharedSession:dbSession];
//
//    self.dbSession = dbSession;
}

- (void)linkFromViewController:(UIViewController*)vct {
    if (![self isLogin]) {
        
        DBScopeRequest *scopeRequest = [[DBScopeRequest alloc]
                    initWithScopeType:DBScopeTypeUser
                                                scopes:@[@""]
                                                includeGrantedScopes:NO];
        [DBClientsManager authorizeFromControllerV2:[UIApplication sharedApplication]
            controller:vct
            loadingStatusDelegate:nil
            openURL:^(NSURL *url) {
        #if IS_IOS_BASE_SDK_ATLEAST(_WTLibrary_iOS_WTDropboxManager_API_VERSION_10)
          if (@available(iOS 10.0, *))
          {
              [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
          }
        #if IS_IOS_DEPLOY_TARGET_BELOW(_WTLibrary_iOS_WTDropboxManager_API_VERSION_10)
          else
        #endif
        #endif
        #if IS_IOS_DEPLOY_TARGET_BELOW(_WTLibrary_iOS_WTDropboxManager_API_VERSION_10)
          {
              [[UIApplication sharedApplication] openURL:url];
          }
        #endif
            }
                                       scopeRequest:scopeRequest];
    }
}

//+ (UIViewController*)topMostController
//{
//    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//
//    while (topController.presentedViewController) {
//        topController = topController.presentedViewController;
//    }
//
//    return topController;
//}

- (void)unlink {
    if ([self isLogin]) {
        [DBClientsManager unlinkAndResetClients];
    }
}

- (void)openDropBoxOnAppStore
{
    [[WTStoreKit sharedManager] storeProductVCTWithITunesItemIdentifier:@"327630330" completionBlock:^(SKStoreProductViewController *storeProductVCT, BOOL result, NSError *error) {
    } withFallBackURL:@"itms://itunes.com/apps/dropbox"];
}

- (NSDateFormatter*)dropboxDateFormat
{
    //    Date format
    //
    //    All dates in the API are strings in the following format:
    //
    //    "Sat, 21 Aug 2010 22:31:20 +0000"
    //    In code format, which can be used in all programming languages that support strftime or strptime:
    //
    //    "%a, %d %b %Y %H:%M:%S %z"
    NSString *format = @"%a, %d %b %Y %H:%M:%S %z";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = format;
    dateFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    
    return dateFormat;
}

- (BOOL)isLogin
{
    return [[DBClientsManager authorizedClient] isAuthorized];
}

#pragma mark - session delegate

- (BOOL)handleOpenURL:(NSURL *)url
{
    if (![self isSetup]) {
        return NO;
    }
    DBOAuthCompletion completion = ^(DBOAuthResult *authResult) {
      if (authResult != nil) {
        if ([authResult isSuccess]) {
          WatLog(@"\n\nSuccess! User is logged into Dropbox.\n\n");
            [self loginSuccess];
        } else if ([authResult isCancel]) {
          WatLog(@"\n\nAuthorization flow was manually canceled by user!\n\n");
        } else if ([authResult isError]) {
          WatLog(@"\n\nError: %@\n\n", authResult);
        }
      }
    };
    BOOL canHandle = [DBClientsManager handleRedirectURL:url completion:completion];
    return canHandle;
}
- (void)loginSuccess
{
    if(self.beginSessionCompletion){
        self.beginSessionCompletion([self isLogin]);
    }
}

//- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
//{
//    //    if([self.managerDelegate respondsToSelector:@selector(sessionDidReceiveAuthorizationFailure:userId:)]){
//    //        [self.managerDelegate sessionDidReceiveAuthorizationFailure:session userId:userId];
//    //    }
//
//    if(_beginSessionCompletion){
//        _beginSessionCompletion(NO);
//    }
//}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    DBOAuthCompletion completion = ^(DBOAuthResult *authResult) {
      if (authResult != nil) {
        if ([authResult isSuccess]) {
          WatLog(@"\n\nSuccess! User is logged into Dropbox.\n\n");
        } else if ([authResult isCancel]) {
          WatLog(@"\n\nAuthorization flow was manually canceled by user!\n\n");
        } else if ([authResult isError]) {
          WatLog(@"\n\nError: %@\n\n", authResult);
        }
      }
    };
    BOOL canHandle = [DBClientsManager handleRedirectURL:url completion:completion];
    return canHandle;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

-(void)migrate
{
    BOOL willPerformMigration = [DBClientsManager checkAndPerformV1TokenMigration:^(BOOL shouldRetry, BOOL invalidAppKeyOrSecret,
                                                                                    NSArray<NSArray<NSString *> *> *unsuccessfullyMigratedTokenData) {
        if (invalidAppKeyOrSecret) {
            // Developers should ensure that the appropriate app key and secret are being supplied.
            // If your app has multiple app keys / secrets, then run this migration method for
            // each app key / secret combination, and ignore this boolean.
        }
        
        if (shouldRetry) {
            // Store this BOOL somewhere to retry when network connection has returned
        }
        
        if ([unsuccessfullyMigratedTokenData count] != 0) {
            WatLog(@"The following tokens were unsucessfully migrated:");
            for (NSArray<NSString *> *tokenData in unsuccessfullyMigratedTokenData) {
                WatLog(@"DropboxUserID: %@, AccessToken: %@, AccessTokenSecret: %@, StoredAppKey: %@", tokenData[0],
                       tokenData[1], tokenData[2], tokenData[3]);
            }
        }
        
        if (!invalidAppKeyOrSecret && !shouldRetry && [unsuccessfullyMigratedTokenData count] == 0) {
            [DBClientsManager setupWithAppKey:@"<APP_KEY>"];
        }
    } queue:nil appKey:@"<APP_KEY>" appSecret:@"<APP_SECRET>"];
    
    if (!willPerformMigration) {
        [DBClientsManager setupWithAppKey:@"<APP_KEY>"];
    }
}

#pragma clang diagnostic pop

#pragma mark -

- (DBUserClient*)client
{
    return [DBClientsManager authorizedClient];
}

//- (void)rest;

#pragma mark -

-(void)accountInfo
{
//    [[[self client].usersRoutes getCurrentAccount] setResponseBlock:^(DBUSERSFullAccount *result, DBNilObject *routeError, DBRequestError * networkError) {
//        if (_accountInfoCompleteBlock) {
//            _accountInfoCompleteBlock(result);
//        }
//    }];
    __weak typeof (self) weakSelf = self;
    [[[self client].usersRoutes getSpaceUsage] setResponseBlock:^(DBUSERSSpaceUsage *result, DBNilObject *routeError, DBRequestError * networkError) {
        if (weakSelf.accountInfoCompleteBlock) {
            weakSelf.accountInfoCompleteBlock(result);
        }
    }];
}

#pragma mark - rest delegate

//- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info;
//
//- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error;

#pragma mark -

- (void)loadListFileFromRootFolder
{
    [self loadListFileFromFolderPath:@""];
}

- (void)loadListFileFromFolderPath:(NSString*)path;
{//@"/test/path/in/Dropbox/account"
    __weak typeof (self) weakSelf = self;
    [[[self client].filesRoutes listFolder:path]
     setResponseBlock:^(DBFILESListFolderResult *response, DBFILESListFolderError *routeError, DBRequestError *networkError) {
         if (response) {
             NSArray<DBFILESMetadata *> *entries = response.entries;
             NSString *cursor = response.cursor;
             BOOL hasMore = [response.hasMore boolValue];
             
             [self printEntries:entries];
             
             if (hasMore) {
                 WatLog(@"Folder is large enough where we need to call `listFolderContinue:`");
                 
                 [self listFolderContinueWithClient:[self client] cursor:cursor];
             } else {
                 WatLog(@"List folder complete.");
                 if (weakSelf.loadListCompleteBlock) {
                     weakSelf.loadListCompleteBlock(entries);
                 }
             }
         } else {
             WatLog(@"%@\n%@\n", routeError, networkError);
             if (weakSelf.loadListCompleteBlock) {
                 weakSelf.loadListCompleteBlock(@[]);
             }
         }
     }];
}



- (void)listFolderContinueWithClient:(DBUserClient *)client cursor:(NSString *)cursor {
    __weak typeof (self) weakSelf = self;
    [[client.filesRoutes listFolderContinue:cursor]
     setResponseBlock:^(DBFILESListFolderResult *response, DBFILESListFolderContinueError *routeError,
                        DBRequestError *networkError) {
         if (response) {
             NSArray<DBFILESMetadata *> *entries = response.entries;
             NSString *cursor = response.cursor;
             BOOL hasMore = [response.hasMore boolValue];
             
             [self printEntries:entries];
             
             if (hasMore) {
                 [self listFolderContinueWithClient:client cursor:cursor];
             } else {
                 WatLog(@"List folder complete.");
                 if (weakSelf.loadListCompleteBlock) {
                     weakSelf.loadListCompleteBlock(entries);
                 }
             }
         } else {
             WatLog(@"%@\n%@\n", routeError, networkError);
             if (weakSelf.loadListCompleteBlock) {
                 weakSelf.loadListCompleteBlock(@[]);
             }
         }
     }];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

- (void)printEntries:(NSArray<DBFILESMetadata *> *)entries {
    for (DBFILESMetadata *entry in entries) {
        if ([entry isKindOfClass:[DBFILESFileMetadata class]]) {
            DBFILESFileMetadata *fileMetadata = (DBFILESFileMetadata *)entry;
            WatLog(@"File data: %@\n", fileMetadata);
        } else if ([entry isKindOfClass:[DBFILESFolderMetadata class]]) {
            DBFILESFolderMetadata *folderMetadata = (DBFILESFolderMetadata *)entry;
            WatLog(@"Folder data: %@\n", folderMetadata);
        } else if ([entry isKindOfClass:[DBFILESDeletedMetadata class]]) {
            DBFILESDeletedMetadata *deletedMetadata = (DBFILESDeletedMetadata *)entry;
            WatLog(@"Deleted data: %@\n", deletedMetadata);
        }
    }
}

#pragma clang diagnostic pop

//- (void)loadListFileFromRootFolder;
//
//- (void)loadListFileFromFolderPath:(NSString*)path;
//
//#pragma mark - rest delegate
//
//- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata;
//
//- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error ;
//

#pragma mark -

- (void)downloadFromPath:(DBFILESMetadata *)metadata toFolderPath:(NSString*)localFolderPath
{
    [self downloadFromArray:@[metadata] toFolderPath:localFolderPath];
}

- (void)downloadFromArray:(NSArray*)array toFolderPath:(NSString*)localFolderPath
{
    _downloadFolderPath = localFolderPath;
    _downloading = YES;
    _downloadArrayIndex = 0;
    _finishDownloadByte = 0;
    _totalDownloadByte = 0;
    [_downloadArray removeAllObjects];
    [_downloadedArray removeAllObjects];
    [_downloadSuccessArray removeAllObjects];
    [_downloadFailArray removeAllObjects];
    
    [_downloadArray addObjectsFromArray:array];
    for(DBFILESMetadata *metadata in array){
        if ([metadata isKindOfClass:[DBFILESFileMetadata class]]) {
            DBFILESFileMetadata *fileMetadata = (DBFILESFileMetadata *)metadata;
            WatLog(@"File data: %@  %.1f\n", fileMetadata.name, [fileMetadata.size floatValue]/1024.0/1024.0);
            _totalDownloadByte += [[fileMetadata size] floatValue];
        }
    }
    
    [self downloadFileFromPath:_downloadArray[_downloadArrayIndex]];
}

- (void)downloadFileFromPath:(DBFILESFileMetadata*)dropboxPath
{
    __weak typeof (self) weakSelf = self;
    NSURL *destinationUrl = [NSURL fileURLWithPath:[_downloadFolderPath stringByAppendingPathComponent:dropboxPath.pathDisplay]];
    
    _downloadTask = [[[[self client].filesRoutes downloadUrl:dropboxPath.pathDisplay
                                                   overwrite:YES
                                                 destination:destinationUrl]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *networkError, NSURL *destination) {
          if (result) {
              WatLog(@"%@\n", result);
              
              [weakSelf.downloadedArray addObject:result];
              [weakSelf.downloadSuccessArray addObject:result];
              weakSelf.finishDownloadByte += [result.size floatValue];
              
              
              if ([weakSelf.downloadArray count] != [weakSelf.downloadedArray count]) {
                  weakSelf.downloadArrayIndex += 1;
                  [weakSelf downloadFileFromPath:weakSelf.downloadArray[weakSelf.downloadArrayIndex]];
              } else {
                  if (weakSelf.downloadCompleteBlock) {
                      weakSelf.downloadCompleteBlock(result?YES:NO, weakSelf.downloadSuccessArray, weakSelf.downloadFailArray);
                  }
              }
              
          } else {
              WatLog(@"%@\n%@\n", routeError, networkError);
              if (weakSelf.downloadCompleteBlock) {
                  weakSelf.downloadCompleteBlock(result?YES:NO, weakSelf.downloadSuccessArray, weakSelf.downloadFailArray);
              }
//              [_downloadedArray addObject:result];
//              [_downloadFailArray addObject:result];
          }
          
      }] setProgressBlock:^(int64_t bytesDownloaded, int64_t totalBytesDownloaded, int64_t totalBytesExpectedToDownload) {
          WatLog(@"%lld %lld %lld", bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
          
          if (weakSelf.downloadProgressBlock) {
              weakSelf.downloadProgressBlock(bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
          }
      }];
}

//
//- (void)downloadFileFromPath:(NSString*)dropboxPath toPath:(NSString*)localPath;
//
//- (void)downloadFileFromPath:(NSString*)dropboxPath toFolderPath:(NSString*)localFolderPath;
//
//#pragma mark -
//
//- (void)downloadFileFromMetadatas:(NSArray*)dropboxMetadatas toFolderPath:(NSString*)localFolderPath;
//
//- (void)downloadFileFromPaths:(NSArray*)dropboxPaths toFolderPath:(NSString*)localFolderPath;
//
#pragma mark -

- (void)downloadCancel
{
    [_downloadTask cancel];
}

#pragma mark -

//- (void)uploadFileFromPath:(NSString*)fromPath
//{
//    [self client].filesRoutes;
//}
//
//- (void)uploadFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
//
//- (void)uploadNewFileFromPath:(NSString*)fromPath;
//
//- (void)uploadNewFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath;

- (void)uploadFromPath:(NSString*)localPath toPath:(NSString*)dropboxPath;
{
    __weak typeof (self) weakSelf = self;
    
    // For overriding on upload
    DBFILESWriteMode *mode = [[DBFILESWriteMode alloc] initWithOverwrite];
//
//    _uploadTask = [[[[self client].filesRoutes uploadData:dropboxPath
//                                                     mode:mode
//                                               autorename:@(YES)
//                                           clientModified:nil
//                                                     mute:@(NO)
//                                                inputData:fileData]
    
    [[self client].filesRoutes uploadUrl:dropboxPath inputUrl:localPath];
    _uploadTask = [[[[self client].filesRoutes uploadUrl:dropboxPath
                                                     mode:mode
                                               autorename:@(NO)
                                           clientModified:[NSDate date]
                                                     mute:@(NO)
                                          propertyGroups:nil
                                          strictConflict:@(NO)
                                             contentHash:nil
                                                inputUrl:localPath]
                    setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *networkError) {
                        if (result) {
                            WatLog(@"%@\n", result);
                        } else {
                            WatLog(@"%@\n%@\n", routeError, networkError);
                        }
                        if (weakSelf.uploadCompleteBlock) {
                            weakSelf.uploadCompleteBlock(result?YES:NO, routeError, networkError);
                        }
                    }] setProgressBlock:^(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded) {
                        WatLog(@"\n%lld\n%lld\n%lld\n", bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded);
                        
                        if (weakSelf.uploadProgressBlock) {
                            weakSelf.uploadProgressBlock(bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded);
                        }
                    }];
}

#pragma mark -

//- (void)uploadCancel:(NSString*)path;

- (void)uploadCancel
{
    [_uploadTask cancel];
}

//#pragma mark - rest delegate
//
//- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
//              from:(NSString *)srcPath metadata:(DBMetadata *)metadata;
//
//- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress
//           forFile:(NSString*)destPath from:(NSString*)srcPath;
//
//- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error;

#pragma mark -

//#pragma mark - rest delegate
//
//- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
//       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata;
//
//- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath;
//
//- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error;
//
//#pragma mark -
//
//- (void)loadRevisionsForFile:(NSString *)path;
//
//#pragma mark - rest delegate
//- (void)restClient:(DBRestClient*)client loadedRevisions:(NSArray *)revisions forFile:(NSString *)path;
//
//- (void)restClient:(DBRestClient*)client loadRevisionsFailedWithError:(NSError *)error;

@end
