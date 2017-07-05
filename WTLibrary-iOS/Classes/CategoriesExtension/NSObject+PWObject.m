//
//  NSObject+PWObject.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/18/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#import "NSObject+PWObject.h"

@implementation NSObject (PWObject)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
    
    //    int parameter1 = 12;
    //    float parameter2 = 144.1
    
    // Delay execution of my block for 10 seconds.
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
    //        NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
    //    });
}

@end
