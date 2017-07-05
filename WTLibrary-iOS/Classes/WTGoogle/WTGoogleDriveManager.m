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
    @"https://www.googleapis.com/auth/drive",//	View and manage the files in your Google Drive
    //@"https://www.googleapis.com/auth/drive.readonly",//	View the files in your Google Drive
    @"https://www.googleapis.com/auth/drive.appdata",//	View and manage its own configuration data in your Google Drive
    @"https://www.googleapis.com/auth/drive.file",// View and manage Google Drive files and folders that you have opened or created with this app
    //@"https://www.googleapis.com/auth/drive.metadata",//	View and manage metadata of files in your Google Drive
    @"https://www.googleapis.com/auth/drive.metadata.readonly",//	View metadata for files in your Google Drive
    //@"https://www.googleapis.com/auth/drive.photos.readonly",//	View the photos, videos and albums in your Google Photos
    //@"https://www.googleapis.com/auth/drive.scripts",// Modify your Google Apps Script scripts' behavior
                                          ];
    [GIDSignIn sharedInstance].delegate = self;
}

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
                GTLRDrive_File *metadata = _downloadArrayMetadata[_downloadArrayIndex];
                self.downloadProgressBlock(YES,metadata,[metadata.size floatValue]);
            }
            [_downloadSuccessArray addObject:_downloadArrayMetadata[_downloadArrayIndex]];
            _downloadArrayIndex++;
            if(_downloadArrayIndex<[_downloadArrayMetadata count]){
                GTLRDrive_File *metadata = _downloadArrayMetadata[_downloadArrayIndex];
                [self downloadFileFromPath:metadata toFolderPath:_downloadFolderPath];
            }else{
                if(self.downloadCompleteBlock){
                    self.downloadCompleteBlock(YES,_downloadSuccessArray,_downloadFailArray);
                }
            }
            
            
        } else {
            WatLog(@"An error occurred: %@", error);
            
            [_downloadFailArray addObject:_downloadArrayMetadata[_downloadArrayIndex]];
            _downloadArrayIndex++;
            if(_downloadArrayIndex<[_downloadArrayMetadata count]){
                GTLRDrive_File *metadata = _downloadArrayMetadata[_downloadArrayIndex];
                [self downloadFileFromPath:metadata toFolderPath:_downloadFolderPath];
            }else{
                if(self.downloadCompleteBlock){
                    self.downloadCompleteBlock(YES,_downloadSuccessArray,_downloadFailArray);
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
        GTLRServiceTicket *ticketz = [self.service executeQuery:queryz
                                              completionHandler:^(GTLRServiceTicket * ticket, GTLRDrive_File *file, NSError * error) {
            if (error == nil) {
                
                GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
                                                                               uploadParameters:uploadParameters];
                query.fields = @"id";
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


#pragma mark -

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    WatLog(@"goole signin");
    if (error == nil) {
        // Perform any operations on signed in user here.
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
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
@end
