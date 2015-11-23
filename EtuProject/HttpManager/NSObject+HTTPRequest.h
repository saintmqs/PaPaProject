//
//  NSObject+HTTPRequest.h
//  EtuProject
//
//  Created by 黄 时欣 on 13-11-11.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest.h>
#import <ASIFormDataRequest.h>
#import "HttpRequestManager.h"

typedef void (^ RequestCompleteBlock)(ASIHTTPRequest *request, NSDictionary *dict, NSError *error);

@interface NSObject (HTTPRequest)

- (NSString *)requestUUID;
- (void)registerRequestManagerObserver;
- (void)unregisterRequestManagerObserver;

//POST
- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict tag:(NSInteger)tag;
- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict tag:(NSInteger)tag url:(NSString *)url;

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict completeBlock:(RequestCompleteBlock)block;
- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict completeBlock:(RequestCompleteBlock)block url:(NSString *)url;

//GET
- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url tag:(NSInteger)tag;
- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url completeBlock:(RequestCompleteBlock)block;

//CallBack Method
- (void)request:(ASIHTTPRequest *)request failedWithError:(NSError *)error;
- (void)request:(ASIHTTPRequest *)request successedWithDictionary:(NSDictionary *)dict;

@end

