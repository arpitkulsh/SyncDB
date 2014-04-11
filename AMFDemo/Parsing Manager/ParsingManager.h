//
//  ParsingManager.h
//  AMFDemo
//
//  Created by Arpit Kulshrestha on 27/02/14.
//  Copyright (c) 2014 NTT Data. All rights reserved.
//


#import <Foundation/Foundation.h>


@class ParsingManager;
@protocol ParsingManagerDelegate
- (void) parsingHandler:(ParsingManager *)pParsingHandler withRequestType:(NSInteger)pRequestType error:(NSError *)pError;
@end


@interface ParsingManager : NSObject

@property (nonatomic, retain) id <ParsingManagerDelegate> mDelegate;
+ (ParsingManager *) getInstance;

-(id) parseJsonFromWebService:(NSData *)pResponseData withRequestType:(RequestType)pRequestType withStatusCode:(int)code error:(NSError **)pError;

@end
