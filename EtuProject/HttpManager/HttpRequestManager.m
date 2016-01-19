//
//  HttpRequestManager.m
//  EtuProject
//
//  Created by 黄 时欣 on 13-11-8.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "HttpRequestManager.h"

#define RequestTimeOutSeconds 30

#define finishedLog(request)																																																																																													\
	{																																																																																																			\
		DDLogInfo(@"====== request finished =====tag:%ld  \n ========= cost:%.3f s   compress:%@  rawSize:%lu   size:%ld   ========= \n%@", (long)request.tag, [[NSDate date] timeIntervalSinceDate:[request userInfoObjectForKey:@"StartDate"]], request.isResponseCompressed ? @"Yes" : @"No", (long)[request.rawResponseData length], (unsigned long)[request.responseData length], request.responseString);	\
	}																																																																																																			\

#define failedLog(request)																			  \
	{																								  \
		DDLogWarn(@"======= request failed ======tag:%ld  \n\n%@", (long)request.tag, request.error); \
	}																								  \

@interface HttpRequestManager () <ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASINetworkQueue *requestQueue;

@end

@implementation HttpRequestManager
SYNTHESIZE_SINGLETON_FOR_CLASS_M(HttpRequestManager);

+ (void)initialize
{
	RequestManager.requestQueue = [ASINetworkQueue queue];

	// RequestManager.requestQueue.requestDidFinishSelector	= @selector(requestDidFinishSelector:);
	// RequestManager.requestQueue.requestDidFailSelector		= @selector(requestDidFailSelector:);

	[RequestManager.requestQueue go];
}

- (void)dealloc
{
	[_requestQueue cancelAllOperations];
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict
{
	return [self startRequestWithDict:jsonDict url:kBASE_URL];
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict block:(RequestManagerBlock)block
{
	return [self startRequestWithDict:jsonDict url:kBASE_URL block:block];
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict url:(NSString *)url
{
	return [self startRequestWithDict:jsonDict url:url block:nil];
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict url:(NSString *)url block:(RequestManagerBlock)block
{
//	NSAssert([NSJSONSerialization isValidJSONObject:jsonDict], @"the param jsonDict must be valid jsonobject.");

	ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];

	[request setTimeOutSeconds:RequestTimeOutSeconds];
	[request setRequestMethod:@"POST"];
	[request setRequestHeaders:[NSMutableDictionary dictionaryWithDictionary:@{@"Content-Type": @"application/json; charset=UTF-8", @"Accept-Encoding":@"gzip, deflate"}]];

	NSError *error		= nil;
	NSData	*jsonData	= [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
    
    for (NSString *key in jsonDict.allKeys) {
        
        if ([[jsonDict objectForKey:key] isKindOfClass:[NSData class]]) {
            if ([key isEqualToString:@"head"]) {
                [request addData:[jsonDict objectForKey:key] withFileName:@"head.png" andContentType:@"image/png" forKey:key];
            }
            else if ([key isEqualToString:@"image"]) {
                [request addData:[jsonDict objectForKey:key] withFileName:@"image.png" andContentType:@"image/png" forKey:@"filename"];
            }
            else if ([key isEqualToString:@"video"]) {
                [request addData:[jsonDict objectForKey:key] withFileName:@"video.mp4" andContentType:@"video/mp4" forKey:@"filename"];
            }
            else
            {
                [request setData:[jsonDict objectForKey:key] forKey:key];
            }
            
        }
        else
        {
            [request setPostValue:[jsonDict objectForKey:key] forKey:key];
        }
    }
    
	NSLog(@"************* request.url   %@ ***********", request.url);
	NSLog(@"************* start request ***********\n%@\n", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);

//	[request appendPostData:jsonData];

	if (block) {
		__weak typeof(request) bRequest = request;

		[request setCompletionBlock:^{
//			finishedLog(bRequest);
			block(bRequest, YES);
		}];

		[request setFailedBlock:^{
//			failedLog(bRequest);
			block(bRequest, NO);
		}];
	} else {
		request.delegate			= self;
		request.didFailSelector		= @selector(requestDidFailSelector:);
		request.didFinishSelector	= @selector(requestDidFinishSelector:);
	}

#ifndef __OPTIMIZE__
		__weak typeof(request) bRequest = request;

		[request setStartedBlock:^{
			[bRequest addUserInfoObject:[NSDate date] forKey:@"StartDate"];
		}];
#endif
	[_requestQueue addOperation:request];
	return request;
}

- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url
{
	return [self startGetRequestWithUrl:url block:nil];
}

- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url block:(RequestManagerBlock)block
{
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];

	[request setTimeOutSeconds:RequestTimeOutSeconds];
	[request setRequestMethod:@"GET"];
	[request setRequestHeaders:[NSMutableDictionary dictionaryWithDictionary:@{@"Content-Type": @"application/json; charset=UTF-8", @"Accept-Encoding":@"gzip, deflate"}]];
//	DDLogInfo(@"************* start request with url: %@ ***********", request.url);

	if (block) {
		__weak typeof(request) bRequest = request;

		[request setCompletionBlock:^{
//			finishedLog(bRequest);
			block(bRequest, YES);
		}];

		[request setFailedBlock:^{
//			failedLog(bRequest);
			block(bRequest, NO);
		}];
	} else {
		request.delegate			= self;
		request.didFailSelector		= @selector(requestDidFailSelector:);
		request.didFinishSelector	= @selector(requestDidFinishSelector:);
	}

#ifndef __OPTIMIZE__
		__weak typeof(request) bRequest = request;

		[request setStartedBlock:^{
			[bRequest addUserInfoObject:[NSDate date] forKey:@"StartDate"];
		}];
#endif
	[_requestQueue addOperation:request];
	return request;
}

- (void)requestDidFinishSelector:(ASIHTTPRequest *)request
{
//	finishedLog(request);
//	postNotification(kN_MANAGER_REQUEST_CALLBACK, request);
}

- (void)requestDidFailSelector:(ASIHTTPRequest *)request
{
//	failedLog(request);
//	postNotification(kN_MANAGER_REQUEST_CALLBACK, request);
}

@end

@implementation ASIHTTPRequest (Oxygen)

- (void)addUserInfoObject:(id)obj forKey:(NSString *)key
{
	if (obj) {
		if (self.userInfo) {
			NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.userInfo];
			[dict setObject:obj forKey:key];
			self.userInfo = dict;
		} else {
			self.userInfo = @{key:obj};
		}
	}
}

- (id)userInfoObjectForKey:(NSString *)key
{
	if ([NSString isStringEmptyOrBlank:key]) {
		return nil;
	}

	return self.userInfo[key];
}

- (NSDictionary *)paramDictionary
{
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.postBody options:kNilOptions error:nil];

	return dict;
}

@end

