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

@property (nonatomic, strong) NSBundle *mainBundle;
@property (nonatomic, strong) NSArray<NSBundle *> *allBundle;
@property (nonatomic, strong) NSDictionary *infoDictionary;


@end

@implementation WTBundleInfo

+ (instancetype)sharedBudleInfo {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _mainBundle = [NSBundle mainBundle];
    _infoDictionary = [_mainBundle infoDictionary];
    _allBundle = [_mainBundle allBundle];
}

+ (NSString*)displayName
{
    NSDictionary *infoDictionary = [WTBundleInfo sharedBundleInfo].infoDictionary;
    NSString *displayName = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleDisplayName"]];
    return displayName;
}

+ (NSString*)bundleName
{
    NSDictionary *infoDictionary = [WTBundleInfo sharedBundleInfo].infoDictionary;
    NSString *bundleName = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleName"]];
    return bundleName;
}

+ (NSString*)versionNumber
{
    NSDictionary *infoDictionary = [WTBundleInfo sharedBundleInfo].infoDictionary;
    NSString *versionNumber = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    return versionNumber;
}

+ (NSString*)buildNumber
{
    NSDictionary *infoDictionary = [WTBundleInfo sharedBundleInfo].infoDictionary;
    NSString *buildNumber = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleVersion"]];
    return buildNumber;
}

@end
