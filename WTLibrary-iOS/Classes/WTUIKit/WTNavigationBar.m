//
//  CustomNavigationBar.m
//  CustomBackButton
//
//  Created by Peter Boctor on 1/11/11.
//
//  Copyright (c) 2011 Peter Boctor
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#import "WTNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

#define MAX_BACK_BUTTON_WIDTH 160.0

@interface WTNavigationBar(private)
-(void) customLayoutSubviews;
@end

@implementation WTNavigationBar
@synthesize navigationBarBackgroundImage, navigationController;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (id)initWithNavigationController:(UINavigationController*)navVCT {
    if (self = [super initWithFrame:CGRectZero]) {
        // Initialization code
        self.navigationController = navVCT;
    }
    return self;
}

// If we have a custom background image, then draw it, othwerwise call super and draw the standard nav bar
- (void)drawRect:(CGRect)rect
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = 0.5;
    [self.layer addAnimation:animation forKey:@"contents"];
    
    //
//    if (navigationBarBackgroundImage)
//        [navigationBarBackgroundImage.image drawInRect:rect];
//    else
//        [super drawRect:rect];
    
    //
    if (navigationBarBackgroundImage){
        
        BOOL havePrompt = NO;
        if(notGrowPromptIpad && UI_INTERFACE_IDIOM_IS_IPAD()){
            
        }else if(self.navigationController.topViewController.navigationItem.prompt){
                havePrompt = YES;
        }
        
        CGRect size = CGRectMake(0, 0, navigationBarBackgroundImage.size.width, navigationBarBackgroundImage.size.height *((havePrompt)?2:1));
        if([self isTranslucent]){
            [navigationBarBackgroundImage drawInRect:size blendMode:kCGBlendModeNormal alpha:0.7];
        }else{
            [navigationBarBackgroundImage drawInRect:size];
        }
    }
    else
    {
        [super drawRect:rect];
    }
}

// Save the background image and call setNeedsDisplay to force a redraw
-(void) setBackgroundImage:(UIImage*)backgroundImage
{
    //
//    self.navigationBarBackgroundImage = [[[UIImageView alloc] initWithFrame:self.frame] autorelease];
//    navigationBarBackgroundImage.image = backgroundImage;
//    [self setNeedsDisplay];
    
    //
//    if(backgroundImage != navigationBarBackgroundImage.image){
//        CGRect size = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
//        self.navigationBarBackgroundImage = [[[UIImageView alloc] initWithFrame:size] autorelease];
//        navigationBarBackgroundImage.image = backgroundImage;
//    }
    
    //
    if(backgroundImage)
    {
        self.navigationBarBackgroundImage = backgroundImage;
    }
    else
    {
        [self clearBackgroundImage];
    }
    [self setNeedsDisplay];
    [self sizeToFit];
}

// clear the background image and call setNeedsDisplay to force a redraw
-(void) clearBackgroundImage
{
    self.navigationBarBackgroundImage = nil;
    [self setNeedsDisplay];
    [self sizeToFit];
}

-(CGSize) sizeThatFits:(CGSize)size 
{
    if (navigationBarBackgroundImage){
        // This is how you set the custom size of your UINavigationBar
        BOOL havePrompt = NO;
        if(self.navigationController.topViewController.navigationItem.prompt){
            havePrompt = YES;
        }
        if(havePrompt){
            //CGRect frame = [UIScreen mainScreen].applicationFrame;
            CGRect frame = [UIScreen mainScreen].bounds;
            CGSize newSize = CGSizeMake(frame.size.width , self.navigationBarBackgroundImage.size.height*2);
            return newSize;
        }else{
            //CGRect frame = [UIScreen mainScreen].applicationFrame;
            CGRect frame = [UIScreen mainScreen].bounds;
            CGSize newSize = CGSizeMake(frame.size.width , self.navigationBarBackgroundImage.size.height);
            return newSize;
        }
    }
    return [super sizeThatFits:size];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    [self customLayoutSubviews];
}

-(void) customLayoutSubviews
{
    if (navigationBarBackgroundImage){
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIButton")]) {
            view.frame = CGRectMake(view.frame.origin.x,
                                    (self.frame.size.height-view.frame.size.height)/2,
                                    view.frame.size.width,
                                    view.frame.size.height);
        }else
        if ([view isKindOfClass:NSClassFromString(@"UIToolbar")]) {
            view.frame = CGRectMake(view.frame.origin.x,
                                    -2,
                                    view.frame.size.width,
                                    view.frame.size.height);
        }
        if([view isKindOfClass:NSClassFromString(@"UILabel")]){
            CGRect newRect = view.frame;
            newRect.origin.y = view.frame.origin.y+2;
            view.frame = newRect;
        }
    }
    }
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Given the prpoer images and cap width, create a variable width back button
-(UIButton*) buttonWithImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage capInset:(UIEdgeInsets)inset
{
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage;
    UIImage* buttonHighlightImage;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        buttonImage = [normalImage resizableImageWithCapInsets:inset];
        buttonHighlightImage = [highlightImage resizableImageWithCapInsets:inset];
    }else{
        buttonImage = [normalImage stretchableImageWithLeftCapWidth:inset.left topCapHeight:inset.top];
        buttonHighlightImage = [highlightImage stretchableImageWithLeftCapWidth:inset.left topCapHeight:inset.top];
    }
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.5,-0.5);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
#ifdef __IPHONE_6_0
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }else{
#if (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
        button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    }
#else
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setImage:buttonHighlightImage forState:UIControlStateHighlighted];
//    [button setImage:buttonHighlightImage forState:UIControlStateSelected];
    
    return button;
}

// Given the prpoer images and cap width, create a variable width back button
-(UIButton*) backButtonWithImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage capInset:(UIEdgeInsets)inset
{
    // store the cap width for use later when we set the text
    backButtonCapWidth = inset.left;
    
    // Create stretchable images for the normal and highlighted states
    UIImage* buttonImage;
    UIImage* buttonHighlightImage;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        buttonImage = [normalImage resizableImageWithCapInsets:inset];
        buttonHighlightImage = [highlightImage resizableImageWithCapInsets:inset];
    }else{
        buttonImage = [normalImage stretchableImageWithLeftCapWidth:inset.left topCapHeight:inset.top];
        buttonHighlightImage = [highlightImage stretchableImageWithLeftCapWidth:inset.left topCapHeight:inset.top];
    }
    
    // Create a custom button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Set the title to use the same font and shadow as the standard back button
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0.5,-0.5);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the break mode to truncate at the end like the standard back button
#ifdef __IPHONE_6_0
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }else{
#if (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
        button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    }
#else
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    
    // Inset the title on the left and right
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
    
    // Make the button as high as the passed in image
    button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
    
    // Just like the standard back button, use the title of the previous item as the default back text
    [self setText:self.topItem.title onBackButton:button];
    
    // Set the stretchable images as the background for the button
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setImage:buttonHighlightImage forState:UIControlStateHighlighted];
//    [button setImage:buttonHighlightImage forState:UIControlStateSelected];
    
    // Add an action for going back
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void) setBackBarButtonWithBackButton:(UIButton*)backButton text:(NSString*)text
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = barButton;
    [self setText:text onBackButton:backButton];
    WT_SAFE_ARC_RELEASE(barButton);
}

// Set the text on the custom back button
-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton
{
    CGSize expectSize = CGSizeZero;
    UIFont *font = backButton.titleLabel.font;
    
    // Measure the width of the text
#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_7_0)
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        NSDictionary *attributesDict = @{NSFontAttributeName:font};
        expectSize = [text sizeWithAttributes:attributesDict];
    }
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
    else
#endif
#endif
#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
    {
        expectSize = [text sizeWithFont:font];
    }
#endif
    CGSize textSize = expectSize;
    
    // Change the button's frame. The width is either the width of the new text or the max width
//    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, (textSize.width + (backButtonCapWidth * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (backButtonCapWidth * 1.5)), backButton.frame.size.height);
    backButton.frame = CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y,MIN(MAX_BACK_BUTTON_WIDTH, (textSize.width + (backButtonCapWidth * 1.5))), backButton.frame.size.height);
    
    // Set the text on the button
    [backButton setTitle:text forState:UIControlStateNormal];
}

- (void)dealloc
{
    WT_SAFE_ARC_RELEASE(navigationBarBackgroundImage);
//    [navigationController release];
    WT_SAFE_ARC_SUPER_DEALLOC();
}

- (void)setNavigationController:(UINavigationController *)naviCon
{
    navigationController = naviCon;
    [navigationController setValue:self forKey:@"navigationBar"];
}

@end

@implementation UINavigationItem (CustomTitle)

- (void)setCustomTitle:(NSString *)title
{
//    [self setTitle:title];
    UILabel *titleView = (UILabel *)self.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:16];
        titleView.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        titleView.shadowOffset = CGSizeMake(1, 0.5);
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.titleView = titleView;
        WT_SAFE_ARC_RELEASE(titleView);
    }
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)setCustomTitle:(NSString *)title withFadeDuration:(CGFloat)time
{
//    [self setTitle:title];
    
    if([self.title isEqualToString:title])
    {
        
    }
    
    UILabel *titleViewOld = (UILabel *)self.titleView;
    if (!titleViewOld) {
        [self setCustomTitle:@""];
    }
    
    UILabel *titleViewNew = [[UILabel alloc] initWithFrame:CGRectZero];
    titleViewNew.backgroundColor = [UIColor clearColor];
    titleViewNew.font = [UIFont boldSystemFontOfSize:15];
    titleViewNew.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    titleViewNew.shadowOffset = CGSizeMake(1, 0.5);
    titleViewNew.textColor = [UIColor whiteColor];
    
    
    titleViewNew.text = title;
    [titleViewNew sizeToFit];
    
//    CGRect rectNew = titleViewNew.frame;
//    rectNew.origin.x = titleViewOld.frame.size.width;
//    titleViewNew.frame = rectNew;
    
    titleViewNew.alpha = 0.0f;
    
    [UIView animateWithDuration:time
                     animations:^{ 
                         
//                         CGRect rectOld = titleViewOld.frame;
//                         rectOld.origin.x = -rectOld.size.width;
//                         titleViewOld.frame = rectOld;
                         
                         titleViewOld.alpha = 0.0f;
                         
                         self.titleView = titleViewNew;
                         [titleViewNew sizeToFit];
                         
                         titleViewNew.alpha = 1.0f;
                         
                         WT_SAFE_ARC_RELEASE(titleViewNew);
                         
                     } 
                     completion:^(BOOL finished){
                         
                         if (titleViewOld) {
                             [titleViewOld removeFromSuperview];
                         }
                         
                         [UIView animateWithDuration:0.3
                                          animations:^{ 
                                          } 
                                          completion:^(BOOL finished){
                                              ;
                                          }];
                         
                     }];
}

@end
