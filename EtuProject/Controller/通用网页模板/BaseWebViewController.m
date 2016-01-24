//
//  BaseWebViewController.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/24.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "BaseWebViewController.h"
@interface BaseWebViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
}
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = self.titleString;
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight - self.headerView.frameBottom)];
    webview.delegate = self;
    
    NSURLRequest *detailRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    webview.scalesPageToFit = YES;
    [webview loadRequest:detailRequest];
    
    [self.view addSubview:webview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view hideToastActivity];
    [self.view makeToast:@"请求失败" duration:1.5f position:@"center"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view makeToastActivity];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view hideToastActivity];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)dealloc
{
//    NSLog(@"%s,dealloc",__func__);
    webview.delegate = nil;
    [webview loadHTMLString:@"" baseURL:nil];
    [webview stopLoading];
    [webview removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
