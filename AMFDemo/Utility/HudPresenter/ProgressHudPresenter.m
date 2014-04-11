//
//  ProgressHudPresenter.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//


#import "ProgressHudPresenter.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation ProgressHudPresenter {
    MBProgressHUD* progressHud;
}

-(id)init
{
    if (self = [super init])
    {
        progressHud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        progressHud.mode = MBProgressHUDModeIndeterminate;


       // progressHud.labelText = NSLocalizedString(@"Loading", @"Loading"); //Default text

    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    progressHud.labelText = title;
}

-(NSString*)title
{
    return progressHud.labelText;
}

-(void)presentHud
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).window addSubview:progressHud];
    [progressHud show:YES];
}

-(void)presentHud:(NSString *)title
{
    progressHud.labelText = NSLocalizedString(title, title);
    [((AppDelegate*)[UIApplication sharedApplication].delegate).window addSubview:progressHud];    
    [progressHud show:YES];
}

-(void)hideHud
{
    [progressHud removeFromSuperview];
    [progressHud hide:YES];
}

@end
