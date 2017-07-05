//
//  UIImage+NSCoding.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 3/18/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#if WT_REQUIRE_ARC
#error This file must be compiled with ARC.
#endif

#import "UIImage+NSCoding.h"

#define kEncodingKey        @"UIImage"

@implementation UIImage (NSCoding)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        NSData *data = [decoder decodeObjectForKey:kEncodingKey];
        self = [self initWithData:data];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSData *data = UIImagePNGRepresentation(self);
    [encoder encodeObject:data forKey:kEncodingKey];
}

#pragma clang diagnostic pop

@end
