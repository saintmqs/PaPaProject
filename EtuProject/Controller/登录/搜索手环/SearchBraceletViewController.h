//
//  SearchBraceletViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/22.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "PPLoadingView.h"

@interface SearchBraceletViewController : BaseViewController

@property (nonatomic, strong) UIView  *searchView;//搜索设备
@property (nonatomic, strong) UIView  *bleOffView;//蓝牙未开启
@property (nonatomic, strong) UIView  *noResultView;//未搜索到手环

@property (nonatomic, strong) PPLoadingView *loadingView;
@property (nonatomic, strong) PPGradientView *gradientView;

@property (nonatomic, strong) dispatch_source_t timer;

-(void)startScan; //开始扫描附近的蓝牙设备
@end
