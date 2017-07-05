//
//  CustomNavigationBar.h
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

#import <UIKit/UIKit.h>
#import "WTMacro.h"

@interface WTNavigationBar : UINavigationBar
{
    UIImage *navigationBarBackgroundImage;
    CGFloat backButtonCapWidth;
    __unsafe_unretained IBOutlet UINavigationController* navigationController;
    
    BOOL notGrowPromptIpad;
}

@property (nonatomic, retain) UIImage *navigationBarBackgroundImage;
@property (nonatomic, assign) IBOutlet UINavigationController* navigationController;

- (id)initWithNavigationController:(UINavigationController*)navVCT;

-(void) setBackgroundImage:(UIImage*)backgroundImage;
-(void) clearBackgroundImage;

-(UIButton*) buttonWithImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage capInset:(UIEdgeInsets)inset;
-(UIButton*) backButtonWithImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage capInset:(UIEdgeInsets)inset;
-(void) setBackBarButtonWithBackButton:(UIButton*)backButton text:(NSString*)text;

-(void) setText:(NSString*)text onBackButton:(UIButton*)backButton;

@end

@interface UINavigationItem (CustomTitle)

- (void)setCustomTitle:(NSString *)title;
- (void)setCustomTitle:(NSString *)title withFadeDuration:(CGFloat)time;

@end

//@interface UINavigationController (MTCustomNavigationBar)
//
//- (id)initWithCustomNavigationBar:(UINavigationBar *)navigationBar;
//
//@end
