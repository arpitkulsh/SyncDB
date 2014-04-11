//
//  DBManager.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;

-(BOOL)createDB;
-(BOOL)createTable:(NSString*)createQuery;
-(BOOL)saveData:(NSString*)InsertQuery;
-(BOOL)updateData:(NSString*)updateQuery;
-(BOOL)deleteData:(NSString*)deleteQuery;
-(NSArray*)getAllRecords:(NSString*)tableName;
-(NSArray*)searchDatabase :(NSString *)searchQuery;
@end
