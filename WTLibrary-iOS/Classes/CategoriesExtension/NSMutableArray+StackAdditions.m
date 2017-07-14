//
//  NSMutableArray+StackAdditions.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/18/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#import "NSMutableArray+StackAdditions.h"
#import "WTMacro.h"

@implementation NSMutableArray (StackAdditions)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"

- (id)pop
{
    if([self count] == 0) return nil;
    
    id lastObject = [self lastObject];
    if(lastObject){
        WT_SAFE_ARC_AUTORELEASE(WT_SAFE_ARC_RETAIN(lastObject));
        [self removeLastObject];
    }
    return lastObject;
}

#pragma clang diagnostic pop

- (void)push:(id)obj
{
    [self addObject:obj];
}

@end
