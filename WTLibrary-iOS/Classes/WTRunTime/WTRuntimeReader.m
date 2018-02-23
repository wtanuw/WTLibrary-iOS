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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//#include <Cocoa.h>
#import "WTMacro.h"
#import "WTBundleInfo.h"

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
@property (nonatomic, strong) WTRTApplicationObject *application;


@end


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
    [_dict addEntriesFromDictionary:@{}];
}

+ (void)startReader {
    [[WTRuntimeReader sharedReader] startReader];
}

- (void)startReader {
    [self readProject];
}

- (void)exportToFile:(NSString*)path
{
    
}

- (void)readProject {
    
    WatLog(@"\n");
    WatLog(@"%@------- Project %@(v.%@) ------", @"###", [WTBundleInfo displayName], [WTBundleInfo versionNumber]);
    WatLog(@"%@------- Bundle %@(build %@) ------", @"###", [WTBundleInfo bundleName], [WTBundleInfo buildNumber]);
    
    _application = [WTRTApplicationObject applicationObject];
    _application.displayName = [WTBundleInfo displayName];
    _application.versionNumber = [WTBundleInfo versionNumber];
    _application.bundleName = [WTBundleInfo bundleName];
    _application.buildNumber = [WTBundleInfo buildNumber];
    
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    if (numClasses < 0 ) {
        return;
    }
    WatLog(@"%@ found class", @"###");
    
    classes = (Class *)(malloc(sizeof(Class) * numClasses));
    numClasses = objc_getClassList(classes, numClasses);
    WatLog(@"### number of class: %d", numClasses);
    
    // do something with classes
    [self readClass:numClasses class:classes];
    
    free(classes);
}

- (void)readClass:(int)numClasses class:(Class*)classes {
    
    for (NSInteger i = 0; i < numClasses; i++) {
        
        Class c = classes[i];
        NSBundle *b = [NSBundle bundleForClass:c];
        WTBundleInfo *info = [WTBundleInfo bundleInfoWithBundle:b];
        if (b == [NSBundle mainBundle]) {
            
            WatLog(@"@@@ classname: %s in bundle: %@", class_getName(c), info.bundleName);
            NSString *name = [NSString stringWithFormat:@"%s",class_getName(c)];
            NSString *superClass = [NSString stringWithFormat:@"%@",class_getSuperclass(c)];
            
            if (superClass) {
                WatLog(@"@@@ name - %@  (%@)",name, superClass);
            }
            
            WTRTClassObject *class = [WTRTClassObject classObject];
            [_application.classes addObject:class];
            
            if(![superClass isEqualToString:@"(null)"]){
                
                //                if([name hasPrefix:@"TAG"] || [name hasPrefix:@"TID"] || [name hasPrefix:@"AF"] || [name hasPrefix:@"GAI"]){
                //
                //                }else{
                                    [self getVarInClass:c Name:name];
                                    [self getMethodInClass:c Name:name];
                //                }
            }

        }
    }

}

// Get Var in Class
- (void)getVarInClass:(Class)c Name:(NSString *)name {
    
    unsigned int numberofIvars = 0;
    
    
    Ivar* ivars = class_copyIvarList([c class], &numberofIvars);
    for(const Ivar* p = ivars; p< ivars+numberofIvars;p++){
        Ivar const ivar = *p ;
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *typeString;
        const char *type = ivar_getTypeEncoding(ivar);
        
        NSString *s = [NSString stringWithFormat:@"%s",type];
        s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        s = [s stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        switch (type[0]) {
            case 'c':
                typeString = @"c";//return [NSNumber numberWithChar:(char)ivar->value];
            case 'i':
                typeString = @"i";//return [NSNumber numberWithInt:(int)ivar.value];
            case 's':
                typeString = @"s";//return [NSNumber numberWithShort:(short)ivar.value];
            case 'l':
                typeString = @"l";//return [NSNumber numberWithLong:(long)ivar.value];
            case 'q':
                typeString = @"q";//return [NSNumber numberWithLongLong:(long long)ivar.value];
            case 'C':
                typeString = @"C";// return [NSNumber numberWithUnsignedChar:(unsigned char)ivar.value];
            case 'I':
                typeString = @"I";//return [NSNumber numberWithUnsignedInt:(unsigned int)ivar.value];
            case 'S':
                typeString = @"S";//return [NSNumber numberWithUnsignedShort:(unsigned short)ivar.value];
            case 'L':
                typeString = @"L";//return [NSNumber numberWithUnsignedLong:(unsigned long)ivar.value];
            case 'Q':
                typeString = @"Q";//return [NSNumber numberWithUnsignedLongLong:(unsigned long long)ivar.value];
            case 'f':
                typeString = @"f";//return [NSNumber numberWithFloat:ivar.f];
            case 'd':
                typeString = @"d";//return [NSNumber numberWithDouble:ivar.d];
            case '*':
                typeString = @"*";//return [NSString stringWithUTF8String:(const char *)ivar.value];
            case '@':
            case '#':
                typeString = @"#";//return (id)ivar.value;
            case ':':
                typeString = @":";//return NSStringFromSelector((SEL)ivar.value);
            default:
                typeString = @"default";//return [NSValue valueWithBytes:&ivar.value objCType:type];
        }
        
        //        NSLog(@"name - %@",name);
        name = [name stringByAppendingString:[NSString stringWithFormat:@" - %@",s]];
        
        NSLog(@"Variable: %@",name);
        
    }
    
    
    free(ivars);
    
}

- (void)getPropertyInClass:(Class)c Name:(NSString *)name {
}

//Get Method in Class
- (void)getMethodInClass:(Class)c Name:(NSString *)name {
    
    WatLog(@"\n");
    
    WatLog(@"%@------- METHOD ------", @"***");
    WatLog(@"%@--- %@ ---", @"***", name);
    
    
    Class class = [c class];
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
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(class, &methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        Method method = methods[i];
        SEL methodSelector = method_getName(method);
        const char* methodName = sel_getName(methodSelector);
        
        const char *typeEncodings = method_getTypeEncoding(method);
        
        char returnType[80];
        method_getReturnType(method, returnType, 80);
        
        NSLog(@"%2.2d %@ ==> %s (%s)", 0, name, methodName, (typeEncodings == Nil) ? "" : typeEncodings);
        
        int ac = method_getNumberOfArguments(method);
        int a = 0;
        for (a = 0; a < ac; a++) {
            char argumentType[80];
            method_getArgumentType(method, a, argumentType, 80);
            NSLog(@"   Argument no #%d: %s", a, argumentType);
        }
    }
    
    printf("Found %d methods on '%s'\n", methodCount, class_getName(class));
    for(const Method* p = methods; p < methods+methodCount; p++){
        Method const ivar = *p;
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        const char *type = method_getTypeEncoding(ivar);
        NSString *s = [NSString stringWithFormat:@"%s",type];
        NSMethodSignature * sig = [NSMethodSignature signatureWithObjCTypes:type];
//        printf("\t %d  %s",[sig numberOfArguments], [sig getArgumentTypeAtIndex:0]);
    }
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        const char *type = method_getTypeEncoding(method);
        printf("\t'%s' has method named '%s' of encoding '%s'\n",
               class_getName(class),
               sel_getName(method_getName(method)),
               method_getTypeEncoding(method));
        
        /**
         *  Or do whatever you need here...
         */
    }
    
    free(methods);
    
    
    
    
    // verify with private method [[UIApplication sharedApplication] _methodDescription]
}
@end
