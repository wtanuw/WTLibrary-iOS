//
//  WTUtaPlayer.h
//  ZIONPlayer
//
//  Created by Wat Wongtanuwat on 10/16/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WTUtaProtocol.h"

#pragma mark - Notification

#define sendMusicItemNotification    @"musicItemNotification"
#define finishLoadArtworkMusicItemNotification    @"finishLoadArtworkMusicItemNotification"

#define musicPlayNotification    @"musicPlayNotification"
#define musicStopNotification    @"musicStopNotification"
#define musicBackNotification    @"musicBackNotification"

#pragma mark - UserDefaults

//#define kLastPlayedIndexUserDefaults        @"LastPlayedIndex"
//#define kLastPlayedRepeatUserDefaults        @"LastPlayedRepeat" //0 = none, 1 = one, 2 = all
//#define kLastPlayedShuffleUserDefaults        @"LastPlayedShuffle" //0 = off(normal), 1 = on(shuffle)



#define numberSecondToStartFromBeginWhenPrevious 3

#define numberLoadNextArtworkAdvance 3
#define numberLoadPrevArtworkAdvance 2

#define numberSecondToCrossFade 6

#pragma mark -

typedef enum {
    WTUtaPlayerRepeatStateNone = 0,
    WTUtaPlayerRepeatStateOne = 1,
    WTUtaPlayerRepeatStateAll = 2
} WTUtaPlayerRepeatState;

typedef enum {
    WTUtaPlayerShuffleStateOff = 0,
    WTUtaPlayerShuffleStateOn = 1,
} WTUtaPlayerShuffleState;

typedef enum {
    WTUtaPlayerPlayStatePlay,
    WTUtaPlayerPlayStatePause
} WTUtaPlayerPlayState;

typedef enum {
    WTUtaPlayerNextTuneStateOff = 0,
    WTUtaPlayerNextTuneStateOnOne = 1,
    WTUtaPlayerNextTuneStateOnMany = 1
} WTUtaPlayerNextTuneState;

@interface WTUtaPlayer : NSObject {
    
    AVPlayer *utaPlayer;
    NSMutableArray *normalPlayListArray;
    NSMutableArray *shufflePlayListArray;
    NSMutableArray *nextTunePlaylistArray;
    NSInteger playListSongIndex;
    WTUtaPlayerRepeatState repeatState;
    WTUtaPlayerShuffleState shuffleState;
    WTUtaPlayerPlayState playState;
    WTUtaPlayerNextTuneState nextTuneState;
    
    NSOperationQueue *artworkQueue;
    
    AVPlayer *uraPlayer;
}

@property (nonatomic, readonly, retain) AVPlayer *utaPlayer;
@property (nonatomic, readonly, retain) NSMutableArray *normalPlayListArray;
@property (nonatomic, readonly, retain) NSMutableArray *shufflePlayListArray;
@property (nonatomic, readonly, retain) NSMutableArray *nextTunePlaylistArray;
@property (nonatomic, readonly, assign) NSInteger playListSongIndex;
@property (nonatomic, readonly, assign) WTUtaPlayerRepeatState repeatState;
@property (nonatomic, readonly, assign) WTUtaPlayerShuffleState shuffleState;
@property (nonatomic, readonly, assign) WTUtaPlayerPlayState playState;
@property (nonatomic, readonly, assign) WTUtaPlayerNextTuneState nextTuneState;


@property (nonatomic, readonly, retain) NSArray<WTUtaItem*> *currentPlaylistArray;
@property (nonatomic, readonly, assign) NSUInteger currentPlaylistCount;
@property (nonatomic, readonly, retain) WTUtaItem *currentMusicItem;
@property (nonatomic, readonly, assign) float currentRate;
@property (nonatomic, readonly, assign) float currentTime;
@property (nonatomic, readonly, assign) CMTime currentTimeCMTime;
@property (nonatomic, readonly, assign) float currentDuration;
@property (nonatomic, readonly, assign) CMTime currentDurationCMTime;
@property (nonatomic, readonly, retain) NSString *currentLyric;
@property (nonatomic, readonly, getter = isFirstInPlaylist) BOOL firstInPlaylist;
@property (nonatomic, readonly, getter = isLastInPlaylist) BOOL lastInPlaylist;


@property (nonatomic, assign) int numberOfSecondToStartFromBeginWhenPrevious;//3
@property (nonatomic, assign) int numberToLoadNextArtworkAdvance;//3
@property (nonatomic, assign) int numberToLoadPrevArtworkAdvance;//2
@property (nonatomic, assign) BOOL queueLoadArtworkEnable;//YES
@property (nonatomic, assign) BOOL nowPlayingInfoEnable;//YES
@property (nonatomic, assign) BOOL crossFadeEnable;//NO
@property (nonatomic, assign) int numberOfSecondToCrossFade;//5

- (BOOL)loadPlaylistArrayNormal:(NSMutableArray*)normal arrayShuffle:(NSMutableArray*)shuffle;
- (BOOL)loadPlaylistIndex:(int)index stateRepeat:(WTUtaPlayerRepeatState)repeat stateShuffle:(WTUtaPlayerShuffleState)shuffle;

- (void)callUtaPlayerToChangeTrackTitles;
- (void)callUtaPlayerToPrepareRemote;
- (void)callUtaPlayerToChangeRepeat:(WTUtaPlayerRepeatState)_state;
- (void)callUtaPlayerToPrevious;
- (void)callUtaPlayerToPlay;
- (void)callUtaPlayerToPause;
- (void)callUtaPlayerToStop;
- (void)callUtaPlayerToSkip;
- (void)callUtaPlayerToChangeShuffle:(WTUtaPlayerShuffleState)_state;


- (void)playPlayListSong:(WTUtaItem*)song;
- (void)playPlayListSongAtIndex:(NSInteger)index;
- (void)normalPlay:(NSArray*)array;
- (void)shufflePlay:(NSArray*)array beginWith:(NSUInteger)numbegin;

- (WTUtaItem*)currentPlaylistMusicItemAtIndex:(NSUInteger)index;

- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;
- (id)addBoundaryTimeObserverForTimes:(NSArray *)times queue:(dispatch_queue_t)queue usingBlock:(void (^)(void))block;
- (void)removeTimeObserver:(id)observer;

- (void)startLoadArtworkAdvance;
- (void)stopLoadArtworkAdvance;

- (void)callUtaPlayerToChangeNextTune:(WTUtaPlayerNextTuneState)_state;
- (void)nextTunePlay;
- (void)addSongNextTune:(WTUtaItem*)item;
- (void)removeSongNextTuneAtIndex:(NSUInteger)index;
@end
