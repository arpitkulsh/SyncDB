//
//  ViewController.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "ViewController.h"
#import "UpdateRecordViewController.h"
#import "AddRecordViewController.h"
#import "DBManager.h"
#import "EmployeeData.h"
#import "GetAllDataResponse.h"
#import "SQLQueryManager.h"
#import "EmployeeManager.h"
#import "Reachability.h"
#import "CustomMessage.h"
#import "ProgressHudPresenter.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    ProgressHudPresenter *mHudPresenter;
    UIActionSheet *actionSheet;
    UIPickerView *pickerForFontSize;
    NSArray *sizeArray;
    UIBarButtonItem *rightbarButton1,*leftbarButton,*rightbarButton;
    BOOL isFirstLoad;
}

@property (strong,nonatomic) NSArray *jsonArray;
@end


@implementation ViewController
@synthesize employeeList;
@synthesize jsonArray;

// It loads the view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Allocations
     
    sizeArray=[[NSArray alloc] initWithObjects:@"Auto Sync",@"Manual Sync",nil];
    
    // Left Bar Button
    leftbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEmployee)];
    self.navigationItem.leftBarButtonItem = leftbarButton;
    // Right Bar Button
    rightbarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(syncDataFromServer)];
    
    isFirstLoad = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    // it take out the data from loacl Database and loads it into user interface table
    [self updateTableWithData];
}
- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self setEmployeeList:nil];
    [super viewDidUnload];
    
}

-(void)viewDidAppear:(BOOL)animated
{
  mHudPresenter = [[ProgressHudPresenter alloc]init];
    // Shared Default For "Sync" key
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([userDefault objectForKey:@"sync"] == nil) 
    {
        [userDefault setObject:@"auto" forKey:@"sync"];
        rightbarButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Auto" style:UIBarButtonItemStylePlain target:self action:@selector(changeSyncing)];
        if (isFirstLoad) 
        {
            [self syncDataFromServer];
            isFirstLoad  = NO;
        }
        // Web Service Hit to Sync From the remote Server
    }
    else
    {
        if ([[userDefault objectForKey:@"sync"] isEqualToString:@"auto"]) 
        {
            if (isFirstLoad) 
            {
                [self syncDataFromServer];
                isFirstLoad  = NO;
            }
            
            rightbarButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Auto" style:UIBarButtonItemStylePlain target:self action:@selector(changeSyncing)];
            
        }
        else 
        {
            rightbarButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Manual" style:UIBarButtonItemStylePlain target:self action:@selector(changeSyncing)];
            
        }
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightbarButton1, rightbarButton, nil]];   
    // Right Bar Button
    

	//Initiallize pickerview in actionsheet with done button
	actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
											  delegate:nil
									 cancelButtonTitle:nil
								destructiveButtonTitle:nil
									 otherButtonTitles:nil];
	
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	pickerForFontSize = [[UIPickerView alloc] initWithFrame:pickerFrame];
	pickerForFontSize.showsSelectionIndicator = YES;
    
    ///set the current selected value
	pickerForFontSize.dataSource = self;
	pickerForFontSize.delegate = self;
	[actionSheet addSubview:pickerForFontSize];
    
    // Initialize UISegmentControl for Done Button
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
	closeButton.momentary = YES; 
	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	closeButton.tintColor = [UIColor blackColor];
	[closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
	[actionSheet addSubview:closeButton];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

// it take out the data from local Database and loads it into user interface table
-(void)updateTableWithData
{
    DBManager *db = [DBManager getSharedInstance];
    jsonArray =[db getAllRecords:@"Employee"];   
    
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.employeeList reloadData];
    });
}

// Check internet reachability
-(BOOL)reachable {
    Reachability *r = [Reachability sharedReachability];
    NetworkStatus internetStatus = [r internetConnectionStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

// Navigate to "AddRecordViewController" controller
-(void)addEmployee
{
    AddRecordViewController *addController = [self.storyboard instantiateViewControllerWithIdentifier:@"addRecord"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentViewController:navController animated:YES completion:nil];
}
// Web service call for Syncing data from server
-(void)syncDataFromServer
{ 
    SQLQueryManager *sql = [[SQLQueryManager alloc] init];
    
    NSArray *array = [sql getRecordsOnEmpId];
    
    if ([self reachable]) 
    {
        [mHudPresenter presentHud:@"Getting Data"];
        // Call to EmployeeManager for Web Service Request
        [[EmployeeManager getInstance] postSyncData:array withDelegate:self];
    }
    else 
    {
         // Show Alert Message
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Application unable to connect with remote server. Please check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
// Change of Sync value "auto" / "manual"
- (void)changeSyncing 
{
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
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
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jsonArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [jsonArray objectAtIndex:indexPath.row];
    
    EmployeeData *data = [[EmployeeData alloc] initWithLocalDatabse:dict]; // Instance of Employee Model
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",data.employeeFName,data.employeeLName];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateRecordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"updateRecord"];
    NSDictionary *dict = [jsonArray objectAtIndex:indexPath.row];
  
   EmployeeData *emp = [[EmployeeData alloc] initWithLocalDatabse:dict];
    controller.employee = emp;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];

}

// Call for dismiss hud
-(void)dismissHud
{
  [mHudPresenter hideHud];
}

// Show Message "Updating Server"
-(void)showMessage
{
    CustomMessage *message = [[CustomMessage alloc] init];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:[message showmessage:@"Updated from Server" delay:2 lYAxis:200] atIndex:1];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Call Back Method from EmployeeManager

#pragma mark EmployeeManger Delegate

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
                [self performSelectorOnMainThread:@selector(updateTableWithData) withObject:nil waitUntilDone:NO];
            } 
        }
    }
    else
    {
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


#pragma mark UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [sizeArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
	
    return [sizeArray objectAtIndex:row];
}
// When selects picker row
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (row == 0)
    {   // Select as Auto
        [userDefault setObject:@"auto" forKey:@"sync"];
        [rightbarButton1 setTitle:@"Auto"];
    }
    else
    {
        // Select as Manual
        [userDefault setObject:@"manual" forKey:@"sync"];
        [rightbarButton1 setTitle:@"Manual"];
    }
}

@end
