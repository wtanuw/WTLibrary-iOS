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
#import <WTLibrary_iOS/WTWatLog.h>

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
        _structureVersion = 0.8;
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
    //NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    //WatLog(@"%@", json);
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        WatLog(@"its an array!");
        WatLog(@"jsonArray - %@",(NSArray *)jsonObject);
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
    _json = nil;
    _projectFolderPath = @"";
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"project: %@", _projectName];
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    double jsonStructureVersion = [jsonDict[@"structureVersion"] doubleValue];
    NSAssert(self.structureVersion >= jsonStructureVersion, @"differnt reader and parser vresion");
    
    _projectName = jsonDict[@"projectName"];
    if (jsonDict[@"projectFolderPath"]) {
        _projectFolderPath = jsonDict[@"projectFolderPath"];
    }
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
             @"structureVersion": [NSNumber numberWithDouble:self.structureVersion],
             @"projectName": _projectName,
             @"isIOS": [NSNumber numberWithBool:_isIOS],
             @"isMacOS": [NSNumber numberWithBool:_isMacOS],
             @"projectFolderPath": _projectFolderPath,
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
//    _userDefineClasses = [NSMutableDictionary dictionary];
    
}

- (void)initialize {
    [_classes removeAllObjects];
//    [_userDefineClasses removeAllObjects];
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _displayName = jsonDict[@"displayName"];
    _versionNumber = jsonDict[@"versionNumber"];
    _bundleName = jsonDict[@"bundleName"];
    _buildNumber = jsonDict[@"buildNumber"];
    for (NSDictionary *dict in [jsonDict[@"class"] allObjects]) {
        WTRTClassObject *class = [WTRTClassObject classObject];
        [class importJSON:dict];
        [_classes addEntriesFromDictionary:@{
                                             class.currentClassName: class
                                             }];
    }
//    for (NSDictionary *dict in [jsonDict[@"userDefineClass"] allObjects]) {
//        WTRTClassObject *class = [WTRTClassObject classObject];
//        [class importJSON:dict];
//        [_userDefineClasses addEntriesFromDictionary:@{
//                                                       class.currentClassName: class
//                                                       }];
//    }
}

- (NSDictionary *)classesString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTClassObject *class in _classes.allValues) {
        [dict addEntriesFromDictionary:@{
                                         class.currentClassName: [class exportJSON]
                                         }];
    }
    return dict;
}

//- (NSDictionary *)userDefineClassesString
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    for (WTRTClassObject *class in _userDefineClasses.allValues) {
//        [dict addEntriesFromDictionary:@{
//                                         class.currentClassName: [class exportJSON]
//                                         }];
//    }
//    return dict;
//}

- (NSDictionary *)exportJSON
{
    return @{
             @"displayName": _displayName,
             @"versionNumber": _versionNumber,
             @"bundleName": _bundleName,
             @"buildNumber": _buildNumber,
             @"class": [self classesString],
//             @"userDefineClass": [self userDefineClassesString]
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
    _protocolMethods = [NSMutableDictionary dictionary];
}

- (void)initialize {
    [_variables removeAllObjects];
    [_properties removeAllObjects];
    [_protocols removeAllObjects];
    [_classMethods removeAllObjects];
    [_instanceMethods removeAllObjects];
    [_protocolMethods removeAllObjects];
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _currentClassName = jsonDict[@"currentClassName"];
    _superClassName = jsonDict[@"superClassName"];
    _bundleName = jsonDict[@"bundleName"];
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
    for (NSDictionary *dict in [jsonDict[@"protocolMethods"] allObjects]) {
        WTRTMethodObject *method = [WTRTMethodObject methodObject];
        [method importJSON:dict];
        [_protocolMethods addEntriesFromDictionary:@{
                                                  method.methodName: method}];
    }
    for (NSDictionary *dict in [jsonDict[@"variable"] allObjects]) {
        WTRTVariableObject *variable = [WTRTVariableObject variableObject];
        [variable importJSON:dict];
        [_variables addEntriesFromDictionary:@{
                                                  variable.variableName: variable}];
    }
    for (NSDictionary *dict in [jsonDict[@"properties"] allObjects]) {
        WTRTPropertyObject *property = [WTRTPropertyObject propertyObject];
        [property importJSON:dict];
        [_properties addEntriesFromDictionary:@{
                                                  property.propertyName: property}];
    }
    for (NSDictionary *dict in [jsonDict[@"protocols"] allObjects]) {
        WTRTProtocolObject *protocol = [WTRTProtocolObject protocolObject];
        [protocol importJSON:dict];
        [_protocols addEntriesFromDictionary:@{
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

- (NSDictionary *)protocolMethodsString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WTRTMethodObject *method in _protocolMethods.allValues) {
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
             @"currentClassName": _currentClassName,
             @"superClassName": _superClassName,
//             @"bundleName": _bundleName,
             @"instanceMethods": [self instanceMethodsString],
             @"classMethods": [self classMethodsString],
             @"protocolMethods": [self protocolMethodsString],
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
    _type = @"";
    _typeName = @"";
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _variableName = jsonDict[@"variableName"];
    _type = jsonDict[@"type"];
    _typeName = jsonDict[@"typeName"];
}

- (NSDictionary *)exportJSON
{
    return @{
             @"variableName": _variableName,
             @"type": _type,
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
    _propertyName = @"";
    _type = @"";
    _typeName = @"";
    _variableName = @"";
    _customGetterName = @"";
    _customSetterName = @"";
    _haveVariable = NO;
    _haveCustomGetter = NO;
    _haveCustomSetter = NO;
    _readOnly = NO;
    _strong = NO;
    _weak = NO;
    _copy = NO;
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _propertyName = jsonDict[@"propertyName"];
    _type = jsonDict[@"type"];
    _typeName = jsonDict[@"typeName"];
    _variableName = jsonDict[@"variableName"];
    _customGetterName = jsonDict[@"customGetterName"];
    _customSetterName = jsonDict[@"customSetterName"];
    _haveVariable = [jsonDict[@"haveVariable"] boolValue];
    _haveCustomGetter = [jsonDict[@"haveCustomGetter"] boolValue];
    _haveCustomSetter = [jsonDict[@"haveCustomSetter"] boolValue];
    _readOnly = [jsonDict[@"readOnly"] boolValue];
    _strong = [jsonDict[@"strong"] boolValue];
    _weak = [jsonDict[@"weak"] boolValue];
    _copy = [jsonDict[@"copy"] boolValue];
}

- (NSDictionary *)exportJSON
{
    return @{
             @"propertyName": _propertyName,
             @"type": _type,
             @"typeName": _typeName,
             @"haveVariable": [NSNumber numberWithBool:_haveVariable],
             @"variableName": _variableName,
             @"haveCustomGetter": [NSNumber numberWithBool:_haveCustomGetter],
             @"customGetterName": _customGetterName,
             @"haveCustomSetter": [NSNumber numberWithBool:_haveCustomSetter],
             @"customSetterName": _customSetterName,
             @"readOnly": [NSNumber numberWithBool:_readOnly],
             @"strong": [NSNumber numberWithBool:_strong],
             @"weak": [NSNumber numberWithBool:_weak],
             @"copy": [NSNumber numberWithBool:_copy],
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
    _isInstance = YES;
    _fromProtocolName = @"non";
    _isRequireProtocolMethod = NO;
    _isOptionalProtocolMethod = NO;
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    _methodName = jsonDict[@"methodName"];
    _isInstance = [jsonDict[@"isInstance"] boolValue];
    _fromProtocolName = jsonDict[@"fromProtocolName"];
    _isRequireProtocolMethod = [jsonDict[@"isRequireProtocolMethod"] boolValue];
    _isOptionalProtocolMethod = [jsonDict[@"isOptionalProtocolMethod"] boolValue];
}

- (NSDictionary *)exportJSON
{
    if (_isRequireProtocolMethod || _isOptionalProtocolMethod) {
        return @{
                 @"methodName": _methodName,
                 @"isInstance": [NSNumber numberWithBool:_isInstance],
                 @"fromProtocolName": _fromProtocolName,
                 @"isRequireProtocolMethod": [NSNumber numberWithBool:_isRequireProtocolMethod],
                 @"isOptionalProtocolMethod": [NSNumber numberWithBool:_isOptionalProtocolMethod],
                 };
    } else {
        return @{
                 @"methodName": _methodName,
                 @"isInstance": [NSNumber numberWithBool:_isInstance]
                 };
    }
}

@end
