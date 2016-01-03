//
//  SelectWeightViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/10.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SelectWeightViewController.h"
#import "CustomPickerModel.h"
#import "SelectAgeViewController.h"

#define PICKER_MAXWEIGHT 100
#define PICKER_MINWEIGHT 40

#define CURRENTCOLOR rgbaColor(0, 139, 207, 1)

@interface SelectWeightViewController ()
{
    //存储数组
    NSMutableArray *weightArray;
    NSArray *indexArray;
    
    //限制model
    CustomPickerModel *maxWeightModel;
    CustomPickerModel *minWeightModel;
    
    //记录位置
    NSInteger weightIndex;
    
    UILabel *kgLabel;
}
@end

@implementation SelectWeightViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        weightArray   = [self ishave:weightArray];
        
        //赋值
        for (int i = PICKER_MINWEIGHT; i<PICKER_MAXWEIGHT; i++) {
            NSString *num = [NSString stringWithFormat:@"%d",i];
            [weightArray addObject:num];
        }
        
        //最大最小限制
        if (self.maxLimitWeight) {
            maxWeightModel = [[CustomPickerModel alloc] initWithData:self.maxLimitWeight type:Model_Weight];
        }else{
            self.maxLimitWeight = PICKER_MAXWEIGHT;
            maxWeightModel = [[CustomPickerModel alloc] initWithData:self.maxLimitWeight type:Model_Weight];
        }
        //最小限制
        if (self.minLimitWeight) {
            minWeightModel = [[CustomPickerModel alloc]initWithData:self.minLimitWeight type:Model_Weight];
        }else{
            self.minLimitWeight = PICKER_MINWEIGHT;
            minWeightModel = [[CustomPickerModel alloc]initWithData:self.minLimitWeight type:Model_Weight];
        }
        
        //获取平均体重
        indexArray = [self getNormalWeight:self.ScrollToWeight];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"您的体重";
    self.view.backgroundColor = CURRENTCOLOR;
    
    self.rightNavButton.hidden = NO;
    
    _weightPickerView = [[CSPickerView alloc] initWithFrame:CGRectMake((mScreenWidth - 100)/2, self.headerView.bottom+(mScreenHeight - self.headerView.bottom - 430)/3, 100, 430)];
    _weightPickerView.dataSource = self;
    _weightPickerView.delegate = self;
    _weightPickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                                 (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                                 (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                                 (id)CURRENTCOLOR.CGColor ];
    [self.view addSubview:_weightPickerView];
    
    [_weightPickerView setSelectedRow:[indexArray[0] integerValue] animated:NO];
    
    kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(_weightPickerView.frameWidth-20, _weightPickerView.frameHeight/2-10, 30, 20)];
    kgLabel.text = @"KG";
    kgLabel.textColor = [UIColor whiteColor];
    kgLabel.font = [UIFont systemFontOfSize:16];
    [_weightPickerView addSubview:kgLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _weightPickerView.frame = CGRectMake((mScreenWidth - 100)/2, self.headerView.bottom+(mScreenHeight - self.headerView.bottom - 430)/3, 100, 430);
    kgLabel.frame = CGRectMake(_weightPickerView.frameWidth-20, _weightPickerView.frameHeight/2-10, 30, 20);
}

#pragma mark - 初始化赋值操作
- (NSMutableArray *)ishave:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

//获取平均体重
- (NSArray *)getNormalWeight:(NSInteger)weight
{
    weight =50;
    
    CustomPickerModel *model = [[CustomPickerModel alloc] initWithData:weight type:Model_Weight];
    
    weightIndex = [model.weightData integerValue] - PICKER_MINWEIGHT;
    
    NSNumber *weightData   = [NSNumber numberWithInteger:weightIndex];
    
    return @[weightData];
}

#pragma mark - Picker Delegate and Data Source

- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSString *title;
    if (pickerView == _weightPickerView) {
        title = weightArray[row];
        weightIndex = row;
        
        [UserDataManager shareInstance].registModel.weight = weightArray[row];
    }
    
    self.title = title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == kCSPickerViewFrontTableTag ? 60.f : 60.f;
}

- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView
{
    if (pickerView == _weightPickerView) {
        return PICKER_MAXWEIGHT - PICKER_MINWEIGHT;
    }
    
    return 0;
}

- (UITableViewCell *)pickerView:(CSPickerView *)pickerView tableView:(UITableView *)tableView cellForRow:(NSInteger)row
{
    // Create table cell.
    NSString *identifier = (tableView.tag == kCSPickerViewFrontTableTag
                            ? kCSPickerViewFrontCellIdentifier : kCSPickerViewBackCellIdentifier);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (tableView.tag == kCSPickerViewBackTopTableTag || tableView.tag == kCSPickerViewBackBottomTableTag) {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    // Populate table cell.
    [self pickerView:pickerView tableView:tableView populateCell:cell atRow:row];
    
    return cell;
}

- (void)pickerView:(CSPickerView *)pickerView customizeTableView:(UITableView *)tableView
{
    if (tableView.tag != kCSPickerViewFrontTableTag) {
        tableView.backgroundColor = CURRENTCOLOR;
    }
}

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row
{
    if (pickerView == _weightPickerView) {
        cell.textLabel.text = weightArray[row];
    }
}

#pragma mark - TopRightButton 点击事件
-(void)didTopRightButtonClick:(UIButton *)sender
{
    SelectAgeViewController *vc = [[SelectAgeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
