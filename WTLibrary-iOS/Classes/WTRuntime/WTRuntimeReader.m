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


#define WATLOG_DEBUG

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
    
}

- (void)initialize {
    [_dict removeAllObjects];
}

+ (void)startReader {
    [[WTRuntimeReader sharedReader] startReader];
}

- (void)startReader {
    [self readProject];
    [self exportToFile:nil];
}

- (void)exportToFile:(NSString*)fileName
{
    NSString *json = [_project exportJSONString];
//    NSData *data = [_project exportJSONData];
    NSString *desktopPath = @"/Users/imac/Desktop";
//    NSString *desktopPath = @"/Users/wat/Desktop";
    NSString *txtFilePath = [desktopPath stringByAppendingPathComponent:@"test.json"];
    NSString *jsonFilePath = [desktopPath stringByAppendingPathComponent:@"test.txt"];
    BOOL success = [json writeToFile:jsonFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    WatLog(@"%@",WTBOOL(success));
    success = [json writeToFile:txtFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    WatLog(@"%@",WTBOOL(success));
}

- (void)readProject {
    
    WatLog(@"\n");
//    WatLog(@"%@------- Project %@(v.%@) ------", @"###", [WTBundleInfo displayName], [WTBundleInfo versionNumber]);
//    WatLog(@"%@------- Bundle %@(build %@) ------", @"###", [WTBundleInfo bundleName], [WTBundleInfo buildNumber]);
    
    
    
    _project = [WTRTProjectObject projectObject];
    _project.projectName = [WTBundleInfo bundleName];
    
    
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

- (void)getClassInProject:(WTRTProjectObject *)project {
    
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    if (numClasses < 0 ) {
        return;
    }
    WatLog(@"%@ found class", @"###");
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    classes = (Class *)(malloc(sizeof(Class) * numClasses));
    numClasses = objc_getClassList(classes, numClasses);
    WatLog(@"### number of class: %d", numClasses);
    
    for (NSInteger i = 0; i < numClasses; i++) {
        
        Class c = classes[i];
        
        // prevent crash
        NSString *ccc = NSStringFromClass(c);
        if ([ccc hasPrefix:@"WK"]) {
            continue;
        }
        
        NSBundle *b = [NSBundle bundleForClass:c];
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
            class.className = name;
            class.superClassName = superClass;
            [class.superClass addObject:superClass];
            [bundle.classes addObject:class];
            
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

        }
    }
    free(classes);

}

// Get Var in Class
- (void)getVariableInClass:(Class)class classObject:(WTRTClassObject *)classObject {
    
    WatLog(@"\n");
    WatLog(@"%@------- VARIABLE ------", @"***");
    WatLog(@"%@--- of class %@ ---", @"***", classObject.className);
    
    Class currentClass = class;
    
    unsigned int variableCount = 0;
    int i = 0;
    Ivar* ivars = class_copyIvarList(currentClass, &variableCount);
    for(const Ivar* p = ivars; p < ivars+variableCount; p++)
    {
        Ivar const ivar = *p;
        NSString *variableName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        const char *type = ivar_getTypeEncoding(ivar);
        NSString *typeString;
        
        NSString *s = [NSString stringWithFormat:@"%s",type];
        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
        NSString *typeName = s;
        
        WTRTVariableObject *variable = [WTRTVariableObject variableObject];
        variable.variableName = variableName;
        variable.typeName = typeName;
        variable.typeKey = s;
        [classObject.variables addObject:variable];
        
        WatLog(@"%2.2d variable %@ ==> %@ ", i, classObject.className, variableName);i++;
        
//        switch (type[0]) {
//            case 'c':
//                typeString = @"c";//return [NSNumber numberWithChar:(char)ivar->value];
//            case 'i':
//                typeString = @"i";//return [NSNumber numberWithInt:(int)ivar.value];
//            case 's':
//                typeString = @"s";//return [NSNumber numberWithShort:(short)ivar.value];
//            case 'l':
//                typeString = @"l";//return [NSNumber numberWithLong:(long)ivar.value];
//            case 'q':
//                typeString = @"q";//return [NSNumber numberWithLongLong:(long long)ivar.value];
//            case 'C':
//                typeString = @"C";// return [NSNumber numberWithUnsignedChar:(unsigned char)ivar.value];
//            case 'I':
//                typeString = @"I";//return [NSNumber numberWithUnsignedInt:(unsigned int)ivar.value];
//            case 'S':
//                typeString = @"S";//return [NSNumber numberWithUnsignedShort:(unsigned short)ivar.value];
//            case 'L':
//                typeString = @"L";//return [NSNumber numberWithUnsignedLong:(unsigned long)ivar.value];
//            case 'Q':
//                typeString = @"Q";//return [NSNumber numberWithUnsignedLongLong:(unsigned long long)ivar.value];
//            case 'f':
//                typeString = @"f";//return [NSNumber numberWithFloat:ivar.f];
//            case 'd':
//                typeString = @"d";//return [NSNumber numberWithDouble:ivar.d];
//            case '*':
//                typeString = @"*";//return [NSString stringWithUTF8String:(const char *)ivar.value];
//            case '@':
//            case '#':
//                typeString = @"#";//return (id)ivar.value;
//            case ':':
//                typeString = @":";//return NSStringFromSelector((SEL)ivar.value);
//            default:
//                typeString = @"default";//return [NSValue valueWithBytes:&ivar.value objCType:type];
//        }
//        
//        //        NSLog(@"name - %@",name);
//        name = [name stringByAppendingString:[NSString stringWithFormat:@" - %@",s]];
//        
//        NSLog(@"Variable: %@",name);
        
    }
    
    free(ivars);
    
}

- (void)getPropertyInClass:(Class)class classObject:(WTRTClassObject *)classObject {
    
    WatLog(@"\n");
    WatLog(@"%@------- PROPERTY ------", @"***");
    WatLog(@"%@--- of class %@ ---", @"***", classObject.className);
    
    Class currentClass = class;
    
    unsigned int propertyCount = 0;
    
    objc_property_t* propertys = class_copyPropertyList(currentClass, &propertyCount);
    for(const objc_property_t* p = propertys; p < propertys+propertyCount; p++)
    {
        objc_property_t const propertyt = *p ;
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyt)];
//        const char *type = ivar_getTypeEncoding(ivar);
        NSString *typeString;
        
//        NSString *s = [NSString stringWithFormat:@"%s",type];
//        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
//        NSString *typeName = s;
        
        WTRTPropertyObject *property = [WTRTPropertyObject propertyObject];
        property.propertyName = propertyName;
//        variable.typeName = typeName;
        [classObject.properties addObject:property];
    }
    
}

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
        [classObject.protocols addObject:protocol];
        
        [self getInstanceMethodInProtocol:ptc protocolObject:protocol];
    }
    
}
//
////Get Method in Class
//- (void)getMethodInClass:(Class)c classObject:(WTRTClassObject *)classObject {
//    
//    WatLog(@"\n");
//    
//    WatLog(@"%@------- METHOD ------", @"***");
//    WatLog(@"%@--- %@ ---", @"***", classObject.className);
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
//        NSLog(@"%2.2d %@ ==> %s (%s)", 0, classObject.className, methodName, (typeEncodings == Nil) ? "" : typeEncodings);
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
    WatLog(@"%@--- of class %@ ---", @"***", classObject.className);
    
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
        [classObject.classMethods addObject:methodObject];
        
        WatLog(@"%2.2d class %@ ==> %@ (%s)", i, classObject.className, methodName, (typeEncodings == Nil) ? "" : typeEncodings);
        
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
    WatLog(@"%@--- of class %@ ---", @"***", classObject.className);
    
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
        
        char returnType[80];
        method_getReturnType(method, returnType, 80);
        
        WTRTMethodObject *methodObject = [WTRTMethodObject methodObject];
        methodObject.methodName = methodName;
        [classObject.instanceMethods addObject:methodObject];
        
        WatLog(@"%2.2d instance %@ ==> %@ (%s)", i, classObject.className, methodName, (typeEncodings == Nil) ? "" : typeEncodings);
        
//        currentClass = [currentClass superclass];
        
    }
    //} while ([currentClass superclass]);
    
    free(methods);
    
    
    
    
    // verify with private method [[UIApplication sharedApplication] _methodDescription]
}

- (void)getInstanceMethodInProtocol:(Protocol *)protocol protocolObject:(WTRTProtocolObject *)protocolObject
{
//    Protocol *protocol = @protocol(UITableViewDelegate);
    
    BOOL isRequiredMethod = YES;
    BOOL isInstanceMethod = YES;
    
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    NSLog(@"%d required instance methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        NSLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
    }
    isRequiredMethod = YES;
    isInstanceMethod = NO;
    
    methodCount = 0;
    methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    NSLog(@"%d required class methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        NSLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
    }
    isRequiredMethod = NO;
    isInstanceMethod = YES;
    
    methodCount = 0;
    methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    NSLog(@"%d optional instance methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        NSLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
    }
    isRequiredMethod = NO;
    isInstanceMethod = NO;
    
    methodCount = 0;
    methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    
    NSLog(@"%d optinal class methods found:", methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        struct objc_method_description methodDescription = methods[i];
        NSLog(@"Method #%d: %@", i, NSStringFromSelector(methodDescription.name));
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


@end