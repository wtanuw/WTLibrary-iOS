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
@interface WTRuntimeObject : NSObject

@end

@interface WTRTProjectObject : NSObject

@end

@interface WTRTClassObject : NSObject
@property (nonatomic, assign) NSArray *properties;
@property (nonatomic, assign) NSArray *methods;
-(NSString *)exportcsv;
@end

@interface WTRTVariableObject : NSObject
@property (nonatomic, assign) NSString *name;
@end

@interface WTRTPropertyObject : NSObject
@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) WTRTVariableObject *variable;
@property (nonatomic, assign) NSString *getter;
@property (nonatomic, assign) NSString *setter;
@end

@interface WTRTMethodObject : NSObject
@property (nonatomic, assign) NSArray<WTRTVariableObject*> *params;

@end
