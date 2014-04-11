//
//  ProgressHudPresenter.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ProgressHudPresenter : NSObject

@property(nonatomic, retain) NSString* title;

-(void)presentHud;

-(void)hideHud;
-(void)presentHud:(NSString *)title;

@end
