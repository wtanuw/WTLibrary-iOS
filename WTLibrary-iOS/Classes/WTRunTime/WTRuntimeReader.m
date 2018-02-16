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

@implementation WTRuntimeReader

+(void)startGetList{
    [self getClassListArray];
}

+(NSString*)displayName
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleDisplayName"]];
    return displayName;
}

+(NSString*)bundleName
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleName"]];
    return bundleName;
}

+(NSString*)versionNumber
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNumber = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleShortVersionString"]];
    return versionNumber;
}

+(NSString*)buildNumber
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *buildNumber = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleVersion"]];
    return buildNumber;
}

+(void)getClassListArray{
    
    WatLog(@"\n");
    WatLog(@"###------- Project %@(%@) ------", [self displayName], [self versionNumber]);
    WatLog(@"###------- Project %@(%@) ------", [self bundleName], [self buildNumber]);
    
    
    Class *classes = NULL;
    int numberOfClasses = objc_getClassList(NULL, 0);
    
    if (numberOfClasses < 0 ) {
        return;
    }
    WatLog(@"### found class");
    
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
    numberOfClasses = objc_getClassList(classes, numberOfClasses);
    WatLog(@"### number of class: %d", numberOfClasses);
    
    for (int i = 0; i < numberOfClasses; i++) {
        Class c = classes[i];
        NSBundle *b = [NSBundle bundleForClass:c];
        if (b == [NSBundle mainBundle]) {
            
            WatLog(@"@@@ classname: %s  in bundle: %@", class_getName(c), b.infoDictionary[@"CFBundleName"]);
            NSString *name = [NSString stringWithFormat:@"%s",class_getName(c)];
            NSString *superClass = [NSString stringWithFormat:@"%@",class_getSuperclass(c)];
            WatLog(@"@@@ name - %@",name);
            
            if(![superClass isEqualToString:@"(null)"]){
                
                //                if([name hasPrefix:@"TAG"] || [name hasPrefix:@"TID"] || [name hasPrefix:@"AF"] || [name hasPrefix:@"GAI"]){
                //
                //                }else{
                //                    [self getVarInClass:c Name:name];
                //                    [self getMethodInClass:c Name:name];
                //                }
            }
            
            
            // ...
        }
    }
    
    free(classes);
    
    
}




// Get Var in Class
+(void)getVarInClass:(UIViewController *)controller Name:(NSString *)name{
    
    unsigned int numberofIvars = 0;
    
    
    Ivar* ivars = class_copyIvarList([controller class], &numberofIvars);
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


//Get Method in Class
+(void)getMethodInClass:(UIViewController *)controller Name:(NSString *)name{
    
    NSLog(@"\n");
    
    NSLog(@"------- METHOD ------");
    NSLog(@"--- %@ ---",name);
    
    
    Class class = [controller class];
    unsigned int count;
    Method *methods = class_copyMethodList(class, &count);
    
    // iterate over them and print out the method name
    for (int i=0; i<count; i++) {
        Method *method = &methods[i];
        SEL selector = method_getName(*method);
        NSLog(@"Method: %@", NSStringFromSelector(selector));
        
    }
}
@end
