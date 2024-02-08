//
//  metadataRetriever.m
//  SwiftLoad
//
//  Created by Nathaniel Symer on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WTMetadataRetriever.h"
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WTMacro.h"
#import "ID3Parser.h"

#define showUnknownArtistForNil
#define showUnknownAlbumForNil

#define UseMetaDataLog 0
#if UseMetaDataLog && WATLOG_DEBUG_ENABLE
#    define MetaDataLog(...) NSLog(__VA_ARGS__)
#else
#    define MetaDataLog(...) /* */
#endif

NSString * const kAEAudioControllerSessionRouteChangeNotification = @"com.theamazingaudioengine.AEAudioControllerRouteChangeNotification";
static float const kCarPrice = 300.0f;
static NSString* const kCarModel = @"Lexus IS 200T";
static int const KCarType = 1;

#define UnknownArtist   @"Unknown Artist"
#define UnknownAlbum    @"Unknown Album"

static NSString* const kUnknownArtist = UnknownArtist;
static NSString* const kUnknownAlbum = UnknownAlbum;
static NSString* const kUnknownGenre = @"---";
static NSString* const kUnknownTime = @"";

@interface WTSongMetaData ()

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) NSString *trackNumber;
@property (nonatomic, strong) NSString *trackNumber1;
@property (nonatomic, strong) NSString *trackNumber2;
@property (nonatomic, strong) NSString *genreName;
@property (nonatomic, strong) NSString *durationTime;
@property (nonatomic, strong) NSNumber *trackNumberNumber;
@property (nonatomic, strong) NSNumber *trackNumber1Number;
@property (nonatomic, strong) NSNumber *trackNumber2Number;
@property (nonatomic, strong) NSNumber *durationTimeNumber;
@property (nonatomic, getter=isRetrived) BOOL retrived;
@property (nonatomic, getter=isValid) BOOL valid;
@property (nonatomic, assign) BOOL ad;

@end

@implementation WTSongMetaData

+ (instancetype)metaDataFromFileURL:(NSURL *)fileURL
{
    return [[self alloc] initWithFileURL:fileURL];
}

- (instancetype)initWithFileURL:(NSURL *)fileURL
{
    self = [self init];
    if(self)
    {
        _fileURL = fileURL;
//        NSDate *date1 = [NSDate date];
//        NSArray *array = [WTMetadataRetriever getMetadataForURL:_fileURL];
//        NSDate *date2 = [NSDate date];
//        ID3Tag* dtag = [ID3Parser parseAudioFileForID3Tag:_fileURL];
//        NSDate *date3 = [NSDate date];
//        NSDictionary *dict1 = [ID3Parser id3TagsForURL:_fileURL];
//        NSDate *date4 = [NSDate date];
//        NSDictionary *dict2 = [ID3Parser id3TagsForURL2:_fileURL];
//        NSDate *date5 = [NSDate date];
////        NSLog(@"idtag %@", dtag);
////        NSLog(@"dict1 %@", dict1);
////        NSLog(@"dict2 %@", dict2);
//        NSLog(@"date1 %f", date1.timeIntervalSince1970);
//        NSLog(@"date2 %f", date2.timeIntervalSince1970);
//        NSLog(@"date3 %f", date3.timeIntervalSince1970);
//        NSLog(@"date4 %f", date4.timeIntervalSince1970);
//        NSLog(@"date5 %f", date5.timeIntervalSince1970);
//
//
//
//        NSLog(@"ret %@", [WTMetadataRetriever songForMetadataArray:array]);
//        NSLog(@"ret %@", [WTMetadataRetriever artistForMetadataArray:array]);
//        NSLog(@"ret %@", [WTMetadataRetriever albumForMetadataArray:array]);
//        NSLog(@"ret %@", [WTMetadataRetriever playtimeForMetadataArray:array]);
//
//
//        NSLog(@"tag %@", dtag.title);
//        NSLog(@"tag %@", dtag.artist);
//        NSLog(@"tag %@", dtag.album);
//        NSLog(@"tag %@", dtag.approxDuration);
//
//        NSLog(@"dict1 %@", dict1[[NSString stringWithUTF8String: kAFInfoDictionary_Title]]);
//        NSLog(@"dict1 %@", dict1[[NSString stringWithUTF8String: kAFInfoDictionary_Artist]]);
//        NSLog(@"dict1 %@", dict1[[NSString stringWithUTF8String: kAFInfoDictionary_Album]]);
//        NSLog(@"dict1 %@", dict1[[NSString stringWithUTF8String: kAFInfoDictionary_ApproximateDurationInSeconds]]);
//
        
    }
    return self;
}
//Printing description of dict1:
//{
//    TALB album = "Blaster Master Zero Original Soundtrack";
//    "approximate duration in seconds" = "129.463";
//    TCOM artist = "Ippo Yamada, Aoi Takeda, Kotaro Yamada, Ryo Kawakami, Hiroaki Sano, Naoki Kodaka, hally, Bun, Tatsuhiko Kasuga, Ichiro Kato";
//    TENC comments = "http://www.sonixgvn.net/";
//    TPE1 composer = "Ippo Yamada, Aoi Takeda, Kotaro Yamada, Ryo Kawakami, Hiroaki Sano, Naoki Kodaka, hally, Bun, Tatsuhiko Kasuga, Ichiro Kato";
//    WPUB "encoding application" = "http://www.sonixgvn.net/";
//    TCON genre = Game;
//    TIT2 title = "The Underground Adventure Begins";
//    TRCK "track number" = "03/29";
//    TYER year = 2017;
//}
- (BOOL)readAll
{
    return _valid;
}

- (BOOL)readByRetriever
{
    NSArray *array = [WTMetadataRetriever getMetadataForURL:_fileURL];
    if (array) {
        _artistName = [WTMetadataRetriever artistForMetadataArray:array];
        _songName = [WTMetadataRetriever songForMetadataArray:array];
        _albumName = [WTMetadataRetriever albumForMetadataArray:array];
        _trackNumber = [WTMetadataRetriever trackNumberForMetadataArray:array];
        _trackNumber1 = [WTMetadataRetriever trackNumberForMetadataArray:array];
        _trackNumber2 = @"";
        _genreName = [WTMetadataRetriever genreForMetadataArray:array];
        _durationTime = [WTMetadataRetriever playtimeForMetadataArray:array];
        _valid = true;
    }
    _retrived = true;
    
    return _valid;
}

- (BOOL)readByID3TagParser
{
    ID3Tag *idtag = [ID3Parser parseAudioFileForID3Tag:_fileURL];
    if (idtag) {
        _artistName = idtag.artist;
        _songName = idtag.title;
        _albumName = idtag.album;
        _trackNumber = [NSString stringWithFormat:@"%ld",idtag.trackNumber.integerValue];
        _trackNumber1 = [NSString stringWithFormat:@"%ld",idtag.trackNumber.integerValue];
        _trackNumber2 = [NSString stringWithFormat:@"%ld",idtag.totalTracks.integerValue];
        _genreName = idtag.genre;
        _durationTime = [NSString stringWithFormat:@"%ld",idtag.approxDuration.integerValue];
        _valid = true;
    }
    _retrived = true;
    return _valid;
}

- (BOOL)readByParser1
{
    NSDictionary *nsDict = [ID3Parser id3TagsForURL1:_fileURL];
    if (nsDict) {
        _artistName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Artist]];
        _songName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Title]];
        _albumName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Album]];
        _genreName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Genre]];
        _durationTime = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ApproximateDurationInSeconds]];
        _durationTimeNumber = [NSNumber numberWithInt:[[nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ApproximateDurationInSeconds]] intValue]];
        
        NSString* tracks = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_TrackNumber]];

        NSUInteger slashLocation = [tracks rangeOfString:@"/"].location;

        if (slashLocation == NSNotFound) {
            _trackNumber = tracks;
            _trackNumberNumber = [NSNumber numberWithInt:[tracks intValue]];
            _trackNumber1 = tracks;
            _trackNumber1Number = [NSNumber numberWithInt:[tracks intValue]];
            _trackNumber2 = @"";
            _trackNumber2Number = [NSNumber numberWithInt:0];
        } else {
            _trackNumber = [tracks substringToIndex:slashLocation];
            _trackNumber1 = [tracks substringToIndex:slashLocation];
            _trackNumber2 = [tracks substringFromIndex:(slashLocation+1 < [tracks length] ? slashLocation+1 : 0 )];
            _trackNumberNumber = [NSNumber numberWithInt:[[tracks substringToIndex:slashLocation] intValue]];
            _trackNumber1Number = [NSNumber numberWithInt:[[tracks substringToIndex:slashLocation] intValue]];
            _trackNumber2Number = [NSNumber numberWithInt:[[tracks substringFromIndex:(slashLocation+1 < [tracks length] ? slashLocation+1 : 0 )] intValue]];
        }
        _valid = true;
    }
    _retrived = true;
    return _valid;
}

- (BOOL)readBy2
{
    NSDictionary *nsDict = [ID3Parser id3TagsForURL2:_fileURL];
    if (nsDict) {
        _artistName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Artist]];
        _songName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Title]];
        _albumName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Album]];
        _genreName = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Genre]];
        _durationTime = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ApproximateDurationInSeconds]];
        _durationTimeNumber = [NSNumber numberWithInt:[[nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ApproximateDurationInSeconds]] intValue]];
        
        NSString* tracks = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_TrackNumber]];

        NSUInteger slashLocation = [tracks rangeOfString:@"/"].location;

        if (slashLocation == NSNotFound) {
            _trackNumber = tracks;
            _trackNumberNumber = [NSNumber numberWithInt:[tracks intValue]];
            _trackNumber1 = tracks;
            _trackNumber1Number = [NSNumber numberWithInt:[tracks intValue]];
            _trackNumber2 = @"";
            _trackNumber2Number = [NSNumber numberWithInt:0];
        } else {
            _trackNumberNumber = [NSNumber numberWithInt:[[tracks substringToIndex:slashLocation] intValue]];
            _trackNumber1Number = [NSNumber numberWithInt:[[tracks substringToIndex:slashLocation] intValue]];
            _trackNumber2Number = [NSNumber numberWithInt:[[tracks substringFromIndex:(slashLocation+1 < [tracks length] ? slashLocation+1 : 0 )] intValue]];
            _trackNumber = [tracks substringToIndex:slashLocation];
            _trackNumber1 = [tracks substringToIndex:slashLocation];
            _trackNumber2 = [tracks substringFromIndex:(slashLocation+1 < [tracks length] ? slashLocation+1 : 0 )];
        }
        _valid = true;
    }
    _retrived = true;
    return _valid;
}

- (void)readByPreferMethod {
    [self readByID3TagParser];
}

- (NSString*)fileName
{
    if (_fileName) {
        return _fileName;
    }
    _fileName = [[_fileURL lastPathComponent] stringByDeletingPathExtension];
    return _fileName;
}

- (NSString*)fileNameWithEx
{
    if (_fileName) {
        return _fileName;
    }
    _fileName = [_fileURL lastPathComponent];
    return _fileName;
}

- (NSString*)songName
{
    if (_valid && _songName) {
        return _songName;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _songName;
    }
    return [self fileName];
}

- (NSString*)artistName
{
    if (_valid && _artistName) {
        return _artistName;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _artistName;
    }
#ifdef showUnknownArtistForNil
    return kUnknownArtist;
#else
    return @"";
#endif
}

- (NSString*)albumName
{
    if (_valid && _albumName) {
        return _albumName;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _albumName;
    }
#ifdef showUnknownAlbumForNil
    return kUnknownAlbum;
#else
    return @"";
#endif
}

- (NSString*)trackNumber
{
    if (_valid && _trackNumber) {
        return _trackNumber;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _trackNumber;
    }
    return @"";
}

- (NSString*)genreName
{
    if (_valid && _genreName) {
        return _genreName;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _genreName;
    }
    return kUnknownGenre;
}

- (NSString*)durationTime
{
    if (_valid && _durationTime) {
        return _durationTime;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _durationTime;
    }
    return kUnknownTime;
}

- (NSString*)trackNumber1
{
    if (_valid && _trackNumber1) {
        return _trackNumber1;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _trackNumber1;
    }
    return @"";
}

- (NSString*)trackNumber2
{
    if (_valid && _trackNumber2) {
        return _trackNumber2;
    }
    if (!_retrived) {
        [self readByPreferMethod];
    }
    if (_valid) {
        return _trackNumber2;
    }
    return @"";
}

@end

@implementation WTMetadataRetriever


+ (WTSongMetaData*)metaDataFromFileURL:(NSURL *)fileURL
{
    return [WTSongMetaData metaDataFromFileURL:fileURL];
}

+ (void)printMetadataForFileAtPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    AVAsset *asset = [AVURLAsset assetWithURL:url];
    NSArray *availableFormats = [asset availableMetadataFormats];
    NSLog(@"Available formats: %@", availableFormats);
    NSArray *iTunesMetadata = [asset metadataForFormat:AVMetadataFormatiTunesMetadata];
    for (AVMetadataItem *item in iTunesMetadata)
    {
        NSLog(@"%@ %lx", item.key, [(NSNumber *)item.key longValue]);

        if ([item.key isEqual:AVMetadataiTunesMetadataKeySongName])
        {
            NSLog(@"FOUND song name: %@", item.stringValue);
        }
    }
    NSLog(@"====================");
    NSLog(@"%@ %@ %@", AVMetadataiTunesMetadataKeySongName, AVMetadataiTunesMetadataKeyAlbum, AVMetadataiTunesMetadataKeyArtist);
}

+ (NSArray *)getMetadataForURL:(NSURL *)fileURL {
    
    if(!fileURL) {
        return nil;
    }
    
    AudioFileID fileID  = nil;
    OSStatus err        = noErr;
    
    err = AudioFileOpenURL( (CFURLRef) CFBridgingRetain(fileURL), kAudioFileReadPermission, 0, &fileID );
    if (err != noErr) {
        MetaDataLog(@"AudioFileOpenURL failed");
    }
    
    UInt32 id3DataSize  = 0;
    char * rawID3Tag    = NULL;
    
    err = AudioFileGetPropertyInfo( fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL );
    if (err != noErr) {
        MetaDataLog(@"AudioFileGetPropertyInfo failed for ID3 tag");
    }
    
    rawID3Tag = (char *) malloc(id3DataSize);
    if (rawID3Tag == NULL) {
        MetaDataLog(@"could not allocate %u bytes of memory for ID3 tag", (unsigned int)id3DataSize);
    }
    
    err = AudioFileGetProperty(fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag);
    if (err != noErr) {
        MetaDataLog(@"AudioFileGetProperty failed for ID3 tag");
    }
    
    int ilim = 100;
    if (ilim > id3DataSize) {
        ilim = id3DataSize;
    }
    for (int i=0; i < ilim; i++) {
        if( rawID3Tag[i] < 32 ) {
            //            printf( "." );
        } else {
            //            printf( "%c", rawID3Tag[i] );
        }
    }
    
    UInt32 id3TagSize = 0;
    UInt32 id3TagSizeLength = 0;
    err = AudioFormatGetProperty( kAudioFormatProperty_ID3TagSize,
                                 id3DataSize,
                                 rawID3Tag,
                                 &id3TagSizeLength,
                                 &id3TagSize
                                 );
    if( err != noErr ) {
        MetaDataLog(@"AudioFormatGetProperty failed for ID3 tag size");
        switch( err ) {
            case kAudioFormatUnspecifiedError:
                MetaDataLog(@"err: audio format unspecified error" );
                break;
            case kAudioFormatUnsupportedPropertyError:
                MetaDataLog(@"err: audio format unsupported property error" );
                break;
            case kAudioFormatBadPropertySizeError:
                MetaDataLog(@"err: audio format bad property size error" );
                break;
            case kAudioFormatBadSpecifierSizeError:
                MetaDataLog(@"err: audio format bad specifier size error" );
                break;
            case kAudioFormatUnsupportedDataFormatError:
                MetaDataLog(@"err: audio format unsupported data format error");
                break;
            case kAudioFormatUnknownFormatError:
                MetaDataLog(@"err: audio format unknown format error");
                break;
            default:
                MetaDataLog(@"err: some other audio format error");
                break;
        }
    }
    
    CFDictionaryRef piDict = nil;
    UInt32 piDataSize = sizeof(piDict);
    
    err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict );
    if(err != noErr) {
        MetaDataLog(@"AudioFileGetProperty failed for property info dictionary");
        free(rawID3Tag);
        return nil;
    }else{
        
        
        NSString *artistCF = (NSString *)CFDictionaryGetValue(piDict, CFSTR(kAFInfoDictionary_Artist));
        NSString *titleCF = (NSString *)CFDictionaryGetValue(piDict, CFSTR(kAFInfoDictionary_Title));
        NSString *albumCF = (NSString *)CFDictionaryGetValue(piDict, CFSTR(kAFInfoDictionary_Album));
        
        NSString *playtimeCF = (NSString *)CFDictionaryGetValue(piDict, CFSTR(kAFInfoDictionary_ApproximateDurationInSeconds));
        NSString *genreCF = (NSString *)CFDictionaryGetValue(piDict, CFSTR(kAFInfoDictionary_Genre));
        NSString *tracknumberCF = (NSString *)CFDictionaryGetValue(piDict, CFSTR(kAFInfoDictionary_TrackNumber));
        
        
        NSString *artist = [NSString stringWithFormat:@"%@",artistCF];
        NSString *title = [NSString stringWithFormat:@"%@",titleCF];
        NSString *album = [NSString stringWithFormat:@"%@",albumCF];
        
        NSString *playtime = [NSString stringWithFormat:@"%@",playtimeCF];
        NSString *genre = [NSString stringWithFormat:@"%@",genreCF];
        NSString *tracknumber;
        
        NSUInteger slashLocation = [tracknumberCF rangeOfString:@"/"].location;
        
        if (slashLocation == NSNotFound) {
            tracknumber = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[tracknumberCF intValue]]];
        } else {
            tracknumber = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[[tracknumberCF substringToIndex:slashLocation] intValue]]];
            //        tag.totalTracks = [NSNumber numberWithInt:[[tracks substringFromIndex:(slashLocation+1 < [tracks length] ? slashLocation+1 : 0 )] intValue]];
        }
        
        
#ifdef showUnknownArtistForNil
        NSString *artistNil = UnknownArtist;
#else
        NSString *artistNil = @"";
#endif
        NSString *titleNil = [NSString stringWithString:[fileURL lastPathComponent]];
#ifdef showUnknownAlbumForNil
        NSString *albumNil = UnknownAlbum;
#else
        NSString *albumNil = @"";
#endif
        
        NSString *playtimeNil = @"0";
        NSString *genreNil = @"---";
        NSString *tracknumberNil = @"";
        
        BOOL artistIsNil = [artist isEqualToString:@"(null)"];
        BOOL albumIsNil = [album isEqualToString:@"(null)"];
        BOOL titleIsNil = [title isEqualToString:@"(null)"];
        
        BOOL playtimeIsNil = [playtime isEqualToString:@"(null)"];
        BOOL genreIsNil = [genre isEqualToString:@"(null)"];
        BOOL tracknumberIsNil = [tracknumber isEqualToString:@"(null)"];
        
        NSMutableArray *initArray = [NSMutableArray arrayWithCapacity:10];
        if (artistIsNil) {
            [initArray addObject:artistNil];
        } else {
            [initArray addObject:artist];
        }
        if (titleIsNil) {
            [initArray addObject:titleNil];
        } else {
            [initArray addObject:title];
        }
        if (albumIsNil) {
            [initArray addObject:albumNil];
        } else {
            [initArray addObject:album];
        }
        
        if (playtimeIsNil) {
            [initArray addObject:playtimeNil];
        } else {
            [initArray addObject:[playtime stringByReplacingOccurrencesOfString:@"," withString:@""]];
        }
        if (genreIsNil) {
            [initArray addObject:genreNil];
        } else {
            [initArray addObject:genre];
        }
        if (tracknumberIsNil) {
            [initArray addObject:tracknumberNil];
        } else {
            [initArray addObject:tracknumber];
        }
        
        CFRelease(piDict);
        free(rawID3Tag);
        
        
        NSArray *theArray = [NSArray arrayWithArray:initArray];
        
        return theArray;
    }
}


+ (NSString *)playtimeForFile:(NSString *)filePath
{
    return @"";
}

+ (NSString *)playtimeForURL:(NSURL *)fileURL
{
    return @"";
}

+ (NSString*)getPlaytime:(NSURL *)fileURL {
    
    if(!fileURL) {
        return nil;
    }
    
    return [WTMetadataRetriever metaDataFromFileURL:fileURL].durationTime;
    
}
+ (NSString *)artistForMetadataArray:(NSArray *)array {
    if ([array count] < 0 ) {
        return kUnknownArtist;
    }
    return [array objectAtIndex:0];
}

+ (NSString *)songForMetadataArray:(NSArray *)array {
    if ([array count] < 1 ) {
        return @"";
    }
    return [array objectAtIndex:1];
}

+ (NSString *)albumForMetadataArray:(NSArray *)array {
    if ([array count] < 2 ) {
        return kUnknownAlbum;
    }
    return [array objectAtIndex:2];
}

+ (NSString *)playtimeForMetadataArray:(NSArray *)array {
    if ([array count] < 3 ) {
        return kUnknownTime;
    }
    return [array objectAtIndex:3];
}

+ (NSString *)genreForMetadataArray:(NSArray *)array {
    if ([array count] < 4 ) {
        return kUnknownGenre;
    }
    return [array objectAtIndex:4];
}

+ (NSString *)trackNumberForMetadataArray:(NSArray *)array {
    if ([array count] < 5 ) {
        return @"";
    }
    return [array objectAtIndex:5];
}

+ (NSString *)lyricsForURL:(NSURL *)url{
    
    //    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    //lyrics key
    //ULT = 5590100;//
    
    //lyrics key
    //USLT = 1431522388;//
    //1431522388 = 0X55534C54 -> "0X55","(85, 'U')"  "0X53","(83,'S')" "0X4C","(76,'L')" "0X54","(84,'T')"
    
    NSArray *meta = [asset metadataForFormat:AVMetadataFormatiTunesMetadata];
    NSArray *itfilteredKeys = [AVMetadataItem metadataItemsFromArray:meta withKey:AVMetadataiTunesMetadataKeyTrackNumber keySpace:nil];
    for ( AVMetadataItem* item in itfilteredKeys ) {
        NSData *value = [item dataValue];
        unsigned char aBuffer[4];
        [value getBytes:aBuffer length:4];
        //unsigned char *n = [value bytes];
        int value1 = aBuffer[3];
        NSLog(@"trackNumber from iTunes = %i", value1);
    }
    
    NSArray * tagArray = [asset metadataForFormat:AVMetadataFormatID3Metadata ];
    for(AVMetadataItem *item in tagArray){
        
        NSString *keySpace = item.keySpace;
        NSString *key = [NSString stringWithFormat:@"%@", (NSString*)item.key];
        
//        NSLog(@"%@=%@", key, [item.value copyWithZone:nil]);
//        NSLog(@"%@=%@", key, item);
//        WatLog(@"%@ / %@ / %@ / %@",item.commonKey,item.identifier,item.value,item.key);
        
        
        if (key && [keySpace isEqualToString:AVMetadataKeySpaceID3]){
            if([key isEqualToString:@"1431522388"] ){ // ios < 8
                NSDictionary *data = [NSDictionary dictionaryWithDictionary:(NSDictionary*)item.value];
                return [data objectForKey:@"text"];
            }else if([key isEqualToString:@"5590100"]){ // ios < 8
                NSDictionary *data = [NSDictionary dictionaryWithDictionary:(NSDictionary*)item.value];                return [data objectForKey:@"text"];
            }else if([key isEqualToString:@"USLT"]){ // ios == 8
                return (NSString*)item.value;
            }else if([key isEqualToString:@"ULT"]){ // ios == 8
                return (NSString*)item.value;
            }
        }
        
        // in case still not found lyric, do more search
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
            key = [NSString stringWithFormat:@"%@", [AVMetadataItem keyForIdentifier:item.identifier]];
            if (key && [keySpace isEqualToString:AVMetadataKeySpaceID3]){
                if([key isEqualToString:@"1431522388"] ){
                    return (NSString*)item.value;
                }else if([key isEqualToString:@"5590100"]){
                    return (NSString*)item.value;
                }else if([key isEqualToString:@"USLT"] ){
                    return (NSString*)item.value;
                }else if([key isEqualToString:@"ULT"]){
                    return (NSString*)item.value;
                }
            }
        }
        
    }
    
    return @"";
}

+ (UIImage *)artworkForFile:(NSString *)filePath withSize:(CGSize)size{
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    for (NSString *format in [asset availableMetadataFormats]) {
        for (AVMetadataItem *item in [asset metadataForFormat:format]) {
            if ([[item commonKey] isEqualToString:@"artwork"]) {
                
                NSString *string = [filePath substringFromIndex:[filePath length]-4];
                NSComparisonResult result2 = [string compare:@".m4a"];
                if(!result2){
                    @try
                    {
                        id value = [[item value] copyWithZone:nil];
                        NSData *data;
                        if([value respondsToSelector:@selector(objectForKey:)]){
                            data = [value objectForKey:@"data"];
                        }else{
                            data = (NSData*)value;
                        }
                        UIImage *img = [UIImage imageWithData:data];
                        UIImage *img2 = [self imageWithImage:img scaledToSizeWithSameAspectRatio:size];
                        return img2;
                    }
                    @catch(NSException* ex)
                    {
                        MetaDataLog(@"Error Artwork");
                    }
                }else{
                    id value = [[item value] copyWithZone:nil];
                    NSData *data;
                    if([value respondsToSelector:@selector(objectForKey:)]){
                        data = [value objectForKey:@"data"];
                    }else{
                        data = (NSData*)value;
                    }
                    UIImage *img = [UIImage imageWithData:data];
                    UIImage *img2 = [self imageWithImage:img scaledToSizeWithSameAspectRatio:size];
                    return img2;
                }
                continue;
            }
            
        }
        
    }
    return nil;
}

+ (UIImage *)resizeImage:(UIImage *)image Width:(float)_w Height:(float)_h{
	
	CGImageRef imageRef = [image CGImage];
	
	int width, height;
	
    width = _w;
    height = _h;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef bitmap;
	bitmap = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGColorSpaceRelease(colorSpace);
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;
}

+ (UIImage *)scaleImage:(UIImage*)image toResolution:(int)resolution {
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGRect bounds = CGRectMake(0, 0, width, height);
    //if already at the minimum resolution, return the orginal image, otherwise scale
    if (width <= resolution && height <= resolution) {
        return image;
    } else {
        CGFloat ratio = width/height;
        
        if (ratio > 1) {//landscape
            bounds.size.width = resolution;
            bounds.size.height = bounds.size.width / ratio;
        } else {//portrait
            bounds.size.height = resolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (width <= targetSize.width && height <= targetSize.height) {
        return sourceImage;
    }else if (width <= targetSize.width || height <= targetSize.height) {
        CGFloat ratio = width/height;
        
        if (ratio > 1) {//landscape
            
            targetWidth = width;
            targetHeight = width / ratio;
            scaledWidth = targetWidth;
            scaledHeight = targetHeight;
        } else {//portrait
            
            targetWidth = height * ratio;
            targetHeight = height;
            scaledWidth = targetWidth;
            scaledHeight = targetHeight;
        }
    }
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            //thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            targetHeight = scaledHeight;
        }
        else if (widthFactor < heightFactor) {
            //thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            targetWidth = scaledWidth;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

@end

