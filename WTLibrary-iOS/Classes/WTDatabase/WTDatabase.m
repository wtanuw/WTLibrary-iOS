//
//  WTDatabase.m
//  WTProject
//
//  Created by Wat Wongtanuwat on 11/18/14.
//  Copyright (c) 2014 Wat Wongtanuwat. All rights reserved.
//

#import "WTDatabase.h"

#import "WTPath.h"

@interface WTDatabase()

@property (nonatomic,WT_SAFE_ARC_PROP_RETAIN) NSMutableDictionary *SQLDatabasePathDictionary;

@property (nonatomic,strong) FMDatabase *db;

@end

@implementation WTDatabase

+ (instancetype)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}


#pragma mark -

- (NSUserDefaults*)standardUserDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (void)registerDefaults:(NSDictionary*)dict
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault registerDefaults:dict];
}

- (void)resetStandardUserDefaults
{
    [NSUserDefaults resetStandardUserDefaults];
}

- (BOOL)synchronizeUserDefaults
{
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

- (FMDatabase*)SQLDatabaseWithPath:(NSString*)dbPath withName:(NSString*)name
{
//#ifdef WTPath_VERSION
//    NSString *dbPath   = [[WTPath libraryDirectoryPath] stringByAppendingPathComponent:@"temp.db"];
//#else
//    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"temp.db"];
//#endif
//    NSLog(@"%@",[WTPath libraryDirectoryPath]);
//    NSString *name = @"temp.db";
//    
    FMDatabase *sqldb = self.SQLDatabasePathDictionary[name];
    
    if(!sqldb)
    {
        sqldb = [FMDatabase databaseWithPath:dbPath];
        
       self.SQLDatabasePathDictionary[name] = sqldb;
    }
    
    return sqldb;
}

- (FMDatabase*)SQLDatabaseFileWithDefaultsPath
{
#ifdef WTPath_VERSION
    NSString *dbPath   = [[WTPath libraryDirectoryPath] stringByAppendingPathComponent:@"temp.db"];
#else
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"temp.db"];
#endif
    NSLog(@"%@",[WTPath libraryDirectoryPath]);
    NSString *name = @"temp.db";
    
    
    return [self SQLDatabaseWithPath:dbPath withName:name];
}

//A file system path. The file does not have to exist on disk. If it does not exist, it is created for you.
- (FMDatabase*)SQLDatabaseFileWithPath:(NSString *)fileNamePath
{
    NSAssert(fileNamePath,@"fileNamePath is NULL. please use SQLDatabaseMemoryWithName instead.");
    NSAssert(![fileNamePath isEqualToString:@""],@"fileNamePath is empty. please use SQLDatabaseTemporaryWithName instead.");
    
    NSString *name = [[fileNamePath lastPathComponent] stringByDeletingPathExtension];
    
    return [self SQLDatabaseWithPath:fileNamePath withName:name];
}

//An empty string (@""). An empty database is created at a temporary location. This database is deleted with the FMDatabase connection is closed.
- (FMDatabase*)SQLDatabaseTemporaryWithName:(NSString*)name
{
//    _db = [FMDatabase databaseWithPath:@""];
    
    return [self SQLDatabaseWithPath:@"" withName:name];
}

//NULL. An in-memory database is created. This database will be destroyed with the FMDatabase connection is closed.
- (FMDatabase*)SQLDatabaseMemoryWithName:(NSString*)name
{
//    _db = [FMDatabase databaseWithPath:NULL];
    
    return [self SQLDatabaseWithPath:NULL withName:name];
}

- (FMDatabase*)SQLDatabaseName:(NSString*)name
{
    return self.SQLDatabasePathDictionary[name];
}

- (void)removeSQLDatabaseName:(NSString*)name
{
    FMDatabase *db = self.SQLDatabasePathDictionary[name];
    [db closeOpenResultSets];
    [db close];
    self.SQLDatabasePathDictionary[name] = nil;
}

#pragma mark -

- (void)openDatabaseName:(NSString*)name
{
    FMDatabase *sqldb = self.SQLDatabasePathDictionary[name];
    
    if(sqldb)
    {
        if (![sqldb open]) {
            return;
        }
    }
}

- (void)closeDatabaseName:(NSString*)name
{
    FMDatabase *sqldb = self.SQLDatabasePathDictionary[name];
    
    if(sqldb)
    {
        if (![sqldb close]) {
            return;
        }
    }
}

- (void)openDatabase
{
    if (![_db open]) {
        WT_SAFE_ARC_RELEASE(_db);
        return;
    }
}

- (void)closeDatabase
{
    if (![_db close]) {
        return;
    }
}

#pragma mark -
//A SELECT statement is a query and is executed via one of the -executeQuery... methods.
//
//Executing queries returns an FMResultSet object if successful, and nil upon failure. You should use the -lastErrorMessage and -lastErrorCode methods to determine why a query failed.
//
//In order to iterate through the results of your query, you use a while() loop. You also need to "step" from one record to the other. With FMDB, the easiest way to do that is like this:
- (void)select
{
//    FMResultSet *s = [db executeQuery:@"SELECT * FROM myTable"];
//    while ([s next]) {
//        //retrieve values for each record
//    }
}

//Any sort of SQL statement which is not a SELECT statement qualifies as an update. This includes CREATE, UPDATE, INSERT, ALTER, COMMIT, BEGIN, DETACH, DELETE, DROP, END, EXPLAIN, VACUUM, and REPLACE statements (plus many more). Basically, if your SQL statement does not begin with SELECT, it is an update statement.
//
//Executing updates returns a single value, a BOOL. A return value of YES means the update was successfully executed, and a return value of NO means that some error was encountered. You may invoke the -lastErrorMessage and -lastErrorCode methods to retrieve more information.
- (BOOL)update
{
//    return [[WTDatabase sharedManager] SQLDatabaseTemporaryWithName:@""].update;
    return NO;
}

@end

#pragma mark -

//@implementation WTDatabaseSQL
//
//+ (instancetype)databaseFileWithPath:(NSString*)fileNamePath
//{
//    return [[self alloc] initWithPath:fileNamePath name:fileNamePath];
//}
//
//+ (instancetype)databaseTemporaryWithName:(NSString*)name
//{
//    return [[self alloc] initWithPath:@"" name:name];
//}
//
//+ (instancetype)databaseMemoryWithName:(NSString*)name
//{
//    return [[self alloc] initWithPath:NULL name:name];
//}
//
//- (instancetype)initWithPath:(NSString*)path name:(NSString*)name;
//{
//    self = [super init];
//    if(self){
//        
//        FMDatabase *db = [FMDatabase databaseWithPath:path];
//        self.sqlDb = db;
//        self.name = name;
//        
//    }
//    return self;
//}
//
//#pragma mark -
//
//- (void)open
//{
//    if (![_sqlDb open]) {
//        WT_SAFE_ARC_RELEASE(_db);
//        return;
//    }
//}
//
//- (void)close
//{
//    if (![_sqlDb close]) {
//        return;
//    }
//}
//
//- (NSDictionary*)select
//{
//    [self open];
//    
//    FMResultSet *s = [_sqlDb executeQuery:@"SELECT * FROM myTable"];
//    while ([s next]) {
//        //retrieve values for each record
//    }
//    
//    ;
//    
//    return [s resultDictionary];
//}
//
//- (BOOL)update
//{
//    [self open];
//    
//    BOOL rs = [_sqlDb executeUpdate:@"INSERT INTO myTable VALUES (?, ?, ?)"];
//    
//    NSDictionary *argsDict = [NSDictionary dictionaryWithObjectsAndKeys:@"My Name", @"name", nil];
//    [_sqlDb executeUpdate:@"INSERT INTO myTable (name) VALUES (:name)" withParameterDictionary:argsDict];
//    
//    [_sqlDb executeUpdate:[NSString stringWithFormat:@"INSERT INTO myTable VALUES (%@)", @"this has \" lots of ' bizarre \" quotes '"]];//wrong
//        
//    [_sqlDb executeUpdate:@"INSERT INTO myTable VALUES (?)", @"this has \" lots of ' bizarre \" quotes '"];
//    
//    [_sqlDb executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:42]];
//    
//    [_sqlDb executeUpdateWithFormat:@"INSERT INTO myTable VALUES (%d)", 42];
//    
//    NSString *tableName = [NSString stringWithFormat:@"%@%@",@"prefix_",@"tablename"];
//    [_sqlDb executeUpdate:@"CREATE TABLE IF NOT EXISTS ? (sort_id integer,file_name text,source_type integer)",tableName];
//    
//    [_sqlDb executeUpdateWithFormat:@"CREATE TABLE IF NOT EXISTS dsada (sort_id integer,file_name text,source_type integer)"];
//    
//    NSString *sql = @"create table bulktest1 (id integer primary key autoincrement, x text);"
//    "create table bulktest2 (id integer primary key autoincrement, y text);"
//    "create table bulktest3 (id integer primary key autoincrement, z text);"
//    "insert into bulktest1 (x) values ('XXX');"
//    "insert into bulktest2 (y) values ('YYY');"
//    "insert into bulktest3 (z) values ('ZZZ');";
//    
//    
//    BOOL success = [_sqlDb executeStatements:sql];
//
//    
//    return rs;
//}
//
//
//@end
