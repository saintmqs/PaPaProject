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

- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress
{
    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
    
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 指定文件保存路径，将文件保存在沙盒中
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:requestURL parameters:paramDic error:nil];
    
    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
    //
    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    //
    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPMethod:@"POST"];
    //
    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 也可以检查文件是否存在
//        [[NSFileManager defaultManager] removeItemAtPath:savedPath error:nil];
        
        // 下一步可以进行进一步处理，或者发送通知给用户。
        NSLog(@"下载成功");
        
        success(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
        
        NSLog(@"下载失败");
        
    }];
    
    [operation start];

}


-(void)asynchronousGetRequest:(NSString*)url parameters:(NSDictionary *)parameters successBlock:(void (^)(BOOL success,id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock{
    NSString *paramsUrl = url;
    if(parameters)
    {
        NSString *paramsStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error: nil] encoding:NSUTF8StringEncoding];
        
        paramsUrl = [[[[NSString stringWithFormat:@"%@&jsonRequest=%@",url,paramsStr] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:paramsUrl]];
    AFJSONResponseSerializer *responseSerializer =[[AFJSONResponseSerializer alloc] init];
    responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html", nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer =responseSerializer;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (responseObject){
                successBlock(YES,responseObject,@"");
            }else{
                successBlock(NO,nil,@"no res");
            }
        }
        
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        failureBlock(error.localizedDescription);
        
    }];
    [operation start];
    
}
@end

