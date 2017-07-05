//
//  NSObject+PWObject.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/18/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PWObject)
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
@end
