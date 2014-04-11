//
//  ParsingManager.m
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 27/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//


#import "ParsingManager.h"
#import "GetAllDataResponse.h"
#import "SyncDataRequest.h"


@implementation ParsingManager
@synthesize mDelegate;
static ParsingManager *sharedInstance = nil;

/*
 * ParsingManager manager singleton instance method
 */

+ (ParsingManager *) getInstance
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

// Handling parsing for disfferent WebService Requests
-(id) parseJsonFromWebService:(NSData *)pResponseData withRequestType:(RequestType)pRequestType withStatusCode:(int)code error:(NSError **)pError
{
    NSError *parsingError;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:pResponseData options:NSJSONReadingAllowFragments error:&parsingError];
    id responseObject;
   
    
    switch (pRequestType) 
    {
        case kPostSyncRequest:
        {
            NSDictionary *response = [dict objectForKey:@"data"];
            responseObject = response;
        }
            break;
        default:
            break;
    }
    return responseObject;
}
@end
