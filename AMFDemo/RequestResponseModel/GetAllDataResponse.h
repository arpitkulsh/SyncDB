//
//  GetAllDataResponse.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 05/03/14
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAllDataResponse : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *employees;
@property (nonatomic,strong) NSString *lastSyncTime;

+ (GetAllDataResponse *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
