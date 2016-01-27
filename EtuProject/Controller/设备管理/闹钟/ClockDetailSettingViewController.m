//
//  ClockDetailSettingViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "ClockDetailSettingViewController.h"
#import "CustomPickerModel.h"
#import "ClockSettingTableCell.h"
#import "ClocksCycleSettingViewController.h"

#import "JGActionSheet.h"

#define PICKER_MAXHOUR 23
#define PICKER_MINHOUR 0

#define PICKER_MAXMINUTE 59
#define PICKER_MINMINUTE 0

#define PICKER_HOUR 24
#define PICKER_MINUTE 60

#define CURRENTCOLOR rgbaColor(255, 255, 255, 1)

@interface ClockDetailSettingViewController ()<UITableViewDataSource, UITableViewDelegate,JGActionSheetDelegate,ClockSettingTableCellDelegate>
{
    UIView *leftView;
    UIView *rightView;
    
    //存储数组
    NSMutableArray *hourArray;
    NSMutableArray *minuteArray;
    NSArray *indexArray;
    
    //限制model
    CustomPickerModel *maxTimeModel;
    CustomPickerModel *minTimeModel;
    
    //记录位置
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    UILabel *hourLabel;
    UILabel *minuteLabel;
    
    NSString *hourStr,*minuteStr;
    
    UITableView *settingsTable;
    NSArray     *titlesArray;
    
    NSString    *cycleString;
}
@end

@implementation ClockDetailSettingViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        hourArray   = [self ishave:hourArray];
        minuteArray  = [self ishave:minuteArray];
        
        //赋值
        for (int i = 0 ; i<=PICKER_MAXHOUR; i++) {
            NSString *num = [NSString stringWithFormat:@"%02d",i];
            [hourArray addObject:num];
        }
        for (int i=0; i<=PICKER_MAXMINUTE; i++) {
            NSString *num = [NSString stringWithFormat:@"%02d",i];
            [minuteArray addObject:num];
        }
        
        //最大最小限制
        if (self.maxLimitTime) {
            maxTimeModel = [[CustomPickerModel alloc] initWithTime:self.maxLimitTime];
        }else{
            self.maxLimitTime = [self dateFromString:@"23:59" withFormat:@"HH:mm"];
            maxTimeModel = [[CustomPickerModel alloc] initWithTime:self.maxLimitTime];
        }
        //最小限制
        if (self.minLimitTime) {
            minTimeModel = [[CustomPickerModel alloc] initWithTime:self.minLimitTime];
        }else{
            self.minLimitTime = [self dateFromString:@"00:00" withFormat:@"HH:mm"];
            minTimeModel = [[CustomPickerModel alloc] initWithTime:self.minLimitTime];
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.selectClockModel.w isEqualToString:@"0"]) {
        cycleString = @"只响一次";
        return;
    }
    
    if ([self.selectClockModel.w isEqualToString:@"1,2,3,4,5,6,7"]) {
        cycleString = @"每天";
        return;
    }
    
    NSArray *checkedDays = [self.selectClockModel.w componentsSeparatedByString:@","];
    NSArray *weekArray = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    
    NSMutableArray *cycleStrings = [NSMutableArray array];
    for (NSString *indexStr in checkedDays) {
        [cycleStrings addObject:weekArray[[indexStr integerValue]-1]];
    }
    cycleString = [cycleStrings componentsJoinedByString:@""];
    
    [settingsTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"闹钟设置";
    self.titleLabel.textColor = [UIColor grayColor];
    self.headerView.backgroundColor = rgbColor(242, 242, 242);
    
    [self resetNavButton];
    
    //获取当前日期，储存当前时间位置
    indexArray = [self getNowTime:self.scrollToTime];
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom + 40, mScreenWidth/2, 240)];
    leftView.backgroundColor = [UIColor whiteColor];
    leftView.layer.borderWidth = 1;
    leftView.layer.borderColor = rgbaColor(240, 240, 240, 1).CGColor;
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frameRight, self.headerView.frameBottom + 40, mScreenWidth/2, 240)];
    rightView.backgroundColor = [UIColor whiteColor];
    rightView.layer.borderWidth = 1;
    rightView.layer.borderColor = rgbaColor(240, 240, 240, 1).CGColor;
    [self.view addSubviews:leftView, rightView, nil];
    
    _hourPickerView = [[CSPickerView alloc] initWithFrame:CGRectMake((mScreenWidth/2 - 100)/2,0,100,leftView.frameHeight)];
    _hourPickerView.dataSource = self;
    _hourPickerView.delegate = self;
    _hourPickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)CURRENTCOLOR.CGColor ];
    [leftView addSubview:_hourPickerView];
    
    hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hourPickerView.frameWidth-10, _hourPickerView.frameHeight/2-10, 30, 20)];
    hourLabel.text = @"时";
    hourLabel.textColor = rgbaColor(0, 155, 232, 1);
    hourLabel.font = [UIFont systemFontOfSize:16];
    [_hourPickerView addSubview:hourLabel];
    
    _minutePickerView = [[CSPickerView alloc] initWithFrame:CGRectMake((mScreenWidth/2 - 100)/2, 0, 100,rightView.frameHeight)];
    _minutePickerView.dataSource = self;
    _minutePickerView.delegate = self;
    _minutePickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)CURRENTCOLOR.CGColor ];
    [rightView addSubview:_minutePickerView];
    
    minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(_minutePickerView.frameWidth-10, _minutePickerView.frameHeight/2-10, 30, 20)];
    minuteLabel.text = @"分";
    minuteLabel.textColor = rgbaColor(0, 155, 232, 1);
    minuteLabel.font = [UIFont systemFontOfSize:16];
    [_minutePickerView addSubview:minuteLabel];

    [_hourPickerView setSelectedRow:[indexArray[0] integerValue] animated:NO];
    [_minutePickerView setSelectedRow:[indexArray[1] integerValue] animated:NO];
    
    titlesArray = [NSArray arrayWithObjects:@"闹钟周期", @"智能唤醒", nil];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetNavButton
{
    [self.leftNavButton setImage:nil forState:UIControlStateNormal];
    [self.leftNavButton setImage:nil forState:UIControlStateHighlighted];
    [self.leftNavButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftNavButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.leftNavButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.rightNavButton.hidden = NO;
    [self.rightNavButton setImage:nil forState:UIControlStateNormal];
    [self.rightNavButton setImage:nil forState:UIControlStateHighlighted];
    [self.rightNavButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.rightNavButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.rightNavButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

-(void)setupTableView
{
    settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, leftView.frameBottom + 30, mScreenWidth, mScreenHeight - leftView.frameBottom - 30)];
    settingsTable.dataSource = self;
    settingsTable.delegate = self;
    settingsTable.backgroundColor = [UIColor clearColor];
    settingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    settingsTable.bounces = NO;
    [self.view addSubview:settingsTable];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    leftView.frame = CGRectMake(0, self.headerView.frameBottom + 40, mScreenWidth/2, 240);
    rightView.frame = CGRectMake(leftView.frameRight, self.headerView.frameBottom + 40, mScreenWidth/2, 240);
}

#pragma mark - Button Action
-(void)didTopRightButtonClick:(UIButton *)sender
{
    if (hourStr && minuteStr) {
       self.selectClockModel.t = strFormat(@"%@:%@",hourStr,minuteStr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

//获取当前时间解析及位置
- (NSArray *)getNowTime:(NSDate *)date
{
    NSDate *dateShow;
    if (self.isFromClockSet) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        dateShow = [dateFormatter dateFromString:APP_DELEGATE.userData.baseInfo.birthday];
    }
    else
    {
        if (date) {
            dateShow = date;
        }else{
            dateShow = [NSDate date];
        }
    }
    
    CustomPickerModel *model = [[CustomPickerModel alloc]initWithTime:dateShow];
    
    hourIndex = [model.hour intValue]- PICKER_MINHOUR;
    minuteIndex = [model.minute intValue]-PICKER_MINMINUTE;
    
    NSNumber *hour   = [NSNumber numberWithInteger:hourIndex];
    NSNumber *minute  = [NSNumber numberWithInteger:minuteIndex];
    
    return @[hour,minute];
}

//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

#pragma mark - Picker Delegate and Data Source

- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSString *title;
    if (pickerView == _hourPickerView) {
        title = hourArray[row];
        hourStr = hourArray[row];
        hourIndex = row;
    }
    else if (pickerView == _minutePickerView)
    {
        title = minuteArray[row];
        minuteStr = minuteArray[row];
        minuteIndex = row;
    }
    
    self.title = title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == settingsTable) {
        return 60;
    }
    return tableView.tag == kCSPickerViewFrontTableTag ? 40.f : 40.f;
}

- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView
{
    if (pickerView == _hourPickerView) {
        return PICKER_HOUR;
    }
    if (pickerView == _minutePickerView)
    {
        return PICKER_MINUTE;
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
            cell.textLabel.textColor = rgbaColor(170, 170, 170, 1);
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = rgbaColor(0, 155, 232, 1);
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.f];
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
    if (pickerView == _hourPickerView) {
        cell.textLabel.text = hourArray[row];
        
    }
    if (pickerView == _minutePickerView) {
        cell.textLabel.text = minuteArray[row];
        
    }
}

#pragma mark - UITableView DataSource & Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titlesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ClockSettingTableCell";
    ClockSettingTableCell *cell = (ClockSettingTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ClockSettingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.seperateLine.hidden = indexPath.row == [titlesArray count] -1;
    cell.settingTitleLabel.text = [titlesArray objectAtIndex:indexPath.row];
    [cell.settingSwitch setOn:self.selectClockModel.isOn animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.cellType = DETAIL_TYPE;
            cell.settingDetailLabel.frame = CGRectMake(mScreenWidth/2 - 40, (60-30)/2, mScreenWidth/2, 30);
            cell.settingDetailLabel.text = cycleString;
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.cellType = SWITCH_TYPE;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            [self selectClockRingModel];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Cell Delegate Method
-(void)settingSwitchAction:(id)sender
{
    UISwitch *tempswitch = (UISwitch *)sender;
    BOOL setting = tempswitch.isOn;
    [tempswitch setOn:setting animated:YES];
    self.selectClockModel.isOn = setting;
}

#pragma mark - 选择闹钟模式
- (void)selectClockRingModel
{
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"每天", @"只响一次"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    NSArray *sections = @[section, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"自定义闹钟"] buttonStyle:JGActionSheetButtonStyleCancel]];
    JGActionSheet* actionSheet = [[JGActionSheet alloc] initWithSections:sections];
    actionSheet.delegate = self;
    
    [actionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0) {
                self.selectClockModel.y = 2;
                self.selectClockModel.w = @"1,2,3,4,5,6,7";
                cycleString = @"每天";
            }
            else
            {
                self.selectClockModel.y = 1;
                self.selectClockModel.w = @"0";
                cycleString = @"只响一次";
            }
            
        }
        else if (indexPath.section == 1)
        {
            ClocksCycleSettingViewController *vc = [[ClocksCycleSettingViewController alloc] init];
            vc.clockModel = self.selectClockModel;
            [self.navigationController pushViewController:vc animated:YES];

        }
        
        [sheet dismissAnimated:YES];
        
        [settingsTable reloadData];
    }];
    
    [actionSheet showInView:self.navigationController.view animated:YES];
}
@end
