//
//  OCProgress.m
//  ProgressView
//
//  Created by Brian Harmann on 7/24/09.
//  Copyright 2009 Obsessive Code. All rights reserved.
//

#import "OCProgress.h"


@implementation OCProgress

@synthesize  minValue, maxValue, currentValue;
@synthesize lineColor, progressRemainingColor, progressColor;
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		minValue = 0;
		maxValue = 1;
		currentValue = 0;
		self.backgroundColor = [UIColor clearColor];
		lineColor = [[UIColor whiteColor] retain];
		progressColor = [[UIColor darkGrayColor] retain];
		progressRemainingColor = [[UIColor lightGrayColor] retain];
    }
    return self;
}

+ (UIImage*)maskImage:(UIImage*)image withMask:(UIImage*)maskImage {
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(image.CGImage, mask);
    UIImage* result = [UIImage imageWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
    UIGraphicsEndImageContext();
    CGImageRelease(mask);
    CGImageRelease(masked);
    return result;
}
//- (void)drawRect:(CGRect)rect {
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	
//	CGContextSetLineWidth(context, 2);
//	
//	CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
//	CGContextSetFillColorWithColor(context, [[progressRemainingColor colorWithAlphaComponent:.7] CGColor]);
//
//	
//	float radius = (rect.size.height / 2) - 2;
//	CGContextMoveToPoint(context, 2, rect.size.height/2);
//
//	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
//	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
//	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
//	CGContextFillPath(context);
//	
//	CGContextSetFillColorWithColor(context, [progressRemainingColor CGColor]);
//
//	CGContextMoveToPoint(context, rect.size.width - 2, rect.size.height/2);
//	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
//	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
//	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
//	CGContextFillPath(context);
//	
//	
//	CGContextMoveToPoint(context, 2, rect.size.height/2);
//	
//	CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius);
//	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
//	CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius);
//	CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius);
//	
//	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
//	CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius);
//	CGContextStrokePath(context);
//	
//	CGContextSetFillColorWithColor(context, [[progressColor colorWithAlphaComponent:.78] CGColor]);
//
//	radius = radius - 2;
//	CGContextMoveToPoint(context, 4, rect.size.height/2);
//	float amount = (currentValue/(maxValue - minValue)) * (rect.size.width);
//	
//	if (amount >= radius + 4 && amount <= (rect.size.width - radius - 4)) {
//		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
//		CGContextAddLineToPoint(context, amount, 4);
//		//CGContextAddLineToPoint(context, amount, radius + 4);
//		CGContextAddArcToPoint(context, amount + radius + 4, 4,  amount + radius + 4, rect.size.height/2, radius);
//
//		CGContextFillPath(context);
//		
//		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
//		CGContextMoveToPoint(context, 4, rect.size.height/2);
//		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
//		CGContextAddLineToPoint(context, amount, rect.size.height - 4);
//		CGContextAddArcToPoint(context, amount + radius + 4, rect.size.height - 4,  amount + radius + 4, rect.size.height/2, radius);
//		//CGContextAddLineToPoint(context, amount, radius + 4);
//		CGContextFillPath(context);
//	} else if (amount > radius + 4) {
//		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
//		CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4);
//		CGContextAddArcToPoint(context, rect.size.width - 4, 4, rect.size.width - 4, rect.size.height/2, radius);
//		CGContextFillPath(context);
//		
//		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
//		CGContextMoveToPoint(context, 4, rect.size.height/2);
//		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
//		CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4);
//		CGContextAddArcToPoint(context, rect.size.width - 4, rect.size.height - 4, rect.size.width - 4, rect.size.height/2, radius);
//		CGContextFillPath(context);
//	} else if (amount < radius + 4 && amount > 0) {
//		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
//		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
//		CGContextFillPath(context);
//		
//		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
//		CGContextMoveToPoint(context, 4, rect.size.height/2);
//		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
//		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
//		CGContextFillPath(context);
//	}
//
//	
//}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    float strokeWidth = 1.0;
    
	CGContextSetLineWidth(context, strokeWidth);
	
	CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
	CGContextSetFillColorWithColor(context, [[progressRemainingColor colorWithAlphaComponent:.7] CGColor]);
    
	
	float radius = 0;//(rect.size.height / 2) - 2;
//	CGContextMoveToPoint(context, 2, rect.size.height/2);
//    
//	CGContextAddLineToPoint(context, rect.size.width - radius - 2, 2);
	CGContextFillPath(context);
	
	CGContextSetFillColorWithColor(context, [progressRemainingColor CGColor]);
    
//	CGContextMoveToPoint(context, rect.size.width - 2, rect.size.height/2);
//	CGContextAddLineToPoint(context, radius + 2, rect.size.height - 2);
	CGContextFillPath(context);
	
	
	CGContextMoveToPoint(context, strokeWidth, rect.size.height - strokeWidth);
	
	CGContextAddLineToPoint(context, strokeWidth, strokeWidth);
	CGContextAddLineToPoint(context, rect.size.width - strokeWidth, strokeWidth);
    CGContextAddLineToPoint(context, rect.size.width - strokeWidth, rect.size.height - strokeWidth);
	CGContextAddLineToPoint(context, strokeWidth/strokeWidth, rect.size.height - strokeWidth);
	CGContextStrokePath(context);
	
//	CGContextSetFillColorWithColor(context, [[progressColor colorWithAlphaComponent:.78] CGColor]);
	CGContextSetFillColorWithColor(context, [[progressColor colorWithAlphaComponent:1] CGColor]);
    
	radius = 0;//radius - 2;
    
    CGContextMoveToPoint(context, strokeWidth, rect.size.height - strokeWidth);
    
	float amount = (currentValue/(maxValue - minValue)) * (rect.size.width) * 1.01;
    if(amount>rect.size.width - radius - strokeWidth) amount = rect.size.width - radius - strokeWidth;
    
	if (amount > radius + 2 && amount <= (rect.size.width - radius)) {
//		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
        CGContextAddLineToPoint(context, strokeWidth, strokeWidth);
		CGContextAddLineToPoint(context, amount, strokeWidth);
//		CGContextAddArcToPoint(context, amount + radius + 4, 4,  amount + radius + 4, rect.size.height/2, radius);
        CGContextAddLineToPoint(context, amount, rect.size.height - strokeWidth);
        
		CGContextFillPath(context);
		
		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
		CGContextMoveToPoint(context, strokeWidth, rect.size.height - strokeWidth);
//		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
		CGContextAddLineToPoint(context, strokeWidth, rect.size.height - strokeWidth);
//		CGContextAddArcToPoint(context, amount + radius + 4, rect.size.height - 4,  amount + radius + 4, rect.size.height/2, radius);
		//CGContextAddLineToPoint(context, amount, radius + 4);
		CGContextFillPath(context);
//	} else if (amount > radius + 4) {
//		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
//		CGContextAddLineToPoint(context, rect.size.width - radius - 4, 4);
//		CGContextAddArcToPoint(context, rect.size.width - 4, 4, rect.size.width - 4, rect.size.height/2, radius);
//		CGContextFillPath(context);
//		
//		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
//		CGContextMoveToPoint(context, 4, rect.size.height/2);
//		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
//		CGContextAddLineToPoint(context, rect.size.width - radius - 4, rect.size.height - 4);
//		CGContextAddArcToPoint(context, rect.size.width - 4, rect.size.height - 4, rect.size.width - 4, rect.size.height/2, radius);
//		CGContextFillPath(context);
	} 
//    else if (amount < radius + 4 && amount > 0) {
//		CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius);
//		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
//		CGContextFillPath(context);
//		
//		CGContextSetFillColorWithColor(context, [progressColor CGColor]);
//		CGContextMoveToPoint(context, 4, rect.size.height/2);
//		CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius);
//		CGContextAddLineToPoint(context, radius + 4, rect.size.height/2);
//		CGContextFillPath(context);
//	}
	
}

-(void)setNewRect:(CGRect)newFrame 
{
	self.frame = newFrame;
	[self setNeedsDisplay];

}

-(void)setMinValue:(float)newMin
{
	minValue = newMin;
	[self setNeedsDisplay];

}

-(void)setMaxValue:(float)newMax
{
	maxValue = newMax;
	[self setNeedsDisplay];

}

-(void)setCurrentValue:(float)newValue
{
	currentValue = newValue;
	[self setNeedsDisplay];
}

-(void)setLineColor:(UIColor *)newColor
{
	[newColor retain];
	[lineColor release];
	lineColor = newColor;
	[self setNeedsDisplay];

}

-(void)setProgressColor:(UIColor *)newColor
{
	[newColor retain];
	[progressColor release];
	progressColor = newColor;
	[self setNeedsDisplay];

}

-(void)setProgressRemainingColor:(UIColor *)newColor
{
	[newColor retain];
	[progressRemainingColor release];
	progressRemainingColor = newColor;
	[self setNeedsDisplay];

}

- (void)dealloc {
	[lineColor release];
	[progressColor release];
	[progressRemainingColor release];
    [super dealloc];
}


@end
