//
//  WTGoogleDriveManager.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/1/17.
//  Copyright © 2017 Wat Wongtanuwat. All rights reserved.
//

#import "WTGoogleDriveManager.h"

//static NSString *const kKeychainItemName = @"Drive API";
//static NSString *const kClientID = @"YOUR_CLIENT_ID_HERE";
#import "WTGoogleScope.h"
#import <WTLibrary_iOS/WTWatLog.h>

#if (WTGoogleDriveManager_VERSION >= GOOGLEOAUTH2_VERSION) && (WTGoogleDriveManager_VERSION < GOOGLEAPPAUTH_VERSION)


#elif (WTGoogleDriveManager_VERSION >= GOOGLEAPPAUTH_VERSION) && (WTGoogleDriveManager_VERSION < GOOGLEAPPAUTHSIGN6_VERSION)

#elif (WTGoogleDriveManager_VERSION >= GOOGLEAPPAUTHSIGN6_VERSION)

#endif

#if (WTGoogleDriveManager_VERSION <= GOOGLEOAUTH2_VERSION)

#import <GoogleAPIClientForREST/GTLRUtilities.h>
#import <GTMSessionFetcher/GTMSessionFetcherService.h>
#import "GTMAppAuth.h"

#elif (WTGoogleDriveManager_VERSION >= GOOGLEAPPAUTH_VERSION)

#import <AppAuth/AppAuth.h>
#import <GTMAppAuth/GTMAppAuth.h>
#import <GTMSessionFetcher/GTMSessionFetcherService.h>
#import <GTMSessionFetcher/GTMSessionFetcherLogging.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>


@interface WTGoogleDriveManager()
//@property (nonatomic,strong) WTGoogleFetcherAuth *auth;
@property (nonatomic,strong) NSArray *scope;
@property (nonatomic,strong) NSArray *grantedScope;
@end
#endif

@implementation WTGoogleDriveManager

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

//@synthesize service = _service;
//@synthesize output = _output;
#pragma mark - AUTH
#if (WTGoogleDriveManager_VERSION <= GOOGLEOAUTH2_VERSION)
#pragma mark OAUTH2

- (void)authWithClientID:(NSString*)clientID keychainForName:(NSString*)keychainItemName withCompletion:(void (^)(BOOL linkSuccess))completion
{
    self.beginSessionCompletion = completion;
    
    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.service = [[GTLRDriveService alloc] init];
    
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:keychainItemName
                                                          clientID:clientID
                                                      clientSecret:nil];
    
    self.clientID = clientID;
    self.keychainItemName = keychainItemName;

    
    [GIDSignIn sharedInstance].clientID = clientID;
    [GIDSignIn sharedInstance].scopes = @[
    @"https://www.googleapis.com/auth/drive",//    View and manage the files in your Google Drive
    //@"https://www.googleapis.com/auth/drive.readonly",//    View the files in your Google Drive
    @"https://www.googleapis.com/auth/drive.appdata",//    View and manage its own configuration data in your Google Drive
    @"https://www.googleapis.com/auth/drive.file",// View and manage Google Drive files and folders that you have opened or created with this app
    //@"https://www.googleapis.com/auth/drive.metadata",//    View and manage metadata of files in your Google Drive
    @"https://www.googleapis.com/auth/drive.metadata.readonly",//    View metadata for files in your Google Drive
    //@"https://www.googleapis.com/auth/drive.photos.readonly",//    View the photos, videos and albums in your Google Photos
    //@"https://www.googleapis.com/auth/drive.scripts",// Modify your Google Apps Script scripts' behavior
                                          ];
    
    [GIDSignIn sharedInstance].delegate = self;
}

#elif (WTGoogleDriveManager_VERSION <= GOOGLEOAPPAUTH_VERSION)
#pragma mark APPAUTH + SIGNIN5

- (void)authWithClientID:(NSString*)clientID keychainForName:(NSString*)keychainItemName withCompletion:(void (^)(BOOL linkSuccess))completion
{
    self.beginSessionCompletion = completion;
    
    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.service = [[GTLRDriveService alloc] init];
        
#pragma mark todo: fix
    WTGoogleFetcherAuth *auth = [WTGoogleFetcherAuth withClientID:clientID redirect:@"com.googleusercontent.apps.1033902726278-oasu73dou0am6obvu0erthsnn0nda1i4:/oauthredirect"];
//    WTGoogleFetcherAuth *auth = [WTGoogleFetcherAuth withClientID:clientID redirect:@"com.googleusercontent.apps.62617891720-s9kjgvv0ll2f3eheknbq5cq9pga0887v:/oauthredirect"];
    
    self.auth = auth;
//    [auth authWithAutoCodeExchange:clientID];
    
    self.clientID = clientID;
    self.keychainItemName = keychainItemName;

    
    GIDSignIn.sharedInstance.clientID = clientID;
    [GIDSignIn sharedInstance].scopes = @[
        kGTLRAuthScopeDrive,//Authorization scope: See, edit, create, and delete all of your Google Drive files
        kGTLRAuthScopeDriveAppdata,// Authorization scope: See, create, and delete its own configuration data in your Google Drive
        kGTLRAuthScopeDriveFile,//Authorization scope: View and manage Google Drive files and folders that you have opened or created with this app
//        kGTLRAuthScopeDriveMetadata,//Authorization scope: View and manage metadata of files in your Google Drive
        kGTLRAuthScopeDriveMetadataReadonly,//Authorization scope: See information about your Google Drive files
//        kGTLRAuthScopeDrivePhotosReadonly,//Authorization scope: View the photos, videos and albums in your Google Photos
//        kGTLRAuthScopeDriveReadonly,//Authorization scope: See and download all your Google Drive files
//        kGTLRAuthScopeDriveScripts,//Authorization scope: Modify your Google Apps Script scripts' behavior
    ];
    [GIDSignIn sharedInstance].delegate = self;
}


#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTHSIGN6_VERSION)
#pragma mark APPAUTH + SIGNIN6

- (void)authWithClientID:(NSString*)clientID keychainForName:(NSString*)keychainItemName withCompletion:(void (^)(BOOL linkSuccess))completion
{
    self.beginSessionCompletion = completion;
    
    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.service = [[GTLRDriveService alloc] init];
        
    OIDServiceConfiguration *configuration =
        [GTMAppAuthFetcherAuthorization configurationForGoogle];
#pragma mark todo: fix
//    WTGoogleFetcherAuth *auth = [WTGoogleFetcherAuth withClientID:clientID redirect:@"com.googleusercontent.apps.1033902726278-oasu73dou0am6obvu0erthsnn0nda1i4:/oauthredirect"];
////    WTGoogleFetcherAuth *auth = [WTGoogleFetcherAuth withClientID:clientID redirect:@"com.googleusercontent.apps.62617891720-s9kjgvv0ll2f3eheknbq5cq9pga0887v:/oauthredirect"];
//
//    self.auth = auth;
//    [auth authWithAutoCodeExchange:clientID];
    
    self.clientID = clientID;
    self.keychainItemName = keychainItemName;

//    [GIDSignIn.sharedInstance addScopes:@[] presentingViewController:nil callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
//
//    }]
//    GIDSignIn.sharedInstance.clientID = clientID;
        self.scope = @[
 ////       kGTLRAuthScopeDrive,//Authorization scope: See, edit, create, and delete all of your Google Drive files
 ////       kGTLRAuthScopeDriveAppdata,//nonsensitive// Authorization scope: See, create, and delete its own configuration data in your Google Drive
        kGTLRAuthScopeDriveFile,//nonsensitive//Authorization scope: View and manage Google Drive files and folders that you have opened or created with this app
//        kGTLRAuthScopeDriveMetadata,//Authorization scope: View and manage metadata of files in your Google Drive
////        kGTLRAuthScopeDriveMetadataReadonly,//Authorization scope: See information about your Google Drive files
//        kGTLRAuthScopeDrivePhotosReadonly,//Authorization scope: View the photos, videos and albums in your Google Photos
//        kGTLRAuthScopeDriveReadonly,//Authorization scope: See and download all your Google Drive files
//        kGTLRAuthScopeDriveScripts,//Authorization scope: Modify your Google Apps Script scripts' behavior
    ];
    
}

#endif

#pragma mark - GIDSignIn

#if (WTGoogleDriveManager_VERSION <= GOOGLEOAUTH2_VERSION)
#pragma mark OAUTH
-(BOOL)signInSilently
{
    return NO;
}

- (BOOL)signIn
{
    return NO;
}

- (BOOL)signIn:(UIViewController*)vct
{
    return NO;
}

#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTH_VERSION)
#pragma mark APPAUTH + SIGNIN5
-(BOOL)signInSilently
{
    if ([[GIDSignIn sharedInstance] hasPreviousSignIn]) {
        [[GIDSignIn sharedInstance] restorePreviousSignIn];
        return YES;
    }
    return NO;
}

- (BOOL)signIn
{
//    [[GIDSignIn sharedInstance] setPresentingViewController:self];
    [[GIDSignIn sharedInstance] signIn];
    return [[GIDSignIn sharedInstance] hasPreviousSignIn];
}

- (BOOL)signIn:(UIViewController*)vct
{
    UIViewController * a =[GIDSignIn sharedInstance].presentingViewController;
    [self linkFromViewController:a];
    return [[GIDSignIn sharedInstance] hasPreviousSignIn];
}

#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTHSIGN6_VERSION)
#pragma mark APPAUTH + SIGNIN6
-(BOOL)signInSilently
{
    if ([[GIDSignIn sharedInstance] hasPreviousSignIn]) {
        [[GIDSignIn sharedInstance] restorePreviousSignInWithCallback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
            self.grantedScope = user.grantedScopes;
            [self signIn:nil didSignInForUser:user withError:error];
        }];
        return YES;
    }
    return NO;
}

- (BOOL)signIn
{
    GIDConfiguration *signInConfig = [[GIDConfiguration alloc] initWithClientID:self.clientID];
    [[GIDSignIn sharedInstance] signInWithConfiguration:signInConfig 
                               presentingViewController:self.vct
                                               callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
        self.grantedScope = user.grantedScopes;
//        if ([self checkScope:self.scope]) {
            [self signIn:nil didSignInForUser:user withError:error];
//        } else {
//            [GIDSignIn.sharedInstance addScopes:self.scope presentingViewController:self.vct callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
//                self.grantedScope = user.grantedScopes;
//                [self signIn:nil didSignInForUser:user withError:error];
//            }];
//        }
    }];
    return [[GIDSignIn sharedInstance] hasPreviousSignIn];
}

- (BOOL)signIn:(UIViewController*)vct
{
//    UIViewController * a =[GIDSignIn sharedInstance].presentingViewController;
//    [self linkFromViewController:a];
//    return [[GIDSignIn sharedInstance] hasPreviousSignIn];
    self.vct = vct;
    GIDConfiguration *signInConfig = [[GIDConfiguration alloc] initWithClientID:self.clientID];
    [GIDSignIn.sharedInstance signInWithConfiguration:signInConfig
                             presentingViewController:self.vct
                                             callback:^(GIDGoogleUser * _Nullable user,
                                                        NSError * _Nullable error) {
      if (error) {
        return;
      }
        self.grantedScope = user.grantedScopes;

      // If sign in succeeded, display the app's main content View.
        [GIDSignIn.sharedInstance addScopes:self.scope presentingViewController:self.vct callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
            [self signIn:nil didSignInForUser:user withError:error];
        }];
//        [self signIn:nil didSignInForUser:user withError:error];
    }];
    return [[GIDSignIn sharedInstance] hasPreviousSignIn];
}


- (BOOL)checkScope:(NSArray* _Nonnull)scopes
{
    NSSet<NSString *> *grantedScopes =
        [NSSet setWithArray:self.grantedScope];
    NSSet<NSString *> *requestedScopes =
        [NSSet setWithArray:scopes];
    if ([requestedScopes isSubsetOfSet:grantedScopes]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)addScope:(NSArray *)scopes withCompletion:(void (^)(BOOL))completion
{
    if ([self checkScope:scopes]) {
        completion(YES);
    } else {
        [GIDSignIn.sharedInstance addScopes:scopes presentingViewController:self.vct callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                completion(NO);
                return;
            }
            [WTGoogleDriveManager sharedManager].service.authorizer = [user.authentication fetcherAuthorizer];
            self.grantedScope = user.grantedScopes;
            if ([self checkScope:scopes]) {
                completion(YES);
            } else {
                completion(NO);
            }
        }];
    }
    return [[GIDSignIn sharedInstance] hasPreviousSignIn];
}

#endif

#pragma mark - openurl

#if (WTGoogleDriveManager_VERSION <= GOOGLEOAUTH2_VERSION)
#pragma mark OAUTH

- (BOOL)handleOpenURL:(NSURL *)url
{
    return NO;
}

#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTH_VERSION)
#pragma mark APPAUTH + SIGNIN5

- (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL open = [self.auth application:nil openURL:url options:nil];
    return open;
}

#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTHSIGN6_VERSION)
#pragma mark APPAUTH + SIGNIN6

- (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL handled = [GIDSignIn.sharedInstance handleURL:url];
    return handled;
}

- (UIButton*)googleButton
{
    GIDSignInButton *button = [[GIDSignInButton alloc] init];
    button.style = kGIDSignInButtonStyleStandard;
    button.colorScheme = kGIDSignInButtonColorSchemeLight;
    return (UIButton*)button;
}

#endif

#pragma mark - link
#if (WTGoogleDriveManager_VERSION <= GOOGLEOAUTH2_VERSION)

#pragma mark OAUTH
- (void)linkFromViewController:(UIViewController*)vct
{
    
    if (!self.service.authorizer.canAuthorize) {
        UIViewController *auth = [self createAuthController];
        [vct presentViewController:auth animated:YES completion:nil];
    }
}

- (void)unlink
{
    if (self.service.authorizer.canAuthorize) {
        [[GIDSignIn sharedInstance] signOut];
        self.service = nil;
    }
}

- (BOOL)isLogin
{
    return self.service.authorizer.canAuthorize;
}
#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTH_VERSION)
#pragma mark APPAUTH + SIGNIN5
- (void)linkFromViewController:(UIViewController*)vct
{
    id<GTMFetcherAuthorizationProtocol> a = self.service.authorizer;
    if (!a.canAuthorize) {
#pragma mark todo: fix
//        UIViewController *auth = [self createAuthController];
//        [vct presentViewController:auth animated:YES completion:nil];
        [self.auth authWithAutoCodeExchange:vct];
    }
}

- (void)unlink
{
    if (self.service.authorizer.canAuthorize) {
        [[GIDSignIn sharedInstance] signOut];
        self.service = nil;
    }
}

- (BOOL)isLogin
{
    return self.service.authorizer.canAuthorize;
}
#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTHSIGN6_VERSION)
#pragma mark APPAUTH + SIGNIN6
- (void)linkFromViewController:(UIViewController*)vct
{
    
}

- (void)unlink
{
    if (self.service.authorizer.canAuthorize) {
        [[GIDSignIn sharedInstance] signOut];
        self.service = nil;
    }
}

- (BOOL)isLogin
{
    return self.service.authorizer.canAuthorize;
}

#endif

#pragma mark - drive

-(void)listFolderCompletion:(void (^)(GTLRServiceTicket *ticket,
                           GTLRDrive_FileList *files,
                           NSError *error))completion
{
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.q = @"mimeType='application/vnd.google-apps.folder'";
    query.spaces = @"drive";
    query.fields = @"nextPageToken, files(id, name)";
    [self.service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket,
                                                         GTLRDrive_FileList *files,
                                                         NSError *error) {
        if (error == nil) {
            for(GTLRDrive_File *file in files) {
                NSLog(@"Found file: %@ (%@)", file.name, file.identifier);
            }
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
}

- (void)searchFolder:(NSString*)folderName completion:(void (^)(GTLRServiceTicket *ticket,
                                                                GTLRDrive_FileList *files,
                                                                NSError *error))completion
{
//    GTLRDrive_File *metadata = [GTLRDrive_File object];
//    metadata.name = @"Klang2";
//    metadata.mimeType = @"application/vnd.google-apps.folder";
//    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
//                                                                   uploadParameters:nil];
//    query.fields = @"id";
//    [self.service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket,
//                                                         GTLRDrive_File *file,
//                                                         NSError *error) {
//        if (error == nil) {
//            NSLog(@"File ID %@", file.identifier);
//        } else {
//            NSLog(@"An error occurred: %@", error);
//        }
//    }];
    
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.q = [NSString stringWithFormat:@"name='%@' and mimeType='application/vnd.google-apps.folder'", folderName];
    query.spaces = @"drive";
    query.fields = @"nextPageToken, files(id, name, trashed)";
    [self.service executeQuery:query completionHandler:completion];
}

- (void)moveFolderOutOfTrashed:(GTLRDrive_File *)metadataFile completion:(void (^)(GTLRServiceTicket *ticket,
                                                 GTLRDrive_File *file,
                                                 NSError *error))completion
{
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.trashed = [NSNumber numberWithBool:NO];
    GTLRDriveQuery_FilesUpdate *query = [GTLRDriveQuery_FilesUpdate queryWithObject:metadata fileId:metadataFile.identifier uploadParameters:nil];
    query.fields = @"id, parents";
    [self.service executeQuery:query completionHandler:completion];
}

- (void)createFolder:(NSString*)folderName completion:(void (^)(GTLRServiceTicket *ticket,
                        GTLRDrive_File *file,
                        NSError *error))completion
{
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = [NSString stringWithFormat:@"%@", folderName];
    metadata.mimeType = @"application/vnd.google-apps.folder";
    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
                                                                   uploadParameters:nil];
    query.fields = @"id";
    [self.service executeQuery:query completionHandler:completion];
}

- (void)listFileFromFolder:(NSString*)folderIdentifier completion:(void (^)(GTLRServiceTicket *ticket,
                                        GTLRDrive_FileList *files,
                                        NSError *error))completion
{
    
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.q = [NSString stringWithFormat:@"'%@' in parents", folderIdentifier];
    query.spaces = @"drive";
    query.fields = @"nextPageToken, files(id, name, originalFilename, mimeType, size, parents)";
    query.orderBy = @"";
    [self.service executeQuery:query completionHandler:completion];
}

- (void)downloadFileFromMetadatas:(NSArray *)metadatas toFolderPath:(NSString *)localFolderPath
{
    _downloadFolderPath = localFolderPath;
    _arrayDownloading = YES;
    _downloadArrayIndex = 0;
    _downloadArrayMetadata = [NSMutableArray arrayWithArray:metadatas];
    _downloadSuccessArray = [NSMutableArray array];
    _downloadFailArray = [NSMutableArray array];
    
    GTLRDrive_File *metadata = _downloadArrayMetadata[_downloadArrayIndex];
    [self downloadFileFromPath:metadata toFolderPath:_downloadFolderPath];
}

- (void)downloadFileFromPath:(GTLRDrive_File*)googleFile toFolderPath:(NSString*)localFolderPath
{
    NSString *destPath = [localFolderPath stringByAppendingPathComponent:googleFile.name];
//    [[NSFileManager defaultManager] createDirectoryAtPath:[destPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
//    [self.restClient loadFile:srcPath intoPath:destPath];
    
    __weak typeof(self) weak_self = self;
    
    GTLRQuery *query = [GTLRDriveQuery_FilesGet queryForMediaWithFileId:googleFile.identifier];
    
    GTLRServiceTicket *ticket = [self.service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket,
                                                         GTLRDataObject *file,
                                                         NSError *error) {
        if (error == nil) {
            WatLog(@"Downloaded %lu bytes", file.data.length);
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:destPath error:nil];
            }
            
            [[NSFileManager defaultManager] createFileAtPath:destPath contents:file.data attributes:nil];
            
            
            if(self.downloadProgressBlock){
                GTLRDrive_File *metadata = weak_self.downloadArrayMetadata[weak_self.downloadArrayIndex];
                self.downloadProgressBlock(YES,metadata,[metadata.size floatValue]);
            }
            [weak_self.downloadSuccessArray addObject:weak_self.downloadArrayMetadata[weak_self.downloadArrayIndex]];
            weak_self.downloadArrayIndex++;
            if(weak_self.downloadArrayIndex<[weak_self.downloadArrayMetadata count]){
                GTLRDrive_File *metadata = weak_self.downloadArrayMetadata[weak_self.downloadArrayIndex];
                [self downloadFileFromPath:metadata toFolderPath:weak_self.downloadFolderPath];
            }else{
                if(self.downloadCompleteBlock){
                    self.downloadCompleteBlock(YES,weak_self.downloadSuccessArray,weak_self.downloadFailArray);
                }
            }
            
            
        } else {
            WatLog(@"An error occurred: %@", error);
            
            [weak_self.downloadFailArray addObject:weak_self.downloadArrayMetadata[weak_self.downloadArrayIndex]];
            weak_self.downloadArrayIndex++;
            if(weak_self.downloadArrayIndex<[weak_self.downloadArrayMetadata count]){
                GTLRDrive_File *metadata = weak_self.downloadArrayMetadata[weak_self.downloadArrayIndex];
                [self downloadFileFromPath:metadata toFolderPath:weak_self.downloadFolderPath];
            }else{
                if(self.downloadCompleteBlock){
                    self.downloadCompleteBlock(YES,weak_self.downloadSuccessArray,weak_self.downloadFailArray);
                }
            }
        }
        
    }];
    
    ticket.objectFetcher.receivedProgressBlock = ^ (int64_t bytesWritten,
                                                    int64_t totalBytesWritten){
        if (self.downloadProgressBlock) {
            self.downloadProgressBlock(NO, nil, totalBytesWritten);
        }
    };
}

- (void)downloadCancel
{
//    DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
//    [self.restClient cancelFileLoad:metadata.path];
//    
//    [self.restClient cancelAllRequests];
    
    [self.service.fetcherService stopAllFetchers];
    
    
    [_downloadArrayMetadata removeObjectsInArray:_downloadSuccessArray];
    [_downloadFailArray addObjectsFromArray:_downloadArrayMetadata];
    
    if(self.downloadCompleteBlock){
        self.downloadCompleteBlock(NO,_downloadSuccessArray,_downloadFailArray);
    }
}

- (void)searchFile:(NSString*)fileName completion:(void (^)(GTLRServiceTicket *ticket,
                                                                GTLRDrive_FileList *files,
                                                                NSError *error))completion
{
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.q = [NSString stringWithFormat:@"name='%@'", [fileName lastPathComponent]];
    query.spaces = @"drive";
    query.fields = @"nextPageToken, files(id, name, trashed, headRevisionId)";
    [self.service executeQuery:query completionHandler:completion];
}

- (void)uploadFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath revision:(NSString*)rev
{
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:fromPath];
    NSString *folderId = toPath;
    
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = [fromPath lastPathComponent];
    metadata.parents = [NSArray arrayWithObject:folderId];
    NSString * mimeType = [NSString stringWithFormat:@"audio/%@",[fromPath pathExtension]];
    
    GTLRUploadParameters *uploadParameters = [GTLRUploadParameters uploadParametersWithData:fileData
                                                                                   MIMEType:mimeType];
    uploadParameters.shouldUploadWithSingleRequest = NO;
    
    if (!rev) {
        GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
                                                                          uploadParameters:uploadParameters];
        query.fields = @"id";
        query.executionParameters.uploadProgressBlock =
        ^(GTLRServiceTicket *ticket,
          unsigned long long numberOfBytesRead,
          unsigned long long dataLength) {
            if (self.uploadProgressBlock) {
                self.uploadProgressBlock(toPath, numberOfBytesRead*1.0/dataLength, nil);
            }
      };
        GTLRServiceTicket *ticket = [self.service executeQuery:query completionHandler:^(GTLRServiceTicket * ticket, GTLRDrive_File *file, NSError * error) {
            
            if (error == nil) {
                if (self.uploadCompleteBlock) {
                    self.uploadCompleteBlock(toPath, YES, error);
                }
            } else {
                if (self.uploadCompleteBlock) {
                    self.uploadCompleteBlock(toPath, NO, error);
                }
            }
        }];
        
        ticket.objectFetcher.sendProgressBlock = ^ (int64_t bytesSent,
                                                    int64_t totalBytesSent,
                                                    int64_t totalBytesExpectedToSend){
            if (self.uploadProgressBlock) {
                self.uploadProgressBlock(toPath, totalBytesSent*1.0/totalBytesExpectedToSend, nil);
            }
        };
    } else {
        GTLRDriveQuery_FilesDelete *queryz = [GTLRDriveQuery_FilesDelete queryWithFileId:rev];
        /*GTLRServiceTicket *ticketz =*/ [self.service executeQuery:queryz
                                              completionHandler:^(GTLRServiceTicket * ticket, GTLRDrive_File *file, NSError * error) {
            if (error == nil) {
                
                GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
                                                                               uploadParameters:uploadParameters];
                query.fields = @"id";
                query.executionParameters.uploadProgressBlock =
                ^(GTLRServiceTicket *ticket,
                  unsigned long long numberOfBytesRead,
                  unsigned long long dataLength) {
                    if (self.uploadProgressBlock) {
                        self.uploadProgressBlock(toPath, numberOfBytesRead*1.0/dataLength, nil);
                    }
              };
                GTLRServiceTicket *ticket = [self.service executeQuery:query completionHandler:^(GTLRServiceTicket * ticket, GTLRDrive_File *file, NSError * error) {
                    
                    if (error == nil) {
                        if (self.uploadCompleteBlock) {
                            self.uploadCompleteBlock(toPath, YES, error);
                        }
                    } else {
                        if (self.uploadCompleteBlock) {
                            self.uploadCompleteBlock(toPath, NO, error);
                        }
                    }
                }];
                ticket.objectFetcher.sendProgressBlock = ^ (int64_t bytesSent,
                                                            int64_t totalBytesSent,
                                                            int64_t totalBytesExpectedToSend){
                    if (self.uploadProgressBlock) {
                        self.uploadProgressBlock(toPath, totalBytesSent*1.0/totalBytesExpectedToSend, nil);
                    }
                };
            } else {
                if (self.uploadCompleteBlock) {
                    self.uploadCompleteBlock(toPath, NO, error);
                }
            }
        }];
    }
    
    
    
    
    
}

- (void)uploadCancel
{
    //    DBMetadata *metadata = _downloadArrayMetadata[_downloadArrayIndex];
    //    [self.restClient cancelFileLoad:metadata.path];
    //
    //    [self.restClient cancelAllRequests];
    [self.service.fetcherService stopAllFetchers];
    
    
    if(self.uploadCompleteBlock){
        self.uploadCompleteBlock(nil, NO, nil);
    }
}

- (void)addFileToFolder
{
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:@"files/photo.jpg"];
    NSString *folderId = @"0BwwA4oUTeiV1UVNwOHItT0xfa2M";
    
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = @"photo.jpg";
    metadata.parents = [NSArray arrayWithObject:folderId];
    
    GTLRUploadParameters *uploadParameters = [GTLRUploadParameters uploadParametersWithData:fileData
                                                                                   MIMEType:@"image/jpeg"];
    uploadParameters.shouldUploadWithSingleRequest = TRUE;
    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
                                                                   uploadParameters:uploadParameters];
    query.fields = @"id";
    [self.service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket,
                                                         GTLRDrive_File *file,
                                                         NSError *error) {
        if (error == nil) {
            NSLog(@"File ID %@", file.identifier);
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
}


// List up to 10 files in Drive
- (void)listFileFromRootFolder {
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.fields = @"nextPageToken, files(id, name, originalFilename, mimeType)";
    query.pageSize = 1000;
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRDrive_FileList *)result
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *output = [[NSMutableString alloc] init];
        if (result.files.count > 0) {
            [output appendString:@"Files:\n"];
            int count = 1;
            for (GTLRDrive_File *file in result.files) {
                [output appendFormat:@"%@ (%@) [%@]\n", file.name, file.originalFilename, file.mimeType];
                count++;
            }
        } else {
            [output appendString:@"No files found."];
        }
        self.output.text = output;
    } else {
        NSMutableString *message = [[NSMutableString alloc] init];
        [message appendFormat:@"Error getting presentation data: %@\n", error.localizedDescription];
        [self showAlert:@"Error" message:message];
    }
}

#if (WTGoogleDriveManager_VERSION <= GOOGLEOAUTH2_VERSION)

// Creates the auth controller for authorizing access to Drive API.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLRAuthScopeDriveReadonly, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:_clientID
                      clientSecret:nil
                      keychainItemName:_keychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Drive API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTH_VERSION)

#pragma mark todo: fix

#endif


// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
//    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - protocol GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    WatLog(@"goole signin");
    if (error == nil) {
        // Perform any operations on signed in user here.
//        NSString *userId = user.userID;                  // For client-side use only!
//        NSString *idToken = user.authentication.idToken; // Safe to send to the server
//        NSString *fullName = user.profile.name;
//        NSString *givenName = user.profile.givenName;
//        NSString *familyName = user.profile.familyName;
//        NSString *email = user.profile.email;
        // ...
        
        [WTGoogleDriveManager sharedManager].service.authorizer = [user.authentication fetcherAuthorizer];
        self.beginSessionCompletion(YES);
    } else {
        self.beginSessionCompletion(NO);
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    WatLog(@"google signout");
}

#pragma mark - deprecated


- (void)uploadFileFromPath:(NSString*)fromPath
{
    
}
- (void)uploadFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath
{
    
}
- (void)uploadNewFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath
{
    
}
- (void)uploadCancel:(NSString*)path
{
    
}


//- (void)listFileFromRootFolder
//{
//    
//}
- (void)listFileFromFolderPath:(NSString*)path
{
    
}
- (void)listFileFromFolderPath:(NSString*)path recursive:(BOOL)recursive
{
    
}

- (void)loadListFileFromRootFolder
{
    
}
- (void)loadListFileFromFolderPath:(NSString*)path
{
    
}
- (void)loadListFileFromFolderPath:(NSString*)path recursive:(BOOL)recursive
{
    
}


- (void)download
{
    
}
- (void)downloadFileFromPath:(NSString*)path toPath:(NSString*)localPath
{
    
}
//- (void)downloadFileFromPath:(NSString*)path toFolderPath:(NSString*)localFolderPath;

- (void)downloadFileFromPaths:(NSArray*)paths toFolderPath:(NSString*)localFolderPath
{
    
}

@end
