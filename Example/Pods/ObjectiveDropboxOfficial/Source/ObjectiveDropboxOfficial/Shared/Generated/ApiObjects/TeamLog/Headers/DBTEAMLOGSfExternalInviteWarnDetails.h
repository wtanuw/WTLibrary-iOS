///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGSfExternalInviteWarnDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SfExternalInviteWarnDetails` struct.
///
/// Admin settings: team members see a warning before sharing folders outside
/// the team (DEPRECATED FEATURE).
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGSfExternalInviteWarnDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @return An initialized instance.
///
- (instancetype)initDefault;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SfExternalInviteWarnDetails` struct.
///
@interface DBTEAMLOGSfExternalInviteWarnDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGSfExternalInviteWarnDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGSfExternalInviteWarnDetails`
/// API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGSfExternalInviteWarnDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGSfExternalInviteWarnDetails *)instance;

///
/// Deserializes `DBTEAMLOGSfExternalInviteWarnDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGSfExternalInviteWarnDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGSfExternalInviteWarnDetails`
/// object.
///
+ (DBTEAMLOGSfExternalInviteWarnDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END