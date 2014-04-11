//
//  CustomMessage.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CustomMessage : UIView {

}
-(void)show:(NSString *)msg inView:(UIView *) parentView delay:(int)loDelay lYAxis:(int)loY;
-(CustomMessage*)showmessage:(NSString*)msg delay:(int)loDelay lYAxis:(int)loY;
- (void)dismiss:(id)sender;
@end