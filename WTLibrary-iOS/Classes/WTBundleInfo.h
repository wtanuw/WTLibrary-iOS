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

@end
