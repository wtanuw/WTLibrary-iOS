//
//  WTBundleInfo.m
//  Pods
//
//  Created by Wat Wongtanuwat on 2/18/2561 BE.
//
//

#import "WTBundleInfo.h"
#import "WTMacro.h"

@interface WTBundleInfo()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSArray<NSBundle *> *allBundle;
@property (nonatomic, strong) NSDictionary *infoDictionary;


@end

@implementation WTBundleInfo

+ (instancetype)mainBundleInfo {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initWithBundle:[NSBundle mainBundle]];
    });
}

+ (instancetype)bundleInfoWithBundle:(NSBundle*)bundle
{
    return [[self alloc] initWithBundle:bundle];
}

- (instancetype)initWithBundle:(NSBundle*)bundle {
    self = [super init];
    if (self) {
        _bundle = bundle;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _infoDictionary = [_bundle infoDictionary];
    _allBundle = [NSBundle allBundles];
}

+ (NSString*)bundleIdentifier
{
    return [[WTBundleInfo mainBundleInfo] bundleIdentifier];
}

+ (NSString*)displayName
{
    return [[WTBundleInfo mainBundleInfo] displayName];
}

+ (NSString*)bundleName
{
    return [[WTBundleInfo mainBundleInfo] bundleName];
}

+ (NSString*)versionNumber
{
    return [[WTBundleInfo mainBundleInfo] versionNumber];
}

+ (NSString*)buildNumber
{
    return [[WTBundleInfo mainBundleInfo] buildNumber];
}

- (NSString*)bundleIdentifier
{
    NSString *bundleIdentifier = _bundle.bundleIdentifier;
    return bundleIdentifier;
}

- (NSString*)displayName
{
    NSDictionary *infoDictionary = _bundle.infoDictionary;
    NSString *displayName = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleDisplayName"]];
    return displayName;
}

- (NSString*)bundleName
{
    NSDictionary *infoDictionary = _bundle.infoDictionary;
    NSString *bundleName = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleName"]];
    return bundleName;
}

- (NSString*)versionNumber
{
    NSDictionary *infoDictionary = _bundle.infoDictionary;
    NSString *versionNumber = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    return versionNumber;
}

- (NSString*)buildNumber
{
    NSDictionary *infoDictionary = _bundle.infoDictionary;
    NSString *buildNumber = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleVersion"]];
    return buildNumber;
}


@end
