//
//  WebServiceHandler.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 03/03/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//

#import "WebServiceHandler.h"
#import "HttpRequest.h"

@implementation WebServiceHandler
{
    NSMutableDictionary *mDelegateDictionary;
}
@synthesize mDelegate;

static WebServiceHandler *sharedInstance = nil;

#pragma mark DPKRequestHandler singleton class method
+ (WebServiceHandler *) getInstance
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [[self alloc] init];
			
		}
	}
	
	return sharedInstance;
}

+ (id) allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if(sharedInstance == nil)
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id) init
{
	self = [super init];
	
	if (self != nil)
    {
		mQueue = [[NSOperationQueue alloc] init];
		AlertVisible = NO;
        mDelegateDictionary = [NSMutableDictionary dictionary];
        //-- Create new SBJSON parser object
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

#pragma mark RequestMethods
- (NSArray *) requests
{
	return [mQueue operations];
}

- (void) cancellAllRequest
{
	[mQueue cancelAllOperations];
}

#pragma mark -
#pragma mark RequestMethods

// Put Request Architecture
-(void)putRequestURL:(NSString *)pURL withBody:(NSString*)pBody requestType:(RequestType)pRequestType withDelegate:(id)pDelegate
{
    NSString *keyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
    [mDelegateDictionary setObject:pDelegate forKey:keyString];
    
    HttpRequest *networkRequest = [[HttpRequest alloc]initPutRequestWithURL:pURL withBody:pBody requestType:mRequestType httpHeader:@""];
    [networkRequest setDelegate:self];
    [mQueue addOperation:networkRequest];
}

// Get Request Architecture
- (void) getRequestURL:(NSString *)pURL delegate:(id)pDelegate requestType:(RequestType)pRequestType
{

    NSLog(@"url is %@",pURL);
     self.mDelegate = pDelegate;
        if (!mDelegateDictionary)
        {
            mDelegateDictionary = [NSMutableDictionary dictionary];
        }
        
        NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
        id tDelegate = [mDelegateDictionary objectForKey:tKeyString];
        
        if (tDelegate == nil)
        {
            [mDelegateDictionary setObject:pDelegate forKey:tKeyString];
        }
        
		HttpRequest *networkRequest = [[HttpRequest alloc] initGetRequestWithURL:pURL requestType:pRequestType httpHeader:nil];
		networkRequest.delegate = self;
		[mQueue addOperation:networkRequest]; // this will start the "Network Operation"
}

// Delete Request Architecture
- (void) deleteRequestURL:(NSString *)pURL delegate:(id)pDelegate requestType:(RequestType)pRequestType
{
    if (!mDelegateDictionary)
    {
        mDelegateDictionary = [NSMutableDictionary dictionary];
    }
    self.mDelegate = pDelegate;
    
    NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
    id tDelegate = [mDelegateDictionary objectForKey:tKeyString];
    
    if (tDelegate == nil)
    {
        [mDelegateDictionary setObject:pDelegate forKey:tKeyString];
    }

    HttpRequest *networkRequest = [[HttpRequest alloc] initDeleteRequestWithURL:pURL requestType:mRequestType httpHeader:@""];
    networkRequest.delegate = self;
     [mQueue addOperation:networkRequest];
}

// Post Request Architecture without Image
-(void)postRequestwithHostURL:(NSString *)pHostURL bodyPost:(NSDictionary *)pBodyPost withImageData:(NSData*)image delegate:(id)pDelegate requestType:(RequestType)pRequestType

{
    if (!mDelegateDictionary)
    {
        mDelegateDictionary = [NSMutableDictionary dictionary];
    }
    self.mDelegate = pDelegate;
    
    NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
    id tDelegate = [mDelegateDictionary objectForKey:tKeyString];
    
    if (tDelegate == nil)
    {
        [mDelegateDictionary setObject:pDelegate forKey:tKeyString];
    }
    HttpRequest *networkRequest = [[HttpRequest alloc] initPostRequestWithImage:image hostURL:pHostURL bodyPost:pBodyPost requestType:pRequestType httpHeader:nil];
    networkRequest.delegate = self;
    [mQueue addOperation:networkRequest];
}

// Post Request Architecture with Image
- (void) postRequestwithHostURL:(NSString *)pHostURL bodyPost:(NSString *)pBodyPost delegate:(id)pDelegate requestType:(RequestType)pRequestType
{
    NSLog(@"coming string is %@",pBodyPost);
    if (!mDelegateDictionary)
    {
        mDelegateDictionary = [NSMutableDictionary dictionary];
    }
    self.mDelegate = pDelegate;
    
    NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
    id tDelegate = [mDelegateDictionary objectForKey:tKeyString];
    
    if (tDelegate == nil)
    {
        [mDelegateDictionary setObject:pDelegate forKey:tKeyString];
    }
    
    HttpRequest *networkRequest = [[HttpRequest alloc] initPostRequestWithHostURL:pHostURL bodyPost:pBodyPost requestType:pRequestType];
    networkRequest.delegate = self;
    [mQueue addOperation:networkRequest];
}

// Call Back From Httprequest
#pragma mark - http Request Methods
- (void) httpRequest:(HttpRequest *)pRequest requestType:(RequestType)pRequestType error:(NSError *)pError
{
    NSLog(@"RequestType:%d",pRequestType);
    NSString *tKeyString = [NSString stringWithFormat:@"k_Delegate%d", pRequestType];
    self.mDelegate = [mDelegateDictionary objectForKey:tKeyString];
    
    if(!pError)
    {
        [self.mDelegate webServiceHandler:self withData:pRequest.responseData withRequestType:pRequestType  error:nil withStatusCode:pRequest.code];
    }
    else
    {
        [self.mDelegate webServiceHandler:self withData:pRequest.responseData withRequestType:pRequestType  error:pError withStatusCode:pRequest.code];
    }

}

@end

