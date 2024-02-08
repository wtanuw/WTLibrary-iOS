//
//  WTBundleInfo.h
//  Pods
//
//  Created by Wat Wongtanuwat on 2/18/2561 BE.
//
//

#import <Foundation/Foundation.h>

@interface WTBundleInfo : NSObject

+ (NSString*)bundleIdentifier;
+ (NSString*)displayName;
+ (NSString*)bundleName;
+ (NSString*)versionNumber;
+ (NSString*)buildNumber;

+ (instancetype)bundleInfoWithBundle:(NSBundle*)bundle;

- (NSString*)bundleIdentifier;
- (NSString*)displayName;
- (NSString*)bundleName;
- (NSString*)versionNumber;
- (NSString*)buildNumber;

+ (void)addOnDemandBundle:(NSBundleResourceRequest*)request forTag:(NSString*)tag;
+ (NSBundle*)onDemandBundleForTag:(NSString*)tag;

+ (BOOL)conditionallyBeginAccessingResourcesForTag:(NSString*)tag withCompletionHandler:(void (^)(BOOL resourcesAvailable))completionHandler;
+ (void)beginAccessingResources:(NSString*)tag withCompletionHandler:(void (^)(NSError * error))completionHandler;
+ (void)endAccessingResourcesForTag:(NSString*)tag;

@end
