//
//  UITableView+Oxygen.h
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-12.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@protocol UITableViewRefrshDelegate <NSObject>
@optional
- (void)tableViewPull:(UITableView *)tableView refreshView:(MJRefreshBaseView *)refreshView;
- (void)tableViewDrag:(UITableView *)tableView refreshView:(MJRefreshBaseView *)refreshView;

@end

@interface UITableView (Oxygen)

@property (nonatomic, strong) MJRefreshHeaderView	*header;
@property (nonatomic, strong) MJRefreshFooterView	*footer;
@property (nonatomic,assign) NSInteger firstPageNo;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,assign) NSInteger pages;

@property (nonatomic, assign) id <UITableViewRefrshDelegate> refreshDelegate;

- (id)initPullDragTableWithFrame:(CGRect)frame style:(UITableViewStyle)style allDelegateDataSource:(id)delegate;

- (void)noMoreData;
- (void)reloadAllData;

@end

