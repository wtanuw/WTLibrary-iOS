//
//  WTRuntimeObject.h
//  WTLibrary-iOS
//
//  Created by iMac on 2/16/18.
//  Copyright © 2018 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 untime.h ‣ 
 #import <objc/runtime.h> ‣ 
 a number of C functions to interact with the runtime 
 ‣ Several “categories” of interactions 
 ‣ objc_... interact with toplevel runtime (eg register a class) 
 ‣ class_... interact with classes (eg make subclass) 
 ‣ object_... interact with objects (eg get classname) 
 ‣ method_... interact with methods (eg get the number of arguments) 
 ‣ ivar_... interact with ivars (eg get the type of an ivar) 
 ‣ property_... interact with properties (eg get the name of a property) 
 ‣ protocol_... interact with protocols (eg get properties of a protocol) 
 ‣ sel_... interact with selectors (eg register selector names) 
 ‣ imp_...  interact with method implementations (provide implementations using blocks)
 
 - iskindofclass
 - class
 
 NSStringfromclass
 NSSelectorFromString
 
 
 */

@class WTRTProjectObject;
@class WTRTClassObject;
@class WTRTVariableObject;
@class WTRTPropertyObject;
@class WTRTMethodObject;

@interface WTRuntimeObject : NSObject

@end

@interface WTRTProjectObject : NSObject
@property (nonatomic, readonly) NSArray<WTRTClassObject *> *classes;
@property (nonatomic, readonly) NSArray<WTRTClassObject *> *userDefineClasses;
-(NSString *)exportjson;
@end

@interface WTRTClassObject : NSObject
@property (nonatomic, readonly) NSArray<WTRTVariableObject *> *variables;
@property (nonatomic, readonly) NSArray<WTRTPropertyObject *> *properties;
@property (nonatomic, readonly) NSArray<WTRTMethodObject *> *methods;
-(NSString *)exportjson;
@end

@interface WTRTVariableObject : NSObject
@property (nonatomic, readonly) NSString *name;
-(NSString *)exportjson;
@end

@interface WTRTPropertyObject : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) WTRTVariableObject *variable;
@property (nonatomic, readonly) NSString *getter;
@property (nonatomic, readonly) NSString *setter;
@property (nonatomic, readonly) BOOL haveGetter;
@property (nonatomic, readonly) BOOL haveSetter;
@property (nonatomic, readonly) BOOL isVisible;
-(NSString *)exportjson;
@end

@interface WTRTMethodObject : NSObject
@property (nonatomic, readonly) NSArray<WTRTVariableObject *> *params;
@property (nonatomic, readonly) BOOL isVisible;
-(NSString *)exportjson;
@end
