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
@class WTMaster15VolumeView;

@interface WTConfigMasterVolumeView : UIView
+ (instancetype)storyboardView;
- (void)showFromView:(UIView *)view;
//@property (nonatomic, weak, readonly) MPVolumeView *sliderVolume;
//@property (nonatomic, assign, readonly) float sliderVolumeValue;
//@property (nonatomic, weak, readonly) IBOutlet UILabel *sliderVolumeLabel;
//
//@property (nonatomic, strong) UIImage *background;
//@property (nonatomic, strong) UIImage *fill;
//@property (nonatomic, strong) UIImage *thumbVol;
//@property (nonatomic, assign) BOOL simulatorMode; //default is NO
//@property (nonatomic, assign) WTMasterVolumeRotate rotateMode; //default is top
//@property (nonatomic, assign) BOOL snapMode; //default is NO
//@property (nonatomic, assign) BOOL numberOnThumb; //default is NO
//- (void)addLabel:(UILabel*)label;
//- (void)updateMode;
//
//@property (nonatomic, copy) void (^volumeDidChangeBlock)(float volumeValue);
//@property (nonatomic, copy) NSString* (^customTextVolumeValueBlock)(float volumeValue);
//
//-(void)syncVolumeView:(id)sender;
//
////#if TARGET_INTERFACE_BUILDER
////@property (nonatomic, assign) IBInspectable NSUInteger location;
////#else
////@property (nonatomic, assign) mKlangV2VolumeCustomLocation location;
////#endif
@property (weak, nonatomic) IBOutlet WTMaster15VolumeView *top1VolumeView;
@property (weak, nonatomic) IBOutlet WTMaster15VolumeView *top2VolumeView;
@property (weak, nonatomic) IBOutlet WTMaster15VolumeView *side1VolumeView;
@property (weak, nonatomic) IBOutlet WTMaster15VolumeView *side2VolumeView;

- (IBAction)simulatorButtonPressed:(id)sender;
- (IBAction)snapButtonPressed:(id)sender;
- (IBAction)numberOnThumbButtonPressed:(id)sender;
- (IBAction)imageButtonPressed:(id)sender;
- (IBAction)button1Pressed:(id)sender;
- (IBAction)button2Pressed:(id)sender;
- (IBAction)button3Pressed:(id)sender;
- (IBAction)button4Pressed:(id)sender;
- (IBAction)outlineButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *offsetXTextField;
@property (weak, nonatomic) IBOutlet UITextField *offsetYTextField;
@property (weak, nonatomic) IBOutlet UITextField *frameXTextField;
@property (weak, nonatomic) IBOutlet UITextField *frameYTextField;
@property (weak, nonatomic) IBOutlet UITextField *frameWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *frameHeightTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbOffsetTopTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbOffsetRightTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbOffsetBottomTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbOffsetLeftTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbFrameXTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbFrameYTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbFrameWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *thumbFrameHeightTextField;
- (IBAction)sliderChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end
