//
//  SQLQueryManager.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 03/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployeeData.h"
@interface SQLQueryManager : NSObject

-(BOOL)addRecordInTable:(EmployeeData*)emp;
-(BOOL)updateRecordIntable:(EmployeeData*)emp;
-(BOOL)deleteRecordFromtable:(EmployeeData*)emp;

-(NSArray*)getRecordsOnEmpId;
@end
