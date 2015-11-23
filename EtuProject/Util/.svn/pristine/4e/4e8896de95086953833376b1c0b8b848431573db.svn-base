//
//  UITableView+Oxygen.m
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-12.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "UITableView+Oxygen.h"

@interface UITableView () <MJRefreshBaseViewDelegate>

@end

@implementation UITableView (Oxygen)
@dynamic header;
@dynamic footer;
@dynamic refreshDelegate;

static NSString *kRefreshHeaderKey;
static NSString *kRefreshFooterKey;
static NSString *kRefreshDelegateKey;
static NSString *kFirstPageNoKey;
static NSString *kCurPageKey;
static NSString *kPagesKey;

- (void)setHeader:(MJRefreshHeaderView *)header
{
	header.delegate		= self;
	header.scrollView	= self;
	[self willChangeValueForKey:@"kRefreshHeaderKey"];
	objc_setAssociatedObject(self, &kRefreshHeaderKey, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"kRefreshHeaderKey"];
}

- (MJRefreshHeaderView *)header
{
	id obj = objc_getAssociatedObject(self, &kRefreshHeaderKey);

	return obj;
}

- (void)setFooter:(MJRefreshFooterView *)footer
{
	footer.delegate		= self;
	footer.scrollView	= self;
	[self willChangeValueForKey:@"kRefreshFooterKey"];
	objc_setAssociatedObject(self, &kRefreshFooterKey, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"kRefreshFooterKey"];
}

- (MJRefreshFooterView *)footer
{
	id obj = objc_getAssociatedObject(self, &kRefreshFooterKey);

	return obj;
}

- (void)setRefreshDelegate:(id <UITableViewRefrshDelegate>)refreshDelegate
{
	[self willChangeValueForKey:@"kRefreshDelegateKey"];
	objc_setAssociatedObject(self, &kRefreshDelegateKey, refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
	[self didChangeValueForKey:@"kRefreshDelegateKey"];
}

- (id <UITableViewRefrshDelegate>)refreshDelegate
{
	id obj = objc_getAssociatedObject(self, &kRefreshDelegateKey);

	return obj;
}

- (void)setFirstPageNo:(NSInteger)firstPageNo
{
	[self willChangeValueForKey:@"kFirstPageNoKey"];
	objc_setAssociatedObject(self, &kFirstPageNoKey, [NSNumber numberWithInteger:firstPageNo], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"kFirstPageNoKey"];
}

- (NSInteger)firstPageNo
{
	return [objc_getAssociatedObject(self, &kFirstPageNoKey) integerValue];
}


- (void)setCurPage:(NSInteger)curPage
{
	[self willChangeValueForKey:@"kCurPageKey"];
	objc_setAssociatedObject(self, &kCurPageKey, [NSNumber numberWithInteger:curPage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"kCurPageKey"];
}

- (NSInteger)curPage
{
	return [objc_getAssociatedObject(self, &kCurPageKey) integerValue];
}

- (void)setPages:(NSInteger)pages
{
	[self willChangeValueForKey:@"kPagesKey"];
	objc_setAssociatedObject(self, &kPagesKey, [NSNumber numberWithInteger:pages], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"kPagesKey"];
}

- (NSInteger)pages
{
	return [objc_getAssociatedObject(self, &kPagesKey) integerValue];
}

- (id)initPullDragTableWithFrame:(CGRect)frame style:(UITableViewStyle)style allDelegateDataSource:(id)delegate
{
	self = [self initWithFrame:frame style:style];

	if (self) {
		self.delegate			= delegate;
		self.dataSource			= delegate;
		self.refreshDelegate	= delegate;
		self.header				= [MJRefreshHeaderView header];
		self.footer				= [MJRefreshFooterView footer];
	}

	return self;
}

- (void)noMoreData
{
	[self.footer setState:RefreshStateNoMore];
}

- (void)reloadAllData
{
	[self reloadData];
	[self.header endRefreshing];
	[self.footer endRefreshing];
    
    if (self.curPage - self.firstPageNo + 1 == self.pages) {
		[self noMoreData];
	}
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
	if (self.refreshDelegate) {
		if (refreshView == self.header) {
			//下拉刷新
			if ([self.refreshDelegate respondsToSelector:@selector(tableViewPull:refreshView:)]) {
				[self.refreshDelegate tableViewPull:self refreshView:refreshView];
			}
		} else if (refreshView == self.footer) {
			//上拉加载
			if ([self.refreshDelegate respondsToSelector:@selector(tableViewDrag:refreshView:)]) {
				[self.refreshDelegate tableViewDrag:self refreshView:refreshView];
			}
		}
	}
}

@end

