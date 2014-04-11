//
//  EmployeeManager.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 06/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmployeeData.h"
#import "ParsingManager.h"
#import "WebServiceHandler.h"

@class EmployeeManager;

@protocol EmployeeManagerDelegate
- (void) EmployeeManager:(EmployeeManager *)pProfileManager finishedRequestType:(RequestType)pRequestType WithObject:(id)pObject withError:(NSError*)pError;

@end

@interface EmployeeManager : NSObject<WebServiceHandlerDelegate>

@property (nonatomic,retain) NSArray *employeeArray;

@property (nonatomic, retain) id<EmployeeManagerDelegate> delegate;
@property (nonatomic,retain) WebServiceHandler *requestHandler;
@property (nonatomic,retain) ParsingManager *parser;


+(EmployeeManager *) getInstance;
-(void)postSyncData:(NSArray*)empArray withDelegate:(id)pDelegate;
-(BOOL)checkEmpId:(EmployeeData*)emp;
-(void)showMessage:(NSString*)displayMessage;
-(void)performOperationsByEmployee:(NSArray *)empArray;
@end
