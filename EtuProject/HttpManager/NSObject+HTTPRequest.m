//
//  NSObject+HTTPRequest.m
//  EtuProject
//
//  Created by 黄 时欣 on 13-11-11.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "NSObject+HTTPRequest.h"

@interface NSDictionary (Service)
- (BOOL)isServiceError;
- (NSString *)errorCode;
- (NSString *)errorMessage;
@end
@implementation NSDictionary (Service)

- (BOOL)isServiceError
{
	NSString *result = self[@"status"];

	return result ? result.intValue != 0 : YES;
	// return self[@"error"]!= nil;
}

- (NSString *)errorCode
{
	return self[@"status"] ? : @"0";
	// return self[@"error"][@"code"];
}

- (NSString *)errorMessage
{
	return self[@"msg"] ? : @"";
	// return self[@"error"][@"message"];
}

@end

@implementation NSObject (HTTPRequest)

static NSString * ControllerInstanceUUID;

- (void)registerRequestManagerObserver
{
	removeSelfNofificationObserver(kN_MANAGER_REQUEST_CALLBACK);
	addSelfAsNotificationObserver(kN_MANAGER_REQUEST_CALLBACK, @selector(onReceiveRequestBack:));
}

- (void)unregisterRequestManagerObserver
{
	removeSelfNofificationObserver(kN_MANAGER_REQUEST_CALLBACK);
}

- (NSString *)requestUUID
{
	NSString *result = objc_getAssociatedObject(self, &ControllerInstanceUUID);

	if (!result) {
		CFUUIDRef uuid = CFUUIDCreate(NULL);

		if (uuid) {
			// result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
			// 利用base64将uuid缩短至22位
			CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuid);

			Byte buffer[] = {bytes.byte0, bytes.byte1, bytes.byte2, bytes.byte3, bytes.byte4, bytes.byte5, bytes.byte6, bytes.byte7, bytes.byte8, bytes.byte9, bytes.byte10, bytes.byte11, bytes.byte12, bytes.byte13, bytes.byte14, bytes.byte15};

			NSData *data = [NSData dataWithBytes:buffer length:16];
			result = [[data base64Encoding]substringToIndex:22];

			CFRelease(uuid);
		}

		[self willChangeValueForKey:@"ControllerInstanceUUID"];
		objc_setAssociatedObject(self, &ControllerInstanceUUID, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[self didChangeValueForKey:@"ControllerInstanceUUID"];
	}

	return result;
}

- (void)onReceiveRequestBack:(NSNotification *)notification
{
	ASIHTTPRequest *request = notification.object;

	if ([request isKindOfClass:[ASIHTTPRequest class]]) {
		NSDictionary *userInfo = request.userInfo;

		if ([[self requestUUID] isEqualToString:userInfo[@"ObserverUUID"]]) {
			// [self.view makeToast:@"request success"];
			NSError *error = request.error;

			if (!error) {
				NSData			*data	= request.responseData;
				NSDictionary	*dict	= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

				if (dict.isServiceError) {
					error = [[NSError alloc]initWithDomain:dict.errorMessage code:[dict.errorCode intValue] userInfo:dict];
					[self request:request failedWithError:error];
					return;
				}

				if (dict) {
					[self request:request successedWithDictionary:dict];
					return;
				}
			}

			[self request:request failedWithError:error];
		}
	}
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict tag:(NSInteger)tag
{
	return [self startRequestWithDict:jsonDict tag:tag url:kBASE_URL];
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict tag:(NSInteger)tag url:(NSString *)url
{
	ASIFormDataRequest *request = [RequestManager startRequestWithDict:jsonDict url:url];

	request.userInfo	= @{@"ObserverUUID":[self requestUUID]};
	request.tag			= tag;
	return request;
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict completeBlock:(RequestCompleteBlock)block url:(NSString *)url
{
	ASIFormDataRequest *request = [RequestManager startRequestWithDict:jsonDict url:url block:^(ASIHTTPRequest *request, BOOL success) {
			NSError *error = request.error;

			if (!error) {
				NSData *data = request.responseData;
				NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

				if (dict.isServiceError) {
                    if ([dict.errorCode intValue] == 1) {
                        error = nil;
                    }
                    else
                    {
                        error = [[NSError alloc]initWithDomain:dict.errorMessage code:[dict.errorCode intValue] userInfo:dict];
                    }
				}

				if (block && dict) {
					block(request, dict, error);
					return;
				}
			}

			if (block) {
				block(request, nil, error);
			}
		}];

	return request;
}

- (ASIFormDataRequest *)startRequestWithDict:(NSDictionary *)jsonDict completeBlock:(RequestCompleteBlock)block
{
	return [self startRequestWithDict:jsonDict completeBlock:block url:kBASE_URL];
}

- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url tag:(NSInteger)tag
{
	ASIFormDataRequest *request = [RequestManager startGetRequestWithUrl:url];

	request.userInfo	= @{@"ObserverUUID":[self requestUUID]};
	request.tag			= tag;
	return request;
}

- (ASIFormDataRequest *)startGetRequestWithUrl:(NSString *)url completeBlock:(RequestCompleteBlock)block
{
	ASIFormDataRequest *request = [RequestManager startGetRequestWithUrl:url block:^(ASIHTTPRequest *request, BOOL success) {
			NSError *error = request.error;

			if (!error) {
				NSData *data = request.responseData;
				NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

				if (dict.isServiceError) {
					error = [[NSError alloc]initWithDomain:dict.errorMessage code:[dict.errorCode intValue] userInfo:dict];
				}

				if (block && dict) {
					block(request, dict, error);
					return;
				}
			}

			if (block) {
				block(request, nil, error);
			}
		}];

	return request;
}

- (void)request:(ASIHTTPRequest *)request failedWithError:(NSError *)error {}

- (void)request:(ASIHTTPRequest *)request successedWithDictionary:(NSDictionary *)dict {}

@end

