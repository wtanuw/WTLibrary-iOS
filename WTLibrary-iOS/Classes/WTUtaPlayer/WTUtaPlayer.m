//
//  WTUtaPlayer.m
//  ZIONPlayer
//
//  Created by Wat Wongtanuwat on 10/16/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import "WTUtaPlayer.h"

@interface WTUtaPlayer()

@property (nonatomic, retain) id crossFadeObserver;
@property (nonatomic, retain) AVPlayer *uraPlayer;

@property (nonatomic, retain) AVPlayer *utaPlayer;
@property (nonatomic, retain) NSMutableArray *normalPlayListArray;
@property (nonatomic, retain) NSMutableArray *shufflePlayListArray;
@property (nonatomic, retain) NSMutableArray *nextTunePlaylistArray;
@property (nonatomic, assign) int playListSongIndex;
@property (nonatomic, assign) WTUtaPlayerRepeatState repeatState;
@property (nonatomic, assign) WTUtaPlayerShuffleState shuffleState;
@property (nonatomic, assign) WTUtaPlayerPlayState playState;

- (void)callUtaPlayerToPlayURL:(NSURL*)url;

- (void)queueAdvanceLoadCurrentArtwork;
- (void)queueAdvanceLoadArtworks;
- (void)queueClearAllLoadArtwork;
- (void)queueClearPlayedLoadArtwork;

- (void)didPlayToEndTimeNotification:(NSNotification *)notification;

- (void)changeToNormalPlayListSong:(NSArray*)array;

- (void)changeToShufflePlayListSong:(NSArray*)array beginWith:(int)numbegin;
- (NSMutableArray*)functionRandomArray:(NSMutableArray*)list;
- (NSMutableArray*)functionRandomArray:(NSMutableArray*)list beginWith:(int)numbegin;


@end

@implementation WTUtaPlayer

@synthesize crossFadeObserver;
@synthesize uraPlayer;

@synthesize utaPlayer;
@synthesize normalPlayListArray;
@synthesize shufflePlayListArray;
@synthesize nextTunePlaylistArray;
@synthesize playListSongIndex;
@synthesize repeatState;
@synthesize shuffleState;
@synthesize playState;
@synthesize nextTuneState;

@synthesize currentPlaylistArray;
@synthesize currentPlaylistCount;
@synthesize currentMusicItem;
@synthesize currentRate;
@synthesize currentTime;
@synthesize currentTimeCMTime;
@synthesize currentDuration;
@synthesize currentDurationCMTime;
@synthesize currentLyric;
@synthesize firstInPlaylist;
@synthesize lastInPlaylist;

@synthesize numberOfSecondToStartFromBeginWhenPrevious;
@synthesize numberToLoadNextArtworkAdvance;
@synthesize numberToLoadPrevArtworkAdvance;
@synthesize queueLoadArtworkEnable;
@synthesize nowPlayingInfoEnable;
@synthesize crossFadeEnable;
@synthesize numberOfSecondToCrossFade;

+ (id)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id)init {
    if ((self = [super init])) {
        
        self.normalPlayListArray = [NSMutableArray array];
        
        self.shufflePlayListArray = [NSMutableArray array];
        
        self.nextTunePlaylistArray = [NSMutableArray array];
        
//        self.currentPlayListSong = [NSMutableArray array];
        
        playListSongIndex = 0;
        
        repeatState = WTUtaPlayerRepeatStateAll;
        
        shuffleState = WTUtaPlayerShuffleStateOff;
        
        playState = WTUtaPlayerPlayStatePause;
        
        nextTuneState = WTUtaPlayerNextTuneStateOnOne;
        
        
        numberOfSecondToStartFromBeginWhenPrevious = numberSecondToStartFromBeginWhenPrevious;
        
        if(UI_INTERFACE_IDIOM_IS_IPHONE() && UI_INTERFACE_SCREEN_IS_RETINA()){
            numberToLoadNextArtworkAdvance = numberLoadNextArtworkAdvance;
            numberToLoadPrevArtworkAdvance = numberLoadPrevArtworkAdvance;
        }else if(UI_INTERFACE_IDIOM_IS_IPHONE()){
            numberToLoadNextArtworkAdvance = numberLoadNextArtworkAdvance-1;
            numberToLoadPrevArtworkAdvance = numberLoadPrevArtworkAdvance;
        }else if(UI_INTERFACE_IDIOM_IS_IPAD() && UI_INTERFACE_SCREEN_IS_RETINA()){
            numberToLoadNextArtworkAdvance = numberLoadNextArtworkAdvance;
            numberToLoadPrevArtworkAdvance = numberLoadPrevArtworkAdvance;
        }else if(UI_INTERFACE_IDIOM_IS_IPAD()){
            numberToLoadNextArtworkAdvance = numberLoadNextArtworkAdvance-1;
            numberToLoadPrevArtworkAdvance = numberLoadPrevArtworkAdvance;
        }
        
        queueLoadArtworkEnable = YES;
        
        nowPlayingInfoEnable = YES;
        
        crossFadeEnable = NO;
        
        numberOfSecondToCrossFade = numberSecondToCrossFade;
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        {
            if([utaPlayer respondsToSelector:@selector(allowsExternalPlayback)]){
                utaPlayer.allowsExternalPlayback = YES;
            }
            if([utaPlayer respondsToSelector:@selector(usesExternalPlaybackWhileExternalScreenIsActive)]){
                utaPlayer.usesExternalPlaybackWhileExternalScreenIsActive = YES;
            }
        }
        else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
        {
            if([utaPlayer respondsToSelector:@selector(allowsAirPlayVideo)]){
                utaPlayer.allowsAirPlayVideo = YES;
            }
            if([utaPlayer respondsToSelector:@selector(usesAirPlayVideoWhileAirPlayScreenIsActive)]){
                utaPlayer.usesAirPlayVideoWhileAirPlayScreenIsActive = YES;
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didPlayToEndTimeNotification:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:utaPlayer];
        
        if(!artworkQueue){
            artworkQueue = [[NSOperationQueue alloc] init];
        }
        [artworkQueue setMaxConcurrentOperationCount:2];
        
        
        //play music in background
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSError *setCategoryError = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        if (setCategoryError) { /* handle the error condition */ }
        
        NSError *activationError = nil;
        [audioSession setActive:YES error:&activationError];
        if (activationError) { /* handle the error condition */ }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioSessionInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:audioSession];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioSessionRouteChange:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:audioSession];
        
    }
    return self;
}

- (void)dealloc {
    
    [crossFadeObserver release];
    
    [uraPlayer release];
    
    [utaPlayer release];
    
    [normalPlayListArray release];
    
    [shufflePlayListArray release];
    
    [nextTunePlaylistArray release];
    
//    [currentPlayListSong release];
    
    [self removeObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification];
    
    if(artworkQueue){
        [artworkQueue setSuspended:YES];
        [artworkQueue cancelAllOperations];
        // you need to decide if you need to handle running operations
        // reasonably, but don't wait here because that may block the
        // main thread
        [artworkQueue release];
    }
    
    [super dealloc];
}

- (void)handleAudioSessionInterruption:(NSNotification*)notification {
    
    NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber *interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    
    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:{
            // • Audio has stopped, already inactive
            // • Change state of UI, etc., to reflect non-playing state
            [self callUtaPlayerToPause];
        } break;
        case AVAudioSessionInterruptionTypeEnded:{
            // • Make session active
            // • Update user interface
            // • AVAudioSessionInterruptionOptionShouldResume option
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                // Here you should continue playback.
                //[self callUtaPlayerToPlay];
            }
        } break;
        default:
            break;
    }
    
    
}
- (void)handleAudioSessionRouteChange:(NSNotification*)notification {
    
    NSInteger routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    if (routeChangeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        // The old device is unavailable == headphones have been unplugged
        [self callUtaPlayerToPause];
    }else if (routeChangeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {
        if(self.playState == WTUtaPlayerPlayStatePlay){
            //[self callUtaPlayerToPlay];
        }
    }
}

#pragma mark -

- (NSArray*)currentPlaylistArray{
    if(shuffleState == WTUtaPlayerShuffleStateOn && [shufflePlayListArray count] > 0){
        return shufflePlayListArray;
    }else if(shuffleState == WTUtaPlayerShuffleStateOff && [normalPlayListArray count] > 0){
        return normalPlayListArray;
    }
    return nil;
}

- (int)currentPlaylistCount{
    return [[self currentPlaylistArray] count];
}

- (MusicItem*)currentMusicItem{
    if([[self currentPlaylistArray] count] > playListSongIndex){
        return (MusicItem*)[[self currentPlaylistArray] objectAtIndex:playListSongIndex];
    }
    return  nil;
}

- (float)currentRate{
    return [self.utaPlayer rate];
}

- (float)currentTime{
    return CMTimeGetSeconds([self.utaPlayer currentTime]);
}

- (CMTime)currentTimeCMTime{
    return [self.utaPlayer currentTime];
}

- (float)currentDuration{
    
    if(self.utaPlayer.status == AVPlayerStatusUnknown){
        
        return CMTimeGetSeconds([[[self.utaPlayer currentItem] asset] duration]);
        
    }else if(self.utaPlayer.status == AVPlayerStatusReadyToPlay){
        
        return CMTimeGetSeconds([[[self.utaPlayer currentItem] asset] duration]);
        
    }else if(self.utaPlayer.status == AVPlayerStatusFailed){
        
    }
    
    return 1;
}

- (CMTime)currentDurationCMTime{
    
    if(self.utaPlayer.status == AVPlayerStatusUnknown){
        
        return [[[self.utaPlayer currentItem] asset] duration];
        
    }else if(self.utaPlayer.status == AVPlayerStatusReadyToPlay){
        
        return [[[self.utaPlayer currentItem] asset] duration];
        
    }else if(self.utaPlayer.status == AVPlayerStatusFailed){
        
    }
    
    return CMTimeMakeWithSeconds(1, 1);
}

- (NSString*)currentLyric{
    return [[[self.utaPlayer currentItem] asset] lyrics];
}

- (BOOL)isFirstInPlaylist{
    return (playListSongIndex-1 < 0);
}

- (BOOL)isLastInPlaylist{
    return (playListSongIndex+1 >= [[self currentPlaylistArray] count]);
}

#pragma mark -

- (BOOL)loadPlaylistArrayNormal:(NSMutableArray*)normal arrayShuffle:(NSMutableArray*)shuffle{
    self.normalPlayListArray = normal;
    self.shufflePlayListArray = shuffle;
    playListSongIndex = 0;
    return YES;
}

- (BOOL)loadPlaylistIndex:(int)index stateRepeat:(WTUtaPlayerRepeatState)repeat stateShuffle:(WTUtaPlayerShuffleState)shuffle{
    playListSongIndex = index;
    repeatState = repeat;
    shuffleState = shuffle;
    if(playListSongIndex>=0 && playListSongIndex<[[self currentPlaylistArray] count]){
//        [self callUtaPlayerToPlayURL:[(MusicItem*)[[self currentPlaylistArray] objectAtIndex:playListSongIndex] pathURL]];
        MusicItem *song = [self currentPlaylistMusicItemAtIndex:index];
        [self playSong:song];
        [self callUtaPlayerToPause];
        [self queueAdvanceLoadCurrentArtwork];
        return YES;
    }else{
        playListSongIndex = 0;
        return NO;
    }
}

#pragma mark - avplayer function of musicplayer

- (void)callUtaPlayerToChangeTrackTitles{
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        
//        int playingQueueCount = [[self currentPlaylistArray] count];
        MusicItem *nowPlayingItem = [self currentMusicItem];
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        if (playingInfoCenter)
        {
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            if([nowPlayingItem title]){[songInfo setObject:[nowPlayingItem title] forKey:MPMediaItemPropertyTitle];}
            if([nowPlayingItem albumTitle]){[songInfo setObject:[nowPlayingItem albumTitle] forKey:MPMediaItemPropertyAlbumTitle];}
            if([nowPlayingItem artist]){[songInfo setObject:[nowPlayingItem artist] forKey:MPMediaItemPropertyArtist];}
            if([nowPlayingItem artwork]){
                MPMediaItemArtwork *albumArt;
                albumArt = [[MPMediaItemArtwork alloc] initWithImage: [nowPlayingItem artwork]];
                [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                [albumArt release];
                
                [songInfo setObject:[NSNumber numberWithFloat:[self currentRate]] forKey:MPNowPlayingInfoPropertyPlaybackRate];
                [songInfo setObject:[NSNumber numberWithFloat:[self currentTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
                [songInfo setObject:[NSNumber numberWithFloat:[self currentDuration]] forKey:MPMediaItemPropertyPlaybackDuration];

            }
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
            [songInfo release];
        }
        
    }
}
- (void)callUtaPlayerToChangeTimeDuration{
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        
        //        int playingQueueCount = [[self currentPlaylistArray] count];
        MusicItem *nowPlayingItem = [self currentMusicItem];
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        if (playingInfoCenter)
        {
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            if([nowPlayingItem title]){[songInfo setObject:[nowPlayingItem title] forKey:MPMediaItemPropertyTitle];}
            if([nowPlayingItem albumTitle]){[songInfo setObject:[nowPlayingItem albumTitle] forKey:MPMediaItemPropertyAlbumTitle];}
            if([nowPlayingItem artist]){[songInfo setObject:[nowPlayingItem artist] forKey:MPMediaItemPropertyArtist];}
            if([nowPlayingItem artwork]){
                MPMediaItemArtwork *albumArt;
                albumArt = [[MPMediaItemArtwork alloc] initWithImage: [nowPlayingItem artwork]];
                [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                [albumArt release];
                
                [songInfo setObject:[NSNumber numberWithFloat:[self currentRate]] forKey:MPNowPlayingInfoPropertyPlaybackRate];
                [songInfo setObject:[NSNumber numberWithFloat:[self currentTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
                [songInfo setObject:[NSNumber numberWithFloat:[self currentDuration]] forKey:MPMediaItemPropertyPlaybackDuration];
                
            }
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
            [songInfo release];
        }
        
    }
}

- (void)callUtaPlayerToPrepareRemote{
    
    if([[self currentPlaylistArray] count] == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:musicStopNotification object:nil];
        return;
    }
    
    [self.utaPlayer play];
    [self.utaPlayer performSelector:@selector(pause) withObject:nil afterDelay:0.5];
}

-(void)callUtaPlayerToFadeInAndOut{
    
    AVPlayerItem *myAVPlayerItem = [self.utaPlayer currentItem];
    AVAsset *myAVAsset = myAVPlayerItem.asset;
    NSArray *audioTracks = [myAVAsset tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        
        if([self playState] == WTUtaPlayerPlayStatePlay){
            [audioInputParams setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:CMTimeRangeMake(CMTimeMake(0, 1), CMTimeMake(numberOfSecondToCrossFade/2, 1))];
        }
        
        [audioInputParams setVolumeRampFromStartVolume:1.0 toEndVolume:0.0 timeRange:CMTimeRangeMake(CMTimeSubtract(myAVPlayerItem.duration,CMTimeMake(numberOfSecondToCrossFade, 1)), CMTimeMake(numberOfSecondToCrossFade, 1))];
        
        [allAudioParams addObject:audioInputParams];
        
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    
    [myAVPlayerItem setAudioMix:audioMix];
}

- (void)callUtaPlayerToPlayURL:(NSURL*)url{
    
    if(crossFadeEnable){
        
        [self.uraPlayer pause];
        self.uraPlayer = nil;
        
        [self removeCrossFade];
        
        self.uraPlayer = self.utaPlayer;
        
        [self.uraPlayer pause];
        self.uraPlayer = nil;
    }
    
    
    [self.utaPlayer pause];
    self.utaPlayer = nil;
    self.utaPlayer = [AVPlayer playerWithURL:url];
    
    if(self.nowPlayingInfoEnable){
        [self callUtaPlayerToChangeTrackTitles];
    }
    
    if(crossFadeEnable){
        [self callUtaPlayerToFadeInAndOut];
        [self addCrossFade];
    }
}

- (void)callUtaPlayerToPlayURLCrossFade:(NSURL*)url{
    
    self.utaPlayer = [AVPlayer playerWithURL:url];
    
    if(nowPlayingInfoEnable){
        [self callUtaPlayerToChangeTrackTitles];
    }
    
    if(crossFadeEnable){
        [self callUtaPlayerToFadeInAndOut];
        [self addCrossFade];
    }
}

- (void)callUtaPlayerToChangeRepeat:(WTUtaPlayerRepeatState)_state{
    repeatState = _state;
}

-(void)callUtaPlayerSeekToBeginning{
    [self.utaPlayer seekToTime:CMTimeMakeWithSeconds(0, 1)];
    
    [self callUtaPlayerToChangeTimeDuration];
}

- (void)callUtaPlayerToPrevious{
    
    if([[self currentPlaylistArray] count] == 0){
        return;
    }
    
    if((CMTimeGetSeconds([self currentTimeCMTime]))>numberOfSecondToStartFromBeginWhenPrevious){
        
        [self callUtaPlayerSeekToBeginning];
        
    }else{
        
        if(repeatState == WTUtaPlayerRepeatStateOne){
            
            if(playListSongIndex-1 < 0){
                
                //already first song
                [[NSNotificationCenter defaultCenter] postNotificationName:musicBackNotification object:nil];
                
                [self callUtaPlayerToPause];
                
                [self callUtaPlayerSeekToBeginning];
                
            }else{
                
                [self playPlayListSongAtIndex:playListSongIndex-1];
                
            }
            
        }else if(repeatState == WTUtaPlayerRepeatStateNone){
            
            if(playListSongIndex-1 < 0){
                
                //already first song
                [[NSNotificationCenter defaultCenter] postNotificationName:musicBackNotification object:nil];
                
                [self callUtaPlayerToPause];
                
                [self callUtaPlayerSeekToBeginning];
                
            }else{
                
                [self playPlayListSongAtIndex:playListSongIndex-1];
                
            }
            
        }else if(repeatState == WTUtaPlayerRepeatStateAll){
            
            if(playListSongIndex-1 < 0){
                
                [self playPlayListSongAtIndex:[[self currentPlaylistArray] count]-1];
                
            }else{
                
                [self playPlayListSongAtIndex:playListSongIndex-1];
                
            }
            
        }
        
    }
    
}

- (void)callUtaPlayerToPlay{
    
    if([[self currentPlaylistArray] count] == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:musicStopNotification object:nil];
        return;
    }
    
    playState = WTUtaPlayerPlayStatePlay;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:musicPlayNotification object:nil];
    
    [self.utaPlayer play];
    
    [self callUtaPlayerToChangeTimeDuration];
    
}

- (void)callUtaPlayerToPause{
    
    if([[self currentPlaylistArray] count] == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:musicStopNotification object:nil];
        return;
    }
    
    playState = WTUtaPlayerPlayStatePause;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:musicStopNotification object:nil];
    
    [self.utaPlayer pause];
    
    [self callUtaPlayerToChangeTimeDuration];
    
}

- (void)callUtaPlayerToStop{
    
    if([[self currentPlaylistArray] count] == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:musicStopNotification object:nil];
        return;
    }
    
    [self callUtaPlayerToPause];
    
    [self callUtaPlayerSeekToBeginning];
    
}

- (void)callUtaPlayerToSkip{
    
    if([[self currentPlaylistArray] count] == 0){
        return;
    }
    
    if([self isNextTuneHaveSong]){
        
        [self nextTunePlay];
        
        return;
    }
    
    
    if(repeatState == WTUtaPlayerRepeatStateOne){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
            //already last song
            [[NSNotificationCenter defaultCenter] postNotificationName:musicBackNotification object:nil];
            
            [self callUtaPlayerToPause];
            
            [self callUtaPlayerSeekToBeginning];
            
        }else{
            
            [self playPlayListSongAtIndex:playListSongIndex+1];
            
        }
        
    }else if(repeatState == WTUtaPlayerRepeatStateNone){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
            //already last song
            [[NSNotificationCenter defaultCenter] postNotificationName:musicBackNotification object:nil];
            
            [self callUtaPlayerToPause];
            
            [self callUtaPlayerSeekToBeginning];
            
        }else{
            
            [self playPlayListSongAtIndex:playListSongIndex+1];
            
        }
        
    }else if(repeatState == WTUtaPlayerRepeatStateAll){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
            [self playPlayListSongAtIndex:0];
            
        }else{
            
            [self playPlayListSongAtIndex:playListSongIndex+1];
            
        }
        
    }
    
}

- (void)callUtaPlayerToChangeShuffle:(WTUtaPlayerShuffleState)_state{
    
    if([[self currentPlaylistArray] count] == 0){
        return;
    }
    
    if(_state == WTUtaPlayerShuffleStateOn){
        
        [self changeToShufflePlayListSong:normalPlayListArray beginWith:playListSongIndex];
        
        playListSongIndex = 0;
        
    }else if(_state == WTUtaPlayerShuffleStateOff){
        
        MusicItem *song = [self currentMusicItem];
        
        [self changeToNormalPlayListSong:normalPlayListArray];
        
        int newPlaylistSongIndex = [normalPlayListArray indexOfObject:song];
        
        playListSongIndex = newPlaylistSongIndex;
        
    }
    
}

- (void)callUtaPlayerToChangeNextTune:(WTUtaPlayerNextTuneState)_state
{
    nextTuneState = _state;
}

#pragma mark - queue load artwork

- (void)startLoadArtworkAdvance{
    
    if(queueLoadArtworkEnable){
        [self stopLoadArtworkAdvance];
        [self queueAdvanceLoadArtworks];
    }
}

- (void)stopLoadArtworkAdvance{
    
    [artworkQueue cancelAllOperations];
}

- (void)loadDataWithOperation:(MusicItem*)song{
    
    NSAutoreleasePool* threadPool = [NSAutoreleasePool new];
    
    if([song isKindOfClass:NSClassFromString(@"MusicItem")]){
        
        if(![song isLoadArtwork]){
            
            [song loadArtworkImage];
            
        }
        
        if([self currentMusicItem] == song){
            
            [self callUtaPlayerToChangeTrackTitles];
            [[NSNotificationCenter defaultCenter] postNotificationName:finishLoadArtworkMusicItemNotification object:song];
                
        }
    }
    
    [threadPool drain];
}

-(int)getNumberOfLoadNextArtworkAdvance:(int)_arrayCount{
    
    int numberNext = numberToLoadNextArtworkAdvance;
    
    if(_arrayCount < 1+numberToLoadNextArtworkAdvance+numberToLoadPrevArtworkAdvance){
        numberNext = ceil((_arrayCount-1)/2.0);
    }
    return numberNext;
}

-(int)getNumberOfLoadPrevArtworkAdvance:(int)_arrayCount{
    
    int numberPrev = numberToLoadPrevArtworkAdvance;
    
    if(_arrayCount < 1+numberToLoadNextArtworkAdvance+numberToLoadPrevArtworkAdvance){
        numberPrev = floor((_arrayCount-1)/2.0);
    }
    return numberPrev;
}

-(void)queueAdvanceLoadCurrentArtwork{
    
    [self stopLoadArtworkAdvance];
    
    MusicItem *item = [self currentMusicItem];
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self
                                                                             selector:@selector(loadDataWithOperation:)
                                                                               object:item] autorelease];
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [artworkQueue addOperation:operation];
}

-(void)queueAdvanceLoadArtworks{
    
//    [artworkQueue performSelectorOnMainThread:@selector(cancelAllOperations) withObject:nil waitUntilDone:NO];
//    [artworkQueue cancelAllOperations];
    
    int arrayCount = [[self currentPlaylistArray] count];
    int numberNext = [self getNumberOfLoadNextArtworkAdvance:arrayCount];
    int numberPrev = [self getNumberOfLoadPrevArtworkAdvance:arrayCount];
    
//    NSOperation *operationX = nil;
    for(int i=1 ; i<1+numberNext ; i++){
        int index = (playListSongIndex+arrayCount+i)%arrayCount;
        MusicItem *item = [self currentPlaylistMusicItemAtIndex:index];
        NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(loadDataWithOperation:)
                                                                                    object:item] autorelease];
        [operation setQueuePriority:NSOperationQueuePriorityNormal];
        
//        CLS_LOG(@"operation %d: %@",i,operationX);
//        if (operation && operationX) {
//            [operation addDependency:operationX];
//        }
//        operationX = operation;
        [artworkQueue addOperation:operation];
    }
    
    for(int i=-1 ; i>-1-numberPrev ; i--){
        int index = (playListSongIndex+arrayCount+i)%arrayCount;
        MusicItem *item = [self currentPlaylistMusicItemAtIndex:index];
        NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(loadDataWithOperation:)
                                                                                    object:item] autorelease];
        [operation setQueuePriority:NSOperationQueuePriorityNormal];
        
//        CLS_LOG(@"operation %d: %@",i,operationX);
//        if(operation && operationX) {
//            [operation addDependency:operationX];
//        }
//        operationX = operation;
        [artworkQueue addOperation:operation];
    }
}

-(void)queueClearAllLoadArtwork{
    
    MusicItem *itemX = [self currentMusicItem];
    if([itemX isLoadArtwork]){
        [itemX removeArtwork];
    }
    
    int arrayCount = [[self currentPlaylistArray] count];
    int numberNext = [self getNumberOfLoadNextArtworkAdvance:arrayCount];
    int numberPrev = [self getNumberOfLoadPrevArtworkAdvance:arrayCount];
    
    for(int i=1 ; i<1+numberNext ; i++){
        int index = (playListSongIndex+arrayCount+i)%arrayCount;
        MusicItem *item = [self currentPlaylistMusicItemAtIndex:index];
        if([item isLoadArtwork]){
            [item removeArtwork];
        }
    }
    
    for(int i=-1 ; i>-1-numberPrev ; i--){
        int index = (playListSongIndex+arrayCount+i)%arrayCount;
        MusicItem *item = [self currentPlaylistMusicItemAtIndex:index];
        if([item isLoadArtwork]){
            [item removeArtwork];
        }
    }
}

-(void)queueClearPlayedLoadArtwork{
    
    //clear only prev artwork
    
    int arrayCount = [[self currentPlaylistArray] count];
//        int numberNext = [self getNumberOfLoadNextArtworkAdvance:arrayCount];
    int numberPrev = [self getNumberOfLoadPrevArtworkAdvance:arrayCount];
    
//        for(int i=numberNext ; i<1+numberNext && numberNext!=0  ; i++){
//            int index = (playListSongIndex+arrayCount+i)%arrayCount;
//            MusicItem *item = (MusicItem*)[shufflePlayListSong objectAtIndex:index];
//            if([item isLoadArtwork]){
//                item.artwork = nil;
//                item.loadArtwork = NO;
//            }
//        }
    
    for(int i=-numberPrev ; i>-1-numberPrev && numberPrev!=0  ; i--){
        int index = (playListSongIndex+arrayCount+i)%arrayCount;
        MusicItem *item = [self currentPlaylistMusicItemAtIndex:index];
        if([item isLoadArtwork]){
            [item removeArtwork];
        }
    }
}

#pragma mark - function

- (void)playPlayListSong:(MusicItem *)song{
    
    NSInteger newPlaylistSongIndex = [[self currentPlaylistArray] indexOfObject:song];
    
    if(newPlaylistSongIndex != NSNotFound){
        [self playPlayListSongAtIndex:newPlaylistSongIndex];
    }
}

- (void)playPlayListSongAtIndex:(NSInteger)index{
    
    if(index<0){
        index = 0;
    }
    
    if(repeatState == WTUtaPlayerRepeatStateOne){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
        }else if(playListSongIndex-1 < 0){
            
        }else{
            
            if(index == playListSongIndex+1){
                [self queueClearPlayedLoadArtwork];
            }
            
        }
        
    }else if(repeatState == WTUtaPlayerRepeatStateNone){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
        }else if(playListSongIndex-1 < 0){
            
        }else{
            
            if(index == playListSongIndex+1){
                [self queueClearPlayedLoadArtwork];
            }
            
        }
        
    }else if(repeatState == WTUtaPlayerRepeatStateAll){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
            if(index == 0){
                [self queueClearPlayedLoadArtwork];
            }
            
        }else if(playListSongIndex-1 < 0){
            
        }else{
            
            if(index == playListSongIndex+1){
                [self queueClearPlayedLoadArtwork];
            }
            
        }
        
    }
    
    playListSongIndex = index;
    
//    if(queueLoadArtworkEnable){
//        [self queueAdvanceLoadArtwork];
//    }
    
    MusicItem *song = [self currentPlaylistMusicItemAtIndex:index];
    
    [self queueAdvanceLoadCurrentArtwork];
    
    [self playSong:song];
}

- (void)playSong:(MusicItem *)song{
    
    if(song.pathURL){
        [self callUtaPlayerToPause];
        [self callUtaPlayerToPlayURL:[song pathURL]];
        [self callUtaPlayerToPlay];
    }else{
        [self callUtaPlayerToPause];
        [self callUtaPlayerToPlayURL:[song pathURL]];
        [self callUtaPlayerToPlay];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:sendMusicItemNotification object:song];
}

- (void)playPlayListSongAtIndexCrossFade:(int)index{
    
    [self queueClearPlayedLoadArtwork];
    
    if(index<0){
        index = 0;
    }
    playListSongIndex = index;
    
//    if(queueLoadArtworkEnable){
//        [self queueAdvanceLoadArtwork];
//    }
    
    MusicItem *song = [self currentPlaylistMusicItemAtIndex:index];
    
    [self queueAdvanceLoadCurrentArtwork];
    
    [self callUtaPlayerToPlayURLCrossFade:[song pathURL]];
    [self callUtaPlayerToPlay];
    [[NSNotificationCenter defaultCenter] postNotificationName:sendMusicItemNotification object:song];
}

//- (void)didPlayToEndTimeNotification:(NSNotification *)notification{
//    
//    if(repeatState == WTUtaPlayerRepeatStateOne){
//        
//        [self playPlayListSongAtIndex:playListSongIndex];
//        
//    }else if(repeatState == WTUtaPlayerRepeatStateNone){
//        
//        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
//            
//            [self callUtaPlayerToPause];
//            
//            [self callUtaPlayerToPrevious];
//            
//        }else{
//            
//            [self playPlayListSongAtIndex:playListSongIndex+1];
//            
//        }
//        
//    }else if(repeatState == WTUtaPlayerRepeatStateAll){
//        
//        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
//            
//            [self playPlayListSongAtIndex:0];
//            
//        }else{
//            
//            [self playPlayListSongAtIndex:playListSongIndex+1];
//            
//        }
//        
//    }
//    
//}

- (void)didPlayToCrossFadeTimeNotification{
    
    if(crossFadeEnable){
        [self removeCrossFade];
    }
    WatLog(@"cross fade noti");
    self.uraPlayer = self.utaPlayer;
    
    
    if(repeatState == WTUtaPlayerRepeatStateOne){
        
        [self playPlayListSongAtIndexCrossFade:playListSongIndex];
        
    }else if(repeatState == WTUtaPlayerRepeatStateNone){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
            [self callUtaPlayerToPause];
            
            [self callUtaPlayerToPrevious];
            
        }else{
            
            [self playPlayListSongAtIndexCrossFade:playListSongIndex+1];
            
        }
        
    }else if(repeatState == WTUtaPlayerRepeatStateAll){
        
        if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
            
            [self playPlayListSongAtIndexCrossFade:0];
            
        }else{
            
            [self playPlayListSongAtIndexCrossFade:playListSongIndex+1];
            
        }
        
    }
    
}

- (void)didPlayToEndTimeNotification:(NSNotification *)notification{
    
    if([self isNextTuneHaveSong]){
        
        [self nextTunePlay];
        
        return;
    }
    
    if(crossFadeEnable){
        
        AVPlayerItem *noti = [notification object];
        
        [self.uraPlayer pause];
        self.uraPlayer = nil;
        
        if([self.utaPlayer currentItem] != noti)
        {
            return;
        }
        
        [self didPlayToCrossFadeTimeNotification];
        
    }else{
        
        if(repeatState == WTUtaPlayerRepeatStateOne){
            
            [self playPlayListSongAtIndex:playListSongIndex];
            
        }else if(repeatState == WTUtaPlayerRepeatStateNone){
            
            if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
                
                [self callUtaPlayerToPause];
                
                [self callUtaPlayerToPrevious];
                
            }else{
                
                [self playPlayListSongAtIndex:playListSongIndex+1];
                
            }
            
        }else if(repeatState == WTUtaPlayerRepeatStateAll){
            
            if(playListSongIndex+1 >= [[self currentPlaylistArray] count]){
                
                [self playPlayListSongAtIndex:0];
                
            }else{
                
                [self playPlayListSongAtIndex:playListSongIndex+1];
                
            }
            
        }
        
    }
}

- (void)normalPlay:(NSArray*)array{
    [self queueClearAllLoadArtwork];
    [self changeToNormalPlayListSong:array];
}

- (void)changeToNormalPlayListSong:(NSArray*)array{
    self.normalPlayListArray = [NSMutableArray arrayWithArray:array];
    shuffleState = WTUtaPlayerShuffleStateOff;
}

- (void)shufflePlay:(NSArray*)array beginWith:(int)numbegin{
    [self queueClearAllLoadArtwork];
    [self changeToShufflePlayListSong:array beginWith:numbegin];
}

- (void)changeToShufflePlayListSong:(NSArray*)array beginWith:(int)numbegin{
    self.normalPlayListArray = [NSMutableArray arrayWithArray:array];
    NSArray *shuffleArray;
    if(numbegin < 0){
        shuffleArray = [self functionRandomArray:normalPlayListArray];
    }else{
        shuffleArray = [self functionRandomArray:normalPlayListArray beginWith:numbegin];
    }
    self.shufflePlayListArray = [NSMutableArray arrayWithArray:shuffleArray];
    shuffleState = WTUtaPlayerShuffleStateOn;
}


- (NSMutableArray*)functionRandomArray:(NSMutableArray*)list{
	
    NSMutableArray *list_Normal = [[NSMutableArray alloc]initWithArray:list];
    
	NSMutableArray *list_Random = [[[NSMutableArray alloc]init]autorelease];
	
	for(int i = [list_Normal count] ; i > 0 ; i--){
		
		int randomIndex = arc4random()%i;
		
        [list_Random addObject:[list_Normal objectAtIndex:randomIndex]];
		
		[list_Normal removeObjectAtIndex:randomIndex];
		
	}
    
    [list_Normal release];
    
	return list_Random;
}

- (NSMutableArray*)functionRandomArray:(NSMutableArray*)list beginWith:(int)numbegin{
	
    if(numbegin < 0 && numbegin >= [list count]){
        numbegin = arc4random()%[list count];
    }
    
    NSMutableArray *list_Normal = [[NSMutableArray alloc]initWithArray:list];
	
	NSMutableArray *list_Random = [[[NSMutableArray alloc]init]autorelease];
	
	[list_Random addObject:[list_Normal objectAtIndex:numbegin]];
	
    [list_Normal removeObjectAtIndex:numbegin];
    
	for(int i = [list_Normal count] ; i > 0 ; i--){
		
		int randomIndex = arc4random()%i;
		
        [list_Random addObject:[list_Normal objectAtIndex:randomIndex]];
        
		[list_Normal removeObjectAtIndex:randomIndex];
		
	}
    
    [list_Normal release];
    
	return list_Random;
}

- (MusicItem*)currentPlaylistMusicItemAtIndex:(int)index{
    if(index >= 0 && index < [[self currentPlaylistArray] count]){
        return (MusicItem*)[[self currentPlaylistArray] objectAtIndex:index];
    }
    return  nil;
}

#pragma mark - observer

- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block{
    
    return [self.utaPlayer addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:block];
}

- (id)addBoundaryTimeObserverForTimes:(NSArray *)times queue:(dispatch_queue_t)queue usingBlock:(void (^)(void))block{
    
    return [self.utaPlayer addBoundaryTimeObserverForTimes:times queue:queue usingBlock:block];
}

- (void)removeTimeObserver:(id)observer{
    
    return [self.utaPlayer removeTimeObserver:observer];
}

- (void)addCrossFade
{
    Float64 durationSeconds = [self currentDuration];
    CMTime crossFadePoint = CMTimeSubtract(CMTimeMakeWithSeconds(durationSeconds, 1),CMTimeMake(numberOfSecondToCrossFade, 1));
    
    [self addBoundaryTimeObserverForTimes:[NSArray arrayWithObjects: [NSValue valueWithCMTime:crossFadePoint], nil] queue:NULL usingBlock:^{
        [self didPlayToCrossFadeTimeNotification];
    }];
}

- (void)removeCrossFade
{
    [self removeTimeObserver:crossFadeObserver];
    self.crossFadeObserver = nil;
}

#pragma mark -

- (void)nextTunePlay
{
    MusicItem *item = [self.nextTunePlaylistArray objectAtIndex:0];
    
    [self normalPlay:[NSArray arrayWithObject:item]];
    
    [self playPlayListSongAtIndex:0];
    
    [self.nextTunePlaylistArray removeObjectAtIndex:0];
}

- (BOOL)isNextTuneHaveSong
{
    if([self.nextTunePlaylistArray count] > 0){
        return YES;
    }else{
        return NO;
    }
}

- (void)addSongNextTune:(MusicItem*)item
{
    
    if(nextTuneState == WTUtaPlayerNextTuneStateOnOne)
    {
        [self.nextTunePlaylistArray removeAllObjects];
        [self.nextTunePlaylistArray addObject:item];
    }
    else if(nextTuneState == WTUtaPlayerNextTuneStateOnMany)
    {
        [self.nextTunePlaylistArray addObject:item];
    }
    
//    if([self.nextTunePlaylistArray count] == 1){
//        
//        if([self playState] == WTUtaPlayerPlayStatePause){
//            
//            if([self isNextTuneHaveSong]){
//                
//                [self nextTunePlay];
//                
//            }
//            
//        }
//        
//    }
}

- (void)removeSongNextTuneAtIndex:(int)index{
    [self.nextTunePlaylistArray removeObjectAtIndex:index];
}

//- (NSArray*)matchMusicItemFromPlaylistSongItem:(NSArray*)_array{
//    
//    NSArray *playlistSongItemInPlaylist = _array;
//    
//    NSMutableArray *musicItemInPlaylist = [NSMutableArray array];
//    
//    for(PlaylistSongItem *aItem in playlistSongItemInPlaylist){
//        
//        if(aItem.type == PlaylistSongItemSourceFromiPod){
//            
//            for(MusicItem *bItem in allSongiPod) {
//                
//                if([aItem.fileName isEqualToString:bItem.filename]){
//                    
//                    [musicItemInPlaylist addObject:bItem];
//                    break;
//                    
//                }
//                
//            }
//            
//        }else if(aItem.type == PlaylistSongItemSourceFromApp){
//            
//            for(MusicItem *bItem in allSongAppDoc) {
//                
//                if([aItem.fileName isEqualToString:bItem.filename]){
//                    
//                    [musicItemInPlaylist addObject:bItem];
//                    break;
//                    
//                }
//                
//            }
//            
//        }
//        
//    }
//    
//    return musicItemInPlaylist;
//    
//}

//#pragma mark - return array for music filter
//
//
//- (NSArray*)queryAllSongiPod{
//    
//    return self.allSongiPod;
//    
//}
//
//- (NSArray*)queryAllSongAppDoc{
//    
//    return self.allSongAppDoc;
//    
//}
//
//- (NSArray*)queryPlaylistiPod{
//    
//    MPMediaQuery *everything = [MPMediaQuery playlistsQuery];
//    NSArray *items = [NSArray arrayWithArray:[everything collections]];
//    
//    NSMutableArray *itemsFromGenericQuery = [NSMutableArray array];
//    int i = 0;
//    for (MPMediaItemCollection *playlist in items) {
//        NSString *name = [playlist valueForProperty: MPMediaPlaylistPropertyName];
//        
//        NSArray *songs = [playlist items];
//        PlaylistItem *item = [[PlaylistItem alloc] initWithName:name SortId:i Total:[songs count]];
//        [itemsFromGenericQuery addObject:item];
//        [item release];
//        i++;
//    }
//    
//    return itemsFromGenericQuery;
//}
//
//- (NSArray*)queryPlaylistAppDoc{
//    
//    return [self readPlaylist];
//    
//}
//
//- (NSArray*)queryPlaylistSongiPodWithPlaylistName:(NSString*)_playlist{
//    
//    MPMediaQuery *everything = [MPMediaQuery playlistsQuery];
//    NSArray *items = [NSArray arrayWithArray:[everything collections]];
//    
//    NSMutableArray *itemsFromGenericQuery = [NSMutableArray array];
//    
//    for (MPMediaItemCollection *playlist in items) {
//        NSString *name = [playlist valueForProperty: MPMediaPlaylistPropertyName];
//        
//        if([name isEqualToString:_playlist]){
//            
//            NSArray *array = [playlist items];
//            
//            for (MPMediaItem *song in array) {
//                MusicItem *item = [[MusicItem alloc] initItem:song WithType:MusicItemSourceFromiPod];
//                [itemsFromGenericQuery addObject:item];
//                [item release];
//            }
//            
//        }
//        
//    }
//    
//    return itemsFromGenericQuery;
//}
//
//- (NSArray*)queryPlaylistSongAppDocWithPlaylistName:(NSString*)_playlist{////////
//    
//    NSArray *playlistSongItemInPlaylist = [NSArray arrayWithArray:[self readPlaylistSongWithPlaylistName:_playlist]];
//    
//    return [self matchMusicItemFromPlaylistSongItem:playlistSongItemInPlaylist];
//    
//}
//
//- (void)firstQueryAllSongiPod{
//    
//    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
//    NSArray *items = [NSArray arrayWithArray:[everything items]];
//    
//    [everything release];
//    
//    NSMutableArray *itemsFromGenericQuery = [NSMutableArray array];
//    
//    for (MPMediaItem *song in items) {
//        MusicItem *item = [[MusicItem alloc] initItem:song WithType:MusicItemSourceFromiPod];
//        [itemsFromGenericQuery addObject:item];
//        [item release];
//    }
//    
//    self.allSongiPod = [NSArray arrayWithArray:itemsFromGenericQuery];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:addSongNotification object:nil];
//}
//
//- (void)firstQueryAllSongAppDoc{
//    
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * documentsDirectory = [paths objectAtIndex:0];
//    
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
//    
//    NSArray *items = [NSArray arrayWithArray:fileList];
//    
//    NSMutableArray *itemsFromGenericQuery = [NSMutableArray array];
//    
//    for (NSString *song in items) {
//        NSString * urlPath = [NSString stringWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:song]];
//        MusicItem *item = [[MusicItem alloc] initItem:urlPath WithType:MusicItemSourceFromApp];
//        if(item.filsIsOK){
//            [itemsFromGenericQuery addObject:item];
//        }
//        [item release];
//    }
//    
//    self.allSongAppDoc = [NSArray arrayWithArray:itemsFromGenericQuery];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:addSongNotification object:nil];
//}
//
//- (void)updateAllSongiPod{
//    [self firstQueryAllSongiPod];
//}
//
//- (void)updateAllSongAppDoc{
//    [self firstQueryAllSongAppDoc];
//}

@end
