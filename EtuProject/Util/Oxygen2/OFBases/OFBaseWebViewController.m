//
//  OFBaseWebViewController.m
//  CheXingZhe
//
//  Created by 黄 时欣 on 13-5-9.
//  Copyright (c) 2013年 Jiang Su Nanyi Digital Dna Science & Technology CO.LTD. All rights reserved.
//

#import "OFBaseWebViewController.h"

@interface OFBaseWebViewController ()

@end

@implementation OFBaseWebViewController

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

-(id)initWithUrl:(NSString *)url title:(NSString *)title{
    self = [self initWithUrl:url];
    if(self){
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = [NSString isStringEmpty:self.title]?@"详情":self.title;
    
    if(self.url){
        NSURL *url = [[NSURL alloc] initWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:requestUrl];
    }
}

-(void)loadView{
    [super loadView];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, viewHeight-44)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.opaque = YES;
    _webView.backgroundColor = [UIColor clearColor];
    
    for (UIView *subView in [_webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    
    [self.view addSubview:_webView];
}

@end
