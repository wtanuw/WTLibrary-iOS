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
//    [self setup];
//    [self initialize];
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
    WatLog(@"%@", json);
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        WatLog(@"its an array!");
        NSArray *jsonArray = (NSArray *)jsonObject;
        WatLog(@"jsonArray - %@",jsonArray);
    } else {
        WatLog(@"its probably a dictionary");
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        WatLog(@"jsonDictionary - %@",jsonDictionary);
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

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    [self setup];
    [self initialize];
    return self;
}


- (void)setup {
    _bundles = [NSMutableDictionary dictionary];
}

- (void)initialize {
    [_bundles removeAllObjects];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"project: %@", _projectName];
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _projectName = jsonDict[@"projectName"];
    _isIOS = [jsonDict[@"isIOS"] boolValue];
    _isMacOS = [jsonDict[@"isMacOS"] boolValue];
//    NSString *mainBundleName = jsonDict[@"mainBundleName"];
    for (NSDictionary *dict in [jsonDict[@"bundle"] allObjects]) {
        WTRTBundleObject *bundle = [WTRTBundleObject bundleObject];
        [bundle importJSON:dict];
        [_bundles addEntriesFromDictionary:@{
                                             bundle.bundleName: bundle
           }];
//        if ([mainBundleName isEqualToString:bundle.bundleName]) {
//            _mainBundle = bundle;
//        }
    }
    _mainBundle = [WTRTBundleObject bundleObject];
    [_mainBundle importJSON:jsonDict[@"mainBundle"]];
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

- (NSDictionary *)exportJSON
{
    return @{
             @"projectName": _projectName,
             @"isIOS": [NSNumber numberWithBool:_isIOS],
             @"isMacOS": [NSNumber numberWithBool:_isMacOS],
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
    _classes = [NSMutableDictionary dictionary];
    _userDefineClasses = [NSMutableDictionary dictionary];
    
}

- (void)initialize {
    [_classes removeAllObjects];
    [_userDefineClasses removeAllObjects];
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _displayName = jsonDict[@"displayName"];
    _versionNumber = jsonDict[@"versionName"];
    _bundleName = jsonDict[@"bundleName"];
    _buildNumber = jsonDict[@"buildNumber"];
    for (NSDictionary *dict in [jsonDict[@"class"] allObjects]) {
        WTRTClassObject *class = [WTRTClassObject classObject];
        [class importJSON:dict];
        [_classes addEntriesFromDictionary:@{
                                             class.className: class
                                             }];
    }
    for (NSDictionary *dict in [jsonDict[@"userclass"] allObjects]) {
        WTRTClassObject *class = [WTRTClassObject classObject];
        [class importJSON:dict];
        [_userDefineClasses addEntriesFromDictionary:@{
                                                       class.className: class
                                                       }];
    }
}

- (NSDictionary *)classesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTClassObject *class in _classes.allValues) {
        [dict addEntriesFromDictionary:@{
                                         class.className: [class exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)userDefineClassesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTClassObject *class in _userDefineClasses.allValues) {
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
    _variables = [NSMutableDictionary dictionary];
    _properties = [NSMutableDictionary dictionary];
    _protocols = [NSMutableDictionary dictionary];
    _classMethods = [NSMutableDictionary dictionary];
    _instanceMethods = [NSMutableDictionary dictionary];
    
}

- (void)initialize {
    [_variables removeAllObjects];
    [_properties removeAllObjects];
    [_protocols removeAllObjects];
    [_classMethods removeAllObjects];
    [_instanceMethods removeAllObjects];
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _className = jsonDict[@"className"];
    _superClassName = jsonDict[@"superClass"];
    for (NSDictionary *dict in [jsonDict[@"instanceMethods"] allObjects]) {
        WTRTMethodObject *method = [WTRTMethodObject methodObject];
        [method importJSON:dict];
        [_instanceMethods addEntriesFromDictionary:@{
                                                     method.methodName: method}];
    }
    for (NSDictionary *dict in [jsonDict[@"classMethods"] allObjects]) {
        WTRTMethodObject *method = [WTRTMethodObject methodObject];
        [method importJSON:dict];
        [_classMethods addEntriesFromDictionary:@{
                                                     method.methodName: method}];
    }
    for (NSDictionary *dict in [jsonDict[@"variable"] allObjects]) {
        WTRTVariableObject *variable = [WTRTVariableObject variableObject];
        [variable importJSON:dict];
        [_classMethods addEntriesFromDictionary:@{
                                                  variable.variableName: variable}];
    }
    for (NSDictionary *dict in [jsonDict[@"properties"] allObjects]) {
        WTRTPropertyObject *property = [WTRTPropertyObject propertyObject];
        [property importJSON:dict];
        [_classMethods addEntriesFromDictionary:@{
                                                  property.propertyName: property}];
    }
    for (NSDictionary *dict in [jsonDict[@"protocols"] allObjects]) {
        WTRTProtocolObject *protocol = [WTRTProtocolObject protocolObject];
        [protocol importJSON:dict];
        [_classMethods addEntriesFromDictionary:@{
                                                  protocol.protocolName: protocol}];
    }
}

- (NSDictionary *)instanceMethodsString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTMethodObject *method in _instanceMethods.allValues) {
        [dict addEntriesFromDictionary:@{
                                         method.methodName: [method exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)classMethodsString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTMethodObject *method in _classMethods.allValues) {
        [dict addEntriesFromDictionary:@{
                                         method.methodName: [method exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)variablesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTVariableObject *variable in _variables.allValues) {
        [dict addEntriesFromDictionary:@{
                                         variable.variableName: [variable exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)propertiesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTPropertyObject *property in _properties.allValues) {
        [dict addEntriesFromDictionary:@{
                                         property.propertyName: [property exportJSON]
                                         }];
    }
    return dict;
}

- (NSDictionary *)protocolsString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTProtocolObject *protocol in _protocols.allValues) {
        [dict addEntriesFromDictionary:@{
                                         protocol.protocolName: [protocol exportJSON]
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
             @"variable": [self variablesString],
             @"properties": [self propertiesString],
             @"protocols": [self protocolsString]
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

- (void)importJSON:(NSDictionary *)jsonDict
{
    _variableName = jsonDict[@"variableName"];
    _typeName = jsonDict[@"typeName"];
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

- (void)importJSON:(NSDictionary *)jsonDict
{
    _propertyName = jsonDict[@"propertyName"];
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

- (void)importJSON:(NSDictionary *)jsonDict
{
    _protocolName = jsonDict[@"protocolName"];
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
    
}

- (void)initialize {
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _methodName = jsonDict[@"methodName"];
}

- (NSDictionary *)exportJSON
{
    return @{
             @"methodName": _methodName,
             };
}

@end
