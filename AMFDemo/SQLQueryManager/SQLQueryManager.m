//
//  SQLQueryManager.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 03/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "SQLQueryManager.h"
#import "DBManager.h"
#import "EmployeeData.h"

@implementation SQLQueryManager


// Handle SQL query for Inserting into Local Database
-(BOOL)addRecordInTable:(EmployeeData*)emp
{
    NSLog(@"Employee-->%@",emp);
    NSString *addQuery = [NSString stringWithFormat:@"INSERT INTO Employee VALUES (%d,'%@','%@',%d,%d,%d,%d,%d);",emp.employeeId,emp.employeeFName,emp.employeeLName,emp.employeeDailyRate,emp.employeePaidAmount,emp.employeeBalanceAmount,emp.syncStatus,emp.operationId];
    
   return [[DBManager getSharedInstance] saveData:addQuery];
}

// Handle SQL Query for Updating Records into Local Database
-(BOOL)updateRecordIntable:(EmployeeData*)emp
{
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE Employee SET empFName = '%@', empLName = '%@' ,empDailyRate = %d,empPaidAmount = %d, empBalance = %d, syncStatus = %d, operationId = %d WHERE empId = %d;",emp.employeeFName,emp.employeeLName,emp.employeeDailyRate,emp.employeePaidAmount,emp.employeeBalanceAmount,emp.syncStatus,emp.operationId,emp.employeeId];
    
    NSLog(@"Query --> %@",updateQuery);
    
    return [[DBManager getSharedInstance] updateData:updateQuery];
}

// Handle SQL Query for deleting Records into Local DataBase
-(BOOL)deleteRecordFromtable:(EmployeeData*)emp
{
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM Employee WHERE empId = %d",emp.employeeId];
    
   return [[DBManager getSharedInstance] deleteData:deleteQuery];
}

// Handle SQL Qusery for Reading Data from Local Database
-(NSArray*)getRecordsOnEmpId
{
    NSString *getQuery = [NSString stringWithFormat:@"SELECT * FROM Employee WHERE syncStatus = 0"];
    
    return [[DBManager getSharedInstance] searchDatabase:getQuery];
}
@end


