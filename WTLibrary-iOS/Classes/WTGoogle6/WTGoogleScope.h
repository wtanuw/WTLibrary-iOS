//
//  WTGoogleFetcherAuth.h
//  Pods
//
//  Created by Mac on 13/5/2564 BE.
//

#import <Foundation/Foundation.h>

//@"https://www.googleapis.com/auth/drive",//    View and manage the files in your Google Drive
////@"https://www.googleapis.com/auth/drive.readonly",//    View the files in your Google Drive
//@"https://www.googleapis.com/auth/drive.appdata",//    View and manage its own configuration data in your Google Drive
//@"https://www.googleapis.com/auth/drive.file",// View and manage Google Drive files and folders that you have opened or created with this app
////@"https://www.googleapis.com/auth/drive.metadata",//    View and manage metadata of files in your Google Drive
//@"https://www.googleapis.com/auth/drive.metadata.readonly",//    View metadata for files in your Google Drive
////@"https://www.googleapis.com/auth/drive.photos.readonly",//    View the photos, videos and albums in your Google Photos
////@"https://www.googleapis.com/auth/drive.scripts",// Modify your Google Apps Script scripts' behavior

//// Authorization scopes GTLRDriveService
//
//NSString * const kGTLRAuthScopeDrive                 = @"https://www.googleapis.com/auth/drive";
//NSString * const kGTLRAuthScopeDriveAppdata          = @"https://www.googleapis.com/auth/drive.appdata";
//????NSString * const kGTLRAuthScopeDriveFile             = @"https://www.googleapis.com/auth/drive.file";
//NSString * const kGTLRAuthScopeDriveMetadata         = @"https://www.googleapis.com/auth/drive.metadata";
//NSString * const kGTLRAuthScopeDriveMetadataReadonly = @"https://www.googleapis.com/auth/drive.metadata.readonly";
//NSString * const kGTLRAuthScopeDrivePhotosReadonly   = @"https://www.googleapis.com/auth/drive.photos.readonly";
//????NSString * const kGTLRAuthScopeDriveReadonly         = @"https://www.googleapis.com/auth/drive.readonly";
//NSString * const kGTLRAuthScopeDriveScripts          = @"https://www.googleapis.com/auth/drive.scripts";


//Scope code    Description    Usage
#define REC_NONSEN_drive_appdata    @"https://www.googleapis.com/auth/drive.appdata"
//See, create, and delete its own configuration data in your Google Drive
#define REC_NONSEN_drive_appfolder  @"https://www.googleapis.com/auth/drive.appfolder" //View and manage the app's own configuration data in your Google Drive.    Recommended Non-sensitive
//See, create, and delete its own configuration data in your Google Drive

#define REC_NONSEN_drive_install    @"https://www.googleapis.com/auth/drive.install"    //Allow apps to appear as an option in the "Open with" or the "New" menu.    Recommended Non-sensitive
//Connect itself to your Google Drive. Learn more
#define REC_NONSEN_drive_file       @"https://www.googleapis.com/auth/drive.file"     //Create new Drive files, or modify existing files, that you open with an app or that the user shares with an app while using the Google Picker API or the app's file picker.    Recommended Non-sensitive
//See, edit, create, and delete only the specific Google Drive files you use with this app. Learn more

#define SEN_drive_apps_readonly     @"https://www.googleapis.com/auth/auth/drive.apps.readonly"     //View apps authorized to access your Drive.    Sensitive
//Some requested scopes were invalid. {valid=[https://www.googleapis.com/auth/userinfo.email, https://www.googleapis.com/auth/userinfo.profile, openid], invalid=[https://www.googleapis.com/auth/auth/drive.apps.readonly]}
                                            
#define RES_drive                   @"https://www.googleapis.com/auth/drive"     //View and manage all of your Drive files.    Restricted
#define RES_drive_readonly          @"https://www.googleapis.com/auth/drive.readonly"     //View and download all your Drive files.    Restricted
#define RES_drive_activity          @"https://www.googleapis.com/auth/drive.activity"     //View and add to the activity record of files in your Drive.    Restricted
#define RES_drive_activity_readonly @"https://www.googleapis.com/auth/drive.activity.readonly"     //View the activity record of files in your Drive.    Restricted
#define RES_drive_metadata          @"https://www.googleapis.com/auth/drive.metadata"     //View and manage metadata of files in your Drive.    Restricted
#define RES_drive_metadata_readonly @"https://www.googleapis.com/auth/drive.metadata.readonly"     //View metadata for files in your Drive.    Restricted
#define RES_drive_scripts           @"https://www.googleapis.com/auth/drive.scripts"     //Modify your Google Apps Script scripts' behavior.    Restricted


NS_ASSUME_NONNULL_BEGIN

@interface WTGoogleScope : NSObject

@end

NS_ASSUME_NONNULL_END
