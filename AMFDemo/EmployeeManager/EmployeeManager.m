//
//  EmployeeManager.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 06/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "EmployeeManager.h"
#import "DBManager.h"
#import "EmployeeData.h"
#import "GetAllDataResponse.h"
#import "SQLQueryManager.h"

#import "SyncDataRequest.h"
#import "CustomMessage.h"

@implementation EmployeeManager
{
    NSMutableDictionary *mDelegateDictionary;
}
@synthesize delegate,requestHandler,parser;
@synthesize employeeArray;

static EmployeeManager *sharedInstance = nil;

// EmployeeManager used for the purpose of handling all services of Employee Database
// Used Singleton pattern and delegation pattern of iOS programming

#pragma mark LocationMannager singleton class method

+ (EmployeeManager *) getInstance
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [[self alloc] init];
            sharedInstance.parser = [ParsingManager getInstance];
            sharedInstance.requestHandler = [WebServiceHandler getInstance];
            [sharedInstance prepareManager];
		}
	}
	return sharedInstance;
}

-(void)prepareManager
{
    mDelegateDictionary = [NSMutableDictionary dictionary];
}

// Make Call to WebServiceHandler for the purpose of making sync request  
-(void)postSyncData:(NSArray*)empArray withDelegate:(id)pDelegate
{
    NSString *keyString = [NSString stringWithFormat:@"k_Delegate%d", kPostSyncRequest];
    [mDelegateDictionary setValue:pDelegate forKey:keyString];
    
    SyncDataRequest *request = [[SyncDataRequest alloc] initWithArray:empArray];
    
    [[WebServiceHandler getInstance ] postRequestwithHostURL:kServerURL
                                                    bodyPost:[request createDictionary]
                                               withImageData:nil
                                                    delegate:self
                                                 requestType:kPostSyncRequest];
}

// Show alert message
-(void)showMessage:(NSString*)displayMessage
{
    CustomMessage *message = [[CustomMessage alloc] init];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:[message showmessage:displayMessage delay:2 lYAxis:200] atIndex:1];
}

// Check that given employee id is already exist or not
-(BOOL)checkEmpId:(EmployeeData*)emp 
{
    NSDictionary *dict = [emp dictionaryRepresentation];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Employee WHERE empId = %@",[dict objectForKey:@"employeeId"]];
    NSArray *empArray =[[DBManager getSharedInstance] searchDatabase:query];
    if ([empArray count] == 0) 
    {
        return NO;
    }
    
    return YES;
}

// Whenever application gets the response from server, It will perform operation as implemented here
// On the basis of OperationId

-(void)performOperationsByEmployee:(NSArray *)empArray
{
    SQLQueryManager *sql = [[SQLQueryManager alloc] init];
    for (int i=0; i < [empArray count]; i++) 
    {
        EmployeeData *emp = [empArray objectAtIndex:i];
        if ([[EmployeeManager getInstance] checkEmpId:emp]) 
        {
            if([sql deleteRecordFromtable:emp])
            {
                
            }
            else 
            {
            }
        }
        
        if (emp.operationId != Delete) 
        {
            if ([sql addRecordInTable:emp])
            {
                
            }
            else 
            {
                
            }
        }
    }
}

// Call Back from WebService Handler
#pragma mark - WebService Handler Delegate
-(void)webServiceHandler:(WebServiceHandler *)pWebServiceHandler withData:(NSData *)pData withRequestType:(RequestType)pRequestType error:(NSError *)pError withStatusCode:(int)code
{
    id object;
    NSString *keyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
    delegate = [mDelegateDictionary objectForKey:keyString];
    
    if (!pError)
    {
        NSError *error;
        object = [self.parser parseJsonFromWebService:pData withRequestType:pRequestType withStatusCode:code error:&error];
        [delegate EmployeeManager:self finishedRequestType:pRequestType WithObject:object withError:error];
    }
    else
    {
        [delegate EmployeeManager:self finishedRequestType:pRequestType WithObject:object withError:pError];
    }
    
}
@end
