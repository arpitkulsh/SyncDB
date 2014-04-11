//
//  HttpRequest.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 03/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest
@synthesize delegate, responseData,code,imageData,mBodyData,mBodyDict,mAthorizationHeader;

- (id) initGetRequestWithURL:(NSString *)pURL requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader
{
	self = [super init];
    if (self != nil)
    {
		mRequestURL = [[NSURL alloc] initWithString:pURL];
        mRequestType = pRequestType;
        mAthorizationHeader = pAthorizationHeader;
        mHeaderType = kGET;
	}
    return self;
}

-(id)initPostRequestWithImage:(NSData*)image hostURL:(NSString*)pURL bodyPost:(NSDictionary*)pBodyPost requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader
{
    self = [super init];
    if (self != nil)
    {
        mRequestURL = [[NSURL alloc] initWithString:pURL];
        mRequestType = pRequestType;
        mBodyDict = pBodyPost;
        imageData = image;
        mAthorizationHeader = pAthorizationHeader;
        mHeaderType = kPOST;
	}
    return self;
}

- (id) initPostRequestWithHostURL:(NSString *)pURL bodyPost:(NSString *)pBodyPost requestType:(RequestType)pRequestType
{
    self = [super init];
    if (self != nil)
    {
        mRequestURL = [[NSURL alloc] initWithString:pURL];
        NSLog(@"url is %@",mRequestURL);
        mRequestType = pRequestType;
        mBodyData = pBodyPost;
        mHeaderType = kPOST;
	}
    return self;
}
-(id)initPutRequestWithURL:(NSString *)pURL withBody:(NSString *)pBodyData requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader
{
    self = [super init];
    if (self != nil)
    {
        pURL = [pURL stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        mRequestURL = [[NSURL alloc] initWithString:pURL];
        mRequestType = pRequestType;
        mBodyData = pBodyData;
        mAthorizationHeader = pAthorizationHeader;
        mHeaderType = kPUT;
	}
    return self;
}

- (id) initDeleteRequestWithURL:(NSString *)pURL requestType:(RequestType)pRequestType httpHeader:(NSString*)pAthorizationHeader
{
    self = [super init];
    if (self != nil)
    {
        pURL = [pURL stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        mRequestURL = [NSURL URLWithString:pURL];
        mRequestType = pRequestType;
        mAthorizationHeader = pAthorizationHeader;
        mHeaderType = kDELETE;
	}
    return self;
}

// For Handling POST Multipart type HTTP Requests
-(void)sendPostMultipart
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mRequestURL];
    [request setURL:mRequestURL];
    [request setTimeoutInterval:150.0];
    [request setHTTPMethod:@"POST"];
    
    if (mAthorizationHeader != nil)
    {
        // Uncomment this code when ever there is requirment of authorization header 
        
//        NSData* data=[mAthorizationHeader dataUsingEncoding:NSUTF8StringEncoding];
//        NSString *result = [data base64Encoding];
//        NSString *str = [[NSString string] stringByAppendingFormat:@"Basic %@",result];
//        [request setValue:str forHTTPHeaderField:@"Authorization"];
        
        // ----------------------------------------------------------------------------
    }
    
    NSString *stringBoundary = @"ImageBoundray";
    
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data;charset=UTF-8; boundary=%@",stringBoundary];
    // set header
    [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    // create data
    NSMutableData *postBody = [NSMutableData data];
    
    NSArray *keys = [mBodyDict allKeys];
    NSLog(@"%@",keys);
    for (int i = 0; i < [keys count]; i++)
    {
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@",[keys objectAtIndex:i]);
        
        if ([[mBodyDict valueForKey:[keys objectAtIndex:i]] isKindOfClass:[NSArray class]] ) 
        {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[mBodyDict valueForKey:[keys objectAtIndex:i]]];
        [postBody appendData:data];
        }
        else
        {
           [postBody appendData:[[mBodyDict valueForKey:[keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    if (imageData)
    {
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"photo\";filename=\"FileName.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[NSData dataWithData:imageData]];
    }
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    NSString *str = [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    NSError *error;
    NSHTTPURLResponse *response = nil;
    self.responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSLog(@"status code is %d",[response statusCode]);
    
    NSString* newStr = [[NSString alloc] initWithData: self.responseData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",newStr);
    code = [response statusCode];
    if(!error)
    {
        [delegate httpRequest:self requestType:mRequestType error:nil];
    }
    else
    {
        [delegate httpRequest:self requestType:mRequestType error:error];
    }
}

// For Handling GET type HTTP Requests
-(void)sendGetData
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mRequestURL];
    [request setURL:mRequestURL];
    [request setTimeoutInterval:150.0];
    [request setHTTPMethod:@"GET"];
    
    if (mAthorizationHeader != nil)
    {
        // Uncomment this code when ever there is requirment of authorization header 
        
        //        NSData* data=[mAthorizationHeader dataUsingEncoding:NSUTF8StringEncoding];
        //        NSString *result = [data base64Encoding];
        //        NSString *str = [[NSString string] stringByAppendingFormat:@"Basic %@",result];
        //        [request setValue:str forHTTPHeaderField:@"Authorization"];
        
        // ----------------------------------------------------------------------------

    }

    NSError *error;
    NSHTTPURLResponse *response;
    responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"string %@",myString);
    
    code = [response statusCode];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if(!error)
    {
        [delegate httpRequest:self requestType:mRequestType error:nil];
    }
    else
    {
        [delegate httpRequest:self requestType:mRequestType error:error];
    }
}

// For Handling POST type HTTP Requests
- (void) sendPostData
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mRequestURL];
    [request setURL:mRequestURL];
    NSLog(@"URL --->%@",mRequestURL);
	NSString *postLength = [NSString stringWithFormat:@"%d", [mBodyData length]];
    [request setTimeoutInterval:20.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSError *error;
    
    //Prepare convert to json string
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:mBodyDict options:0 error:&error];
    NSLog(@"Dictionary--->%@",mBodyDict);
    NSString *requestString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSLog(@"Bosy data --> %@",requestString);

    [request setHTTPBody:bodyData];

    NSURLResponse *response;
    self.responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *dataString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response -> %@",dataString);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    if(!error)
    {
         [delegate httpRequest:self requestType:mRequestType error:nil]; 
    }
    else
    {
       [delegate httpRequest:self requestType:mRequestType error:error];
    }
    
}

// For Handling PUT type HTTP Requests
-(void)sendPutData
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mRequestURL];
    [request setURL:mRequestURL];
    [request setTimeoutInterval:150.0];
    [request setHTTPMethod:@"PUT"];
    
    if (mAthorizationHeader != nil)
    {
        // Uncomment this code when ever there is requirment of authorization header 
        
        //        NSData* data=[mAthorizationHeader dataUsingEncoding:NSUTF8StringEncoding];
        //        NSString *result = [data base64Encoding];
        //        NSString *str = [[NSString string] stringByAppendingFormat:@"Basic %@",result];
        //        [request setValue:str forHTTPHeaderField:@"Authorization"];
        
        // ----------------------------------------------------------------------------
    }
    
    //checking for body
    if (mBodyData)
    {
        [request setHTTPBody:[mBodyData dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    
    NSError *error;
    NSHTTPURLResponse *response;
    responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@" status code for requestType %d %d", mRequestType, [response statusCode]);
    code = [response statusCode];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    if(!error)
    {
        [delegate httpRequest:self requestType:mRequestType error:nil];
    }
    else
    {
        [delegate httpRequest:self requestType:mRequestType error:error];
    }
    
}

// For Handling DELETE type HTTP Requests
-(void)sendDeleteData
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mRequestURL];
    [request setURL:mRequestURL];
    [request setTimeoutInterval:150.0];
    [request setHTTPMethod:@"DELETE"];
    
    if (mAthorizationHeader != nil)
    {
        // Uncomment this code when ever there is requirment of authorization header 
        
        //        NSData* data=[mAthorizationHeader dataUsingEncoding:NSUTF8StringEncoding];
        //        NSString *result = [data base64Encoding];
        //        NSString *str = [[NSString string] stringByAppendingFormat:@"Basic %@",result];
        //        [request setValue:str forHTTPHeaderField:@"Authorization"];
        
        // ----------------------------------------------------------------------------

    }

    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSError *error;
    NSHTTPURLResponse *response = nil;
    self.responseData = (NSMutableData *)[NSURLConnection sendSynchronousRequest:request
                                                               returningResponse:&response
                                                                           error:&error];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString* newStr = [[NSString alloc] initWithData: self.responseData
                                             encoding: NSUTF8StringEncoding];
    NSLog(@"data is %@",newStr);
    code = [response statusCode];
    if(!error)
    {
        [delegate httpRequest:self requestType:mRequestType error:nil];
    }
    else
    {
        [delegate httpRequest:self requestType:mRequestType error:error];
    }
    
}

- (void) main
{
	@autoreleasepool
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        switch (mHeaderType) {
            case kGET:
                [self sendGetData];
                break;
            case kPOST:
                [self sendPostData];
                break;
            case kPUT:
                [self sendPutData];
                break;
            case kDELETE:
                [self sendDeleteData];
                break;
            default:
                break;
        }
    }
}
@end
