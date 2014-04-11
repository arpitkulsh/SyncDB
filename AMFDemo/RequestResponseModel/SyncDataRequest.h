//
//  SyncDataRequest.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 06/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncDataRequest : NSObject

@property (nonatomic,retain) NSArray *employeeArray;
@property (nonatomic,retain) NSString *lastUpdatedTime;

-(SyncDataRequest*)initWithArray:(NSArray*)empArray;
-(NSDictionary*)createDictionary;

@end
