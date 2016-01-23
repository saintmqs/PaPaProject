//
//  PasswordViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"

@interface PasswordViewController : BaseViewController

@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *verifycode;
@property (nonatomic, assign) BOOL     isFindPwd;
@end
