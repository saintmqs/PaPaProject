//
//  HttpRequestManager.h
//  EtuProject
//
//  Created by 黄 时欣 on 13-11-8.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASINetworkQueue.h>
#import <ASIHTTPRequest.h>
#import <ASIFormDataRequest.h>
#import "OFMacro.h"

#define RequestManager ([HttpRequestManager sharedHttpRequestManager])

typedef void (^ RequestManagerBlock) (ASIHTTPRequest *request, BOOL success);
@interface HttpRequestManager : NSObject

								SYNTHESIZE_SINGLETON_FOR_CLASS_H(HttpRequestManager);

// POST
- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict;
- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict url:(NSString *)url;

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict block:(RequestManagerBlock)block;
- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict url:(NSString *)url block:(RequestManagerBlock)block;

// GET
- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url;
- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url block:(RequestManagerBlock)block;
@end

@interface ASIHTTPRequest (Oxygen)

// - (void)setUserInfo:(NSDictionary *)userInfo NS_DEPRECATED_IOS(3_0, 3_0, "Use addUserInfoObject: forKey:");

- (NSDictionary *)paramDictionary;
- (void)addUserInfoObject:(id)obj forKey:(NSString *)key;
- (id)userInfoObjectForKey:(NSString *)key;

@end

