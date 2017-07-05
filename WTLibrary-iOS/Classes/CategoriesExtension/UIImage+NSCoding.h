//
//  UIImage+NSCoding.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/18/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NSCoding) <NSCoding>
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end
