//
//  HttpRequest.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 03/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HttpRequest;
@protocol HttpRequestDelegate
- (void) httpRequest:(HttpRequest *)pRequest requestType:(RequestType)pRequestType error:(NSError *)pError;
@end

@interface HttpRequest : NSOperation
{
    
	NSURL *mRequestURL;
    NSDictionary *mBodyDict;
    NSString *mBodyData;
    NSData *imageData;
	RequestType mRequestType;
    HttpHeaderType mHeaderType;
    NSString *mAthorizationHeader;
}

@property (nonatomic, retain) id <HttpRequestDelegate> delegate;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic,assign) int code;
@property (nonatomic,retain) NSData *imageData;
@property (nonatomic,retain) NSString *mBodyData;
@property (nonatomic,retain) NSDictionary *mBodyDict;
@property (nonatomic,retain) NSString *mAthorizationHeader;


- (id) initGetRequestWithURL:(NSString *)pURL requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader;
-(id)initPostRequestWithImage:(NSData*)image hostURL:(NSString*)pURL bodyPost:(NSDictionary*)pBodyPost requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader;
-(id)initPutRequestWithURL:(NSString *)pURL withBody:(NSString *)pBodyData requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader;
- (id) initDeleteRequestWithURL:(NSString *)pURL requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader;
- (id) initPostRequestWithHostURL:(NSString *)pURL bodyPost:(NSString *)pBodyPost requestType:(RequestType)pRequestType;
@end
