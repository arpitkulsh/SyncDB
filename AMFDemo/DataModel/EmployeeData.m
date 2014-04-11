//
//  EmployeeData.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "EmployeeData.h"

// Server database Keys

NSString *const EmployeesEmpDailyRate = @"employeeDailyRate";
NSString *const EmployeesEmpLName = @"employeeLName";
NSString *const EmployeesEmpBalance = @"employeeBalanceAmount";
NSString *const EmployeesEmpPaidUpToCurrentDate = @"employeePaidAmount";
NSString *const EmployeesSyncStatus = @"syncStatus";
NSString *const EmployeesLastUpdatedTime = @"lastUpdatedTime";
NSString *const EmployeesEmpId = @"employeeId";
NSString *const EmployeesOperationId = @"operationId";
NSString *const EmployeesEmpFName = @"employeeFName";

// Local DataBase Keys
NSString *const EmpDailyRate = @"empDailyRate";
NSString *const EmpLName = @"empLName";
NSString *const EmpBalance = @"empBalance";
NSString *const EmpPaidUpToCurrentDate = @"empPaidAmount";
NSString *const SyncStatus = @"syncStatus";
NSString *const EmpId = @"empId";
NSString *const OperationId = @"operationId";
NSString *const EmpFName = @"empFName";

@implementation EmployeeData

@synthesize employeeId;
@synthesize employeeFName;
@synthesize employeeLName;
@synthesize employeeBalanceAmount;
@synthesize employeeDailyRate;
@synthesize employeePaidAmount;
@synthesize syncStatus;
@synthesize operationId;

// EmployeeData Model
+ (EmployeeData *)modelObjectWithDictionary:(NSDictionary *)dict
{
    EmployeeData *instance = [[EmployeeData alloc] initWithDict:dict];
    return instance;
}

+ (EmployeeData *) modelObjectForLocalDict:(NSDictionary *)dict
{
    EmployeeData *instance = [[EmployeeData alloc] initWithLocalDatabse:dict];
    return instance;
}
// Init For Employee Model
-(EmployeeData *)initWithDict:(NSDictionary*)dict
{
    self.employeeDailyRate = [[self objectOrNilForKey:EmployeesEmpDailyRate fromDictionary:dict] intValue];
    self.employeeLName = [self objectOrNilForKey:EmployeesEmpLName fromDictionary:dict];
    self.employeeBalanceAmount = [[self objectOrNilForKey:EmployeesEmpBalance fromDictionary:dict] intValue];
    self.employeePaidAmount = [[self objectOrNilForKey:EmployeesEmpPaidUpToCurrentDate fromDictionary:dict] intValue];
    self.syncStatus = [[self objectOrNilForKey:EmployeesSyncStatus fromDictionary:dict] intValue];
    self.employeeId = [[self objectOrNilForKey:EmployeesEmpId fromDictionary:dict] intValue];
    self.operationId = [[self objectOrNilForKey:EmployeesOperationId fromDictionary:dict] intValue];
    self.employeeFName = [self objectOrNilForKey:EmployeesEmpFName fromDictionary:dict];    
    return self;
}

// Init For Employee Model As per the Local Database
-(EmployeeData *)initWithLocalDatabse:(NSDictionary*)dict
{
    self.employeeDailyRate = [[self objectOrNilForKey:EmpDailyRate fromDictionary:dict] intValue];
    self.employeeLName = [self objectOrNilForKey:EmpLName fromDictionary:dict];
    self.employeeBalanceAmount = [[self objectOrNilForKey:EmpBalance fromDictionary:dict] intValue];
    self.employeePaidAmount = [[self objectOrNilForKey:EmpPaidUpToCurrentDate fromDictionary:dict] intValue];
    self.syncStatus = [[self objectOrNilForKey:SyncStatus fromDictionary:dict] intValue];
    self.employeeId = [[self objectOrNilForKey:EmpId fromDictionary:dict] intValue];
    self.operationId = [[self objectOrNilForKey:OperationId fromDictionary:dict] intValue];
    self.employeeFName = [self objectOrNilForKey:EmpFName fromDictionary:dict];   

    return self;
}

// Prepare the Dictionary for Local Database
-(NSDictionary*)localDictionaryrepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeeDailyRate] forKey:EmpDailyRate];
    [mutableDict setValue:self.employeeLName forKey:EmployeesEmpLName];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeeBalanceAmount] forKey:EmpBalance];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeePaidAmount] forKey:EmpPaidUpToCurrentDate];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.syncStatus] forKey:SyncStatus];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeeId] forKey:EmpId];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.operationId] forKey:OperationId];
    [mutableDict setValue:self.employeeFName forKey:EmpFName];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

// Prerpare Dictionary for Remote Database
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeeDailyRate] forKey:EmployeesEmpDailyRate];
    [mutableDict setValue:self.employeeLName forKey:EmployeesEmpLName];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeeBalanceAmount] forKey:EmployeesEmpBalance];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeePaidAmount] forKey:EmployeesEmpPaidUpToCurrentDate];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.syncStatus] forKey:EmployeesSyncStatus];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.employeeId] forKey:EmployeesEmpId];
    [mutableDict setValue:[NSString stringWithFormat:@"%d",self.operationId] forKey:EmployeesOperationId];
    [mutableDict setValue:self.employeeFName forKey:EmployeesEmpFName];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

// Check for null in Key
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? object : object;
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.employeeDailyRate = [aDecoder decodeDoubleForKey:EmployeesEmpDailyRate];
    self.employeeLName = [aDecoder decodeObjectForKey:EmployeesEmpLName];
    self.employeeBalanceAmount = [aDecoder decodeDoubleForKey:EmployeesEmpBalance];
    self.employeePaidAmount = [aDecoder decodeDoubleForKey:EmployeesEmpPaidUpToCurrentDate];
    self.syncStatus = [aDecoder decodeDoubleForKey:EmployeesSyncStatus];
    self.employeeId = [aDecoder decodeDoubleForKey:EmployeesEmpId];
    self.operationId = [aDecoder decodeDoubleForKey:EmployeesOperationId];
    self.employeeFName = [aDecoder decodeObjectForKey:EmployeesEmpFName];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeDouble:employeeDailyRate forKey:EmployeesEmpDailyRate];
    [aCoder encodeObject:employeeLName forKey:EmployeesEmpLName];
    [aCoder encodeDouble:employeeBalanceAmount forKey:EmployeesEmpBalance];
    [aCoder encodeDouble:employeePaidAmount forKey:EmployeesEmpPaidUpToCurrentDate];
    [aCoder encodeDouble:syncStatus forKey:EmployeesSyncStatus];
    [aCoder encodeDouble:employeeId forKey:EmployeesEmpId];
    [aCoder encodeDouble:operationId forKey:EmployeesOperationId];
    [aCoder encodeObject:employeeFName forKey:EmployeesEmpFName];
}

@end
