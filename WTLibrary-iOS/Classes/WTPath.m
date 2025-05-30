//
//  WTPath.m
//  CosplayTarika
//
//  Created by Wat Wongtanuwat on 8/6/13.
//
//

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#import "WTPath.h"
#import "WTMacro.h"
#import "WTBundleInfo.h"

@interface WTPath() {
}

@end


@implementation WTPath

+ (NSString*)pathToDirectory:(NSSearchPathDirectory)directory
{
//    //in case want NSURL 
//    [[NSFileManager defaultManager] URLsForDirectory:directory
//                                           inDomains:NSUserDomainMask];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *pathDirectory = [paths lastObject];
    
    return pathDirectory;
}

// documents (Documents)
+ (NSString*)documentDirectoryPath
{
    return [WTPath pathToDirectory:NSDocumentDirectory];
}

// various documentation, support, and configuration files, resources (Library)
+ (NSString*)libraryDirectoryPath
{
    return [WTPath pathToDirectory:NSLibraryDirectory];
}

//location of application support files (plug-ins, etc) (Library/Application Support)
+ (NSString*)applicationSupportDirectoryPath
{
    return [WTPath pathToDirectory:NSApplicationSupportDirectory];
}

// location of discardable cache files (Library/Caches)
+ (NSString*)cacheDirectoryPath
{
    return [WTPath pathToDirectory:NSCachesDirectory];
}

+ (NSString*)temporaryDirectoryPath
{
    return NSTemporaryDirectory();
}

+ (NSString*)desktopDirectoryPath
{
    return [WTPath pathToDirectory:NSDesktopDirectory];
}

+ (void)aaa
{
//    [[NSFileManager defaultManager] createDirectoryAtPath:<#(NSString *)#> withIntermediateDirectories:<#(BOOL)#> attributes:<#(NSDictionary *)#> error:<#(NSError *__autoreleasing *)#>];
}


+ (NSString*)resourcePath
{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString*)resourcePathByAppend:(NSString*)path
{
    return [[self resourcePath] stringByAppendingPathComponent:path];
}


//link in app store
+ (NSString*)itunesAppstorePath
{
    //your app link
    NSString *urlString = @"itunes.apple.com/us/app/bubblett/id868783196?ls=1&mt=8";
    
    //open link in app store
    NSString *itmsString = [NSString stringWithFormat:@"itms-apps://%@", urlString];
    
    return itmsString;
}

//link in browser
+ (NSString*)itunesBrowserPath
{
    //your app link
    NSString *urlString = @"itunes.apple.com/us/app/bubblett/id868783196?ls=1&mt=8";
    
    //open link in browser
    NSString *httpString = [NSString stringWithFormat:@"https://%@", urlString];
    
    return httpString;
}

+ (NSString*)addAppStoreId:(NSString*)appstoreIdString
{
    return @"";
}

+ (void)openItunes
{
#if TARGET_OS_IPHONE
    
    //open link in app store
//    NSString *itmsString = [self itunesAppstorePath];
//
//    NSString *httpString = [self itunesBrowserPath];
    
    NSString *itmsString = @"";
    
    NSString *httpString = @"";
    
    //check if can open the link in app store
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_10_0)
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:itmsString]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itmsString] options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:httpString] options:@{} completionHandler:nil];
            }
        }
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_10_0)
        else
#endif
#endif
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_10_0)
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:itmsString]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itmsString]];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:httpString]];
            }
        }
#endif
    }
    
#elif TARGET_OS_MAC
#endif
}

+ (void)openSettingApp;
{
#if TARGET_OS_IPHONE
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_10_0)
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_10_0)
        else
#endif
#endif
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_10_0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
#endif
    }
    
#elif TARGET_OS_MAC
#endif
}


@end

@implementation WTPath(OnDemand)

+ (NSString*)onDemandPathForTag:(NSString*)tag
{
    return [[WTBundleInfo onDemandBundleForTag:tag] resourcePath];
}

+ (NSString*)onDemandPathForTag:(NSString*)tag fileName:(NSString*)fileName
{
    return [[WTBundleInfo onDemandBundleForTag:tag] pathForResource:fileName ofType:nil];
}

@end
