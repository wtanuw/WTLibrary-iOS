//
//  WTBundleInfo.h
//  Pods
//
//  Created by Wat Wongtanuwat on 2/18/2561 BE.
//
//

#import <Foundation/Foundation.h>

@interface WTBundleInfo : NSObject

#pragma mark - useful string

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

#pragma mark - on demand resource

//+ (void)addOnDemandBundle:(NSBundleResourceRequest*)request forTag:(NSString*)tag;
+ (void)addOnDemandBundleForTag:(NSArray<NSString*>*)tags;

+ (NSBundle*)onDemandBundleForTag:(NSString*)tag;// wtpath useing

//Requesting Access to the Tags
+ (void)beginAccessingResources:(NSString*)tag withCompletionHandler:(void (^)(NSError * error))completionHandler;//downloads the resources from the App Store.

//Checking Whether Tags Are Already on the Device
+ (BOOL)conditionallyBeginAccessingResourcesForTag:(NSString*)tag withCompletionHandler:(void (^)(BOOL resourcesAvailable))completionHandler;//does not download the resources.

+ (void)endAccessingResourcesForTag:(NSString*)tag;

@end
