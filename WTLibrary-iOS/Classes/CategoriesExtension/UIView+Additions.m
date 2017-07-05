//
//  UIView+Additions.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 1/13/17.
//  Copyright © 2017 Wat Wongtanuwat. All rights reserved.
//

//  UIView+Additions.m
//The trick here is that sending an action to nil sends it to the first responder.
#import "UIView+Additions.h"
static __weak id currentFirstResponder;
@implementation UIView (Additions)
+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    // This will invoke on first responder when target is nil
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    // First responder will set the static variable to itself
    currentFirstResponder = self;
}
@end
