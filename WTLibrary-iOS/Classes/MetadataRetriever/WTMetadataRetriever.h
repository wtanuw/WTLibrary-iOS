//
//  metadataRetriever.h
//  SwiftLoad
//
//  Created by Nathaniel Symer on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

extern NSString * const kAEAudioControllerSessionRouteChangeNotification;
static float const kCarPrice;
static NSString* const kCarModel;
static int const KCarType;

static NSString* const kUnknownArtist;
static NSString* const kUnknownAlbum;
@class WTSongMetaData;

@interface WTMetadataRetriever : NSObject

+ (NSArray *)getMetadataForURL:(NSURL *)fileURL DEPRECATED_MSG_ATTRIBUTE("use metaDataFromFileURL and readBy... instead.");

+ (NSString *)artistForMetadataArray:(NSArray *)array;
+ (NSString *)songForMetadataArray:(NSArray *)array;
+ (NSString *)albumForMetadataArray:(NSArray *)array;
+ (NSString *)playtimeForMetadataArray:(NSArray *)array;
+ (NSString *)genreForMetadataArray:(NSArray *)array;
+ (NSString *)trackNumberForMetadataArray:(NSArray *)array;

+ (NSString *)lyricsForURL:(NSURL *)url;

+ (UIImage *)artworkForFile:(NSString *)filePath withSize:(CGSize)size;

+ (UIImage *)scaleImage:(UIImage*)image toResolution:(int)resolution;

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

+ (WTSongMetaData*)metaDataFromFileURL:(NSURL *)fileURL;
//+ (NSString *)filenameForURL:(NSURL *)filePath;
//+ (NSString *)artistForURL:(NSURL *)fileURL;
//+ (NSString *)songForURL:(NSURL *)fileURL;
//+ (NSString *)albumForURL:(NSURL *)fileURL;
//+ (NSString *)playtimeForURL:(NSURL *)fileURL;
//+ (NSString *)genreForURL:(NSURL *)fileURL;
//+ (NSString *)trackNumberForURL:(NSURL *)fileURL;

@end

@interface WTSongMetaData : NSObject

+ (instancetype)metaDataFromFileURL:(NSURL *)fileURL;

@property (nonatomic, readonly) NSURL *fileURL;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *artistName;
@property (nonatomic, readonly) NSString *songName;
@property (nonatomic, readonly) NSString *albumName;
@property (nonatomic, readonly) NSString *genreName;
@property (nonatomic, readonly) NSString *trackNumber;
@property (nonatomic, readonly) NSString *trackNumber1;
@property (nonatomic, readonly) NSString *trackNumber2;
@property (nonatomic, readonly) NSString *durationTime;
@property (nonatomic, readonly, getter=isRetrived) BOOL retrived;
@property (nonatomic, readonly, getter=isValid) BOOL valid;

- (BOOL)readByRetriever;
- (BOOL)readByID3TagParser;
- (BOOL)readByParser1;

@end
