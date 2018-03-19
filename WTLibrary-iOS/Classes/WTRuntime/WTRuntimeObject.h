//
//  WTRuntimeObject.h
//  WTLibrary-iOS
//
//  Created by iMac on 2/16/18.
//  Copyright © 2018 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTRTProjectObject;
@class WTRTBundleObject;
@class WTRTClassObject;
@class WTRTVariableObject;
@class WTRTPropertyObject;
@class WTRTProtocolObject;
@class WTRTMethodObject;

@interface WTRuntimeObject : NSObject
@property (nonatomic, assign) BOOL prettyPrinted; // default is YES
@property (nonatomic, assign) int a;
@property (nonatomic, assign) signed int b;
@property (nonatomic, assign) unsigned int c;
@property (nonatomic, assign) short int d;
@property (nonatomic, assign) long int e;
@property (nonatomic, assign) long long int f;
@property (nonatomic, assign) NSInteger g;
@property (nonatomic, assign) NSUInteger h;
@property (nonatomic, assign) float z;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) NSUInteger x;
- (void)importJSON:(NSDictionary *)jsonDict; // for subclass
- (NSDictionary *)exportJSON; // for subclass
- (void)importJSONString:(NSString *)jsonString;
- (NSString *)exportJSONString;
@end

@interface WTRTProjectObject : WTRuntimeObject
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, assign) BOOL isIOS;
@property (nonatomic, assign) BOOL isMacOS;
@property (nonatomic, strong) WTRTBundleObject *mainBundle;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTBundleObject *> *bundles;
@property (nonatomic, strong) NSString *json;
+ (instancetype)projectObject;
+ (WTRTProjectObject*)startParser:(NSString*)filePath;
- (NSString *)exportJSONData;
@end

@interface WTRTBundleObject : WTRuntimeObject
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *versionNumber;
@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, strong) NSString *buildNumber;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTClassObject *> *classes;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTClassObject *> *userDefineClasses;
+ (instancetype)bundleObject;
@end

@interface WTRTClassObject : WTRuntimeObject
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *superClassName;
@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSString *> *superClass;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTVariableObject *> *variables;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTPropertyObject *> *properties;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTProtocolObject *> *protocols;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTMethodObject *> *classMethods;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WTRTMethodObject *> *instanceMethods;
+ (instancetype)classObject;
@end

@interface WTRTVariableObject : WTRuntimeObject
@property (nonatomic, strong) NSString *variableName;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *typeKey;
@property (nonatomic, strong) WTRTPropertyObject *property;
+ (instancetype)variableObject;
@end

@interface WTRTPropertyObject : WTRuntimeObject
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) WTRTVariableObject *variable;
//@property (nonatomic, readonly) NSString *getter;
//@property (nonatomic, readonly) NSString *setter;
//@property (nonatomic, readonly) BOOL haveGetter;
//@property (nonatomic, readonly) BOOL haveSetter;
//@property (nonatomic, readonly) BOOL isVisible;
+ (instancetype)propertyObject;
@end

@interface WTRTProtocolObject : WTRuntimeObject
@property (nonatomic, strong) NSString *protocolName;
//@property (nonatomic, readonly) NSArray<WTRTVariableObject *> *params;
//@property (nonatomic, assign) BOOL isVisible;
+ (instancetype)protocolObject;
@end

@interface WTRTMethodObject : WTRuntimeObject
@property (nonatomic, strong) NSString *methodName;
//@property (nonatomic, assign) int numberOfArgument;
//@property (nonatomic, readonly) NSArray<WTRTVariableObject *> *params;
//@property (nonatomic, assign) BOOL isVisible;
+ (instancetype)methodObject;
@end
