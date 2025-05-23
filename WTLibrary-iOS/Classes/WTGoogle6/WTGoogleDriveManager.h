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
#import <GoogleAPIClientForREST/GTLRDrive.h>
#import "WTMacro.h"
//#import <Google/SignIn.h>
//#import <GoogleSignIn/GoogleSignIn.h>
#import "GoogleSignIn/GoogleSignIn.h"
//#import "GoogleSignIn.h"
#import <GTMSessionFetcher/GTMSessionFetcher.h>
#import <GTMAppAuth/GTMAppAuth.h>
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
@property (nonatomic, strong, nullable) UITextView *output;

@property (nonatomic, strong, nullable) NSString *clientID;
@property (nonatomic, strong, nullable) NSString *keychainItemName;

@property (nonatomic, copy, nullable) void (^beginSessionCompletion)(BOOL linkSuccess);

//@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong, nullable) NSMutableDictionary *metadataDictionary;

@property (nonatomic, assign) BOOL recursively;
@property (nonatomic, strong, nullable) NSMutableArray *exploreQueue;
@property (nonatomic, strong, nullable) NSMutableArray *exploreArrayMetadata;

@property (nonatomic, strong, nullable) NSString *downloadFolderPath;
@property (nonatomic, assign) BOOL arrayDownloading;
@property (nonatomic, assign) int downloadArrayIndex;
@property (nonatomic, strong, nullable) NSMutableArray *downloadArrayMetadata;
@property (nonatomic, strong, nullable) NSMutableArray *downloadSuccessArray;
@property (nonatomic, strong, nullable) NSMutableArray *downloadFailArray;
@property (nonatomic, copy, nullable) void (^downloadProgressBlock)(BOOL finish, id _Nullable metadata, float totalBytes);
@property (nonatomic, copy, nullable) void (^downloadCompleteBlock)(BOOL success, NSArray * _Nullable fileSuccess, NSArray * _Nullable fileFail);

@property (nonatomic, copy, nullable) void (^uploadProgressBlock)(NSString * _Nullable file, float progress, NSError * _Nullable error);
@property (nonatomic, copy, nullable) void (^uploadCompleteBlock)(NSString * _Nullable file, BOOL success, NSError * _Nullable error);

+ (nonnull instancetype)sharedManager;

- (BOOL)signInSilently;
- (BOOL)signIn;
- (nonnull UIButton*)googleButton;

//- (void)addRevForFile:(DBMetadata*)metadata;
//- (DBMetadata*)metadataForPath:(NSString*)path;
//- (NSString*)revForFilePath:(NSString*)filePath;
//- (NSString*)hashForFolderPath:(NSString*)folderPath;

//core api
// call this function in appdelegate
- (void)authWithClientID:(nonnull NSString*)clientID keychainForName:(nonnull NSString*)kKeychainItemName withCompletion:(void (^_Nullable)(BOOL linkSuccess))completion;

- (BOOL)signIn:(nonnull UIViewController*)vct;
- (void)linkFromViewController:(nonnull UIViewController*)vct;
- (BOOL)handleOpenURL:(nonnull NSURL *)url;
- (void)unlink;
- (BOOL)isLogin;

- (void)searchFolder:(nonnull NSString*)folderName completion:(void (^_Nullable)(GTLRServiceTicket * _Nullable ticket,
                                                                                 GTLRDrive_FileList * _Nullable files,
                                                                                 NSError * _Nullable error))completion;

- (void)moveFolderOutOfTrashed:(nonnull GTLRDrive_File *)metadataFile completion:(void (^_Nullable)(GTLRServiceTicket * _Nullable ticket,
                                                                                                    GTLRDrive_File * _Nullable file,
                                                                                                    NSError * _Nullable error))completion;
- (void)createFolder:(nonnull NSString*)folderName completion:(void (^_Nullable)(GTLRServiceTicket * _Nullable ticket,
                                                                                 GTLRDrive_File * _Nullable file,
                                                                                 NSError * _Nullable error))completion;
- (void)listFileFromFolder:(nonnull NSString*)folderIdentifier completion:(void (^_Nullable)(GTLRServiceTicket * _Nullable ticket,
                                                                                    GTLRDrive_FileList * _Nullable files,
                                                                                    NSError * _Nullable error))completion;

- (void)downloadFileFromMetadatas:(nonnull NSArray *)googleMetadatas toFolderPath:(nonnull NSString *)localFolderPath;
- (void)downloadFileFromPath:(nonnull GTLRDrive_File*)googleFile toFolderPath:(nonnull NSString*)localFolderPath;

- (void)downloadCancel;

- (void)searchFile:(nonnull NSString*)fileName completion:(void (^_Nullable)(GTLRServiceTicket * _Nullable ticket,
                                                                             GTLRDrive_FileList * _Nullable files,
                                                                             NSError * _Nullable error))completion;

- (void)uploadFileFromPath:(nonnull NSString*)fromPath toPath:(nonnull NSString*)toPath revision:(nonnull NSString*)rev;

- (void)uploadCancel;



//old funcion api

- (void)uploadFileFromPath:(nonnull NSString*)fromPath __attribute((deprecated("not have available method.")));
- (void)uploadFileFromPath:(nonnull NSString*)fromPath toPath:(nonnull NSString*)toPath __attribute((deprecated("not have available method.")));
- (void)uploadNewFileFromPath:(nonnull NSString*)fromPath toPath:(nonnull NSString*)toPath __attribute((deprecated("not have available method.")));
- (void)uploadCancel:(nonnull NSString*)path __attribute((deprecated("not have available method.")));


- (void)listFileFromRootFolder __attribute((deprecated("not have available method.")));
- (void)listFileFromFolderPath:(nonnull NSString*)path __attribute((deprecated("not have available method.")));
- (void)listFileFromFolderPath:(nonnull NSString*)path recursive:(BOOL)recursive __attribute((deprecated("not have available method.")));

- (void)loadListFileFromRootFolder __attribute((deprecated("not have available method.")));
- (void)loadListFileFromFolderPath:(nonnull NSString*)path __attribute((deprecated("not have available method.")));
- (void)loadListFileFromFolderPath:(nonnull NSString*)path recursive:(BOOL)recursive __attribute((deprecated("not have available method.")));


- (void)download __attribute((deprecated("not have available method.")));
- (void)downloadFileFromPath:(nonnull NSString*)path toPath:(nonnull NSString*)localPath __attribute((deprecated("not have available method.")));
//- (void)downloadFileFromPath:(NSString*)path toFolderPath:(NSString*)localFolderPath;

- (void)downloadFileFromPaths:(nonnull NSArray*)paths toFolderPath:(nonnull NSString*)localFolderPath __attribute((deprecated("not have available method.")));

@end
