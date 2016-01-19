//
//  SportRecordViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "RecordViewControllerDelegate.h"
#import "PPChart.h"

@interface SportRecordViewController : BaseViewController<PPChartDataSource,PPChartDelegate>

@property (nonatomic, assign) id<RecordViewControllerDelegate> delegate;

@property (nonatomic, strong) PPChart *chartView;

@property (nonatomic, strong) NSMutableArray *currentDataArr;
@end

#pragma mark - Gradient View

@interface SportRecordGradientView : UIView

@property (nonatomic, strong) NSArray *CGColors;
@property (nonatomic, strong) NSArray *locations;

@end
