//
//  EmployeeData.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeData : NSObject <NSCoding>


+ (EmployeeData *)modelObjectWithDictionary:(NSDictionary *)dict;
+ (EmployeeData *) modelObjectForLocalDict:(NSDictionary *)dict;
-(EmployeeData*)initWithDict:(NSDictionary*)dict;
-(EmployeeData*)initWithLocalDatabse:(NSDictionary*)dict;
- (NSDictionary *)dictionaryRepresentation;
-(NSDictionary*)localDictionaryrepresentation;

@property (nonatomic,assign) int employeeId;
@property (nonatomic,retain) NSString *employeeFName;
@property (nonatomic,retain) NSString *employeeLName;
@property (nonatomic,assign) int employeeDailyRate;
@property (nonatomic,assign) int employeePaidAmount;
@property (nonatomic,assign) int employeeBalanceAmount;
@property (nonatomic,assign) int syncStatus;
@property (nonatomic,assign) int operationId;
@end
