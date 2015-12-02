//
//  SleepingRecordViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "RecordViewControllerDelegate.h"

@interface SleepingRecordViewController : BaseViewController

@property (nonatomic, assign) id<RecordViewControllerDelegate> delegate;

@end
