//
//  SportRecordViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "RecordViewControllerDelegate.h"

@interface SportRecordViewController : BaseViewController

@property (nonatomic, assign) id<RecordViewControllerDelegate> delegate;

@end

#pragma mark - Gradient View

@interface SportRecordGradientView : UIView

@property (nonatomic, strong) NSArray *CGColors;
@property (nonatomic, strong) NSArray *locations;

@end
