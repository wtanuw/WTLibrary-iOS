//
//  WTRuntimeObject.h
//  WTLibrary-iOS
//
//  Created by iMac on 2/16/18.
//  Copyright © 2018 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTRTApplicationObject;
@class WTRTClassObject;
@class WTRTVariableObject;
@class WTRTPropertyObject;
@class WTRTMethodObject;

@interface WTRuntimeObject : NSObject

@end

@interface WTProjectObject : NSObject

@end

@interface WTRTApplicationObject : NSObject
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *versionNumber;
@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, strong) NSString *buildNumber;
@property (nonatomic, readonly) NSMutableArray<WTRTClassObject *> *classes;
@property (nonatomic, readonly) NSMutableArray<WTRTClassObject *> *userDefineClasses;
+ (instancetype)applicationObject;
- (NSString *)exportjson;
@end

@interface WTRTClassObject : NSObject
@property (nonatomic, readonly) NSMutableArray<NSString *> *superClass;
@property (nonatomic, readonly) NSMutableArray<WTRTVariableObject *> *variables;
@property (nonatomic, readonly) NSMutableArray<WTRTPropertyObject *> *properties;
@property (nonatomic, readonly) NSMutableArray<WTRTMethodObject *> *methods;
+ (instancetype)classObject;
- (NSString *)exportjson;
@end

@interface WTRTVariableObject : NSObject
@property (nonatomic, readonly) NSString *name;
+ (instancetype)variableObject;
- (NSString *)exportjson;
@end

@interface WTRTPropertyObject : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) WTRTVariableObject *variable;
@property (nonatomic, readonly) NSString *getter;
@property (nonatomic, readonly) NSString *setter;
@property (nonatomic, readonly) BOOL haveGetter;
@property (nonatomic, readonly) BOOL haveSetter;
@property (nonatomic, readonly) BOOL isVisible;
+ (instancetype)propertyObject;
- (NSString *)exportjson;
@end

@interface WTRTMethodObject : NSObject
@property (nonatomic, readonly) NSArray<WTRTVariableObject *> *params;
@property (nonatomic, readonly) BOOL isVisible;
+ (instancetype)methodObject;
- (NSString *)exportjson;
@end
