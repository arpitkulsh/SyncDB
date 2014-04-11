//
//  WebServiceHandler.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 03/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"


@class WebServiceHandler;

@protocol WebServiceHandlerDelegate
- (void) webServiceHandler:(WebServiceHandler *)pWebServiceHandler withData:(NSData *)pData withRequestType:(RequestType)pRequestType error:(NSError *)pError withStatusCode:(int)code;
@end

@interface WebServiceHandler : NSObject<HttpRequestDelegate, UIAlertViewDelegate>


{
	
	UIAlertView *mAlertView;
	// the queue to run our Operation
    NSOperationQueue *mQueue;
	id delegate;
	////////////////////////////////////
	NSString *mURL;
	NSData *mData;
	id mParser;
	RequestType mRequestType;
	BOOL AlertVisible;
}

+ (WebServiceHandler *) getInstance;
@property (nonatomic, retain) id <WebServiceHandlerDelegate> mDelegate;
- (NSArray *) requests;

- (void) cancellAllRequest;

-(void)putRequestURL:(NSString *)pURL withBody:(NSString*)pBody requestType:(RequestType)pRequestType withDelegate:(id)pDelegate;

- (void) getRequestURL:(NSString *)pURL delegate:(id)pDelegate requestType:(RequestType)pRequestType;

-(void)postRequestwithHostURL:(NSString *)pHostURL bodyPost:(NSDictionary *)pBodyPost withImageData:(NSData*)image delegate:(id)pDelegate requestType:(RequestType)pRequestType;

- (void) deleteRequestURL:(NSString *)pURL delegate:(id)pDelegate requestType:(RequestType)pRequestType;

- (void) postRequestwithHostURL:(NSString *)pHostURL bodyPost:(NSString *)pBodyPost delegate:(id)pDelegate requestType:(RequestType)pRequestType;


@end
