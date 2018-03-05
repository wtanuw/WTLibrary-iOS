//
//  WTRuntimeParser.h
//  WTLibrary-iOS
//
//  Created by iMac on 2/16/18.
//  Copyright © 2018 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRuntimeObject.h"

@class WTRTProjectObject;

@interface WTRuntimeParser : NSObject
+ (WTRTProjectObject *)startParser:(NSString *)filePath;
@end
