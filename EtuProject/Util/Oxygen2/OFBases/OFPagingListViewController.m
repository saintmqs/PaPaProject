//
//  OFPagingListViewController.m
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-12.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "OFPagingListViewController.h"

@interface OFPagingListViewController ()

@end

@implementation OFPagingListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView		= [[UITableView alloc]initPullDragTableWithFrame:self.bounds style:UITableViewStylePlain allDelegateDataSource:self];
	self.firstPageNo	= 1;
	[self.view addSubview:_tableView];
}

- (void)getData
{
	if (self.curPage - self.firstPageNo > self.pages) {
		return;
	}
}

- (void)tableViewPull:(UITableView *)tableView refreshView:(MJRefreshBaseView *)refreshView
{
	self.curPage = self.firstPageNo;
	[self getData];
}

- (void)tableViewDrag:(UITableView *)tableView refreshView:(MJRefreshBaseView *)refreshView
{
	self.curPage++;
	[self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIndetifier = @"Cell";
	UITableViewCell *cell			= [tableView dequeueReusableCellWithIdentifier:cellIndetifier];

	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
	}

	cell.textLabel.text = _datas[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setPages:(NSInteger)pages
{
	self.tableView.pages = pages;
}

- (NSInteger)pages
{
	return self.tableView.pages;
}

- (void)setCurPage:(NSInteger)curPage
{
	self.tableView.curPage = curPage;
}

- (NSInteger)curPage
{
	return self.tableView.curPage;
}

- (void)setFirstPageNo:(NSInteger)firstPageNo
{
	self.tableView.firstPageNo = firstPageNo;
}

- (NSInteger)firstPageNo
{
	return self.tableView.firstPageNo;
}

@end

