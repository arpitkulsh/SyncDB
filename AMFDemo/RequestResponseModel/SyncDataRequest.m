//
//  SyncDataRequest.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 06/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "SyncDataRequest.h"
#import "EmployeeData.h"

@implementation SyncDataRequest
@synthesize employeeArray;
@synthesize lastUpdatedTime;


// Initialization of request with Array
-(SyncDataRequest*)initWithArray:(NSArray*)empArray
{
    self = [super init];
    if (self)
    {
        self.employeeArray = empArray;
    }
    return self;
}

// Create Dictionay as per required into Post request Body
-(NSDictionary*)createDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
     [dict setObject:[self prepareArray] forKey:@"employees"];
    if ([userDefault objectForKey:@"lastSyncTime"] == nil) 
    {
        [dict setObject:@" " forKey:@"lastSyncTime"];
    }
    else 
    {
        [dict setObject:[userDefault objectForKey:@"lastSyncTime"] forKey:@"lastSyncTime"];
    }
    return dict;
}

// Prepare the array which required into above Dictionary
-(NSArray*)prepareArray
{
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i < [self.employeeArray count]; i++) 
    {
        EmployeeData *employee = [[EmployeeData alloc] initWithLocalDatabse:[self.employeeArray objectAtIndex:i]];
        NSDictionary *dict = [employee dictionaryRepresentation];
        [array addObject:dict];
    }
    
    return array;
}

@end
