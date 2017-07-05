//
//  WTDatabase.h
//  WTProject
//
//  Created by Wat Wongtanuwat on 11/18/14.
//  Copyright (c) 2014 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTDatabase_VERSION 0x00020000

#import "WTMacro.h"
//#import <FMDB/FMDB.h>
#import "FMDB.h"

@class WTDatabaseSQL;

@interface WTDatabase : NSObject

+ (instancetype)sharedManager;

- (NSUserDefaults*)standardUserDefaults;
- (void)registerDefaults:(NSDictionary*)dict;
- (void)resetStandardUserDefaults;
- (BOOL)synchronizeUserDefaults;

- (FMDatabase*)SQLDatabaseFileWithDefaultsPath;
- (FMDatabase*)SQLDatabaseFileWithPath:(NSString*)fileNamePath;
- (FMDatabase*)SQLDatabaseTemporaryWithName:(NSString*)name;
- (FMDatabase*)SQLDatabaseMemoryWithName:(NSString*)name;

- (FMDatabase*)SQLDatabaseName:(NSString*)name;
- (void)removeSQLDatabaseName:(NSString*)name;

- (FMDatabase*)openSQLDatabaseName:(NSString*)name;
- (void)closeSQLDatabaseName:(NSString*)name;

- (void)isDatabase:(FMDatabase*)db haveTable:(NSString*)tableName;

@end


//@interface WTDatabaseSQL : NSObject
//
//@property (nonatomic,WT_SAFE_ARC_PROP_RETAIN) FMDatabase *sqlDb;
//@property (nonatomic,WT_SAFE_ARC_PROP_RETAIN) NSString *name;
//
//+ (instancetype)databaseFileWithPath:(NSString*)fileNamePath;
//+ (instancetype)databaseTemporaryWithName:(NSString*)name;
//+ (instancetype)databaseMemoryWithName:(NSString*)name;
//
////- (instancetype)initWithPath:(NSString*)path;
//
//- (BOOL)open;
//- (BOOL)close;
//- (void)goodConnection;
//
//
//- (NSDictionary*)select;
//- (BOOL)update;
//
//- (BOOL)executeUpdate:(NSString*)sql, ...;
//- (BOOL)executeUpdateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
//- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments withCompletion:(void(^)(NSDictionary *resultsDictionary))block;
//- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments withCompletion:(void(^)(NSDictionary *resultsDictionary))block;
//- (FMResultSet *)executeQuery:(NSString*)sql, ...;
//- (FMResultSet *)executeQueryWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);
//- (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
//- (FMResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;
//
//@end
