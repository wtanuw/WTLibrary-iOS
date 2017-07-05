//
//  metadataRetriever.h
//  SwiftLoad
//
//  Created by Nathaniel Symer on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define showUnknownArtistForNil
#define showUnknownAlbumForNil
#define UnknownArtist   @"Unknown Artist"
#define UnknownAlbum    @"Unknown Album"
#define showLastPathForTitle

@interface metadataRetriever : NSObject{
    NSURL *url;
}

+ (NSArray *)getMetadataForURL:(NSURL *)filePath;
+ (NSArray *)getMetadataForFile:(NSString *)filePath;

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
@end
