//
//  WTRuntimeReader.m
//  WTLibrary-iOS
//
//  Created by iMac on 2/16/18.
//  Copyright © 2018 Wat Wongtanuwat. All rights reserved.
//

#import "WTRuntimeReader.h"
//#import <UIKit/UIKit.h>
//#import "objc/objc-class.h"
//#import <objc/objc-runtime.h>


//#define WATLOG_DEBUG
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//#include <Cocoa.h>
#import "WTMacro.h"
#import "WTBundleInfo.h"
#import "WTPath.h"

//http://www.cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html

/*
 
 struct
 
 /// An opaque type that represents a method in a class definition.
 typedef struct objc_method *Method;
 
 /// An opaque type that represents an instance variable.
 typedef struct objc_ivar *Ivar;
 
 /// An opaque type that represents a category.
 typedef struct objc_category *Category;
 
 /// An opaque type that represents an Objective-C declared property.
 typedef struct objc_property *objc_property_t;
 
 
 
 
 */


#define kProjectLevel @"kProject"
#define kClassLevel @"kProject"

@interface WTRuntimeReader()

@property (nonatomic, strong) NSArray *prefixIgnoreList;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) WTRTProjectObject *project;


@end

#pragma mark -

@implementation WTRuntimeReader

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
    _dict = [NSMutableDictionary dictionary];
    _prefixIgnoreList = @[
                   @"WK", @"NSLeaf", @"__NSGenericDeallocHandler",
                   @"_NSZombie_", @"__NSMessageBuilder", @"__NSAtom",
                   @"_CNZombie_",
                   @"JSExport",
                   @"__ARCLite__",
                   @"FigIrisAutoTrimmerMotionSampleExport",
                   @"NSViewServiceApplication",
                   @"PFEmbeddedMulticasterImplementation", @"PFMulticasterDistributionMethods"
                   ];
    
}

- (void)initialize {
    [_dict removeAllObjects];
}

+ (void)startReader {
#if DEBUG
    [[WTRuntimeReader sharedReader] startReader];
#endif
}

- (void)startReader {
#if DEBUG
    [self readProject];
    [self exportToFile:_project.projectName];
#endif
}

- (void)exportToFile:(NSString*)fileName
{
    NSString *json = [_project exportJSONString];
    NSString *tmpPath =  [WTPath desktopDirectoryPath];
    NSArray *filePathComponent =  [tmpPath componentsSeparatedByString:@"/"];
    
    NSString *desktopPath = @"/Users/";
//    NSString *desktopPath = @"/Users/imac/Desktop";
//    NSString *desktopPath = @"/Users/wat/Desktop";
    if ([filePathComponent count] > 2) {
        desktopPath = [NSString stringWithFormat:@"/Users/%@/Desktop", filePathComponent[2]];
    }
    
    NSString *jsonFilePath = [desktopPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"json"]];
//    NSString *txtFilePath = [desktopPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"txt"]];
    BOOL success = [json writeToFile:jsonFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    WatLog(@"%@",WTBOOL(success));
//    success = [json writeToFile:txtFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    WatLog(@"%@",WTBOOL(success));
}

- (void)readProject {
    
    WatLog(@"\n");    
    _project = [WTRTProjectObject projectObject];
    _project.projectName = [WTBundleInfo bundleName];
    
#ifdef SAVEPATH
    _project.projectFolderPath = [SAVEPATH stringByDeletingLastPathComponent];
#else
#endif
    
#if TARGET_OS_IPHONE
    _project.isIOS = YES;
    _project.isMacOS = NO;
#else
    _project.isIOS = NO;
    _project.isMacOS = YES;
#endif
    
    // do something with classes
    [self getClassInProject:_project];
    
}

- (BOOL)checkIgnoreList:(NSString*)classString
{
    BOOL shouldIgnore = NO;
    for (NSString *prefix in _prefixIgnoreList) {
        if ([classString hasPrefix:prefix]) {
            shouldIgnore = YES;
        }
    }
    return shouldIgnore;
}

- (void)getClassInProject:(WTRTProjectObject *)project {
    
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    if (numClasses < 0 ) {
        return;
    }
    WatLog(@"%@ found class", @"###");
    
    //NSBundle *mainBundle = [NSBundle mainBundle];
    
    classes = (Class *)(malloc(sizeof(Class) * numClasses));
    numClasses = objc_getClassList(classes, numClasses);
    WatLog(@"### number of class: %d", numClasses);
    
    for (NSInteger i = 0; i < numClasses; i++) {
        
        Class c = classes[i];
        
        // prevent crash
        NSString *ccc = NSStringFromClass(c);
        if ([self checkIgnoreList:ccc]) {
            continue;
        }
        
        NSBundle *b = [NSBundle bundleForClass:c];
//        NSBundle *b = [NSBundle bundleForClass:[c class]];
        WTBundleInfo *info = [WTBundleInfo bundleInfoWithBundle:b];
        NSString *bundleName = info.bundleName;
        
        if (!bundleName) {
            bundleName = @"nilBundle";
        }
        
        WTRTBundleObject *bundle = project.bundles[bundleName];
        
        if (!bundle) {
            bundle = [WTRTBundleObject bundleObject];
            bundle.displayName = info.displayName;
            bundle.versionNumber = info.versionNumber;
            bundle.bundleName = info.bundleName;
            bundle.buildNumber = info.buildNumber;
            
            [_project.bundles addEntriesFromDictionary:@{
                                                         bundleName: bundle
                                                             }];
            
            if ([info.bundleName isEqualToString:[WTBundleInfo bundleName]]) {
                project.mainBundle = bundle;
            }
        }
        
        if ([info.bundleName isEqualToString:[WTBundleInfo bundleName]]) {
            WatLog(@"@@@ classname: %s in bundle: %@", class_getName(c), info.bundleName);
            NSString *name = [NSString stringWithFormat:@"%s",class_getName(c)];
            NSString *superClass = @"";
            
            if (class_getSuperclass(c)) {
                superClass = [NSString stringWithFormat:@"%@",class_getSuperclass(c)];
                WatLog(@"@@@ name - %@ (%@)",name, superClass);
            }
            
            
            WTRTClassObject *class = [WTRTClassObject classObject];
            class.currentClassName = name;
            class.superClassName = superClass;
            [bundle.classes addEntriesFromDictionary:@{
                                                       class.currentClassName: class
                                                       }];
            
            if(![superClass isEqualToString:@"(null)"]){
                
                //                if([name hasPrefix:@"TAG"] || [name hasPrefix:@"TID"] || [name hasPrefix:@"AF"] || [name hasPrefix:@"GAI"]){
                //
                //                }else{
                [self getClassMethodInClass:c classObject:class];
                [self getInstanceMethodInClass:c classObject:class];
                [self getVariableInClass:c classObject:class];
                [self getPropertyInClass:c classObject:class];
                [self getProtocolInClass:c classObject:class];
                //                }
            } else {
                
            }

        } else {
            WatLog(@"@@@ classname: %s in bundle: %@", class_getName(c), info.bundleName);
            NSString *name = [NSString stringWithFormat:@"%s",class_getName(c)];
            NSString *superClass = @"";
            
            if (class_getSuperclass(c)) {
                superClass = [NSString stringWithFormat:@"%@",class_getSuperclass(c)];
                WatLog(@"@@@ name - %@ (%@)",name, superClass);
            }
            
            WTRTClassObject *class = [WTRTClassObject classObject];
            class.currentClassName = name;
            class.superClassName = superClass;
            class.bundleName = bundleName;
            [bundle.classes addEntriesFromDictionary:@{
                                                       class.currentClassName: class
                                                       }];
            
            if(![superClass isEqualToString:@"(null)"]){
                
//                [self getClassMethodInClass:c classObject:class];
//                [self getInstanceMethodInClass:c classObject:class];
//                [self getVariableInClass:c classObject:class];
//                [self getPropertyInClass:c classObject:class];
//                [self getProtocolInClass:c classObject:class];
                
            } else {
                
            }

        }
    }
    free(classes);

}

// Get Var in Class
- (void)getVariableInClass:(Class)class classObject:(WTRTClassObject *)classObject {
    
    WatLog(@"\n");
    WatLog(@"%@------- VARIABLE ------", @"***");
    WatLog(@"%@--- of class %@ ---", @"***", classObject.currentClassName);
    
    Class currentClass = class;
    
    unsigned int variableCount = 0;
    int i = 0;
    Ivar* ivars = class_copyIvarList(currentClass, &variableCount);
    for(const Ivar* p = ivars; p < ivars+variableCount; p++)
    {
        Ivar const ivar = *p;
        NSString *variableName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        WTRTVariableObject *variable = [WTRTVariableObject variableObject];
        variable.variableName = variableName;
        [classObject.variables addEntriesFromDictionary:@{
                                                          variable.variableName: variable
                                                          }];
        
        WatLog(@"%2.2d variable %@ ==> %@ ", i, classObject.currentClassName, variableName);i++;
        
        const char *type = ivar_getTypeEncoding(ivar);
        NSString *typeString;
        
        NSString *s = [NSString stringWithFormat:@"%s",type];
        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        switch (type[0]) {
            case 'c':
                typeString = @"char";
                break;
            case 'i':
                typeString = @"int";
                break;
            case 's':
                typeString = @"short";
                break;
            case 'l':
                typeString = @"long";
                break;
            case 'q':
                typeString = @"long long";
                break;
            case 'C':
                typeString = @"unsigned char";
                break;
            case 'I':
                typeString = @"unsigned int";
                break;
            case 'S':
                typeString = @"unsigned short";
                break;
            case 'L':
                typeString = @"unsigned long";
                break;
            case 'Q':
                typeString = @"unsigned long long";
                break;
            case 'f':
                typeString = @"float";
                break;
            case 'd':
                typeString = @"double";
                break;
            case '*':
                typeString = @"string";
                break;
            case '@':
            case '#':
                typeString = s;
                break;
            case ':':
                typeString = @"selector";
                break;
            default:
                typeString = @"default";
                break;
        }
        
        variable.type = s;
        variable.typeName  = typeString;
    }
    
    free(ivars);
    
}

- (void)getPropertyInClass:(Class)class classObject:(WTRTClassObject *)classObject {
    
    WatLog(@"\n");
    WatLog(@"%@------- PROPERTY ------", @"***");
    WatLog(@"%@--- of class %@ ---", @"***", classObject.currentClassName);
    
    Class currentClass = class;
    
    unsigned int propertyCount = 0;
    
    objc_property_t* propertys = class_copyPropertyList(currentClass, &propertyCount);
    for(const objc_property_t* p = propertys; p < propertys+propertyCount; p++)
    {
        objc_property_t const propertyt = *p ;
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyt)];
//        const char *type = ivar_getTypeEncoding(ivar);
        //NSString *typeString;
        
//        NSString *s = [NSString stringWithFormat:@"%s",type];
//        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
//        NSString *typeName = s;
        
        WTRTPropertyObject *property = [WTRTPropertyObject propertyObject];
        property.propertyName = propertyName;
//        variable.typeName = typeName;
        
        unsigned int numOfAttributes = 0;
        objc_property_attribute_t *propertyAttributes = property_copyAttributeList(propertyt, &numOfAttributes);
        for ( unsigned int ai = 0; ai < numOfAttributes; ai++ ) {
            const char *name = propertyAttributes[ai].name;
            const char *value = propertyAttributes[ai].value;
            switch (name[0]) {
                case 'V':
                    property.variableName = [self removeQuoteString:value];;
                    property.haveVariable = YES;
                    break;
                case 'T': // type
                    property.type = [self removeQuoteString:value];
                    break;
                case 'R': // readonly : The property is read-only (readonly).
                    property.readOnly = YES;
                    break;
                case 'C': // copy : The property is a copy of the value last assigned (copy).
                    property.copy = YES;
                    break;
                case '&': // retain : The property is a reference to the value last assigned (retain).
                    property.strong = YES;
                    break;
                case 'N': // nonatomic : The property is non-atomic (nonatomic).
                    break;
                case 'G': // custom getter : The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
                    property.haveCustomGetter = YES;
                    property.customGetterName = [self removeQuoteString:value];
                    break;
                case 'S': // custom setter : The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
                    property.haveCustomSetter = YES;
                    property.customSetterName = [self removeQuoteString:value];
                    break;
                case 'D': // dynamic : The property is dynamic (@dynamic).
                    break;
                case 'W': // : The property is a weak reference (__weak).
                    property.weak = YES;
                    break;
                case 'P': // : The property is eligible for garbage collection.
                    break;
                case 't': // : Specifies the type using old-style encoding.
                    break;
                default:
                    break;
            }
        }
        free(propertyAttributes);
    
        [classObject.properties addEntriesFromDictionary:@{
                                                           property.propertyName: property
                                                           }];
    }
    free(propertys);
}

//https://stackoverflow.com/questions/9252147/objective-c-looping-through-all-properties-in-a-class
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
//- (void)propertyTypeForClass {
//    unsigned int numOfProperties;
//    objc_property_t *properties = class_copyPropertyList([self class], &numOfProperties);
//    for ( unsigned int pi = 0; pi < numOfProperties; pi++ ) {
//        // Examine the property attributes
//        unsigned int numOfAttributes;
//        objc_property_attribute_t *propertyAttributes = property_copyAttributeList(properties[pi], &numOfAttributes);
//        for ( unsigned int ai = 0; ai < numOfAttributes; ai++ ) {
//            switch (propertyAttributes[ai].name[0]) {
//                case 'T': // type
//                    break;
//                case 'R': // readonly
//                    break;
//                case 'C': // copy
//                    break;
//                case '&': // retain
//                    break;
//                case 'N': // nonatomic
//                    break;
//                case 'G': // custom getter
//                    break;
//                case 'S': // custom setter
//                    break;
//                case 'D': // dynamic
//                    break;
//                default:
//                    break;
//            }
//        }
//        free(propertyAttributes);
//    }
//    free(properties);
//}

- (void)getProtocolInClass:(Class)class classObject:(WTRTClassObject *)classObject {

    Class currentClass = class;
    
    unsigned int protocolCount = 0;
    
    __unsafe_unretained Protocol** protocols = class_copyProtocolList(currentClass, &protocolCount);
    for(unsigned i = 0; i < protocolCount; i++){
        Protocol* ptc = protocols[i] ;
        NSString *protocolName = [NSString stringWithUTF8String:protocol_getName(ptc)];
//        const char *type = ivar_getTypeEncoding(ptc);
//        NSString *typeString;
        
//        NSString *s = [NSString stringWithFormat:@"%s",type];
//        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
//        NSString *typeName = s;
        
        WTRTProtocolObject *protocol = [WTRTProtocolObject protocolObject];
        protocol.protocolName = protocolName;
        [classObject.protocols addEntriesFromDictionary:@{
                                                          protocol.protocolName: protocol
                                                          }];
        
        [self getInstanceMethodInProtocol:ptc protocolObject:protocol classObject:classObject];
    }
    
}
//
////Get Method in Class
//- (void)getMethodInClass:(Class)c classObject:(WTRTClassObject *)classObject {
//    
//    WatLog(@"\n");
//    
//    WatLog(@"%@------- METHOD ------", @"***");
//    WatLog(@"%@--- %@ ---", @"***", classObject.currentClassName);
//    
//    
//    Class class = [c class];
////    unsigned int count;
////    
////    // get class method of class
//////    class_copyMethodList(object_getClass(class), &count);
////    
////    // get method of class
////    Method *methods = class_copyMethodList(class, &count);
////
////    //get super class method
//////    class_getInstanceMethod(Class cls, SEL name)
//////    
//////    class_getClassMethod(Class cls, SEL name)
////    
////    // iterate over them and print out the method name
////    for (int i=0; i<count; i++) {
////        Method *method = &methods[i];
////        SEL selector = method_getName(*method);
////        WatLog(@"%@ Method: %@", @"===", NSStringFromSelector(selector));
////        
////        const char *type = method_getTypeEncoding(*method);
////        if (type) {
////            
////        }
////        NSString *s = [NSString stringWithFormat:@"%s",type];
////        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
////        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
////        
////        WatLog(@"%@ Method: %@", @"===", s);
////        
////    }
//    
//    unsigned int methodCount = 0;
//    Method *methods = class_copyMethodList(class, &methodCount);
//    for (int i = 0; i < methodCount; i++)
//    {
//        Method method = methods[i];
//        SEL methodSelector = method_getName(method);
//        const char* methodName = sel_getName(methodSelector);
//        
//        const char *typeEncodings = method_getTypeEncoding(method);
//        
//        char returnType[80];
//        method_getReturnType(method, returnType, 80);
//        
//        NSLog(@"%2.2d %@ ==> %s (%s)", 0, classObject.currentClassName, methodName, (typeEncodings == Nil) ? "" : typeEncodings);
//        
//        int ac = method_getNumberOfArguments(method);
//        int a = 0;
//        for (a = 0; a < ac; a++) {
//            char argumentType[80];
//            method_getArgumentType(method, a, argumentType, 80);
//            NSLog(@"   Argument no #%d: %s", a, argumentType);
//        }
//    }
//    
//    printf("Found %d methods on '%s'\n", methodCount, class_getName(class));
//    for(const Method* p = methods; p < methods+methodCount; p++){
//        Method const ivar = *p;
//        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        const char *type = method_getTypeEncoding(ivar);
//        NSString *s = [NSString stringWithFormat:@"%s",type];
//        NSMethodSignature * sig = [NSMethodSignature signatureWithObjCTypes:type];
////        printf("\t %d  %s",[sig numberOfArguments], [sig getArgumentTypeAtIndex:0]);
//    }
//    for (unsigned int i = 0; i < methodCount; i++) {
//        Method method = methods[i];
//        const char *type = method_getTypeEncoding(method);
//        printf("\t'%s' has method named '%s' of encoding '%s'\n",
//               class_getName(class),
//               sel_getName(method_getName(method)),
//               method_getTypeEncoding(method));
//        
//        /**
//         *  Or do whatever you need here...
//         */
//    }
//    
//    free(methods);
//    
//    
//    
//    
//    // verify with private method [[UIApplication sharedApplication] _methodDescription]
//}


//    Class class = [c class];
//    unsigned int count;
//
//    // get class method of class
////    class_copyMethodList(object_getClass(class), &count);
//
//    // get method of class
//    Method *methods = class_copyMethodList(class, &count);
//
//    //get super class method
////    class_getInstanceMethod(Class cls, SEL name)
////
////    class_getClassMethod(Class cls, SEL name)
//
//    // iterate over them and print out the method name
//    for (int i=0; i<count; i++) {
//        Method *method = &methods[i];
//        SEL selector = method_getName(*method);
//        WatLog(@"%@ Method: %@", @"===", NSStringFromSelector(selector));
//
//        const char *type = method_getTypeEncoding(*method);
//        if (type) {
//
//        }
//        NSString *s = [NSString stringWithFormat:@"%s",type];
//        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
//
//        WatLog(@"%@ Method: %@", @"===", s);
//
//    }

//Get Class Method in Class
- (void)getClassMethodInClass:(Class)class classObject:(WTRTClassObject *)classObject {
    
    WatLog(@"%@\n", @"***");
    WatLog(@"%@------- CLASS METHOD ------", @"***");
    WatLog(@"%@--- of class %@ ---", @"***", classObject.currentClassName);
    
    Class currentClass = class;
//    do {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(object_getClass(currentClass), &methodCount);
    for (int i = 0; i < methodCount; i++)
    {
        Method method = methods[i];
        SEL methodSelector = method_getName(method);
        NSString *methodName = [NSString stringWithFormat:@"%s",sel_getName(methodSelector)];
        const char *typeEncodings = method_getTypeEncoding(method);
        
        char returnType[80];
        method_getReturnType(method, returnType, 80);
        
        WTRTMethodObject *methodObject = [WTRTMethodObject methodObject];
        methodObject.methodName = methodName;
        methodObject.isInstance = NO;
        [classObject.classMethods addEntriesFromDictionary:@{
                                                             methodObject.methodName: methodObject
                                                             }];
        
        WatLog(@"%2.2d class %@ ==> %@ (%s)", i, classObject.currentClassName, methodName, (typeEncodings == Nil) ? "" : typeEncodings);
        
//        currentClass = [currentClass superclass];
        
    }
    //}while ([currentClass superClass]);
    
    free(methods);
    
    
    
    
    // verify with private method [[UIApplication sharedApplication] _methodDescription]
}


//Get Instance Method in Class
- (void)getInstanceMethodInClass:(Class)class classObject:(WTRTClassObject *)classObject {
    
    WatLog(@"\n");
    WatLog(@"%@------- INSTANCE METHOD ------", @"***");
    WatLog(@"%@--- of class %@ ---", @"***", classObject.currentClassName);
    
    Class currentClass = class;
//    do {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);
    for (int i = 0; i < methodCount; i++)
    {
        Method method = methods[i];
        SEL methodSelector = method_getName(method);
        NSString *methodName = [NSString stringWithFormat:@"%s",sel_getName(methodSelector)];
        const char *typeEncodings = method_getTypeEncoding(method);
        
//        char returnType[80];
//        method_getReturnType(method, returnType, 80);
//        
//        const char* const type = method_copyReturnType(method);
//        printf("%s : %s\n", NSStringFromSelector(methodSelector).UTF8String, type);
        
        WTRTMethodObject *methodObject = [WTRTMethodObject methodObject];
        methodObject.methodName = methodName;
        methodObject.isInstance = YES;
        [classObject.instanceMethods addEntriesFromDictionary:@{
                                                                methodObject.methodName: methodObject
                                                                }];
        
        WatLog(@"%2.2d instance %@ ==> %@ (%s)", i, classObject.currentClassName, methodName, (typeEncodings == Nil) ? "" : typeEncodings);
        
//        currentClass = [currentClass superclass];
        
    }
    //} while ([currentClass superclass]);
    
    free(methods);
    
    
    
    
    // verify with private method [[UIApplication sharedApplication] _methodDescription]
}

- (void)getInstanceMethodInProtocol:(Protocol *)protocol protocolObject:(WTRTProtocolObject *)protocolObject classObject:(WTRTClassObject *)classObject
{
//    Protocol *protocol = @protocol(UITableViewDelegate);
    
    NSString *protocolName = protocolObject.protocolName;
    WatLog(@"protocolObject name %@ :", protocolObject.protocolName);
    
    BOOL isRequiredMethod = YES;
    BOOL isInstanceMethod = YES;
    
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    WatLog(@"%d required instance methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        WatLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
        
        NSString *methodName = NSStringFromSelector(methodDescription.name);
        WTRTMethodObject *methodObject = [WTRTMethodObject methodObject];
        methodObject.methodName = methodName;
        methodObject.fromProtocolName = protocolName;
        methodObject.isRequireProtocolMethod = YES;
        methodObject.isInstance = isInstanceMethod;
        [classObject.protocolMethods addEntriesFromDictionary:@{
                                                           methodObject.methodName: methodObject
                                                           }];
    }
    isRequiredMethod = YES;
    isInstanceMethod = NO;
    
    methodCount = 0;
    methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    WatLog(@"%d required class methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        WatLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
        
        NSString *methodName = NSStringFromSelector(methodDescription.name);
        WTRTMethodObject *methodObject = [WTRTMethodObject methodObject];
        methodObject.methodName = methodName;
        methodObject.fromProtocolName = protocolName;
        methodObject.isRequireProtocolMethod = YES;
        methodObject.isInstance = isInstanceMethod;
        [classObject.protocolMethods addEntriesFromDictionary:@{
                                                           methodObject.methodName: methodObject
                                                           }];
    }
    isRequiredMethod = NO;
    isInstanceMethod = YES;
    
    methodCount = 0;
    methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    WatLog(@"%d optional instance methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        WatLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
        
        NSString *methodName = NSStringFromSelector(methodDescription.name);
        WTRTMethodObject *methodObject = [WTRTMethodObject methodObject];
        methodObject.methodName = methodName;
        methodObject.fromProtocolName = protocolName;
        methodObject.isOptionalProtocolMethod = YES;
        methodObject.isInstance = isInstanceMethod;
        [classObject.protocolMethods addEntriesFromDictionary:@{
                                                           methodObject.methodName: methodObject
                                                           }];
    }
    isRequiredMethod = NO;
    isInstanceMethod = NO;
    
    methodCount = 0;
    methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    WatLog(@"%d optinal class methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        WatLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
        
        NSString *methodName = NSStringFromSelector(methodDescription.name);
        WTRTMethodObject *methodObject = [WTRTMethodObject methodObject];
        methodObject.methodName = methodName;
        methodObject.fromProtocolName = protocolName;
        methodObject.isOptionalProtocolMethod = YES;
        methodObject.isInstance = isInstanceMethod;
        [classObject.protocolMethods addEntriesFromDictionary:@{
                                                           methodObject.methodName: methodObject
                                                           }];
    }
    
    free(methods);
}

- (NSArray *)propertyList {
    Class currentClass = [self class];
    
    NSMutableArray *propertyList = [NSMutableArray array];
    // class_copyPropertyList does not include properties declared in super classes
    // so we have to follow them until we reach NSObject
    do {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(currentClass, &outCount);
        
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            
            NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
            
            [propertyList addObject:propertyName];
        }
        free(properties);
        currentClass = [currentClass superclass];
    } while ([currentClass superclass]);
    
    return propertyList;
}

- (NSString*)removeQuoteString:(const char *)value
{
    NSString *s = [NSString stringWithFormat:@"%s",value];
    s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
    return s;
}

@end
