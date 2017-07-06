//
//  WTUtaProtocol.h
//  WTLibrary-iOS
//
//  Created by iMac on 7/6/17.
//  Copyright © 2017 wtanuw. All rights reserved.
//

#ifndef WTUtaProtocol_h
#define WTUtaProtocol_h

@protocol WTUtaProtocol <NSObject>

@required@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *artist;
@property (nonatomic,retain) NSString *albumTitle;
@property (nonatomic,assign) int playbackDuration;
@property (nonatomic,retain) NSString *genre;
@property (nonatomic,assign) int trackNumber;
@property (nonatomic,retain) NSURL *pathURL;
@property (nonatomic,retain) UIImage *artwork;
@property (nonatomic,retain) UIImage *artworkThumbnail;
@property (nonatomic,getter = isLoadArtwork,readonly) BOOL loadArtwork;
@property (nonatomic,getter = isLoadArtworkThumbnail,readonly) BOOL loadArtworkThumbnail;

@property (nonatomic,assign) BOOL filsIsOK;

@property (nonatomic,getter = isHaveArtworkThumbnail,readonly) BOOL haveArtworkThumbnail;

@property (nonatomic,retain) NSString *lyrics;

- (void)loadArtworkImage;
- (void)queueLoadArtwork;
- (void)removeArtwork;
- (void)removeArtworkThumbnail;
- (NSString*)loadLyric;

@optional

@end

typedef NSObject<WTUtaProtocol> WTUtaItem;

//@interface MusicItem : NSObject<WTUtaProtocol>
//
//@end

//@interface MusicItem : WTUtaItem
//
//@end


#endif /* WTUtaProtocol_h */

//@interface MusicItem : NSObject
//
//@property (nonatomic,retain) NSString *title;
//@property (nonatomic,retain) NSString *artist;
//@property (nonatomic,retain) NSString *albumTitle;
//@property (nonatomic,assign) int playbackDuration;
//@property (nonatomic,retain) NSString *genre;
//@property (nonatomic,assign) int trackNumber;
//@property (nonatomic,retain) NSURL *pathURL;
//@property (nonatomic,retain) UIImage *artwork;
//@property (nonatomic,retain) UIImage *artworkThumbnail;
//@property (nonatomic,getter = isLoadArtwork,readonly) BOOL loadArtwork;
//@property (nonatomic,getter = isLoadArtworkThumbnail,readonly) BOOL loadArtworkThumbnail;
//
//@property (nonatomic,assign) BOOL filsIsOK;
//
//@property (nonatomic,getter = isHaveArtworkThumbnail,readonly) BOOL haveArtworkThumbnail;
//
//@property (nonatomic,retain) NSString *lyrics;
//
//- (void)loadArtworkImage;
//- (void)queueLoadArtwork;
//- (void)removeArtwork;
//- (void)removeArtworkThumbnail;
//- (NSString*)loadLyric;
//
//@end
