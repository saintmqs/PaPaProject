//
//  HomeViewController.h
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "BaseViewController.h"
#import "SGFocusImageFrame.h"
#import "PaPaSynchronousDataView.h"

@interface HomeViewController : BaseViewController<SGFocusImageFrameDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SGFocusImageFrame *indicatorView;
@property (nonatomic,strong) PaPaSynchronousDataView *synDataView;
@property (nonatomic,strong) UITableView       *detailTableView;

-(void)startSynData;
-(void)endSynData;
@end

#pragma mark - Gradient View

@interface HomeGradientView : UIView

@property (nonatomic, strong) NSArray *CGColors;
@property (nonatomic, strong) NSArray *locations;

@end
