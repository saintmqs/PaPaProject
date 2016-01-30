//
//  AboutUsViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "AboutUsViewController.h"
#import "BaseWebViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"关于我们";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    
    _appIcon = [[UIImageView alloc] initWithFrame:CGRectMake((mScreenWidth - 90)/2, self.headerView.frameBottom + 70, 90, 90)];
    [_appIcon setImage:[UIImage imageNamed:@"appIcon"]];
    [self.view addSubview:_appIcon];
    
    NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
                            @"lightgray":[UIColor lightGrayColor],
                            @"blue":rgbaColor(0, 155, 232, 1)};
    
    _appVersionLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectMake((mScreenWidth - 90)/2, _appIcon.frameBottom + 9, 90, 15)];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _appVersionLabel.attributedText = [strFormat(@"<lightgray>当前版本 </lightgray><blue>V%@</blue>",app_Version)  attributedStringWithStyleBook:style];
    _appVersionLabel.font = [UIFont systemFontOfSize:12];
    _appVersionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_appVersionLabel];
    
    _appProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _appProtocolBtn.frame = CGRectMake((mScreenWidth - 120)/2, mScreenHeight - 90 - 15 - 5 - 16, 120, 16);
    [_appProtocolBtn setTitle:@"软件许可及服务协议" forState:UIControlStateNormal];
    _appProtocolBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_appProtocolBtn setTitleColor:rgbaColor(0, 155, 232, 1) forState:UIControlStateNormal];
    _appProtocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    addBtnAction(_appProtocolBtn, @selector(haveLookProtocol));
    [self.view addSubview:_appProtocolBtn];
    
    _appCopyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, mScreenHeight - 90, mScreenWidth - 40, 15)];
    _appCopyRightLabel.font = [UIFont systemFontOfSize:10];
    _appCopyRightLabel.textColor = [UIColor lightGrayColor];
    _appCopyRightLabel.textAlignment = NSTextAlignmentCenter;
    _appCopyRightLabel.text = @"Copyright©2015-2016. All rights reserved.";
    [self.view addSubview:_appCopyRightLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)haveLookProtocol
{
    BaseWebViewController *vc = [[BaseWebViewController alloc] init];
    vc.titleString = @"软件许可及服务条款";
    vc.urlString = @"http://www.etuchina.com/apihtml/agreement.html";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
