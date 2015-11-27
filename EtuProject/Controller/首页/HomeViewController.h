//
//  HomeViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

@end

#pragma mark - Gradient View

@interface HomeGradientView : UIView

@property (nonatomic) NSArray *CGColors;
@property (nonatomic) NSArray *locations;

@end
