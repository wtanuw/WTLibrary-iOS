//
//  NSString+Size.m
//  Pods
//
//  Created by iMac on 6/13/17.
//
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithAttributesFont:(UIFont *)font
{
    NSDictionary *attribs = @{NSFontAttributeName:font};
    return ([self sizeWithAttributes:attribs]);
}

- (CGSize)sizeWithAttributesLabel:(UILabel *)label
{
    UIFont *font = label.font;
    NSDictionary *attribs = @{NSFontAttributeName:font};
    return ([self sizeWithAttributes:attribs]);
}

- (CGSize)boundingRectWithLabel:(UILabel *)label
{
    UIFont *font = label.font;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    
    // dictionary of attributes
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    CGSize constrainedSize = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    
    CGRect boundingRect = [self boundingRectWithSize:constrainedSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

- (CGSize)boundingRectWithFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode constraintSize:(CGSize)constrainedSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    // dictionary of attributes
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    CGRect boundingRect = [self boundingRectWithSize:constrainedSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
    
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

@end
