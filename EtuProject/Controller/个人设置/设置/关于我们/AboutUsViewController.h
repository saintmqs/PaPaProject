//
//  AboutUsViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "WPHotspotLabel.h"

@interface AboutUsViewController : BaseViewController

@property (nonatomic, strong) UIImageView *appIcon;
@property (nonatomic, strong) WPHotspotLabel     *appVersionLabel;
@property (nonatomic, strong) UIButton    *appProtocolBtn;
@property (nonatomic, strong) UILabel     *appCopyRightLabel;

@end
