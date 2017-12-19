//
//  WTDropboxManager.m
//  MTankSoundSamplerSS
//
//  Created by Wat Wongtanuwat on 1/12/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import "WTDropboxManager.h"

#import "WTMacro.h"
#import "WTStoreKit.h"

#define WTDropboxManager_TEST_METHOD 0

#if WTDropboxManager_TEST_METHOD
//#define APP_KEY @"gchrvot3quxsaxn"
//#define APP_SECRET @"z8rohagbdf4fbi6"
#endif

#if WTDropboxManager_VERSION >= 0x00020000

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
//        _metadataDictionary = [NSMutableDictionary dictionary];
//        _exploreQueue = [NSMutableArray array];
        
        _downloadArray = [NSMutableArray array];
        _downloadedArray = [NSMutableArray array];
        _downloadSuccessArray = [NSMutableArray array];
        _downloadFailArray = [NSMutableArray array];
    }
    return self;
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
        [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                       controller:vct
                                          openURL:^(NSURL *url) {
                                              [[UIApplication sharedApplication] openURL:url];
                                          }];
//        // Reference after programmatic auth flow
//        DBUserClient *client = [DBClientsManager authorizedClient];
//        or
//        // Initialize with manually retrieved auth token
//        DBUserClient *client = [[DBUserClient alloc] initWithAccessToken:@"<MY_ACCESS_TOKEN>"];
    }
}

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
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            WatLog(@"Success! User is logged into Dropbox.");
            [self loginSuccess];
        } else if ([authResult isCancel]) {
            WatLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            WatLog(@"Error: %@", authResult);
        }
        return YES;
    }
    
    return NO;
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
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            WatLog(@"Success! User is logged into Dropbox.");
        } else if ([authResult isCancel]) {
            WatLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            WatLog(@"Error: %@", authResult);
        }
    }
    return NO;
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
    [[[self client].usersRoutes getSpaceUsage] setResponseBlock:^(DBUSERSSpaceUsage *result, DBNilObject *routeError, DBRequestError * networkError) {
        if (_accountInfoCompleteBlock) {
            _accountInfoCompleteBlock(result);
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
                 if (_loadListCompleteBlock) {
                     _loadListCompleteBlock(entries);
                 }
             }
         } else {
             WatLog(@"%@\n%@\n", routeError, networkError);
             if (_loadListCompleteBlock) {
                 _loadListCompleteBlock(@[]);
             }
         }
     }];
}



- (void)listFolderContinueWithClient:(DBUserClient *)client cursor:(NSString *)cursor {
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
                 if (_loadListCompleteBlock) {
                     _loadListCompleteBlock(entries);
                 }
             }
         } else {
             WatLog(@"%@\n%@\n", routeError, networkError);
             if (_loadListCompleteBlock) {
                 _loadListCompleteBlock(@[]);
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
    NSURL *destinationUrl = [NSURL fileURLWithPath:[_downloadFolderPath stringByAppendingPathComponent:dropboxPath.pathDisplay]];
    
    _downloadTask = [[[[self client].filesRoutes downloadUrl:dropboxPath.pathDisplay
                                                   overwrite:YES
                                                 destination:destinationUrl]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *networkError, NSURL *destination) {
          if (result) {
              WatLog(@"%@\n", result);
              
              [_downloadedArray addObject:result];
              [_downloadSuccessArray addObject:result];
              _finishDownloadByte += [result.size floatValue];
              
              
              if ([_downloadArray count] != [_downloadedArray count]) {
                  _downloadArrayIndex += 1;
                  [self downloadFileFromPath:_downloadArray[_downloadArrayIndex]];
              } else {
                  if (_downloadCompleteBlock) {
                      _downloadCompleteBlock(result?YES:NO, _downloadSuccessArray, _downloadFailArray);
                  }
              }
              
          } else {
              WatLog(@"%@\n%@\n", routeError, networkError);
              if (_downloadCompleteBlock) {
                  _downloadCompleteBlock(result?YES:NO, _downloadSuccessArray, _downloadFailArray);
              }
//              [_downloadedArray addObject:result];
//              [_downloadFailArray addObject:result];
          }
          
      }] setProgressBlock:^(int64_t bytesDownloaded, int64_t totalBytesDownloaded, int64_t totalBytesExpectedToDownload) {
          WatLog(@"%lld %lld %lld", bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
          
          if (_downloadProgressBlock) {
              _downloadProgressBlock(bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
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
    
    // For overriding on upload
    DBFILESWriteMode *mode = [[DBFILESWriteMode alloc] initWithOverwrite];
//    
//    _uploadTask = [[[[self client].filesRoutes uploadData:dropboxPath
//                                                     mode:mode
//                                               autorename:@(YES)
//                                           clientModified:nil
//                                                     mute:@(NO)
//                                                inputData:fileData]
    
    _uploadTask = [[[[self client].filesRoutes uploadUrl:dropboxPath
                                                     mode:mode
                                               autorename:@(NO)
                                           clientModified:[NSDate date]
                                                     mute:@(NO)
                                          propertyGroups:nil
                                                inputUrl:localPath]
                    setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *networkError) {
                        if (result) {
                            WatLog(@"%@\n", result);
                        } else {
                            WatLog(@"%@\n%@\n", routeError, networkError);
                        }
                        if (_uploadCompleteBlock) {
                            _uploadCompleteBlock(result?YES:NO, routeError, networkError);
                        }
                    }] setProgressBlock:^(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded) {
                        WatLog(@"\n%lld\n%lld\n%lld\n", bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded);
                        
                        if (_uploadProgressBlock) {
                            _uploadProgressBlock(bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded);
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

#elif WTDropboxManager_VERSION >= 0x00010000

//dropbox core api version 1.3.13
//dropbox sync api version 3.1.2

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
        _metadataDictionary = [NSMutableDictionary dictionary];
        _exploreQueue = [NSMutableArray array];
    }
    return self;
}

- (void)addRevForFile:(DBMetadata*)metadata
{
    if(!_metadataDictionary){
        _metadataDictionary = [NSMutableDictionary dictionary];
    }
    _metadataDictionary[metadata.path] = metadata;
}

- (DBMetadata*)metadataForPath:(NSString*)path
{
    DBMetadata* metadata = _metadataDictionary[path];
    if(metadata){
        return metadata;
    }else{
        return nil;
    }
}

- (NSString*)revForFilePath:(NSString*)filePath
{
    DBMetadata* metadata = _metadataDictionary[filePath];
    if(metadata.rev){
        return metadata.rev;
    }else{
        return metadata.rev;
    }
}

- (NSString*)hashForFolderPath:(NSString*)folderPath
{
    DBMetadata* metadata = _metadataDictionary[folderPath];
    if(metadata.isDirectory){
        return metadata.hash;
    }else{
        return nil;
    }
}

#pragma mark - core api

#if WTDropboxManager_TEST_METHOD
- (void)beginSession
{
    NSString* appKey = APP_KEY;
    NSString* appSecret = APP_SECRET;
    NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
    
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey
                                                   appSecret:appSecret
                                                        root:root]; // either kDBRootAppFolder or kDBRootDropbox
    dbSession.delegate = self;
    [DBSession setSharedSession:dbSession];
}
#endif

- (void)beginSessionForRootAppFolderWithAppKey:(NSString*)key appSecrect:(NSString*)secret withCompletion:(void (^)(BOOL linkSuccess,DBSession *session, NSString *userId))completion
{
    self.beginSessionCompletion = completion;
    
    NSString* appKey = key;
    NSString* appSecret = secret;
    NSString *root = kDBRootAppFolder;
    
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey
                                                   appSecret:appSecret
                                                        root:root]; // either kDBRootAppFolder or kDBRootDropbox
    dbSession.delegate = self;
    [DBSession setSharedSession:dbSession];
    
    self.dbSession = dbSession;
}

- (void)beginSessionForRootDropboxWithAppKey:(NSString*)key appSecrect:(NSString*)secret withCompletion:(void (^)(BOOL linkSuccess,DBSession *session, NSString *userId))completion
{
    self.beginSessionCompletion = completion;
    
    NSString* appKey = key;
    NSString* appSecret = secret;
    NSString *root = kDBRootDropbox;
    
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey
                                                   appSecret:appSecret
                                                        root:root]; // either kDBRootAppFolder or kDBRootDropbox
    dbSession.delegate = self;
    [DBSession setSharedSession:dbSession];
    
    self.dbSession = dbSession;
}

- (void)linkFromViewController:(UIViewController*)vct {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:vct];
    }
}

- (void)unlink {
    if ([[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] unlinkAll];
    }
}

- (void)openDropBoxOnAppStore{
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/dropbox"]];
    
    [[WTStoreKit sharedManager] storeProductVCTWithITunesItemIdentifier:@"327630330" completionBlock:^(SKStoreProductViewController *storeProductVCT, BOOL result, NSError *error) {
        
    } withFallBackURL:@"itms://itunes.com/apps/dropbox"];
    
//    SKStoreProductViewController *storeViewController =
//    [[SKStoreProductViewController alloc] init];
//    
//    storeViewController.delegate = self;
//    
//    NSDictionary *parameters =
//    @{SKStoreProductParameterITunesItemIdentifier:
//          [NSNumber numberWithInteger:327630330]};
//    
//    [storeViewController loadProductWithParameters:parameters
//                                   completionBlock:^(BOOL result, NSError *error) {
//                                       if (result){
//                                           if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
//                                               [self presentViewController:storeViewController
//                                                                  animated:YES
//                                                                completion:nil];
//                                           }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
//                                               [self presentViewController:storeViewController
//                                                                  animated:YES
//                                                                completion:nil];
//                                           }else{
//                                               [self presentModalViewController:storeViewController animated:YES];
//                                           }
//                                       }
//                                   }];
    
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
    return [[DBSession sharedSession] isLinked];
}

#pragma mark - session delegate

- (BOOL)handleOpenURL:(NSURL *)url
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            WatLog(@"App linked successfully!");
            // At this point you can start making API calls
            [self loginSuccess];
        }
        return YES;
    }else{
        return NO;
    }
}
- (void)loginSuccess
{
    if(self.beginSessionCompletion){
        self.beginSessionCompletion([[DBSession sharedSession] isLinked],[DBSession sharedSession],nil);
    }
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
//    if([self.managerDelegate respondsToSelector:@selector(sessionDidReceiveAuthorizationFailure:userId:)]){
//        [self.managerDelegate sessionDidReceiveAuthorizationFailure:session userId:userId];
//    }
    
    if(_beginSessionCompletion){
        _beginSessionCompletion(NO,session,userId);
    }
}

#pragma mark -
- (DBRestClient*)restClient
{
    [self rest];
    return _restClient;
}

- (void)rest
{
    if(!_restClient){
    _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    _restClient.delegate = self;
    }
}

#pragma mark -

-(void)accountInfo{
    [self.restClient loadAccountInfo];
}

#pragma mark - rest delegate

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info
{
    
}

- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    
}

#pragma mark -

#if WTDropboxManager_TEST_METHOD
- (void)upload
{
    // Write a file to the local documents directory
    NSString *text = @"Hello world.";
    NSString *filename = @"working-draft.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
}
#endif

- (void)uploadFileFromPath:(NSString*)fromPath
{
    NSString *filename = [fromPath lastPathComponent];
    NSString *srcPath = fromPath;
    NSString *destPath = @"/";
    NSString *rev = [self revForFilePath:fromPath];
    [self.restClient uploadFile:filename toPath:destPath withParentRev:rev fromPath:srcPath];
}

- (void)uploadFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath
{
    NSString *filename = [fromPath lastPathComponent];
    NSString *srcPath = fromPath;
    NSString *destPath = [toPath stringByDeletingLastPathComponent];
    NSString *rev = [self revForFilePath:toPath];
    [self.restClient uploadFile:filename toPath:destPath withParentRev:rev fromPath:srcPath];
}

- (void)uploadNewFileFromPath:(NSString*)fromPath
{
    NSString *filename = [fromPath lastPathComponent];
    NSString *srcPath = fromPath;
    NSString *destPath = @"/";
    [self.restClient uploadFile:filename toPath:destPath withParentRev:nil fromPath:srcPath];
}

- (void)uploadNewFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath
{
    NSString *filename = [fromPath lastPathComponent];
    NSString *srcPath = fromPath;
    NSString *destPath = toPath;
    [self.restClient uploadFile:filename toPath:destPath withParentRev:nil fromPath:srcPath];
}

- (void)uploadCancel:(NSString*)path
{
    [self.restClient cancelFileUpload:path];
}

- (void)uploadCancel
{
    [self.restClient cancelAllRequests];
}

#pragma mark - rest delegate

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    WatLog(@"File uploaded successfully to path: %@", metadata.path);
    
    [self addRevForFile:metadata];
    
    if(self.uploadProgressBlock){
        self.uploadProgressBlock(YES,destPath,1.0,nil);
    }else{
//        if([self.managerDelegate respondsToSelector:@selector(restClient:loadedFile:contentType:metadata:)]){
//            [self.managerDelegate restClient:client loadedFile:localPath contentType:contentType metadata:metadata];
//        }
    }
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress
           forFile:(NSString*)destPath from:(NSString*)srcPath
{
    if(self.uploadProgressBlock){
        self.uploadProgressBlock(NO,destPath,progress,nil);
    }else{
//        if([self.managerDelegate respondsToSelector:@selector(restClient:loadProgress:forFile:)]){
//            [self.managerDelegate restClient:client loadProgress:(CGFloat)progress forFile:(NSString*)destPath];
//        }
    }
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    WatLog(@"File upload failed with error: %@", error);
    if(self.uploadProgressBlock){
        self.uploadProgressBlock(YES,@"",0.0,error);
    }
}

#pragma mark -

- (void)sd
{
    if(!_exploreQueue){
        _exploreQueue = [NSMutableArray array];
    }else{
        [_exploreQueue removeAllObjects];
    }
    
    if(!_exploreArrayMetadata){
        _exploreArrayMetadata = [NSMutableArray array];
    }else{
        [_exploreArrayMetadata removeAllObjects];
    }
}

- (void)listFileFromRootFolder
{
    [self sd];
    DBMetadata *metadata = [self metadataForPath:@"/"];
    if(metadata){
        if([self respondsToSelector:@selector(restClient:loadedMetadata:)]){
            [self restClient:self.restClient loadedMetadata:metadata];
        }
    }else{
        NSString *hash = [self hashForFolderPath:@"/"];
        if(!hash){
            [self.restClient loadMetadata:@"/"];
        }else{
            [self.restClient loadMetadata:@"/" withHash:hash];
        }
    }
}

- (void)listFileFromFolderPath:(NSString*)path
{
    [self sd];
    DBMetadata *metadata = [self metadataForPath:path];
    if(metadata){
        if([self respondsToSelector:@selector(restClient:loadedMetadata:)]){
            [self restClient:self.restClient loadedMetadata:metadata];
        }
    }else{
        NSString *hash = [self hashForFolderPath:path];
        if(!hash){
            [self.restClient loadMetadata:path];
        }else{
            [self.restClient loadMetadata:path withHash:hash];
        }
    }
}

- (void)loadListFileFromRootFolder
{
    [self sd];
    NSString *hash = [self hashForFolderPath:@"/"];
    if(!hash){
        [self.restClient loadMetadata:@"/"];
    }else{
        [self.restClient loadMetadata:@"/" withHash:hash];
    }
}

- (void)loadListFileFromFolderPath:(NSString*)path
{
    [self sd];
    NSString *hash = [self hashForFolderPath:path];
    if(!hash){
        [self.restClient loadMetadata:path];
    }else{
        [self.restClient loadMetadata:path withHash:hash];
    }
}

#pragma mark - rest delegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
//    if (metadata.isDirectory) {
//        WatLog(@"Folder '%@' contains:", metadata.path);
//        for (DBMetadata *file in metadata.contents) {
//            WatLog(@"	%@", file.filename);
//        }
//    }
    
    
    if (metadata.isDirectory) {
        for (DBMetadata *file in metadata.contents) {
            if(_recursively){
                if (file.isDirectory) {
                    [_exploreQueue enqueue:file.path];
                    [_exploreArrayMetadata addObject:file];
                }else{
                    _metadataDictionary[file.path] = file;
                    [_exploreArrayMetadata addObject:file];
                }
            }else{
                if (file.isDirectory) {
                    
                }else{
                    _metadataDictionary[file.path] = file;
                }
            }
        }
    }
    
    if([_exploreQueue count]>0){
        NSString *next = [_exploreQueue dequeue];
        if(next){
            [self.restClient loadMetadata:next];
        }else{
            //error?
        }
    }else{
        if(_recursively){
            if([self.managerDelegate respondsToSelector:@selector(restClient:loadedMetadataArray:)]){
                [self.managerDelegate restClient:client loadedMetadataArray:_exploreArrayMetadata];
            }
        }else{
            if([self.managerDelegate respondsToSelector:@selector(restClient:loadedMetadataArray:)]){
                [self.managerDelegate restClient:client loadedMetadataArray:_exploreArrayMetadata];
            }
        }
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    WatLog(@"Error loading metadata: %@", error);
    if(_recursively){
        if([self.managerDelegate respondsToSelector:@selector(restClient:loadedMetadataArray:)]){
            [self.managerDelegate restClient:client loadedMetadataArray:nil];
        }
    }else{
        if([self.managerDelegate respondsToSelector:@selector(restClient:loadedMetadata:)]){
            [self.managerDelegate restClient:client loadedMetadata:nil];
        }
    }
}

#pragma mark -

- (void)downloadFileFromPath:(NSString*)dropboxPath
{
    NSString *srcPath = dropboxPath;
    NSString *destPath = [[WTPath documentDirectoryPath] stringByAppendingPathComponent:dropboxPath];
    [self.restClient loadFile:srcPath intoPath:destPath];
}

- (void)downloadFileFromPath:(NSString*)dropboxPath toPath:(NSString*)localPath
{
    NSString *srcPath = dropboxPath;
    NSString *destPath = localPath;
    [self.restClient loadFile:srcPath intoPath:destPath];
}

- (void)downloadFileFromPath:(NSString*)dropboxPath toFolderPath:(NSString*)localFolderPath
{
    NSString *srcPath = dropboxPath;
    NSString *destPath = [localFolderPath stringByAppendingPathComponent:dropboxPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:[destPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    [self.restClient loadFile:srcPath intoPath:destPath];
}

#pragma mark -

- (void)downloadFileFromMetadatas:(NSArray*)dropboxMetadatas toFolderPath:(NSString*)localFolderPath
{
    _downloadFolderPath = localFolderPath;
    _arrayDownloading = YES;
    _downloadArrayIndex = 0;
    _downloadArrayMetadata = [NSMutableArray arrayWithArray:dropboxMetadatas];
    _downloadSuccessArray = [NSMutableArray array];
    _downloadFailArray = [NSMutableArray array];
    
    DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
    [self downloadFileFromPath:metadata.path toFolderPath:_downloadFolderPath];
}

- (void)downloadFileFromPaths:(NSArray*)dropboxPaths toFolderPath:(NSString*)localFolderPath
{
    _downloadFolderPath = localFolderPath;
    _arrayDownloading = YES;
    _downloadArrayIndex = 0;
    _downloadArrayMetadata = [NSMutableArray array];
    for(NSString *path in dropboxPaths){
        DBMetadata *metadata = [self metadataForPath:path];
        if(metadata){
            [_downloadArrayMetadata addObject:metadata];
        }
    }
    _downloadSuccessArray = [NSMutableArray array];
    _downloadFailArray = [NSMutableArray array];
    
    DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
    [self downloadFileFromPath:metadata.path toFolderPath:_downloadFolderPath];
}

#pragma mark -

- (void)downloadCancel
{
    DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
    [self.restClient cancelFileLoad:metadata.path];
    
    [self.restClient cancelAllRequests];
    
    [_downloadArrayMetadata removeObjectsInArray:_downloadSuccessArray];
    [_downloadFailArray addObjectsFromArray:_downloadArrayMetadata];
    
    if(self.downloadCompleteBlock){
        self.downloadCompleteBlock(NO,_downloadSuccessArray,_downloadFailArray);
    }
}

#pragma mark - rest delegate

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
//    WatLog(@"File loaded into path: %@", localPath);
    if(_arrayDownloading){
        if(self.downloadProgressBlock){
            DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
            self.downloadProgressBlock(YES,metadata,1.0);
        }
        [_downloadSuccessArray addObject:_downloadArrayMetadata[_downloadArrayIndex]];
        _downloadArrayIndex++;
        if(_downloadArrayIndex<[_downloadArrayMetadata count]){
            DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
            [self downloadFileFromPath:metadata.path toFolderPath:_downloadFolderPath];
        }else{
            if(self.downloadCompleteBlock){
                self.downloadCompleteBlock(YES,_downloadSuccessArray,_downloadFailArray);
            }
        }
    }else{
        if([self.managerDelegate respondsToSelector:@selector(restClient:loadedFile:contentType:metadata:)]){
            [self.managerDelegate restClient:client loadedFile:localPath contentType:contentType metadata:metadata];
        }
    }
}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath{
    if(_arrayDownloading){
        if(self.downloadProgressBlock){
            DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
            self.downloadProgressBlock(NO,metadata,progress);
        }
    }else{
        if([self.managerDelegate respondsToSelector:@selector(restClient:loadProgress:forFile:)]){
            [self.managerDelegate restClient:client loadProgress:(CGFloat)progress forFile:(NSString*)destPath];
        }
    }
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
//    WatLog(@"There was an error loading the file: %@", error);
    
    if(_arrayDownloading){
        if(self.downloadProgressBlock){
            DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
            self.downloadProgressBlock(YES,metadata,0.0);
        }
        [_downloadFailArray addObject:_downloadArrayMetadata[_downloadArrayIndex]];
        _downloadArrayIndex++;
        if(_downloadArrayIndex<[_downloadArrayMetadata count]){
            DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
            [self downloadFileFromPath:metadata.path toFolderPath:_downloadFolderPath];
        }else{
            if(self.downloadCompleteBlock){
                self.downloadCompleteBlock(YES,_downloadSuccessArray,_downloadFailArray);
            }
        }
    }else{
        if([self.managerDelegate respondsToSelector:@selector(restClient:loadFileFailedWithError:)]){
            [self.managerDelegate restClient:client loadFileFailedWithError:error];
        }
    }
}

#pragma mark -

- (void)loadRevisionsForFile:(NSString *)path
{
    NSString *file = [NSString stringWithFormat:@"/%@",[path lastPathComponent]];
    [self.restClient loadRevisionsForFile:file];
}

#pragma mark - rest delegate
- (void)restClient:(DBRestClient*)client loadedRevisions:(NSArray *)revisions forFile:(NSString *)path
{
    [self addRevForFile:[revisions firstObject]];
    
    if(self.loadRevisionBlock){
        self.loadRevisionBlock(YES,path,revisions,nil);
    }
    self.loadRevisionBlock = nil;
    
    
}

- (void)restClient:(DBRestClient*)client loadRevisionsFailedWithError:(NSError *)error
{
    
    if(self.loadRevisionBlock){
        self.loadRevisionBlock(NO,nil,nil,error);
    }
    self.loadRevisionBlock = nil;
}


@end

#pragma mark -

//@implementation WTDropboxSyncManager
//
//+ (instancetype)sharedManager
//{
//    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
//        return [[self alloc] init];
//    });
//}
//
//- (id)init
//{
//    self = [super init];
//    if(self){
////        _metadataDictionary = [NSMutableDictionary dictionary];
//    }
//    return self;
//}
//
//
//
//- (void)beginSessionForRootAppFolderWithAppKey:(NSString*)key appSecrect:(NSString*)secret withCompletion:(void (^)(BOOL linkSuccess,DBSession *session, NSString *userId))completion
//{
////    self.beginSessionCompletion = completion;
//    
//    NSString* appKey = key;
//    NSString* appSecret = secret;
////    NSString *root = kDBRootAppFolder;
////    
////    DBSession *dbSession = [[DBSession alloc] initWithAppKey:appKey
////                                                   appSecret:appSecret
////                                                        root:root]; // either kDBRootAppFolder or kDBRootDropbox
////    dbSession.delegate = self;
////    [DBSession setSharedSession:dbSession];
////    
////    self.dbSession = dbSession;
//    
//    DBAccountManager *accountManager =
//    [[DBAccountManager alloc] initWithAppKey:appKey
//                                      secret:appSecret];
//    [DBAccountManager setSharedManager:accountManager];
//}
//
//- (void)linkFromViewController:(UIViewController*)vct {
//    if (![[DBAccountManager sharedManager] linkedAccount]) {
//        [[DBAccountManager sharedManager] linkFromController:vct];
//    }
//}
//
//- (BOOL)isLogin
//{
//    return [[DBAccountManager sharedManager] linkedAccount];
//}
//
//#pragma mark - session delegate
//
//- (BOOL)handleOpenURL:(NSURL *)url
//{
//    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
//    if (account) {
//        WatLog(@"App linked successfully!");
//        return YES;
//    }
//    return NO;
//}
//- (void)loginSuccess
//{
////    if(self.beginSessionCompletion){
////        self.beginSessionCompletion([[DBSession sharedSession] isLinked],[DBSession sharedSession],nil);
////    }
//}
//
//- (void)sd
//{
//    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
//    
//    if (account) {
//        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
//        [DBFilesystem setSharedFilesystem:filesystem];
//    }
//    DBPath *newPath = [[DBPath root] childPath:@"hello.txt"];
//    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
//    [file writeString:@"Hello World!" error:nil];
//}
//
//@end

#endif
