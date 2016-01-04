//
//  SelectBraceletViewController.m
//  EtuProject
//
//  Created by 王家兴 on 16/1/3.
//  Copyright © 2016年 王家兴. All rights reserved.
//

#import "SelectBraceletViewController.h"
#import "SelectBraceletCell.h"

@interface SelectBraceletViewController()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *searchResultTable;
    
    UIButton *cancelButton;
}
@end

@implementation SelectBraceletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = rgbaColor(51, 46, 53, 1);
    self.headerView.hidden = NO;
    
    UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerView.frameHeight - 1, mScreenWidth, 1)];
    seperateLine.backgroundColor = rgbaColor(238, 240, 241, 0.1);
    [self.headerView addSubview:seperateLine];
    
    self.titleLabel.text = @"选择设备";
    
    [self setupSearchResultTableView];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((mScreenWidth - 110)/2, self.view.frameBottom - 60, 110, 30);
    [cancelButton setTitle:@"暂时不绑定 >" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:cancelButton];
    
//    [self setupGradientView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSearchResultTableView
{
    searchResultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, mScreenHeight - self.headerView.frameBottom)];
    searchResultTable.delegate = self;
    searchResultTable.dataSource = self;
    searchResultTable.backgroundColor = [UIColor clearColor];
    searchResultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:searchResultTable];
}

#pragma mark - UITableView DataSource & Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectBraceletCell * cell = (SelectBraceletCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectBraceletCell"];
    if (cell == nil) {
        cell = [[SelectBraceletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectBraceletCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultArray.count;
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[BLEManager sharedManager] setCurrentPeripheralWithIndex:indexPath.row]) {
        [[BLEManager sharedManager] startConnect];
    }
}
@end
