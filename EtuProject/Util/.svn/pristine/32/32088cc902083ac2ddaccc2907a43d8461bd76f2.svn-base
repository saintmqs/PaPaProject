//
//  OFPagingListViewController.h
//  cpsdna
//
//  Created by 黄 时欣 on 13-11-12.
//  Copyright (c) 2013年 黄 时欣. All rights reserved.
//

#import "OFBaseViewController.h"
#import "UITableView+Oxygen.h"

@interface OFPagingListViewController : OFBaseViewController<UITableViewDelegate,UITableViewDataSource,UITableViewRefrshDelegate>

@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger firstPageNo;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,assign) NSInteger pages;

-(void)getData;

@end
