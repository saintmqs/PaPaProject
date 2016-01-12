//
//  PaPaSynchronousDataView.h
//  EtuProject
//
//  Created by 王家兴 on 16/1/11.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPActivityIndicator.h"

@interface PaPaSynchronousDataView : UIView

@property (nonatomic, strong) AMPActivityIndicator *progressIndicator;
@property (nonatomic, strong) UILabel  *progressLabel;

@end
