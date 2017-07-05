//
//  NSMutableArray+StackAdditions.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/18/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (StackAdditions)
- (id)pop;
- (void)push:(id)obj;
@end
