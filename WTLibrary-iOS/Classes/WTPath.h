//
//  WTPath.h
//  CosplayTarika
//
//  Created by Wat Wongtanuwat on 8/6/13.
//
//

#import <Foundation/Foundation.h>

#define WTPath_VERSION 0x00020003

@interface WTPath : NSObject

+ (NSString*)pathToDirectory:(NSSearchPathDirectory)directory;

+ (NSString*)documentDirectoryPath;

+ (NSString*)libraryDirectoryPath;

+ (NSString*)applicationSupportDirectoryPath;

+ (NSString*)cacheDirectoryPath;
    
+ (NSString*)temporaryDirectoryPath;


+ (NSString*)resourcePath;

+ (NSString*)resourcePathByAppend:(NSString*)path;


+ (NSString*)itunesAppstorePath;

+ (NSString*)itunesBrowserPath;

+ (void)openItunes;

+ (void)openSettingApp;

@end
