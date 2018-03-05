//
//  WTRuntimeParser.m
//  WTLibrary-iOS
//
//  Created by iMac on 2/16/18.
//  Copyright © 2018 Wat Wongtanuwat. All rights reserved.
//

#import "WTRuntimeParser.h"
//#import <UIKit/UIKit.h>
//#import "objc/objc-class.h"
//#import <objc/objc-runtime.h>


#define WATLOG_DEBUG

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//#include <Cocoa.h>
#import "WTMacro.h"
#import "WTBundleInfo.h"
#import "WTPath.h"

#define kProjectLevel @"kProject"
#define kClassLevel @"kProject"

@interface WTRuntimeParser()

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) WTRTProjectObject *project;

@end

#pragma mark -

@implementation WTRuntimeParser

+ (instancetype)sharedReader {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
        [self initialize];
    }
    return self;
}

- (void)setup {
    
}

- (void)initialize {
}

+ (WTRTProjectObject *)startParser:(NSString *)filePath {
    return [[WTRuntimeParser sharedReader] startParser:filePath];
}

- (WTRTProjectObject *)startParser:(NSString *)filePath {
    _filePath = filePath;
    [self readProject];
    return _project;
}

- (void)readProject {
    
    WatLog(@"\n");
//    WatLog(@"%@------- Project %@(v.%@) ------", @"###", [WTBundleInfo displayName], [WTBundleInfo versionNumber]);
//    WatLog(@"%@------- Bundle %@(build %@) ------", @"###", [WTBundleInfo bundleName], [WTBundleInfo buildNumber]);
    
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    
    NSData *data = [fileManager contentsAtPath:_filePath];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    _project = [WTRTProjectObject projectObject];
    [_project importJSONString:string];
    
}

@end
