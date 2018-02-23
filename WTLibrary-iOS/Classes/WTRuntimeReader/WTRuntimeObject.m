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

@implementation WTRuntimeObject

-(instancetype)init
{
    self = [super init];
    if (self) {
        _prettyPrinted = YES;
    }
    return self;
}

- (void)importJSON:(NSDictionary *)jsonDict
{
    
}

- (NSDictionary *)exportJSON
{
    return @{};
}

- (void)importJSONString:(NSString *)jsonString
{
    
}

- (NSString *)exportJSONString
{
    return @"";
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

- (void)importJSON:(NSDictionary *)jsonDict
{
}

- (NSDictionary *)exportJSON
{
    return @{};
}

- (void)importJSONString:(NSString *)jsonString
{//    NSString *jsonString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@", json);
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSLog(@"its an array!");
        NSArray *jsonArray = (NSArray *)jsonObject;
        NSLog(@"jsonArray - %@",jsonArray);
    } else {
        NSLog(@"its probably a dictionary");
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        NSLog(@"jsonDictionary - %@",jsonDictionary);
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
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

#pragma mark -

@implementation WTRTApplicationObject

+ (instancetype)applicationObject
{
    return [[WTRTApplicationObject alloc] init];
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
    _classes = [NSMutableArray array];
    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
    [_classes removeAllObjects];
    [_userDefineClasses removeAllObjects];
}

//- (void)importJSON:(NSString *)jsonString
//{
////    NSString *jsonString = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *e = nil;
//    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
//    NSLog(@"%@", json);
//
//    return @"";
//}
//-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
//                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
//                                                         error:&error];
//    
//    if (! jsonData) {
//        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
//        return @"{}";
//    } else {
//        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//}

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
//    _classes = [NSMutableArray array];
//    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
//    [_classes removeAllObjects];
//    [_userDefineClasses removeAllObjects];
}

- (NSString *)exportjson
{
    return @"";
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
    //    _classes = [NSMutableArray array];
    //    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
    //    [_classes removeAllObjects];
    //    [_userDefineClasses removeAllObjects];
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
    //    _classes = [NSMutableArray array];
    //    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
    //    [_classes removeAllObjects];
    //    [_userDefineClasses removeAllObjects];
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
//    _classes = [NSMutableArray array];
//    _userDefineClasses = [NSMutableArray array];
    
}

- (void)initialize {
//    [_classes removeAllObjects];
//    [_userDefineClasses removeAllObjects];
}

- (NSString *)exportjson
{
    return @"";
}

@end
