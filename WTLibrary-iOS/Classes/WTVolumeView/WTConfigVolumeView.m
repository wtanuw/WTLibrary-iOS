//
//  ThemeKlangV2Common.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 10/11/17.
//  Copyright © 2017 Wat Wongtanuwat. All rights reserved.
//

#import "WTConfigVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <WTLibrary_iOS/WTVersion.h>
#import <WTLibrary_iOS/WTMacro.h>
#import <WTLibrary_iOS/WTSwipeModalView.h>
#import <WTLibrary_iOS/WTUIInterface.h>
#import "WTVolumeView.h"

@interface WTConfigMasterVolumeView()

//@property (nonatomic, weak) IBOutlet MPVolumeView *sliderVolume;
//@property (nonatomic, assign) float sliderVolumeValue;
//@property (nonatomic, weak) UILabel *sliderVolumeLabel;
//
//@property (nonatomic, weak) UIView *rotateView;

@property (nonatomic,strong) WTSwipeModalView *swipeView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation WTConfigMasterVolumeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    
}

#pragma mark -

+ (instancetype)storyboardView
{
    NSBundle *bundle = [NSBundle bundleForClass:[WTConfigMasterVolumeView class]];
    NSBundle *bundle2 = [NSBundle bundleWithIdentifier:@"org.cocoapods.WTLibrary-iOS"];
    
    NSString *path = [bundle pathForResource:@"WTLibrary_iOS_WTVolumeView"
                                                                 ofType:@"bundle"];

    NSBundle *bundle3 = [NSBundle bundleWithPath:path];
    NSBundle *bundle4 = [NSBundle mainBundle];
    UIStoryboard *s;
    if([WTUIInterface UI_INTERFACE_IDIOM_IS_IPAD]){
        s = [UIStoryboard storyboardWithName:@"WTVolumeView" bundle:bundle];
    } else {
        s = [UIStoryboard storyboardWithName:@"WTVolumeView" bundle:bundle];
    }
//    let bundlePath = NSBundle(forClass: GANavigationMenuViewController.self).pathForResource("resources", ofType: "bundle")
//    let bundle = NSBundle(path: bundlePath!)
    
    UIViewController *controller = [s instantiateViewControllerWithIdentifier:@"WTConfigVolumeView"];
    
    __weak typeof(self) weak_self = self;
//    WTConfigMasterVolumeView *view = ((WTConfigMasterVolumeView*)controller.view);
    WTConfigMasterVolumeView *view = ((WTConfigMasterVolumeView*)controller.view).contentView;
    [view loadView];
    return view;
}

- (void)loadView
{
    UIImage* a =  [UIImage imageNamed:@"MT_NEW_iphone_mastervolumebar_off"];
    UIImage* b =  [UIImage imageNamed:@"MT_NEW_iphone_mastervolumebar_off" inBundle:[NSBundle bundleForClass:[WTConfigMasterVolumeView class]] withConfiguration:nil];
    
    
    
    
        UIImage *background = [[UIImage imageNamed:@"MT_NEW_mastervolumebar_off"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        UIImage *fill = [[UIImage imageNamed:@"MT_NEW_mastervolumebar_off"] resizableImageWithCapInsets:UIEdgeInsetsZero];

    _side1VolumeView.rotateMode = WTMasterVolumeRotateSide;
    _side2VolumeView.rotateMode = WTMasterVolumeRotateSide;
    _top1VolumeView.resizableImageWithCapInsets = YES;
    _top2VolumeView.resizableImageWithCapInsets = YES;
    _side1VolumeView.resizableImageWithCapInsets = YES;
    _side2VolumeView.resizableImageWithCapInsets = YES;
    
    _top1VolumeView.background = [UIImage imageNamed:@"MT_NEW_iphone_mastervolumebar_off"];
    _top1VolumeView.fill = [UIImage imageNamed:@"MT_NEW_iphone_mastervolumebar_on"];
    _top1VolumeView.thumbVol = [UIImage imageNamed:@"MT_NEW_mastervolumebar_knob"];
    _top2VolumeView.background = [UIImage imageNamed:@"MT_NEW_iphone_mastervolumebar_off"];
    _top2VolumeView.fill = [UIImage imageNamed:@"MT_NEW_iphone_mastervolumebar_on"];
    _top2VolumeView.thumbVol = [UIImage imageNamed:@"MT_NEW_mastervolumebar_knob"];
    _side1VolumeView.background = [UIImage imageNamed:@"MT_NEW_mastervolumebar_off"];
    _side1VolumeView.fill = [UIImage imageNamed:@"MT_NEW_mastervolumebar_on"];
    _side1VolumeView.thumbVol = [UIImage imageNamed:@"MT_NEW_mastervolumebar_knob"];
    _side2VolumeView.background = [UIImage imageNamed:@"MT_NEW_mastervolumebar_off"];
    _side2VolumeView.fill = [UIImage imageNamed:@"MT_NEW_mastervolumebar_on"];
    _side2VolumeView.thumbVol = [UIImage imageNamed:@"MT_NEW_mastervolumebar_knob"];
    [_top1VolumeView updateMode];
    [_top2VolumeView updateMode];
    [_side1VolumeView updateMode];
    [_side2VolumeView updateMode];
}
//MT_NEW_iphone_mastervolumebar_off
//MT_NEW_iphone_mastervolumebar_on
//MT_NEW_mastervolumebar_blank
//MT_NEW_mastervolumebar_knob
//MT_NEW_mastervolumebar_off
//MT_NEW_mastervolumebar_on

#pragma mark -

- (void)showFromView:(UIView *)view
{
    if(!self.swipeView){
        WTSwipeModalView *swipeView = [WTSwipeModalView SwipeView];
        swipeView.dimViewAlphaMax = 0.0;
        swipeView.showAnimation = WTSwipeModalAnimationPop;
        swipeView.hideAnimation = WTSwipeModalAnimationPop;
        if ([WTUIInterface UI_INTERFACE_IDIOM_IS_IPAD]) {
            swipeView.useAdaptiveSize = NO;
        }
        self.swipeView = swipeView;
        
    }
    
    [self.swipeView addContent:self];
    [self.swipeView showSwipeFromView:view];
}

- (void)hide
{
    [self.swipeView hideSwipe];
}

#pragma mark -

- (IBAction)imageButtonPressed:(id)sender {
    BOOL on = ((UISwitch*)sender).isOn;
    _top1VolumeView.resizableImageWithCapInsets = on;
    _side1VolumeView.resizableImageWithCapInsets = on;
    _top2VolumeView.resizableImageWithCapInsets = on;
    _side2VolumeView.resizableImageWithCapInsets = on;
    [self updateMode];
}

- (IBAction)simulatorButtonPressed:(id)sender {
    BOOL on = ((UISwitch*)sender).isOn;
    _top2VolumeView.simulatorMode = on;
    _side2VolumeView.simulatorMode = on;
    [self updateMode];
}

- (IBAction)snapButtonPressed:(id)sender {
    BOOL on = ((UISwitch*)sender).isOn;
    _top1VolumeView.snapMode = on;
    _side1VolumeView.snapMode = on;
    _top2VolumeView.snapMode = on;
    _side2VolumeView.snapMode = on;
    [self updateMode];
}

- (IBAction)outlineButtonPressed:(id)sender {
    BOOL on = ((UISwitch*)sender).isOn;
    if (on) {
        _top1VolumeView.layer.borderColor = [UIColor redColor].CGColor;
        _top1VolumeView.layer.borderWidth = 1;
        _top2VolumeView.layer.borderColor = [UIColor redColor].CGColor;
        _top2VolumeView.layer.borderWidth = 1;
        _side1VolumeView.layer.borderColor = [UIColor redColor].CGColor;
        _side1VolumeView.layer.borderWidth = 1;
        _side2VolumeView.layer.borderColor = [UIColor redColor].CGColor;
        _side2VolumeView.layer.borderWidth = 1;
    } else {
        
    }
}

- (IBAction)numberOnThumbButtonPressed:(id)sender {
    BOOL on = ((UISwitch*)sender).isOn;
    _top1VolumeView.numberOnThumb = on;
    _side1VolumeView.numberOnThumb = on;
    _top2VolumeView.numberOnThumb = on;
    _side2VolumeView.numberOnThumb = on;
    [self updateMode];
    
}

- (IBAction)button1Pressed:(id)sender {
    _top1VolumeView.frame = CGRectMake(CGRectGetMinX(_top1VolumeView.frame), CGRectGetMinY(_top1VolumeView.frame), 59, 238);
    _top2VolumeView.frame = CGRectMake(CGRectGetMinX(_top2VolumeView.frame), CGRectGetMinY(_top2VolumeView.frame), 59, 238);
    _widthTextField .text = [NSString stringWithFormat:@"%d",59];
    _heightTextField .text = [NSString stringWithFormat:@"%d",238];
}

- (IBAction)button2Pressed:(id)sender {
    _top1VolumeView.frame = CGRectMake(CGRectGetMinX(_top1VolumeView.frame), CGRectGetMinY(_top1VolumeView.frame), 74, 296);
    _top2VolumeView.frame = CGRectMake(CGRectGetMinX(_top2VolumeView.frame), CGRectGetMinY(_top2VolumeView.frame), 74, 296);
    _widthTextField .text = [NSString stringWithFormat:@"%d",74];
    _heightTextField .text = [NSString stringWithFormat:@"%d",296];
}

- (IBAction)button3Pressed:(id)sender {
    _top1VolumeView.frame = CGRectMake(CGRectGetMinX(_top1VolumeView.frame), CGRectGetMinY(_top1VolumeView.frame), 101, 297);
    _top2VolumeView.frame = CGRectMake(CGRectGetMinX(_top2VolumeView.frame), CGRectGetMinY(_top2VolumeView.frame), 101, 297);
    _widthTextField .text = [NSString stringWithFormat:@"%d",101];
    _heightTextField .text = [NSString stringWithFormat:@"%d",297];
}

- (IBAction)button4Pressed:(id)sender {
    _side1VolumeView.frame = CGRectMake(CGRectGetMinX(_side1VolumeView.frame), CGRectGetMinY(_side1VolumeView.frame), 297, 101);
    _side2VolumeView.frame = CGRectMake(CGRectGetMinX(_side2VolumeView.frame), CGRectGetMinY(_side2VolumeView.frame), 297, 101);
    _widthTextField .text = [NSString stringWithFormat:@"%d",297];
    _heightTextField .text = [NSString stringWithFormat:@"%d",101];
}

- (void)updateMode {
    [_top1VolumeView updateMode];
    [_side1VolumeView updateMode];
    [_top2VolumeView updateMode];
    [_side2VolumeView updateMode];
}

- (IBAction)textChange:(id)sender {
    
//    @property (weak, nonatomic) IBOutlet UITextField *frameXTextField;
//    @property (weak, nonatomic) IBOutlet UITextField *frameYTextField;
    
//    @property (weak, nonatomic) IBOutlet UITextField *thumbFrameXTextField;
//    @property (weak, nonatomic) IBOutlet UITextField *thumbFrameYTextField;
//    @property (weak, nonatomic) IBOutlet UITextField *thumbFrameWidthTextField;
//    @property (weak, nonatomic) IBOutlet UITextField *thumbFrameHeightTextField;
    if(sender == _widthTextField) {
        [self changeSize:CGSizeMake(_widthTextField.text.intValue, _heightTextField.text.intValue)];
    }
    if(sender == _heightTextField) {
        [self changeSize:CGSizeMake(_widthTextField.text.intValue, _heightTextField.text.intValue)];
    }
//    if(sender == _offsetXTextField) {
//        [self changeOffset:CGSizeMake(_offsetXTextField.text.intValue, _offsetYTextField.text.intValue)];
//    }
//    if(sender == _offsetYTextField) {
//        [self changeOffset:CGSizeMake(_offsetXTextField.text.intValue, _offsetYTextField.text.intValue)];
//    }
//    if(sender == _frameWidthTextField) {
//        [self changeBgSize:CGSizeMake(_frameWidthTextField.text.intValue, _frameHeightTextField.text.intValue)];
//    }
//    if(sender == _frameHeightTextField) {
//        [self changeBgSize:CGSizeMake(_frameWidthTextField.text.intValue, _frameHeightTextField.text.intValue)];
//    }
    
    if(sender == _thumbOffsetTopTextField) {
        [self changeThumbOffset:UIEdgeInsetsMake(_thumbOffsetTopTextField.text.intValue, _thumbOffsetLeftTextField.text.intValue, _thumbOffsetBottomTextField.text.intValue, _thumbOffsetRightTextField.text.intValue)];
    }
    if(sender == _thumbOffsetLeftTextField) {
        [self changeThumbOffset:UIEdgeInsetsMake(_thumbOffsetTopTextField.text.intValue, _thumbOffsetLeftTextField.text.intValue, _thumbOffsetBottomTextField.text.intValue, _thumbOffsetRightTextField.text.intValue)];
    }
    if(sender == _thumbOffsetBottomTextField) {
        [self changeThumbOffset:UIEdgeInsetsMake(_thumbOffsetTopTextField.text.intValue, _thumbOffsetLeftTextField.text.intValue, _thumbOffsetBottomTextField.text.intValue, _thumbOffsetRightTextField.text.intValue)];
    }
    if(sender == _thumbOffsetRightTextField) {
        [self changeThumbOffset:UIEdgeInsetsMake(_thumbOffsetTopTextField.text.intValue, _thumbOffsetLeftTextField.text.intValue, _thumbOffsetBottomTextField.text.intValue, _thumbOffsetRightTextField.text.intValue)];
    }
}

- (void)changeSize:(CGSize)size {
    _top1VolumeView.frame = CGRectMake(CGRectGetMinX(_top1VolumeView.frame), CGRectGetMinY(_top1VolumeView.frame), size.width, size.height);
    _top2VolumeView.frame = CGRectMake(CGRectGetMinX(_top2VolumeView.frame), CGRectGetMinY(_top2VolumeView.frame), size.width, size.height);
    _side1VolumeView.frame = CGRectMake(CGRectGetMinX(_side1VolumeView.frame), CGRectGetMinY(_side1VolumeView.frame), size.height, size.width);
    _side2VolumeView.frame = CGRectMake(CGRectGetMinX(_side2VolumeView.frame), CGRectGetMinY(_side2VolumeView.frame), size.height, size.width);
}

- (void)changeOffset:(CGSize)size {
    _top1VolumeView.bgOffset = CGSizeMake(size.width, size.height);
    _top2VolumeView.bgOffset = CGSizeMake(size.width, size.height);
    _side1VolumeView.bgOffset = CGSizeMake(size.width, size.height);
    _side2VolumeView.bgOffset = CGSizeMake(size.width, size.height);
}

- (void)changeBgSize:(CGSize)size {
    _top1VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
    _top2VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
    _side1VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
    _side2VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
}

- (void)changeThumbOffset:(UIEdgeInsets)inset {
    _top1VolumeView.thumbOffset = inset;
    _top2VolumeView.thumbOffset = inset;
    _side1VolumeView.thumbOffset = inset;
    _side2VolumeView.thumbOffset = inset;
}

- (void)changeThumbSize:(CGSize)size {
    _top1VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
    _top2VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
    _side1VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
    _side2VolumeView.bgFrame = CGRectMake(0, 0, size.width, size.height);
}

- (IBAction)sliderChanged:(id)sender {
    float value = ((UISlider*)sender).value;
    _top1VolumeView.sliderVolumeValue = value;
    _top2VolumeView.sliderVolumeValue = value;
    _side1VolumeView.sliderVolumeValue = value;
    _side2VolumeView.sliderVolumeValue = value;
}

@end
