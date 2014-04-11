//
//  CustomMessage.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 26/02/14.
//	Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "CustomMessage.h"
@implementation CustomMessage

-(void)show:(NSString *)msg inView:(UIView *) parentView delay:(int)loDelay lYAxis:(int)loY
{

		CGSize loSize=[msg sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f] constrainedToSize:CGSizeMake(200,50)];
		float start=(300-loSize.width)/2;

		self.frame=CGRectMake(start,loY,loSize.width+10, loSize.height+6);
         // Create a view. Put a label, set the msg
		UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(2,2,loSize.width,loSize.height)];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
		lblTitle.textColor = [UIColor whiteColor];
		lblTitle.textAlignment = UITextAlignmentCenter;
		lblTitle.text = msg;
		lblTitle.backgroundColor = [UIColor clearColor];
		[self addSubview:lblTitle];
		CALayer *layer = self.layer;
		layer.cornerRadius = 12.0f;
	     self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f];
	    [parentView addSubview:self];
		[self performSelector:@selector(dismiss:) withObject:nil afterDelay:loDelay];
		[self setAutoresizesSubviews:TRUE];

}

-(CustomMessage*)showmessage:(NSString*)msg delay:(int)loDelay lYAxis:(int)loY
{
    CGSize loSize=[msg sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f] constrainedToSize:CGSizeMake(200,50)];
    float start=(300-loSize.width)/2;
    
    self.frame=CGRectMake(start,loY,loSize.width+10, loSize.height+6);
    // Create a view. Put a label, set the msg
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(2,2,loSize.width,loSize.height)];
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = UITextAlignmentCenter;
    lblTitle.text = msg;
    lblTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:lblTitle];
    CALayer *layer = self.layer;
    layer.cornerRadius = 12.0f;
    self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f];
    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:loDelay];
    [self setAutoresizesSubviews:TRUE];
    return self;
}
- (void)dismiss:(id)sender {
    // Fade out the message and destroy self
    [UIView animateWithDuration:0.5 
					 animations:^  { self.alpha = 0; }
					 completion:^ (BOOL finished) { [self removeFromSuperview]; }];
}

@end
