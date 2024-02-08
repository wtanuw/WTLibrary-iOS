//
//  WTPath.h
//  CosplayTarika
//
//  Created by Wat Wongtanuwat on 8/6/13.
//
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>

#define WTPath_VERSION 0x00020004

@interface WTPath : NSObject

+ (NSString*)pathToDirectory:(NSSearchPathDirectory)directory;

+ (NSString*)documentDirectoryPath;

+ (NSString*)libraryDirectoryPath;

+ (NSString*)applicationSupportDirectoryPath;

+ (NSString*)cacheDirectoryPath;
    
+ (NSString*)temporaryDirectoryPath;

+ (NSString*)desktopDirectoryPath;


+ (NSString*)resourcePath;

+ (NSString*)resourcePathByAppend:(NSString*)path;


+ (NSString*)itunesAppstorePath DEPRECATED_MSG_ATTRIBUTE("still use fix path.");

+ (NSString*)itunesBrowserPath DEPRECATED_MSG_ATTRIBUTE("still use fix path.");

+ (void)openItunes;

+ (void)openSettingApp;


+ (NSString*)addAppStoreId:(NSString*)appstoreIdString;

@end

@interface WTPath(OnDemand)

+ (NSString*)onDemandPathForTag:(NSString*)tag;
+ (NSString*)onDemandPathForTag:(NSString*)tag fileName:(NSString*)fileName;

@end
