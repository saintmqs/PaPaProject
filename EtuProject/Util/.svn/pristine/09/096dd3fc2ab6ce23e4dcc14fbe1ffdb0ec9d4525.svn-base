//
//  FHTableView.h
//  ChengHongInformation
//
//  Created by 赵化 on 13-4-15.
//  Copyright (c) 2013年 赵化. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSearchBar.h"
#import "WZRefreshTableHeaderView.h"
#import "WZLoadMoreTableFooterView.h"

@class FHTableView;

@protocol FHTableViewDelegate <UISearchBarDelegate,UISearchDisplayDelegate>

@optional

//选择
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath node:(id)node;
//选择
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//头视图
-(UIView *)fhtable:(FHTableView *)table viewForHeaderInSection:(NSInteger)section;
- (CGFloat)fhtable:(FHTableView *)tableView heightForHeaderInSection:(NSInteger)section;

 //脚视图
-(UIView *)fhtable:(FHTableView *)table viewForFooterInSection:(NSInteger)section;
- (CGFloat)fhtable:(FHTableView *)tableView heightForFooterInSection:(NSInteger)section;

//删除
-(NSString *)fhtable:(FHTableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath; //删除字样
- (void)fhtable:(FHTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)fhtable:(FHTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)fhtable:(FHTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;


-(void)reloadTableViewDataSource:(FHTableView *)table;
-(void)loadMoreTableViewDataSource:(FHTableView *)table;
-(void)showControls;
-(void)hideControls;

@required

-(CGFloat)fhtable:(FHTableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *)fhtable:(FHTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)fhtable:(FHTableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end

@interface FHTableView : UIView <UITableViewDataSource,UITableViewDelegate,WZRefreshTableHeaderDelegate,WZLoadMoreTableFooterDelegate,UIGestureRecognizerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    //一页多少row
    int     _numInPage;
    //配置
    NSDictionary *_config;
    //上拉加载更多，下拉刷新
    WZRefreshTableHeaderView * _refreshHeaderView;
    WZLoadMoreTableFooterView * _loadMoreFooterView;
    BOOL _loading;
    //停留的y坐标
    float _YContentOffSet;
    BOOL _isHidden;
    BOOL _canHidden;
}
//table
@property (strong, nonatomic) UITableView *table;
//数据源
@property (strong ,nonatomic) NSMutableArray *dataArray;
//是否还有数据
@property (assign, nonatomic) BOOL hasMoreData;
//是否可以下拉刷新
@property (assign, nonatomic) BOOL hasReloadView;
//代理
@property (assign, nonatomic) IBOutlet id <FHTableViewDelegate> delegate;
//是否可以显示隐藏控件
@property (assign, nonatomic) BOOL canBeHidden;

//搜索栏
@property (strong, nonatomic) CustomSearchBar *searchBar;
@property (assign, nonatomic) BOOL showSearchBar;
@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;

//设置tableView的Style为Group形式
@property (assign, nonatomic) BOOL tableViewIsGroup;


//删除重新加载功能
-(void)delReloadView;
//删除加载更多功能
-(void)delLoadMoreView;
//重用
-(UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
//滑动到顶端
-(void)scrollToTopWithAnimotion:(BOOL)animotion;
//完成上拉加载更多
-(void)doneLoadMoreTableViewData;
//完成刷新
-(void)doneLoadingTableViewData;
//设置
-(void)setIsHidden:(BOOL)isHidden;

//重新设置frame
- (void)reSetFrame:(CGRect)frame;

-(void)setReloadingStateString:(NSString *)normal loading:(NSString *)loading;

@end

