//
//  AddRecordViewController.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "AddRecordViewController.h"
#import "EmployeeData.h"
#import "SQLQueryManager.h"
#import "Reachability.h"
#import "EmployeeManager.h"
#import "GetAllDataResponse.h"
#import "CustomMessage.h"
#import "ProgressHudPresenter.h"

@interface AddRecordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    ProgressHudPresenter *mHudPresenter;
    UIActionSheet *actionSheet;
    UIPickerView *pickerForFontSize;
    NSArray *sizeArray;
}

@property (weak, nonatomic) IBOutlet UITextField *empIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *empFirstName;
@property (weak, nonatomic) IBOutlet UITextField *empLastName;

@property (weak, nonatomic) IBOutlet UITextField *empDailyRate;

@property (weak, nonatomic) IBOutlet UITextField *empPaidUpto;
@property (weak, nonatomic) IBOutlet UITextField *empBalance;
@property(nonatomic,retain) IBOutlet UIScrollView *scroller;

- (IBAction)addRecord:(id)sender;


@property (strong,nonatomic) EmployeeData *employee;

@end

@implementation AddRecordViewController
@synthesize empIdTextField;
@synthesize empFirstName;
@synthesize empLastName;
@synthesize empDailyRate;
@synthesize empPaidUpto;
@synthesize empBalance;
@synthesize employee;
@synthesize scroller;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Allocations
    mHudPresenter = [[ProgressHudPresenter alloc] init];
    employee = [[EmployeeData alloc] init];
    
    // Left bar Button
    UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dissMissController)];
    self.navigationItem.leftBarButtonItem = leftbarButton;
    
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
- (void)viewDidUnload
{
    [self setEmpIdTextField:nil];
    [self setEmpFirstName:nil];
    [self setEmpLastName:nil];
    [self setEmpDailyRate:nil];
    [self setEmpPaidUpto:nil];
    [self setEmpBalance:nil];
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// Called for dismiss controller
-(void)dissMissController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
        [self.scroller setFrame:CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y - 45.0f, self.scroller.frame.size.width, self.scroller.frame.size.height)];
        [UIView commitAnimations];
    }
    else if (textField.tag == 1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scroller setFrame:CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y, self.scroller.frame.size.width, self.scroller.frame.size.height)];
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

// Check reachability for internet connection
-(BOOL)reachable 
{
    Reachability *r = [Reachability sharedReachability];
    NetworkStatus internetStatus = [r internetConnectionStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
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

// Called When user clicks on ADD Button
- (IBAction)addRecord:(id)sender
{
    if (![empIdTextField.text isEqualToString:@""]&&![empFirstName.text isEqualToString:@""]&&![empLastName.text isEqualToString:@""]&&![empDailyRate.text isEqualToString:@""]&&![empBalance.text isEqualToString:@""]&&![empPaidUpto.text isEqualToString:@""]) 
    {
        employee.employeeId = [[NSString stringWithFormat:@"%@",empIdTextField.text] intValue];
        employee.employeeFName = [NSString stringWithFormat:@"%@",empFirstName.text];
        employee.employeeLName = [NSString stringWithFormat:@"%@",empLastName.text];
        employee.employeeBalanceAmount = [[NSString stringWithFormat:@"%@",empBalance.text] intValue];
        employee.employeeDailyRate = [[NSString stringWithFormat:@"%@",empDailyRate.text] intValue];
        employee.employeePaidAmount = [[NSString stringWithFormat:@"%@",empPaidUpto.text] intValue];
        employee.syncStatus = 0;
        employee.operationId = Add;
        
        if ([[EmployeeManager getInstance] checkEmpId:employee])
        {
            NSString * strMessage = [NSString stringWithFormat:@"Employee Id %d already exist",employee.employeeId];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record Exist" message:strMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else 
        {
            SQLQueryManager *sql = [[SQLQueryManager alloc] init];
            
            if ([sql addRecordInTable:employee]) 
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
                    [self performSelectorOnMainThread:@selector(showMessage) withObject:nil waitUntilDone:NO];
                }
            }
            else 
            {
                // Show Alert to user
            }
        }
    }
    else 
    {
        // Show Alert to user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Fill All Details" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// Dismiss Hud
-(void)dismissHud
{
    [mHudPresenter hideHud];
}

// Show Custom Message for Different Operations
-(void)showMessage
{
    CustomMessage *message = [[CustomMessage alloc] init];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:[message showmessage:@"Record Added" delay:2 lYAxis:200] atIndex:1];
    
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
                NSMutableArray * responseArray = [NSMutableArray arrayWithArray:getData.employees];
                
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
