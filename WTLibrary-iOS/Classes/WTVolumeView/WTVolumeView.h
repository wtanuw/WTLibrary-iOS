//
//  ThemeKlangV2Common.h
//  MTankSoundSamplerSS
//
//  Created by iMac on 10/11/17.
//  Copyright © 2017 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
@class AVAudioSession;
@class MPVolumeView;
@class WTVVerticallyAlignedLabel;

typedef enum WTMasterVolumeRotate {
    WTMasterVolumeRotateTop,
    WTMasterVolumeRotateSide,
    WTMasterVolumeRotateReverseSide,
} WTMasterVolumeRotate;

//IB_DESIGNABLE
@interface WTMasterVolumeView : UIView

//@property (nonatomic, weak, readonly) MPVolumeView *sliderVolume;
@property (nonatomic, assign) float sliderVolumeValue;
@property (nonatomic, weak, readonly) IBOutlet UILabel *sliderVolumeLabel;

@property (nonatomic, strong) UIImage *background;
@property (nonatomic, strong) UIImage *fill;
@property (nonatomic, strong) UIImage *thumbVol;
@property (nonatomic, assign) BOOL simulatorMode; //default is NO
@property (nonatomic, assign) WTMasterVolumeRotate rotateMode; //default is top
@property (nonatomic, assign) BOOL snapMode; //default is NO
@property (nonatomic, assign) BOOL numberOnThumb; //default is NO
@property (nonatomic, assign) BOOL resizableImageWithCapInsets; //default is NO

@property (nonatomic, assign) CGSize bgOffset; //
@property (nonatomic, assign) CGRect bgFrame; //for simulatorMode
@property (nonatomic, assign) UIEdgeInsets thumbOffset; //for simulatorMode, snapMode
@property (nonatomic, assign) CGRect thumbFrame; //for simulatorMode, snapMode


- (void)addLabel:(UILabel*)label;
- (void)updateMode;

@property (nonatomic, copy) void (^volumeDidChangeBlock)(float volumeValue);
@property (nonatomic, copy) NSString* (^customTextVolumeValueBlock)(float volumeValue);

-(void)syncVolumeView:(id)sender;

////#if TARGET_INTERFACE_BUILDER
////@property (nonatomic, assign) IBInspectable NSUInteger location;
////#else
////@property (nonatomic, assign) mKlangV2VolumeCustomLocation location;
////#endif
///**
// The current level value in the range 0.0 - 1.0. Defaults to 1.0.
// */
//@property (nonatomic, assign) IBInspectable CGFloat value;
///**
// The threshold value in the range 0.0 - 1.0 at which the bar color
// changes between emptyColor and fullColor. Default is 0.3.
// */
//@property (nonatomic, assign) CGFloat threshold;
///**
// The border width for the frame surrounding the bar. Default is 2.0.
// */
//@property (nonatomic, assign) CGFloat borderWidth;
///**
// The color of the bar border. Default is black.
// */
//@property (nonatomic, copy)   UIColor *borderColor;
///**
// The color of the bar when value >= threshold. Default is green.
// */
//@property (nonatomic, copy)   UIColor *fullColor;
///**
// The color of the bar when value < threshold. Default is red.
// */
//@property (nonatomic, copy)   UIColor *emptyColor;

@end


@interface WTMaster15VolumeView : WTMasterVolumeView
@property (nonatomic, strong) AVAudioSession *audioSession;
@end



@interface mMTankVolumeView : MPVolumeView

@end



typedef enum wtVerticalAlignment {
    wtVerticalAlignmentTop,
    wtVerticalAlignmentMiddle,
    wtVerticalAlignmentBottom,
} wtVerticalAlignment;

@interface WTVVerticallyAlignedLabel : UILabel {
@private
    wtVerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) wtVerticalAlignment verticalAlignment;

@end
