//
//  WTRuntimeObject.m
//  WTLibrary-iOS
//
//  Created by iMac on 2/16/18.
//  Copyright © 2018 Wat Wongtanuwat. All rights reserved.
//

#import "WTRuntimeObject.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "WTMacro.h"
#import "SBJson5.h"

@implementation WTRuntimeObject

@end

#pragma mark -

@implementation WTRTProjectObject

@end

@implementation WTRTApplicationObject

+ (instancetype)applicationObject
{
    return [[WTRTApplicationObject alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self initialize];
    }
    return self;
}

- (void)setup {
    _classes = [NSMutableArray array];
    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
    [_classes removeAllObjects];
    [_userDefineClasses removeAllObjects];
}

- (NSString *)exportjson
{
    SBJson5Writer *write = [SBJson5Writer writerWithMaxDepth:0 humanReadable:YES sortKeys:NO];
    
    
    return @"";
}

@end

@implementation WTRTClassObject

+ (instancetype)classObject
{
    return [[WTRTClassObject alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self initialize];
    }
    return self;
}

- (void)setup {
//    _classes = [NSMutableArray array];
//    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
//    [_classes removeAllObjects];
//    [_userDefineClasses removeAllObjects];
}

- (NSString *)exportjson
{
    return @"";
}

@end

@implementation WTRTVariableObject

@end

@implementation WTRTPropertyObject

@end

@implementation WTRTMethodObject

+ (instancetype)methodObject
{
    return [[WTRTMethodObject alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self initialize];
    }
    return self;
}

- (void)setup {
//    _classes = [NSMutableArray array];
//    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
//    [_classes removeAllObjects];
//    [_userDefineClasses removeAllObjects];
}

- (NSString *)exportjson
{
    return @"";
}

@end
