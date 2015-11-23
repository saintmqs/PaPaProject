//
//  SelectStepsViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/10.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SelectStepsViewController.h"
#import "CustomPickerModel.h"
#import "SearchBraceletViewController.h"

#define PICKER_MAXSTEP 999
#define PICKER_MINSTEP 1

#define CURRENTCOLOR rgbaColor(231, 136, 51, 1)

@interface SelectStepsViewController ()
{
    //存储数组
    NSMutableArray *stepArray;
    NSArray *indexArray;
    
    //限制model
    CustomPickerModel *maxStepModel;
    CustomPickerModel *minStepModel;
    
    //记录位置
    NSInteger stepIndex;
}
@end

@implementation SelectStepsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        stepArray   = [self ishave:stepArray];
        
        //赋值
        for (int i = PICKER_MINSTEP; i<PICKER_MAXSTEP; i++) {
            NSString *num = [NSString stringWithFormat:@"%d",i];
            [stepArray addObject:num];
        }
        
        //最大最小限制
        if (self.maxLimitStep) {
            maxStepModel = [[CustomPickerModel alloc] initWithData:self.maxLimitStep type:Model_Step];
        }else{
            self.maxLimitStep = PICKER_MAXSTEP;
            maxStepModel = [[CustomPickerModel alloc] initWithData:self.maxLimitStep type:Model_Step];
        }
        //最小限制
        if (self.minLimitStep) {
            minStepModel = [[CustomPickerModel alloc]initWithData:self.minLimitStep type:Model_Step];
        }else{
            self.minLimitStep = PICKER_MINSTEP;
            minStepModel = [[CustomPickerModel alloc]initWithData:self.minLimitStep type:Model_Step];
        }
        
        //获取平均体重
        indexArray = [self getNormalStep:self.ScrollToStep];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"目标步数";
    self.view.backgroundColor = CURRENTCOLOR;
    
    self.rightNavButton.hidden = NO;
    
    _stepPickerView = [[CSPickerView alloc] initWithFrame:CGRectMake((mScreenWidth - 140)/2, self.headerView.bottom+(mScreenHeight - self.headerView.bottom - 430)/3, 140, 430)];
    _stepPickerView.dataSource = self;
    _stepPickerView.delegate = self;
    _stepPickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                                 (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                                 (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                                 (id)CURRENTCOLOR.CGColor ];
    [self.view addSubview:_stepPickerView];
    
    [_stepPickerView setSelectedRow:[indexArray[0] integerValue] animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _stepPickerView.frame = CGRectMake((mScreenWidth - 140)/2, self.headerView.bottom+(mScreenHeight - self.headerView.bottom - 430)/3, 140, 430);
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
- (NSArray *)getNormalStep:(NSInteger)Step
{
    Step =10;
    
    CustomPickerModel *model = [[CustomPickerModel alloc] initWithData:Step type:Model_Step];
    
    stepIndex = [model.stepData integerValue] - PICKER_MINSTEP;
    
    NSNumber *StepData   = [NSNumber numberWithInteger:stepIndex];
    
    return @[StepData];
}

#pragma mark - Picker Delegate and Data Source

- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSString *title;
    if (pickerView == _stepPickerView) {
        title = [NSString stringWithFormat:@"%@000",stepArray[row]];
        stepIndex = row;
    }
    
    self.title = title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == kCSPickerViewFrontTableTag ? 60.f : 60.f;
}

- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView
{
    if (pickerView == _stepPickerView) {
        return PICKER_MAXSTEP - PICKER_MINSTEP;
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
    if (pickerView == _stepPickerView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@000",stepArray[row]];
    }
}

#pragma mark - TopRightButton 点击事件
-(void)didTopRightButtonClick:(UIButton *)sender
{
    SearchBraceletViewController *vc = [[SearchBraceletViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
