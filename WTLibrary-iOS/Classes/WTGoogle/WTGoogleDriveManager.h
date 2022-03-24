//
//  WTGoogleDriveManager.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/1/17.
//  Copyright © 2017 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTGoogleDriveManager_VERSION 0x00030000
#define GOOGLEOAUTH2_VERSION 0x00010000
#define GOOGLEAPPAUTH_VERSION 0x00020000
#define GOOGLEAPPAUTHSIGN6_VERSION 0x00030000

#if (WTGoogleDriveManager_VERSION == GOOGLEOAUTH2_VERSION)

#import "GTMOAuth2/GTMOAuth2ViewControllerTouch.h"
#import "GTLRDrive.h"
#import "WTMacro.h"
#import "GoogleSignIn/GoogleSignIn.h"

#elif (WTGoogleDriveManager_VERSION >= GOOGLEAPPAUTH_VERSION)

//#import "GTMOAuth2/GTMOAuth2ViewControllerTouch.h"
#import "GTLRDrive.h"
#import "WTMacro.h"
//#import <Google/SignIn.h>
//#import <GoogleSignIn/GoogleSignIn.h>
#import "GoogleSignIn/GoogleSignIn.h"
//#import "GoogleSignIn.h"
#import <GTMSessionFetcher/GTMSessionFetcher.h>
#import "GTMAppAuth.h"
#import "WTGoogleFetcherAuth.h"

#endif

#if (WTGoogleDriveManager_VERSION <= GOOGLEOAUTH2_VERSION)

@interface WTGoogleDriveManager : NSObject<GIDSignInDelegate>

#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTH_VERSION)

@interface WTGoogleDriveManager : NSObject<GIDSignInDelegate>
@property(nonatomic, nullable) GTMAppAuthFetcherAuthorization *authorization;
@property(nonatomic, nullable) MyAuth *myauthorization;

#elif (WTGoogleDriveManager_VERSION <= GOOGLEAPPAUTHSIGN6_VERSION)

@interface WTGoogleDriveManager : NSObject
@property(nonatomic, nullable) GTMAppAuthFetcherAuthorization *authorization;
@property(nonatomic, nullable) MyAuth *myauthorization;
@property(nonatomic, weak, nullable) UIViewController *vct;
- (BOOL)checkScope:(NSArray* _Nonnull)scopes;
- (BOOL)addScope:(NSArray* _Nonnull)scopes withCompletion:(void (^_Nullable)(BOOL linkSuccess))completion;

#endif

@property (nonatomic, strong, nullable) GTLRDriveService *service;
@property (nonatomic, strong) UITextView *output;

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *keychainItemName;

@property (nonatomic, copy) void (^beginSessionCompletion)(BOOL linkSuccess);

//@property (nonatomic, strong) DBRestClient *restClient;
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
@property (nonatomic, copy) void (^downloadProgressBlock)(BOOL finish, id metadata, float totalBytes);
@property (nonatomic, copy) void (^downloadCompleteBlock)(BOOL success, NSArray *fileSuccess, NSArray *fileFail);

@property (nonatomic, copy) void (^uploadProgressBlock)(NSString *file, float progress, NSError *error);
@property (nonatomic, copy) void (^uploadCompleteBlock)(NSString *file, BOOL success, NSError *error);

+ (instancetype)sharedManager;

- (BOOL)signInSilently;
- (BOOL)signIn;
- (UIButton* _Nonnull)googleButton;

//- (void)addRevForFile:(DBMetadata*)metadata;
//- (DBMetadata*)metadataForPath:(NSString*)path;
//- (NSString*)revForFilePath:(NSString*)filePath;
//- (NSString*)hashForFolderPath:(NSString*)folderPath;

//core api
// call this function in appdelegate
- (void)authWithClientID:(NSString*)clientID keychainForName:(NSString*)kKeychainItemName withCompletion:(void (^)(BOOL linkSuccess))completion;

- (BOOL)signIn:(UIViewController*)vct;
- (void)linkFromViewController:(UIViewController*)vct;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)unlink;
- (BOOL)isLogin;

- (void)searchFolder:(NSString*)folderName completion:(void (^)(GTLRServiceTicket *ticket,
                                                                GTLRDrive_FileList *files,
                                                                NSError *error))completion;

- (void)moveFolderOutOfTrashed:(GTLRDrive_File *)metadataFile completion:(void (^)(GTLRServiceTicket *ticket,
                                                                                   GTLRDrive_File *file,
                                                                                   NSError *error))completion;
- (void)createFolder:(NSString*)folderName completion:(void (^)(GTLRServiceTicket *ticket,
                                                                GTLRDrive_File *file,
                                                                NSError *error))completion;
- (void)listFileFromFolder:(NSString*)folderIdentifier completion:(void (^)(GTLRServiceTicket *ticket,
                                                                      GTLRDrive_FileList *files,
                                                                      NSError *error))completion;

- (void)downloadFileFromMetadatas:(NSArray *)googleMetadatas toFolderPath:(NSString *)localFolderPath;
- (void)downloadFileFromPath:(GTLRDrive_File*)googleFile toFolderPath:(NSString*)localFolderPath;

- (void)downloadCancel;

- (void)searchFile:(NSString*)fileName completion:(void (^)(GTLRServiceTicket *ticket,
                                                            GTLRDrive_FileList *files,
                                                            NSError *error))completion;

- (void)uploadFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath revision:(NSString*)rev;

- (void)uploadCancel;



//old funcion api

- (void)uploadFileFromPath:(NSString*)fromPath __attribute((deprecated("not have available method.")));
- (void)uploadFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath __attribute((deprecated("not have available method.")));
- (void)uploadNewFileFromPath:(NSString*)fromPath toPath:(NSString*)toPath __attribute((deprecated("not have available method.")));
- (void)uploadCancel:(NSString*)path __attribute((deprecated("not have available method.")));


- (void)listFileFromRootFolder __attribute((deprecated("not have available method.")));
- (void)listFileFromFolderPath:(NSString*)path __attribute((deprecated("not have available method.")));
- (void)listFileFromFolderPath:(NSString*)path recursive:(BOOL)recursive __attribute((deprecated("not have available method.")));

- (void)loadListFileFromRootFolder __attribute((deprecated("not have available method.")));
- (void)loadListFileFromFolderPath:(NSString*)path __attribute((deprecated("not have available method.")));
- (void)loadListFileFromFolderPath:(NSString*)path recursive:(BOOL)recursive __attribute((deprecated("not have available method.")));


- (void)download __attribute((deprecated("not have available method.")));
- (void)downloadFileFromPath:(NSString*)path toPath:(NSString*)localPath __attribute((deprecated("not have available method.")));
//- (void)downloadFileFromPath:(NSString*)path toFolderPath:(NSString*)localFolderPath;

- (void)downloadFileFromPaths:(NSArray*)paths toFolderPath:(NSString*)localFolderPath __attribute((deprecated("not have available method.")));

@end
