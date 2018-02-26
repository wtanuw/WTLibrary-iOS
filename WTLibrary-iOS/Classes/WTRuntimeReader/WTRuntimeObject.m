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

// code from: http://stackoverflow.com/questions/1918972/camelcase-to-underscores-and-back-in-objective-c
NSString *CamelCaseToUnderscores(NSString *input) {
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"%s%C", (idx == 0 ? "" : "_"), (unichar)(c & ~0x20)];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

@implementation WTRuntimeObject

-(instancetype)init
{
    self = [super init];
    if (self) {
        _prettyPrinted = YES;
    }
    [self setup];
    [self initialize];
    return self;
}

- (void)setup {
}

- (void)initialize {
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    NSAssert(NO, @"not implemented");
}

- (NSDictionary *)exportJSON
{
    NSAssert(NO, @"not implemented");
    return @{};
}

- (void)importJSONString:(NSString *)jsonString
{
    //    NSString *jsonString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@", json);
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSLog(@"its an array!");
        NSArray *jsonArray = (NSArray *)jsonObject;
        NSLog(@"jsonArray - %@",jsonArray);
    } else {
        NSLog(@"its probably a dictionary");
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        NSLog(@"jsonDictionary - %@",jsonDictionary);
        [self importJSON:jsonDictionary];
    }
}

- (NSString *)exportJSONString
{
    NSDictionary *dict = [self exportJSON];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:(NSJSONWritingOptions)(self.prettyPrinted ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!jsonData) {
        WatLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

#pragma mark -

@implementation WTRTProjectObject

//- (void)importJSON:(NSString *)jsonString
//{
//    NSString *jsonTest = [[[SBJson5Parser alloc] init] parse:nil];
//    
//}
//
//- (NSString *)exportJSON
//{
//    NSDictionary* aNestedObject = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   @"nestedStringValue", @"aStringInNestedObject",
//                                   [NSNumber numberWithInt:1], @"aNumberInNestedObject",
//                                   nil];
//    
//    NSArray * aJSonArray = [[NSArray alloc] initWithObjects: @"arrayItem1", @"arrayItem2", @"arrayItem3", nil];
//    
//    NSDictionary * jsonTestDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         @"stringValue", @"aString",
//                                         [NSNumber numberWithInt:1], @"aNumber",
//                                         [NSNumber numberWithFloat:1.2345f], @"aFloat",
//                                         [[NSDate date] description], @"aDate",
//                                         aNestedObject, @"nestedObject",
//                                         aJSonArray, @"aJSonArray",
//                                         nil];
//    
//    // create JSON output from dictionary
//    
//    NSError *error = nil;
//    NSString * jsonTest = [[[SBJson5Writer alloc] init] stringWithObject:jsonTestDictionary];
//    
//    if ( ! jsonTest ) {
//        NSLog(@"Error: %@", error);
//    }else{
//        NSLog(@"%@", jsonTest);
//    }
//}

+ (instancetype)projectObject
{
    return [[WTRTProjectObject alloc] init];
}

- (void)setup {
    _bundles = [NSMutableDictionary dictionary];
}

- (void)initialize {
    [_bundles removeAllObjects];
}

- (NSDictionary *)bundlesString
{
    int i = 0;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTBundleObject *bundle in _bundles.allValues) {
        if (bundle.bundleName) {
            [dict addEntriesFromDictionary:@{
                                             bundle.bundleName: [bundle exportJSON]
                                             }];
        } else {
            [dict addEntriesFromDictionary:@{
                                             [NSString stringWithFormat:@"null-%d",i]: [bundle exportJSON]
                                             }];
            i++;
        }
    }
    return dict;
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _projectName = jsonDict[@"projectName"];
    for (NSDictionary *dict in jsonDict[@"bundle"]) {
        
    }
    _mainBundle = [WTRTBundleObject bundleObject];
    [_mainBundle importJSON:jsonDict[@"mainBundle"]];
}

- (NSDictionary *)exportJSON
{
    return @{
             @"projectName": _projectName,
             @"mainBundleName": _mainBundle.bundleName,
             @"mainBundle": [_mainBundle exportJSON],
             @"bundle": [self bundlesString]
//             @"app": @{@"sds": @"dsds",@"sdsdsds": @"ddgdsds"},
//             @"asfsfpp": @[@"sds", @"dsds",@"sdsdsds", @"ddgdsds"]
             };
}

- (NSData *)exportJSONData
{
    NSDictionary *dict = [self exportJSON];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:(NSJSONWritingOptions)(self.prettyPrinted ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    return jsonData;
}
@end

#pragma mark -

@implementation WTRTBundleObject

+ (instancetype)bundleObject
{
    return [[WTRTBundleObject alloc] init];
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

- (NSDictionary *)userDefineClassesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTClassObject *class in _userDefineClasses) {
        [dict addEntriesFromDictionary:@{
                                         class.className: [class exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)classesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTClassObject *class in _classes) {
        [dict addEntriesFromDictionary:@{
                                         class.className: [class exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)exportJSON
{
    return @{
             @"displayName": _displayName,
             @"versionName": _versionNumber,
             @"bundleName": _bundleName,
             @"buildNumber": _buildNumber,
             @"class": [self classesString],
             @"userclass": [self userDefineClassesString]
             };
}

@end

#pragma mark -

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
    _variables = [NSMutableArray array];
    _properties = [NSMutableArray array];
    _classMethods = [NSMutableArray array];
    _instanceMethods = [NSMutableArray array];
    
}

- (void)initialize {
    [_variables removeAllObjects];
    [_properties removeAllObjects];
    [_classMethods removeAllObjects];
    [_instanceMethods removeAllObjects];
}

- (NSDictionary *)instanceMethodsString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTMethodObject *method in _instanceMethods) {
        [dict addEntriesFromDictionary:@{
                                         method.methodName: [method exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)classMethodsString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTMethodObject *method in _classMethods) {
        [dict addEntriesFromDictionary:@{
                                         method.methodName: [method exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)variablesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTVariableObject *variable in _variables) {
        [dict addEntriesFromDictionary:@{
                                         variable.variableName: [variable exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)exportJSON
{
    return @{
             @"className": _className,
             @"superClass": _superClassName,
             @"instanceMethods": [self instanceMethodsString],
             @"classMethods": [self classMethodsString],
             @"variable": [self variablesString]
             };
}

@end

#pragma mark -

@implementation WTRTVariableObject

+ (instancetype)variableObject
{
    return [[WTRTVariableObject alloc] init];
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
    
}

- (void)initialize {
    _variableName = @"";
    _typeName = @"";
}

- (NSDictionary *)exportJSON
{
    return @{
             @"variableName": _variableName,
             @"typeName": _typeName,
             };
}

@end

#pragma mark -

@implementation WTRTPropertyObject

+ (instancetype)propertyObject
{
    return [[WTRTPropertyObject alloc] init];
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
    
}

- (void)initialize {
}

- (NSDictionary *)exportJSON
{
    return @{
             @"propertyName": _propertyName,
             };
}

@end

#pragma mark -

@implementation WTRTProtocolObject

+ (instancetype)protocolObject
{
    return [[WTRTProtocolObject alloc] init];
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
    
}

- (void)initialize {
}

- (NSDictionary *)exportJSON
{
    return @{
             @"protocolName": _protocolName,
             };
}

@end

#pragma mark -

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

- (NSDictionary *)exportJSON
{
    return @{
             @"methodName": _methodName,
             };
}

@end
