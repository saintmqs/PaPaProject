// http://www.cocoadev.com/index.pl?BaseSixtyFour

@interface NSData (Oxygen)

//base64String 转 NSData
+ (id)dataWithBase64EncodedString:(NSString *)string encoding:(char[])encoding;
+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
+ (id)dataWithBase64EncodedUrlSafeString:(NSString *)string;
//对NSData进行Base64编码
- (NSString *)base64Encoding:(char[])encoding;
- (NSString *)base64Encoding;
- (NSString *)base64EncodingUrlSafe;

- (NSDictionary *)toJsonDictWithOptions:(NSJSONReadingOptions)opt error:(NSError **)err;
- (NSDictionary *)toJsonDictError:(NSError **)err;
@end
