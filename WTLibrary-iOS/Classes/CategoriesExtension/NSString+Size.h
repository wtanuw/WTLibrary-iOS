//
//  NSString+Size.h
//  Pods
//
//  Created by iMac on 6/13/17.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)sizeWithAttributesFont:(UIFont *)font;

- (CGSize)sizeWithAttributesLabel:(UILabel *)label;

- (CGSize)boundingRectWithLabel:(UILabel *)label;

- (CGSize)boundingRectWithFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode constraintSize:(CGSize)constrainedSize;

@end
