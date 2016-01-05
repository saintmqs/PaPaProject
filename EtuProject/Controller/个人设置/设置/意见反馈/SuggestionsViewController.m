//
//  SuggestionsViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SuggestionsViewController.h"

@interface SuggestionsViewController ()
{
    UIScrollView *contentScrollView;
}
@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"意见反馈";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeft"] forState:UIControlStateNormal];
    [self.leftNavButton setImage:[UIImage imageNamed:@"topIcoLeftWrite"] forState:UIControlStateHighlighted];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight - self.headerView.frameBottom)];
    [self.view addSubview:contentScrollView];
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 200)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.borderWidth = 0.5;
    container.layer.borderColor = rgbaColor(238, 238, 238, 1).CGColor;
    [self.view addSubview:container];
    
    self.suggestionTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 200)];
    _suggestionTextView.textColor = [UIColor blackColor];
    _suggestionTextView.font = [UIFont systemFontOfSize:16];
    _suggestionTextView.placeholderColor = [UIColor grayColor];
    _suggestionTextView.placeholder = @"请写下您遇到的问题或者您对我们的建议";
    [container addSubview:_suggestionTextView];
    
    self.btnFinish = [UIButton btnDefaultFrame:CGRectMake(0, container.frameBottom + 60, mScreenWidth, 50) title:@"提交" font:4];
    [_btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnFinish.backgroundColor = [UIColor whiteColor];
    addBtnAction(_btnFinish, @selector(submitSuggestion));
    
    [contentScrollView addSubviews:container, _btnFinish, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
-(void)submitSuggestion
{
    //验证昵称
    if ([NSString isStringEmptyOrBlank:self.suggestionTextView.text]) {
        showTip(@"请写点什么吧");
        return;
    }
    
    [self submitSuggestionRequest];
}

#pragma mark - Http Request
-(void)submitSuggestionRequest
{
    
}
@end
