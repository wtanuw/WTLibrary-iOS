#import "ID3Parser.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ID3Tag
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return nil;
}

@end

@implementation ID3Parser

+ (ID3Tag*) parseAudioFileForID3Tag:(NSURL*) url {
    if (url == nil) {
        return nil;
    }

    AudioFileID fileID  = nil;
    OSStatus err = noErr;

    err = AudioFileOpenURL( (__bridge CFURLRef) url, kAudioFileReadPermission, 0, &fileID );
    if( err != noErr ) {
        NSLog( @"AudioFileOpenURL failed" );
        return nil;
    } else {
        UInt32 id3DataSize = 0;
        char* rawID3Tag = NULL;

        //  Reads in the raw ID3 tag info
        err = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
        if(err != noErr) {
            return nil;
        }

        //  Allocate the raw tag data
        rawID3Tag = (char *) malloc(id3DataSize);

        if(rawID3Tag == NULL) {
            return nil;
        }

        err = AudioFileGetProperty(fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag);
        if(err != noErr) {
            return nil;
        }

        UInt32 id3TagSize = 0;
        UInt32 id3TagSizeLength = 0;
        err = AudioFormatGetProperty(kAudioFormatProperty_ID3TagSize, id3DataSize, rawID3Tag, &id3TagSizeLength, &id3TagSize);

        if(err != noErr) {
            switch(err) {
                case kAudioFormatUnspecifiedError:
                    NSLog(@"err: audio format unspecified error");
                    return nil;
                case kAudioFormatUnsupportedPropertyError:
                    NSLog(@"err: audio format unsupported property error");
                    return nil;
                case kAudioFormatBadPropertySizeError:
                    NSLog(@"err: audio format bad property size error");
                    return nil;
                case kAudioFormatBadSpecifierSizeError:
                    NSLog(@"err: audio format bad specifier size error");
                    return nil;
                case kAudioFormatUnsupportedDataFormatError:
                    NSLog(@"err: audio format unsupported data format error");
                    return nil;
                case kAudioFormatUnknownFormatError:
                    NSLog(@"err: audio format unknown format error");
                    return nil;
                default:
                    NSLog(@"err: some other audio format error");
                    return nil;
            }
        }

        CFDictionaryRef piDict = nil;
        UInt32 piDataSize = sizeof(piDict);

        //  Populates a CFDictionary with the ID3 tag properties
        err = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
        if(err != noErr) {
            NSLog(@"AudioFileGetProperty failed for property info dictionary");
            return nil;
        }

        //  Toll free bridge the CFDictionary so that we can interact with it via objc
        NSDictionary* nsDict = (__bridge NSDictionary*)piDict;

        ID3Tag* tag = [[ID3Tag alloc] init];
        tag.album = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Album]];
        tag.approxDuration = [NSNumber numberWithInt:[[nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ApproximateDurationInSeconds]] intValue]];
        tag.approxDurationString = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ApproximateDurationInSeconds]];
        tag.artist = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Artist]];
        tag.bitRate = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_NominalBitRate]];
        tag.channelLayout = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ChannelLayout]];
        tag.comments = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Comments]];
        tag.composer = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Composer]];
        tag.copyright = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Copyright]];
        tag.encodingApplication = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_EncodingApplication]];
        tag.genre = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Genre]];
        tag.isrc = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_ISRC]];
        tag.keySignature = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_KeySignature]];
        tag.lyricist = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Lyricist]];
        tag.recordedDate = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_RecordedDate]];
        tag.sourceBitRate = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_SourceBitDepth]];
        tag.sourceEncoder = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_SourceEncoder]];
        tag.subtitle = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_SubTitle]];
        tag.tempo = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Tempo]];
        tag.timeSignature = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_TimeSignature]];
        tag.title = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Title]];
        tag.year = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_Year]];

        /*
         *  We're going to parse tracks differently so that we can perform queries on the data. This means we need to look
         *  for a '/' so that we can seperate out the track from the total tracks on the source compilation (if it's there).
         */
        NSString* tracks = [nsDict objectForKey:[NSString stringWithUTF8String: kAFInfoDictionary_TrackNumber]];

        NSUInteger slashLocation = [tracks rangeOfString:@"/"].location;

        if (slashLocation == NSNotFound) {
            tag.trackNumber = [NSNumber numberWithInt:[tracks intValue]];
        } else {
            tag.trackNumber = [NSNumber numberWithInt:[[tracks substringToIndex:slashLocation] intValue]];
            tag.totalTracks = [NSNumber numberWithInt:[[tracks substringFromIndex:(slashLocation+1 < [tracks length] ? slashLocation+1 : 0 )] intValue]];
        }

        //  ALWAYS CLEAN UP!
        CFRelease(piDict);
        nsDict = nil;
        free(rawID3Tag);

        return tag;
    }
}

+ (NSDictionary *)id3TagsForURL1:(NSURL *)resourceUrl
{
    AudioFileID fileID;
    OSStatus result = AudioFileOpenURL((__bridge CFURLRef)resourceUrl, kAudioFileReadPermission, 0, &fileID);

    if (result != noErr) {
        NSLog(@"Error reading tags: %i", (int)result);
        return nil;
    }

    CFDictionaryRef piDict = nil;
    UInt32 piDataSize = sizeof(piDict);

    result = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
    if (result != noErr)
        NSLog(@"Error reading tags. AudioFileGetProperty failed");

    AudioFileClose(fileID);

    NSDictionary *tagsDictionary = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary*)piDict];
    CFRelease(piDict);

    return tagsDictionary;
}

+ (NSDictionary *)id3TagsForURL2:(NSURL *)resourceUrl
{
    AudioFileID fileID;
    OSStatus result = AudioFileOpenURL((__bridge CFURLRef)resourceUrl, kAudioFileReadPermission, 0, &fileID);

    if (result != noErr) {
        return nil;
    }

    //read raw ID3Tag size
    UInt32 id3DataSize = 0;
    char *rawID3Tag = NULL;
    result = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
    if (result != noErr) {
        AudioFileClose(fileID);
        return nil;
    }

    rawID3Tag = (char *)malloc(id3DataSize);

    //read raw ID3Tag
    result = AudioFileGetProperty(fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag);
    if (result != noErr) {
        free(rawID3Tag);
        AudioFileClose(fileID);
        return nil;
    }

    CFDictionaryRef piDict = nil;
    UInt32 piDataSize = sizeof(piDict);

    //this key returns some other dictionary, which works also in iPod library
    result = AudioFormatGetProperty(kAudioFormatProperty_ID3TagToDictionary, id3DataSize, rawID3Tag, &piDataSize, &piDict);
    if (result != noErr) {
        return nil;
    }

    free(rawID3Tag);
    AudioFileClose(fileID);

    NSDictionary *tagsDictionary = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary*)piDict];
    CFRelease(piDict);

    return tagsDictionary;
}

@end
