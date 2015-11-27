//
//  PPProgressInnerView.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/27.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPProgressInnerView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *detailLabel;

-(id)initWithCenterPoint:(CGPoint)centerPoint;

@end
