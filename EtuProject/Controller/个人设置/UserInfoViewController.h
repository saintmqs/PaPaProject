//
//  UserInfoViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoHeadView.h"


@interface UserInfoViewController : BaseViewController<UserInfoHeadViewDelegate>

@property (nonatomic, strong) UserInfoHeadView *infoHeadView;

@end
