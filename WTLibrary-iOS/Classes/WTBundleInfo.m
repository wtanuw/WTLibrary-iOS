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

@property (nonatomic, strong) NSMutableDictionary<NSString*,NSBundleResourceRequest*> *onDemandBundleDictionary;
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSNumber*> *onDemandLoadedDictionary;

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
    _onDemandBundleDictionary = [NSMutableDictionary dictionary];
    _onDemandLoadedDictionary = [NSMutableDictionary dictionary];
    
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

#pragma mark -

//+ (void)addOnDemandBundle:(NSBundleResourceRequest*)resourceRequest forTag:(NSString*)tag
//{
//    [[WTBundleInfo mainBundleInfo] addOnDemandBundle:resourceRequest forTag:tag];
//}

+ (void)addOnDemandBundleForTag:(NSArray<NSString*>*)tags
{
    for (NSString *tag in tags) {
        [self initializingResourceRequestForTag:tag];
    }
}

- (void)addOnDemandBundle:(NSBundleResourceRequest*)resourceRequest forTag:(NSString*)tag
{
    [_onDemandBundleDictionary setObject:resourceRequest forKey:tag];
}

+ (NSBundleResourceRequest*)resourceRequestForTag:(NSString*)tag
{
    NSBundleResourceRequest *resourceRequest = [[WTBundleInfo mainBundleInfo].onDemandBundleDictionary objectForKey:tag];
    if (resourceRequest) {
        return resourceRequest;
    } else {
        return [self initializingResourceRequestForTag:tag];
    }
}

+ (NSBundle*)onDemandBundleForTag:(NSString*)tag
{
    NSBundleResourceRequest *resourceRequest = [[WTBundleInfo mainBundleInfo].onDemandBundleDictionary objectForKey:tag];
    return resourceRequest.bundle;
}

+ (NSBundleResourceRequest*)initializingResourceRequestForTag:(NSString*)tag
{
    NSSet *tags = [NSSet setWithObject:tag];
    NSBundleResourceRequest *resourceRequest = [[NSBundleResourceRequest alloc] initWithTags:tags];
    [[WTBundleInfo mainBundleInfo] addOnDemandBundle:resourceRequest forTag:tag];
    return resourceRequest;
}

+ (void)beginAccessingResources:(NSString*)tag withCompletionHandler:(void (^)(NSError * _Nullable error))completionHandler
{
    if ([[[WTBundleInfo mainBundleInfo].onDemandLoadedDictionary objectForKey:tag] boolValue]) {
        return;
    }
    
    // Request access to the tags for this resource request
    [[self resourceRequestForTag:tag] beginAccessingResourcesWithCompletionHandler:
                                     ^(NSError * __nullable error)
        {
            // Check if there is an error
            if (error) {
                // There is a problem so update the app state
                [[WTBundleInfo mainBundleInfo].onDemandLoadedDictionary setObject:[NSNumber numberWithBool:NO] forKey:tag];
     
                // Should also inform the user of the error
                
                completionHandler(error);
                return;
            }
     
            // The associated resources are loaded
        [[WTBundleInfo mainBundleInfo].onDemandLoadedDictionary setObject:[NSNumber numberWithBool:YES] forKey:tag];
        
        //needed mainqueue
        MAIN(^(void){
            completionHandler(error);
        });
        }
    ];
}

+ (BOOL)conditionallyBeginAccessingResourcesForTag:(NSString*)tag withCompletionHandler:(void (^)(BOOL resourcesAvailable))completionHandler
{
    if ([[[WTBundleInfo mainBundleInfo].onDemandLoadedDictionary objectForKey:tag] boolValue]) {
        return YES;
    }
    
    // Request access to tags that may already be on the device
    [[self resourceRequestForTag:tag] conditionallyBeginAccessingResourcesWithCompletionHandler:
                                                     ^(BOOL resourcesAvailable)
        {
            // Check whether the resources are available
            if (resourcesAvailable) {
                // the associated resources are loaded, start using them
                completionHandler(resourcesAvailable);
            } else {
                // The resources are not on the device and need to be loaded
                // Queue up a call to a custom method for loading the tags using
                // beginAccessingResourcesWithCompletionHandler:
                completionHandler(resourcesAvailable);
//                NSOperationQueue.mainQueue().addOperationWithBlock(^{
//                    [self loadTags:resourceRequest.tags forWorldArea:worldArea];
//                });
            }
        }
    ];
    
    return NO;

}

+ (void)endAccessingResourcesForTag:(NSString*)tag
{
    [[self resourceRequestForTag:tag] endAccessingResources];
    [[WTBundleInfo mainBundleInfo].onDemandLoadedDictionary setObject:[NSNumber numberWithBool:NO] forKey:tag];
}

//@property double loadingPriority;
//@property (readonly, copy) NSSet<NSString *> *tags;
//@property (readonly, strong) NSBundle *bundle;
//- (void)beginAccessingResourcesWithCompletionHandler:(void (^)(NSError * _Nullable error))completionHandler;
//- (void)conditionallyBeginAccessingResourcesWithCompletionHandler:(void (^)(BOOL resourcesAvailable))completionHandler;
//- (void)endAccessingResources;
//@property (readonly, strong) NSProgress *progress;

@end
