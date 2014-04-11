//
//  DBManager.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

// Create Database 
-(BOOL)createDB
{
    NSString *docsDir;
    NSArray *dirPaths;    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);    
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: 
                    [docsDir stringByAppendingPathComponent: @"Employee.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        isSuccess = [self createTable:CREATE_TABLE];  // Change Query from .pch file
    }    
    
    return isSuccess;
}

// Create table
-(BOOL)createTable:(NSString*)createQuery
{
    BOOL isSuccess = YES;
    const char *dbpath = [databasePath UTF8String];        
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = [createQuery UTF8String];           
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) 
            != SQLITE_OK)
        {
            isSuccess = NO;
            NSLog(@"Failed to create table");
        }
        sqlite3_close(database);
        return  isSuccess;
    }
    else {
        isSuccess = NO;
        NSLog(@"Failed to open/create database");
    }
    return isSuccess;
}

// Close DataBase

-(void)closeDatabase
{
  sqlite3_close(database);
}

// Sqlite CURD Operation

-(BOOL)curdOperation:(NSString*)queryStatement
{
    BOOL isSuccessOperation = NO;
    
    const char *dbpath = [databasePath UTF8String];    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {        
        const char *insert_stmt = [queryStatement UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            isSuccessOperation = YES;
        } 
        else {
            isSuccessOperation = NO;
            NSLog(@"Error --> %s",sqlite3_errmsg(database));
        }
        
        sqlite3_reset(statement);
    }
    return isSuccessOperation;
}

// Insert Data into Database

- (BOOL) saveData:(NSString*)InsertQuery
{
    BOOL isSaved = [self curdOperation:InsertQuery];
    [self closeDatabase];
    return isSaved;
}

// Update Data into Database
-(BOOL) updateData:(NSString*)updateQuery
{
    BOOL isUpdate = [self curdOperation:updateQuery];
    [self closeDatabase];
    return isUpdate;
}

// Delete Data from Database
-(BOOL) deleteData:(NSString*)deleteQuery
{
    BOOL isDelete = [self curdOperation:deleteQuery];
    [self closeDatabase];
    return isDelete;
}

// Get All Records From Database

-(NSArray*) getAllRecords:(NSString*)tableName
{
   NSString *getAllQuery = [NSString stringWithFormat:@"Select * FROM %@",tableName];
   return [self getRecords:getAllQuery isCheckOperationId:YES];
}

-(NSMutableArray*) getRecords :(NSString*)getQuery isCheckOperationId:(BOOL)checkOperation
{
    const char *dbpath = [databasePath UTF8String];    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        const char *query_stmt = [getQuery UTF8String];
        
        sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL);
        NSMutableArray *jsonArray = [NSMutableArray new];
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableArray *objectColumn = [NSMutableArray new];
            NSMutableArray *keysColumn = [NSMutableArray new];
            for (int i=0; i < sqlite3_column_count(statement); i++) 
            {
                [objectColumn addObject:[NSString stringWithUTF8String:(const char *) sqlite3_column_text(statement, i)]];
                [keysColumn addObject:[NSString stringWithUTF8String:(const char *) sqlite3_column_name(statement, i)]];
            }
            
            NSArray *objects=[[NSArray alloc]initWithArray:objectColumn];
            NSArray *keys=[[NSArray alloc]initWithArray:keysColumn];
            NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
            if (checkOperation)
            {
                if ([[dict objectForKey:@"operationId"] isEqualToString:@"2"]) 
                {
                    
                }
                else
                {
                    [jsonArray addObject:dict];
                }
            }
            else 
            {
                [jsonArray addObject:dict];
            }
        }
    
        [self closeDatabase];
        return jsonArray;
    }
    
    return nil;

}

// Search From DataBase

-(NSArray*) searchDatabase :(NSString *)searchQuery
{
    return [self getRecords:searchQuery isCheckOperationId:NO];
    
}

// Get table info

-(NSMutableArray*)getTableInfo:(NSString*)tableName
{
    NSMutableArray *columnArray = [NSMutableArray new];
    const char *dbpath = [databasePath UTF8String];    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {        
        NSString *tableInfo = [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName];
        const char *insert_stmt = [tableInfo UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *columnName = [[NSString alloc] initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 1)];
            [columnArray addObject:columnName];
        } 
        sqlite3_reset(statement);
    }
    NSLog(@"%@",columnArray);

    return columnArray;
}

@end
