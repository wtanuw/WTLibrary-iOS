//
//  ThemeKlangV2Common.m
//  MTankSoundSamplerSS
//
//  Created by iMac on 10/11/17.
//  Copyright © 2017 Wat Wongtanuwat. All rights reserved.
//

#import "WTVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import <WTLibrary_iOS/WTVersion.h>
#import <WTLibrary_iOS/WTMacro.h>
#import <WTLibrary_iOS/WTUIInterface.h>

@interface WTMasterVolumeView()

@property (nonatomic, weak) IBOutlet MPVolumeView *sliderVolume;
//@property (nonatomic, assign) float sliderVolumeValue;
@property (nonatomic, weak) UILabel *sliderVolumeLabel;
@property (nonatomic, weak) UIImageView *mockBgImageView;
@property (nonatomic, weak) UIImageView *mockFillImageView;
@property (nonatomic, weak) UIImageView *snapThumbImageView;
@property (nonatomic, weak) UISlider *mockSlider;

@property (nonatomic, weak) UIView *rotateView;
@property (nonatomic, strong) CAShapeLayer *barLayer;
@property (nonatomic, assign, getter=isDirty) BOOL dirty;


@end

@implementation WTMasterVolumeView

//- (void)setupDefaults {
//    if (self.barLayer == nil) {
//        self.barLayer = [CAShapeLayer layer];
//        [self.layer addSublayer:self.barLayer];
//    }
//    self.value = 1.0f;
//    self.threshold = 0.3f;
//    self.borderWidth = 2.0f;
//    self.borderColor = [UIColor blackColor];
//    self.fullColor = [UIColor greenColor];
//    self.emptyColor = [UIColor redColor];
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupDefaults];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self setupDefaults];
//    }
//    return self;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayerProperties];
}
//
//- (void)setValue:(CGFloat)value {
//    if ((value >= 0.0) && (value <= 1.0)) {
//        _value = value;
//        [self updateLayerProperties];
//    }
//}
//
//- (void)setThreshold:(CGFloat)threshold {
//    if ((threshold >= 0.0) && (threshold <= 1.0)) {
//        _threshold = threshold;
//        [self updateLayerProperties];
//    }
//}
//
//- (void)setBorderWidth:(CGFloat)borderWidth {
//    if (borderWidth != _borderWidth) {
//        _borderWidth = borderWidth;
//        [self updateLayerProperties];
//    }
//}
//
//- (void)setBorderColor:(UIColor *)borderColor {
//    if (borderColor != _borderColor) {
//        _borderColor = borderColor;
//        [self updateLayerProperties];
//    }
//}
//
//- (void)setFullColor:(UIColor *)fullColor {
//    if (fullColor != _fullColor) {
//        _fullColor = fullColor;
//        [self updateLayerProperties];
//    }
//}
//
//- (void)setEmptyColor:(UIColor *)emptyColor {
//    if (emptyColor != _emptyColor) {
//        _emptyColor = emptyColor;
//        [self updateLayerProperties];
//    }
//}

- (void)updateLayerProperties {
//    CGRect barRect = self.bounds;
//    barRect.size.width = self.bounds.size.width * self.value;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:barRect];
//    self.barLayer.path = path.CGPath;
//    self.barLayer.fillColor = (self.value >= self.threshold) ? self.fullColor.CGColor : self.emptyColor.CGColor;
//    self.layer.borderWidth = self.borderWidth;
//    self.layer.borderColor = self.borderColor.CGColor;
//    self.layer.cornerRadius = 5.0f;
//    self.layer.masksToBounds = YES;
    _sliderVolume.frame = self.bounds;
    
    float outputVolume = (self.sliderVolumeValue>0)?self.sliderVolumeValue:0;
    UIView *refViewFrame = (_simulatorMode&&_mockBgImageView)?self.mockBgImageView:self.sliderVolume;
    UIEdgeInsets thumbOffset = self.thumbOffset;
    
    if (self.rotateMode == WTMasterVolumeRotateTop) {
        self.mockFillImageView.frame = CGRectMake(
            CGRectGetMinX(refViewFrame.frame),
            CGRectGetMinY(refViewFrame.frame)+CGRectGetHeight(refViewFrame.frame)*(1-outputVolume),
            CGRectGetWidth(refViewFrame.frame),
            CGRectGetHeight(refViewFrame.frame)*outputVolume
                                                  );
        float height = CGRectGetHeight(refViewFrame.frame)-thumbOffset.top-thumbOffset.bottom;
        self.snapThumbImageView.center = CGPointMake(
            refViewFrame.center.x+thumbOffset.left-thumbOffset.right,
            CGRectGetMinY(refViewFrame.frame)+thumbOffset.top+height*(1-outputVolume));
        
    } else if (self.rotateMode == WTMasterVolumeRotateSide) {
        self.mockFillImageView.frame = CGRectMake(
            CGRectGetMinX(refViewFrame.frame),
            CGRectGetMinY(refViewFrame.frame),
            CGRectGetWidth(refViewFrame.frame)*outputVolume,
            CGRectGetHeight(refViewFrame.frame)
                                                  );
        float width = CGRectGetWidth(refViewFrame.frame)-self.thumbOffset.left-self.thumbOffset.right;
        self.snapThumbImageView.center = CGPointMake(CGRectGetMinX(refViewFrame.frame)+self.thumbOffset.left+width*(outputVolume), self.mockFillImageView.center.y);
        
    } else if (self.rotateMode == WTMasterVolumeRotateReverseSide) {
        self.mockFillImageView.frame = CGRectMake(
            CGRectGetMinX(refViewFrame.frame)+CGRectGetWidth(refViewFrame.frame)*(1-outputVolume),
            CGRectGetMinY(refViewFrame.frame),
            CGRectGetWidth(refViewFrame.frame)*outputVolume,
            CGRectGetHeight(refViewFrame.frame)
                                                  );
        float width = CGRectGetWidth(refViewFrame.frame)-self.thumbOffset.left-self.thumbOffset.right;
        self.snapThumbImageView.center = CGPointMake(CGRectGetMinX(refViewFrame.frame)-self.thumbOffset.right+width*(1-outputVolume), self.mockFillImageView.center.y);
    }
}

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
    MPVolumeView *sliderVolume = [[mMTankVolumeView alloc] initWithFrame:self.bounds];
    [self addSubview:sliderVolume];
    _sliderVolume = sliderVolume;
    _sliderVolumeValue = -1;
    _rotateMode = WTMasterVolumeRotateTop;
    _snapMode = NO;
    _numberOnThumb = NO;
    _resizableImageWithCapInsets = YES;
    _simulatorMode = TARGET_IPHONE_SIMULATOR;
}

- (UIImage*)bgImage
{
    UIImage *background = (_resizableImageWithCapInsets)?[_background resizableImageWithCapInsets:UIEdgeInsetsZero]:_background;
    return background;
}

- (UIImage*)fillImage
{
    UIImage *fill = (_resizableImageWithCapInsets)?[_fill resizableImageWithCapInsets:UIEdgeInsetsZero]:_fill;
    return fill;
}

- (UIImage*)thumbImage
{
    UIImage *thumbVol =_thumbVol;
    return thumbVol;
}

- (UIImage*)blankImage
{
    return [UIImage imageNamed:@"MT_NEW_mastervolumebar_blank"];
}

- (UIImage*)lockImage
{
    return [UIImage imageNamed:@"MT_NEW_mastervolumebar_knob_locked"];
}

#pragma mark -

- (void)setUpSimulatorMode
{
    if (_simulatorMode) {
        self.backgroundColor = [UIColor brownColor];
        [self changeMockVolumeViewImage];
        _mockBgImageView.hidden = NO;
        _mockFillImageView.hidden = NO;
        _sliderVolume.hidden = YES;
        _snapThumbImageView.backgroundColor = [UIColor redColor];
        _sliderVolumeLabel.backgroundColor = [UIColor blueColor];
        if (_rotateMode == WTMasterVolumeRotateTop) {
            _thumbOffset = UIEdgeInsetsMake(_thumbVol.size.width*0.5, 00, _thumbVol.size.width*0.5, 0);
        } else {
            _thumbOffset = UIEdgeInsetsMake(0, _thumbVol.size.width*0.5, 0, _thumbVol.size.width*0.5);
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
        _mockBgImageView.hidden = YES;
        _mockFillImageView.hidden = YES;
        _sliderVolume.hidden = NO;
        _snapThumbImageView.backgroundColor = [UIColor clearColor];
        _sliderVolumeLabel.backgroundColor = [UIColor clearColor];
    }
    [self layoutIfNeeded];
}
- (void)setupSnapMode
{
    if (_snapMode) {
        if (!_snapThumbImageView) {
            UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.thumbVol.size.width, self.thumbVol.size.height)];
            _snapThumbImageView = imageViewBg;
            if (_rotateMode == WTMasterVolumeRotateTop) {
                imageViewBg.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
            }
            [self addSubview:_snapThumbImageView];
        }
        [_sliderVolume setVolumeThumbImage:[self blankImage] forState:UIControlStateNormal];
        _snapThumbImageView.image = [self thumbImage];
        [self bringSubviewToFront:_snapThumbImageView];
        [_mockSlider setThumbImage:[self blankImage] forState:UIControlStateNormal];
    } else {
        [_sliderVolume setVolumeThumbImage:[self thumbImage] forState:UIControlStateNormal];
        _snapThumbImageView.image = [self blankImage];
    }
    [self layoutIfNeeded];
}
- (void)setupNumberOnThumb
{
    if (_numberOnThumb) {
        if (!_sliderVolumeLabel) {
            WTVVerticallyAlignedLabel *label = [[WTVVerticallyAlignedLabel alloc] initWithFrame:CGRectMake(0, 0, self.thumbVol.size.height, self.thumbVol.size.width)];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.verticalAlignment = wtVerticalAlignmentMiddle;
            label.transform =CGAffineTransformIdentity;
//            if (self.rotateMode == WTMasterVolumeRotateSide) {
                label.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_ONE_QUARTER);
//            }
            label.center = CGPointMake(CGRectGetMidX(_snapThumbImageView.bounds), CGRectGetMidY(_snapThumbImageView.bounds));
            self.sliderVolumeLabel = label;
            [_snapThumbImageView addSubview:label];
        }
    } else {
        if (_sliderVolumeLabel.superview == _snapThumbImageView) {
            
            [_sliderVolumeLabel removeFromSuperview];
        }
    }
    [self layoutIfNeeded];
}
- (void)setResizeImage
{
    
}
- (void)setSliderVolumeValue:(float)sliderVolumeValue
{
    _sliderVolumeValue = sliderVolumeValue;
    [self setNeedsLayout];
}

- (void)updateMode
{
//   BOOL simulatorMode; //default is NO
//    @property (nonatomic, assign) WTMasterVolumeRotate rotateMode; //default is top
//    BOOL snapMode; //default is NO
//    BOOL numberOnThumb; //default is NO
//    @property (nonatomic, assign) BOOL resizableImageWithCapInsets; //default is NO
//    @property (nonatomic, assign) CGSize bgOffset; //
//    @property (nonatomic, assign) CGRect bgFrame; //for simulatorMode
//    @property (nonatomic, assign) UIEdgeInsets thumbOffset; //for simulatorMode, snapMode
//    @property (nonatomic, assign) CGRect thumbFrame
    [self setUpSimulatorMode];
    [self setupSnapMode];
    [self setupNumberOnThumb];
    
    if (_simulatorMode) {
//        self.thumbVol = [UIImage imageNamed:@"NEW_mastervolumebar_knob_7"];
       
        [self changeVolumeViewImage];
        [self changeMockVolumeViewImage];
//        self.rotateView.backgroundColor = [UIColor greenColor];
//        self.sliderVolume.backgroundColor = [UIColor yellowColor];
    } else {
        [self changeVolumeViewImage];
    }
}

- (void)addLabel:(UILabel*)label
{
    if (_sliderVolumeLabel==label) {
        return;
    }
    
    if (_sliderVolumeLabel) {
        [_sliderVolumeLabel removeFromSuperview];
    }
    self.sliderVolumeLabel = label;
    if (!label.superview) {
        [self addSubview:label];
    }
}

- (void)changeVolumeViewImage
{
    //    CGSize backgroundStretchPoints = {4, 9}, fillStretchPoints = {3, 8};
    //    UIImage *background = [[UIImage imageNamed:@"volumecontrol_bar.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width
    //                                                                                             topCapHeight:backgroundStretchPoints.height];
    //    UIImage *fill = [[UIImage imageNamed:@"volumecontrol_barFill.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width
    //                                                                                           topCapHeight:fillStretchPoints.height];
    //    UIImage *thumbTrack = [[UIImage imageNamed:@"player_sfxboard_slider_track_handle.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width
    //                                                                                                               topCapHeight:fillStretchPoints.height];
    //    UIImage *thumbVol = [[UIImage imageNamed:@"volumecontrol_handle.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width
    //                                                                                              topCapHeight:fillStretchPoints.height];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        float cap = 0;
        if([WTUIInterface UI_INTERFACE_IDIOM_IS_IPHONE]){
            cap = 12;
        }else{
            cap = 12;
        }
        UIImage *background = [self bgImage];
        UIImage *fill = [self fillImage];
        UIImage *thumbVol = [self thumbImage];
        
        UIView *tempRotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.rotateView = tempRotateView;
        if (_rotateMode == WTMasterVolumeRotateTop) {
            tempRotateView.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_ONE_QUARTER);
        }
        _sliderVolume.frame = tempRotateView.frame;
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.5")){
            
            //            sliderVolume.backgroundColor = [UIColor purpleColor];
            //            [sliderVolume removeConstraints:sliderVolume.constraints];
            [_sliderVolume setShowsVolumeSlider:YES];
            [_sliderVolume setShowsRouteButton:NO];
            _sliderVolume.layer.anchorPoint = CGPointMake(0.5, 0.5);
            _sliderVolume.transform = CGAffineTransformIdentity;
            if (_rotateMode == WTMasterVolumeRotateTop) {
                _sliderVolume.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
            }
            //        sliderVolume.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(130, 0),(RADIAN_FROM_DEGREE(270)));
            [_sliderVolume setVolumeThumbImage:thumbVol forState:UIControlStateNormal];
            [_sliderVolume setMinimumVolumeSliderImage:fill forState:UIControlStateNormal];
            [_sliderVolume setMaximumVolumeSliderImage:background forState:UIControlStateNormal];
        }else{
            [_sliderVolume setShowsVolumeSlider:YES];
            [_sliderVolume setShowsRouteButton:NO];
            _sliderVolume.layer.anchorPoint = CGPointMake(0.14, 0.0);
            _sliderVolume.layer.anchorPoint = CGPointMake(0.5, 0.5);
            _sliderVolume.transform = CGAffineTransformIdentity;
            if (_rotateMode == WTMasterVolumeRotateTop) {
                _sliderVolume.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
            }
            //            sliderVolume.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(120, 0),(RADIAN_FROM_DEGREE(270)));
            [_sliderVolume setVolumeThumbImage:thumbVol forState:UIControlStateNormal];
            [_sliderVolume setMinimumVolumeSliderImage:fill forState:UIControlStateNormal];
            [_sliderVolume setMaximumVolumeSliderImage:background forState:UIControlStateNormal];
        }
        
        [_sliderVolume.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[UISlider class]]) {
                UISlider *slider = (UISlider *)obj;
                [slider addTarget:self action:@selector(syncVolumeView:) forControlEvents:UIControlEventValueChanged];
                *stop = YES;
            }
        }];
        
//        [self performBlock:^{
            [self syncVolumeView:_sliderVolume];
//        } afterDelay:0.3];
        
        [self layoutIfNeeded];
    }
}

- (void)changeMockVolumeViewImage
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        
        UIImage *background = _background;
        UIImage *fill = [self fillImage];
        UIImage *thumbVol = [self thumbImage];
        
        UIView *tempRotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (_rotateMode == WTMasterVolumeRotateTop) {
            tempRotateView.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_ONE_QUARTER);
        }
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.5")){
            if (!_mockBgImageView) {
                UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:tempRotateView.frame];
                _mockBgImageView = imageViewBg;
                imageViewBg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                if (_rotateMode == WTMasterVolumeRotateTop) {
                    imageViewBg.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
                }
                [self addSubview:imageViewBg];
            }
            if (!_mockFillImageView) {
                UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:tempRotateView.frame];
                _mockFillImageView = imageViewBg;
                imageViewBg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                if (_rotateMode == WTMasterVolumeRotateTop) {
                    imageViewBg.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
                }
                [self addSubview:imageViewBg];
            }
            if (!_mockSlider) {
                UISlider *slider = [[UISlider alloc] initWithFrame:tempRotateView.frame];
                _mockSlider = slider;
                if (_rotateMode == WTMasterVolumeRotateTop) {
                    slider.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
                }
                [slider addTarget:self action:@selector(syncVolumeView:) forControlEvents:UIControlEventValueChanged];
                [slider setThumbImage:thumbVol forState:UIControlStateNormal];
                [self addSubview:slider];
            }
//            imageViewBg.layer.anchorPoint = CGPointMake(0.5, 0.5);
//            imageViewBg.contentMode = UIViewContentModeScaleToFill;
        }else{
//            [_sliderVolume setShowsVolumeSlider:YES];
//            [_sliderVolume setShowsRouteButton:NO];
//            _sliderVolume.layer.anchorPoint = CGPointMake(0.14, 0.0);
//            _sliderVolume.layer.anchorPoint = CGPointMake(0.5, 0.5);
//            _sliderVolume.transform = CGAffineTransformIdentity;
//            if (_rotateMode == WTMasterVolumeRotateTop) {
//                _sliderVolume.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
//            }
//            [_sliderVolume setVolumeThumbImage:thumbVol forState:UIControlStateNormal];
//            [_sliderVolume setMinimumVolumeSliderImage:fill forState:UIControlStateNormal];
//            [_sliderVolume setMaximumVolumeSliderImage:background forState:UIControlStateNormal];
        }
        
        _mockBgImageView.image = background;
        _mockFillImageView.image = fill;
        
//        [_sliderVolume.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
//            if([obj isKindOfClass:[UISlider class]]) {
//                UISlider *slider = (UISlider *)obj;
//                [slider addTarget:self action:@selector(syncVolumeView:) forControlEvents:UIControlEventValueChanged];
//                *stop = YES;
//            }
//        }];
//
////        [self performBlock:^{
//            [self syncVolumeView:_sliderVolume];
////        } afterDelay:0.3];
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    //fixed bug VolumeThumb draw below slider
//    [_sliderVolume.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
//        if([obj isKindOfClass:[UISlider class]]) {
//            UISlider *slider = (UISlider *)obj;
//            [slider.subviews enumerateObjectsUsingBlock:^(UIView *obj2, NSUInteger idx, BOOL *stop2) {
//                if(CGSizeEqualToSize(obj2.frame.size, CGSizeZero)) {
//                    [obj bringSubviewToFront:obj2];
//                    *stop2 = YES;
//                }
//            }];
//            *stop = YES;
//        }
//    }];
////    if ( _location == KlangV2VolumeCustomLocationEditor) {
////        [self syncVolumeView:nil];
////    }
//}

- (void)syncVolumeView:(id)sender
{
    if(_sliderVolumeLabel){
        float outputVolume = [AVAudioSession sharedInstance].outputVolume;
        if (_simulatorMode) {
            int interval = 20;
            int cal = ((int)(outputVolume*100/interval));
            outputVolume = cal*interval/100.0;
        }
        _sliderVolumeValue = outputVolume;
        if (_customTextVolumeValueBlock) {
            _sliderVolumeLabel.text = _customTextVolumeValueBlock(_sliderVolumeValue);
        } else {
            _sliderVolumeLabel.text = [NSString stringWithFormat:@"%.0f%%",_sliderVolumeValue*100];
        }
        [_sliderVolume.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[UISlider class]]) {
                UISlider *slider = (UISlider *)obj;
                if(slider.value!=_sliderVolumeValue){
                    _sliderVolumeValue = slider.value;
                    if (_customTextVolumeValueBlock) {
                        _sliderVolumeLabel.text = _customTextVolumeValueBlock(_sliderVolumeValue);
                    } else {
                        _sliderVolumeLabel.text = [NSString stringWithFormat:@"%.0f%%",_sliderVolumeValue*100];
                    }
//                    sliderVolumeLabel.frame = sliderVolumeLabel.superview.bounds;
//                    mixerVolumeLabel.frame = mixerVolumeLabel.superview.bounds;
                }
                *stop = YES;
            }
        }];
    }
    if (_volumeDidChangeBlock) {
        _volumeDidChangeBlock(_sliderVolumeValue);
    }
}

@end

@implementation WTMaster15VolumeView

- (void)addObserver
{
    self.audioSession = [AVAudioSession sharedInstance];
    [self.audioSession addObserver:self forKeyPath:@"outputVolume" options:0 context:nil];
}
- (void)removeObserver
{
    [self.audioSession removeObserver:self forKeyPath:@"outputVolume"];
    self.audioSession = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    CGFloat newVolume = self.audioSession.outputVolume;
    NSLog(@"newVolume: %f", newVolume);

    [self setSystemVolume:newVolume];
      //if the volume gets to max or min observer won't trigger
    if (newVolume > 0.9 || newVolume < 0.1) {
        return;
    }
}

  //set the volume programatically
- (void)setSystemVolume:(CGFloat)volumeValue {
    [self syncVolumeView:self.sliderVolume];
}

- (void)changeVolumeViewImage
{
    [self removeObserver];
    [self addObserver];
    if(SYSTEM_VERSION_LESS_THAN(@"14.0")){
        [super changeVolumeViewImage];
    } else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0")){
        float cap = 0;
        if([WTUIInterface UI_INTERFACE_IDIOM_IS_IPHONE]){
            cap = 12;
        }else{
            cap = 12;
        }
        UIImage *background = [self bgImage];
        UIImage *fill = [self fillImage];
        UIImage *thumbVol = [self thumbImage];

        UIView *rotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (self.rotateMode == WTMasterVolumeRotateTop) {
            rotateView.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_ONE_QUARTER);
        }
        
        self.sliderVolume.frame = rotateView.frame;

        //        sliderVolume.layer.borderWidth = 2;
        //        sliderVolume.layer.borderColor = [UIColor greenColor].CGColor;
//        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.5")){

            //            sliderVolume.backgroundColor = [UIColor purpleColor];
            //            [sliderVolume removeConstraints:sliderVolume.constraints];
            [self.sliderVolume setShowsVolumeSlider:YES];
            [self.sliderVolume setShowsRouteButton:NO];
        self.sliderVolume.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.sliderVolume.transform = CGAffineTransformIdentity;
            if (self.rotateMode == WTMasterVolumeRotateTop) {
                self.sliderVolume.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
            }
            //        sliderVolume.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(130, 0),(RADIAN_FROM_DEGREE(270)));
            [self.sliderVolume setVolumeThumbImage:thumbVol forState:UIControlStateNormal];
            [self.sliderVolume setMinimumVolumeSliderImage:fill forState:UIControlStateNormal];
            [self.sliderVolume setMaximumVolumeSliderImage:background forState:UIControlStateNormal];
        }
//            else{
//            [_sliderVolume setShowsVolumeSlider:YES];
//            [_sliderVolume setShowsRouteButton:NO];
//            _sliderVolume.layer.anchorPoint = CGPointMake(0.14, 0.0);
//            _sliderVolume.layer.anchorPoint = CGPointMake(0.5, 0.5);
//            _sliderVolume.transform = CGAffineTransformIdentity;
//            if (_location != KlangV2VolumeCustomLocationKeyboard) {
//                _sliderVolume.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_THREE_QUARTER);
//            }
//            //            sliderVolume.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(120, 0),(RADIAN_FROM_DEGREE(270)));
//            [_sliderVolume setVolumeThumbImage:thumbVol forState:UIControlStateNormal];
//            [_sliderVolume setMinimumVolumeSliderImage:fill forState:UIControlStateNormal];
//            [_sliderVolume setMaximumVolumeSliderImage:background forState:UIControlStateNormal];
//        }
//
    
    
//    if(!self.sliderVolumeLabel && self.numberOnThumb){
//        UIImage *thumbVol = self.thumbVol;
//        float outputVolume = [AVAudioSession sharedInstance].outputVolume;
//        WTVVerticallyAlignedLabel *label = [[WTVVerticallyAlignedLabel alloc] initWithFrame:CGRectMake(0, 0, thumbVol.size.height, thumbVol.size.width)];
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.verticalAlignment = wtVerticalAlignmentMiddle;
//        label.transform =CGAffineTransformIdentity;
//        if (self.rotateMode == WTMasterVolumeRotateSide) {
//            label.transform = CGAffineTransformMakeRotation(RADIAN_CLOCKWISE_ONE_QUARTER);
//        }
//        [self addSubview:label];
//        self.sliderVolumeLabel = label;
//
//        CGRect trackRect = [self.sliderVolume volumeSliderRectForBounds:self.bounds];
//        CGRect thumbRect = [self.sliderVolume
//                            volumeThumbRectForBounds:self.bounds
//                            volumeSliderRect:trackRect
//                            value:outputVolume];
//        label.center = CGPointMake(thumbRect.origin.x + thumbRect.size.width*0.5+2,  thumbRect.origin.y + thumbRect.size.height*0.5);
//    }
//        [self.sliderVolume.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
//            if([obj isKindOfClass:[UISlider class]]) {
//                UISlider *slider = (UISlider *)obj;
//                [slider addTarget:self action:@selector(syncVolumeView:) forControlEvents:UIControlEventValueChanged];
//                *stop = YES;
//            }
//        }];
        
//        [self performBlock:^{
            [self syncVolumeView:self.sliderVolume];
//        } afterDelay:0.3];
        
        [self layoutIfNeeded];
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    //fixed bug VolumeThumb draw below slider
//    [_sliderVolume.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
//        if([obj isKindOfClass:[UISlider class]]) {
//            UISlider *slider = (UISlider *)obj;
//            [slider.subviews enumerateObjectsUsingBlock:^(UIView *obj2, NSUInteger idx, BOOL *stop2) {
//                if(CGSizeEqualToSize(obj2.frame.size, CGSizeZero)) {
//                    [obj bringSubviewToFront:obj2];
//                    *stop2 = YES;
//                }
//            }];
//            *stop = YES;
//        }
//    }];
////    if ( _location == KlangV2VolumeCustomLocationEditor) {
////        [self syncVolumeView:nil];
////    }
}

- (void)syncVolumeView:(id)sender
{
    if(SYSTEM_VERSION_LESS_THAN(@"14.0")){
        [super syncVolumeView:sender];
        return;
    }
    
    float outputVolume = [AVAudioSession sharedInstance].outputVolume;
    
    if (self.simulatorMode) {
        outputVolume = self.mockSlider.value;
    }
    if(self.sliderVolumeLabel){
        if(self.sliderVolumeValue != outputVolume){
            self.sliderVolumeValue = outputVolume;
            if (self.customTextVolumeValueBlock) {
                self.sliderVolumeLabel.text = self.customTextVolumeValueBlock(self.sliderVolumeValue);
            } else {
                self.sliderVolumeLabel.text = [NSString stringWithFormat:@"%.0f%%",self.sliderVolumeValue*100];
            }
            CGRect trackRect = [self.sliderVolume volumeSliderRectForBounds:self.bounds];
            CGRect thumbRect = [self.sliderVolume volumeThumbRectForBounds:self.bounds
                                                          volumeSliderRect:trackRect
                                                         value:outputVolume];
            
            
            NSInteger offsetMain = 2;
            NSInteger offsetCross = 2;
            NSInteger percentage = 1.0 - self.sliderVolumeValue;
            
            
//            if (self.numberOnThumb && self.rotateMode == WTMasterVolumeRotateTop) {
//                self.sliderVolumeLabel.center = CGPointMake(
//                                                            thumbRect.origin.x + thumbRect.size.width*0.5+2,
//                                                            thumbRect.origin.y + thumbRect.size.height*percentage
//                                                            );
//            } else if (self.numberOnThumb && self.rotateMode == WTMasterVolumeRotateSide) {
//                percentage = self.sliderVolumeValue;
//                    self.sliderVolumeLabel.center = CGPointMake(
//                                                                thumbRect.origin.x +(thumbRect.size.width*0.5+2)*percentage,
//                                                                thumbRect.origin.y + thumbRect.size.height*0.5
//                                                                );
//            } else if (self.numberOnThumb && self.rotateMode == WTMasterVolumeRotateReverseSide) {
//
//            }
            
        }
    }
    
    if (self.volumeDidChangeBlock) {
        self.volumeDidChangeBlock(outputVolume);
    }
}


@end

#pragma mark -

@implementation mMTankVolumeView

- (CGRect)volumeSliderRectForBounds:(CGRect)bounds
{
    CGRect newBounds=[super volumeSliderRectForBounds:bounds];
    newBounds.origin.y=bounds.origin.y;
    newBounds.size.height=bounds.size.height;
    newBounds.size.width=bounds.size.width;
    
    return newBounds;
    
    //    WatLog(@"bounds %@",NSStringFromCGRect(bounds));
    //    CGRect newBounds=[super volumeSliderRectForBounds:bounds];
    //
    //    newBounds.origin.y=bounds.origin.y;
    //    newBounds.size.width=(bounds.size.width>bounds.size.height)?bounds.size.width:bounds.size.height;
    //    newBounds.size.height=(bounds.size.width<bounds.size.height)?bounds.size.width:bounds.size.height;
    //    WatLog(@"new bounds %@",NSStringFromCGRect(newBounds));
    //    return newBounds;
}
- (CGRect)volumeThumbRectForBounds:(CGRect)bounds
                  volumeSliderRect:(CGRect)rect
                             value:(float)value
{
    return bounds;
}
//- (CGRect)volumeThumbRectForBounds:(CGRect)bounds volumeSliderRect:(CGRect)rect value:(float)value
//{
//    return bounds;
//}

- (CGRect) routeButtonRectForBounds:(CGRect)bounds {
    CGRect newBounds=[super routeButtonRectForBounds:bounds];
    
    newBounds.origin.y=bounds.origin.y;
    newBounds.size.height=bounds.size.height;
    
    return newBounds;
}

@end

#pragma mark -

@implementation WTVVerticallyAlignedLabel

@synthesize verticalAlignment = verticalAlignment_;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = wtVerticalAlignmentTop;
    }
    return self;
}

- (void)setVerticalAlignment:(wtVerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case wtVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case wtVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case wtVerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
