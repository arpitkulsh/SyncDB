//
//  GetAllDataResponse.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 05/03/14
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "GetAllDataResponse.h"
#import "EmployeeData.h"


NSString *const kGetAllDataResponseEmployees = @"employees";
NSString *const kGetAllDataResponseLastSyncTime = @"lastSyncTime";

@interface GetAllDataResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetAllDataResponse

@synthesize employees = _employees;

@synthesize lastSyncTime = _lastSyncTime;

// GetAllDataResponse works as Model for Response comes from remote server
// Used Singleton pattern and delegation pattern of iOS programming

+ (GetAllDataResponse *)modelObjectWithDictionary:(NSDictionary *)dict
{
    GetAllDataResponse *instance = [[GetAllDataResponse alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedEmployees = [dict objectForKey:kGetAllDataResponseEmployees];
    NSMutableArray *parsedEmployees = [NSMutableArray array];
    if ([receivedEmployees isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedEmployees) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedEmployees addObject:[EmployeeData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedEmployees isKindOfClass:[NSDictionary class]]) {
       [parsedEmployees addObject:[EmployeeData modelObjectWithDictionary:(NSDictionary *)receivedEmployees]];
    }

    self.employees = [NSArray arrayWithArray:parsedEmployees];
    self.lastSyncTime = [dict objectForKey:kGetAllDataResponseLastSyncTime];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
NSMutableArray *tempArrayForEmployees = [NSMutableArray array];
    for (NSObject *subArrayObject in self.employees) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEmployees addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEmployees addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEmployees] forKey:@"kGetAllDataResponseEmployees"];
    [mutableDict setValue:self.lastSyncTime forKey:@"kGetAllDataResponseLastSyncTime"];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

// Check for key value null or not
#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.employees = [aDecoder decodeObjectForKey:kGetAllDataResponseEmployees];
    self.lastSyncTime = [aDecoder decodeObjectForKey:kGetAllDataResponseLastSyncTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_employees forKey:kGetAllDataResponseEmployees];
    [aCoder encodeObject:_lastSyncTime forKey:kGetAllDataResponseLastSyncTime];
}


@end
