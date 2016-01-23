//
//  HomePageProgressItem.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/27.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCircularProgressView.h"
#import "PPProgressInnerView.h"

@interface HomePageProgressItem : UIView

@property (nonatomic, strong) PPCircularProgressView *progressView;
@property (nonatomic, strong) PPProgressInnerView *innerView;

-(void)startProgressChange;
@end