//
//  UpdateRecordViewController.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "UpdateRecordViewController.h"
#import "SQLQueryManager.h"
#import "Reachability.h"
#import "EmployeeManager.h"
#import "GetAllDataResponse.h"
#import "CustomMessage.h"
#import "ProgressHudPresenter.h"

@interface UpdateRecordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    ProgressHudPresenter *mHudPresenter;
    UIActionSheet *actionSheet;
	UIPickerView *pickerForFontSize;
    NSArray *sizeArray;
}
@property (weak, nonatomic) IBOutlet UITextField *updateEmpId;
@property (weak, nonatomic) IBOutlet UITextField *upadteEmpFname;
@property (weak, nonatomic) IBOutlet UITextField *updateLname;
@property (weak, nonatomic) IBOutlet UITextField *empDailyRate;
@property (weak, nonatomic) IBOutlet UITextField *upadetPaidUptoCurrent;
@property (weak, nonatomic) IBOutlet UITextField *updateEmpBalance;
@property(nonatomic,retain) IBOutlet UIScrollView *scroller;

@property (nonatomic,retain) NSString *printMessage;
- (IBAction)updateRecords:(id)sender;
- (IBAction)deleteRecords:(id)sender;

@end

@implementation UpdateRecordViewController
@synthesize updateEmpId;
@synthesize upadteEmpFname;
@synthesize updateLname;
@synthesize empDailyRate;
@synthesize upadetPaidUptoCurrent;
@synthesize updateEmpBalance;
@synthesize employee;
@synthesize scroller;

@synthesize printMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Load the view and intializations
- (void)viewDidLoad
{
    [super viewDidLoad];
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    
    // Left bar Button
    UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dissMissController)];
    self.navigationItem.leftBarButtonItem = leftbarButton;
    
    //Filling of UI at the time of loading
    updateEmpId.text =[NSString stringWithFormat:@"%d",employee.employeeId];
    upadteEmpFname.text = [NSString stringWithFormat:@"%@",employee.employeeFName];
    updateLname.text = [NSString stringWithFormat:@"%@", employee.employeeLName];
    empDailyRate.text = [NSString stringWithFormat:@"%d",employee.employeeDailyRate];
    upadetPaidUptoCurrent.text = [NSString stringWithFormat:@"%d",employee.employeePaidAmount];
    updateEmpBalance.text = [NSString stringWithFormat:@"%d",employee.employeeBalanceAmount];
    
    // Do any additional setup after loading the view.
}

// Called when Done button action called for dissmiss actionSheet
-(void)dismissActionSheet:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"sync"] isEqualToString:@"manual"]) 
    {
        [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
    }
    else 
    {
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
	
}

// Dismiss Controller
-(void)dissMissController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [self setUpdateEmpId:nil];
    [self setUpadteEmpFname:nil];
    [self setUpdateLname:nil];
    [self setEmpDailyRate:nil];
    [self setUpadetPaidUptoCurrent:nil];
    [self setUpdateEmpBalance:nil];
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Dismiss Hud
-(void)dismissHud
{
    [mHudPresenter hideHud];
}

// When User Clicks on Update Button
- (IBAction)updateRecords:(id)sender
{
    if (![updateEmpId.text isEqualToString:@""]&&![upadteEmpFname.text isEqualToString:@""]&&![updateLname.text isEqualToString:@""]&&![empDailyRate.text isEqualToString:@""]&&![updateEmpBalance.text isEqualToString:@""]&&![upadetPaidUptoCurrent.text isEqualToString:@""]) 
    {
        employee.employeeFName = [NSString stringWithFormat:@"%@",  upadteEmpFname.text];
        employee.employeeLName = [NSString stringWithFormat:@"%@", updateLname.text ];
        employee.employeeDailyRate= [[NSString stringWithFormat:@"%@", empDailyRate.text] intValue];
        employee.employeePaidAmount= [[NSString stringWithFormat:@"%@", upadetPaidUptoCurrent.text] intValue];
        employee.employeeBalanceAmount = [[NSString stringWithFormat:@"%@", updateEmpBalance.text] intValue];
        employee.operationId = Update;
        employee.syncStatus = 0;
        printMessage = @"Record Updated";
        SQLQueryManager *sql = [[SQLQueryManager alloc] init];
        
        if ([sql updateRecordIntable:employee]) 
        {
            NSArray *array = [sql getRecordsOnEmpId];
            
            if ([self reachable]) 
            {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                
                if ([[userDefault objectForKey:@"sync"] isEqualToString:@"manual"]) 
                {
                    [self dismissModalViewControllerAnimated:YES];
                }
                else 
                {
                    [mHudPresenter presentHud:@"Updating server"];
                    [[EmployeeManager getInstance] postSyncData:array withDelegate:self];
                }
                
            }
            else 
            {
                [self dismissModalViewControllerAnimated:YES];
            }
        }
        else 
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else 
    {
        // Show alert to user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Fill All Details" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// Check of Internet Connection
-(BOOL)reachable 
{
    Reachability *r = [Reachability sharedReachability];
    NetworkStatus internetStatus = [r internetConnectionStatus];
    if(internetStatus == NotReachable)
    {
        return NO;
    }
    return YES;
}

// Called when User presses Delete button
- (IBAction)deleteRecords:(id)sender 
{
    employee.operationId = Delete;
    employee.syncStatus = 0;
    SQLQueryManager *sql = [[SQLQueryManager alloc] init];
    printMessage = @"Record Deleted";
    
    if ([sql updateRecordIntable:employee]) 
    {
        NSArray *array = [sql getRecordsOnEmpId];
        
        if ([self reachable]) 
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            if ([[userDefault objectForKey:@"sync"] isEqualToString:@"manual"]) 
            {
                [self dismissModalViewControllerAnimated:YES];
            }
            else 
            {
                [mHudPresenter presentHud:@"Updating server"];
                [[EmployeeManager getInstance] postSyncData:array withDelegate:self];
            }
            
        }
        else 
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else 
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark UITextField Delegate
// Called when needs to move upward the scroller
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 3)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scroller setFrame:CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y - 45.0f, self.scroller.frame.size.width, self.scroller.frame.size.height)];
        [UIView commitAnimations];
    }
    else if(textField.tag == 4)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scroller setFrame:CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y - 90.0f, self.scroller.frame.size.width, self.scroller.frame.size.height)];
        [UIView commitAnimations];
    }
    else 
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scroller setFrame:CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y - 25.0f, self.scroller.frame.size.width, self.scroller.frame.size.height)];
        [UIView commitAnimations];
    }
}

// Event on next button of Keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scroller setFrame:CGRectMake(0,0, self.scroller.frame.size.width, self.scroller.frame.size.height)];
        [UIView commitAnimations];
	}
	return NO;
}



// Show Custom Message for Different Operations
-(void)showMessage
{
    CustomMessage *message = [[CustomMessage alloc] init];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:[message showmessage:printMessage delay:2 lYAxis:200] atIndex:1];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Call Back from EmployeeManager
#pragma mark EmployeeManager Delegate
- (void) EmployeeManager:(EmployeeManager *)pProfileManager finishedRequestType:(RequestType)pRequestType WithObject:(id)pObject withError:(NSError*)pError;
{
    if (!pError) {
        
        switch (pRequestType) {
                
            case kPostSyncRequest:
            {                
                GetAllDataResponse *getData = [GetAllDataResponse modelObjectWithDictionary:(NSDictionary*)pObject];
                NSArray * responseArray = [NSArray arrayWithArray:getData.employees];
                
                // Setup "lastSyncTime" in Shared Preference so can be used in next Web Service hit
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:getData.lastSyncTime forKey:@"lastSyncTime"];
                
                // Performs Database operations as per the operationsId get from the server for respective records
                [[EmployeeManager getInstance] performOperationsByEmployee:responseArray];
                
                // Call for dissmiss hud
                [self performSelectorOnMainThread:@selector(dismissHud) withObject:nil waitUntilDone:NO];
                
                // Call For UI Update
                [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO];

            } 
        }
    }
    else
    {
        
        // Web Service failed to get response from remote server
        switch (pRequestType) 
        {
            case kPostSyncRequest:
            {
                // Call for dissmiss hud
                [self performSelectorOnMainThread:@selector(dismissHud) withObject:nil waitUntilDone:NO];
            }
                
        }
        
    }
}

@end
