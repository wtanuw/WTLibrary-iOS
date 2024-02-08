

#import <Foundation/Foundation.h>
@class ID3Tag;

@interface ID3Parser : NSObject {

}

+ (ID3Tag*) parseAudioFileForID3Tag:(NSURL*) url;

+ (NSDictionary *)id3TagsForURL1:(NSURL *)resourceUrl;

+ (NSDictionary *)id3TagsForURL2:(NSURL *)resourceUrl;

@end



@interface ID3Tag : NSObject <NSCoding> {
    NSString* title_;
    NSString* album_;
    NSString* artist_;
    NSNumber* trackNumber_;
    NSNumber* totalTracks_;
    NSString* genre_;
    NSString* year_;
    NSNumber* approxDuration_;
    NSString* composer_;
    NSString* tempo_;
    NSString* keySignature_;
    NSString* timeSignature_;
    NSString* lyricist_;
    NSString* recordedDate_;
    NSString* comments_;
    NSString* copyright_;
    NSString* sourceEncoder_;
    NSString* encodingApplication_;
    NSString* bitRate_;
    NSStream* sourceBitRate_;
    NSString* channelLayout_;
    NSString* isrc_;
    NSString* subtitle_;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *album;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSNumber *trackNumber;
@property (nonatomic, retain) NSNumber *totalTracks;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSNumber *approxDuration;
@property (nonatomic, retain) NSString *composer;
@property (nonatomic, retain) NSString *tempo;
@property (nonatomic, retain) NSString *keySignature;
@property (nonatomic, retain) NSString *timeSignature;
@property (nonatomic, retain) NSString *lyricist;
@property (nonatomic, retain) NSString *recordedDate;
@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSString *copyright;
@property (nonatomic, retain) NSString *sourceEncoder;
@property (nonatomic, retain) NSString *encodingApplication;
@property (nonatomic, retain) NSString *bitRate;
@property (nonatomic, retain) NSStream *sourceBitRate;
@property (nonatomic, retain) NSString *channelLayout;
@property (nonatomic, retain) NSString *isrc;
@property (nonatomic, retain) NSString *subtitle;

@end
