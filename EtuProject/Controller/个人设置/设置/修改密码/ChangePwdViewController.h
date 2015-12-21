//
//  ChangePwdViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePwdViewController : BaseViewController

@property (nonatomic, strong) UITextField	*password;
@property (nonatomic, strong) UITextField	*newpassword;
@property (nonatomic, strong) UITextField	*reNewpassword;

@property (nonatomic, strong) UIButton      *btnFinish;
@end
