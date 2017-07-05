//
//  NSMutableArray+QueueAdditions.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/18/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#import "NSMutableArray+QueueAdditions.h"
#import "WTMacro.h"

@implementation NSMutableArray (QueueAdditions)

- (id)dequeue
{
    if([self count] == 0) return nil;
    
    id firstObject = [self firstObject];
    if(firstObject){
        WT_SAFE_ARC_AUTORELEASE(WT_SAFE_ARC_RETAIN(firstObject));
        [self removeObjectAtIndex:0];
    }
    return firstObject;
}

- (void)enqueue:(id)obj
{
    [self addObject:obj];
}

@end
