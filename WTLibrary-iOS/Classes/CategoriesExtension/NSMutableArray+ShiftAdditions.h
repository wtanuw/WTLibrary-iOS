//
//  NSMutableArray+ShiftAdditions.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 5/20/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ShiftAdditions)
- (id)shift;
- (void)unshift:(id)obj;
@end
