//
//  SelectAgeViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/8.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SelectAgeViewController.h"
#import "CustomPickerModel.h"
#import "SelectStepsViewController.h"

#define PICKER_MAXDATE 2050
#define PICKER_MINDATE 1970

#define PICKER_MONTH 12

#define CURRENTCOLOR rgbaColor(0, 172, 208, 1)

@interface SelectAgeViewController ()
{
    //存储数组
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSArray *indexArray;
    
    //限制model
    CustomPickerModel *maxDateModel;
    CustomPickerModel *minDateModel;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    
    UILabel *yearLabel;
    UILabel *monthLabel;
    UILabel *dayLabel;
    
    NSString *yearStr,*monthStr,*dayStr;
}
@end

@implementation SelectAgeViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        yearArray   = [self ishave:yearArray];
        monthArray  = [self ishave:monthArray];
        dayArray    = [self ishave:dayArray];
        
        //赋值
        for (int i = 1 ; i<=PICKER_MONTH; i++) {
            NSString *num = [NSString stringWithFormat:@"%02d",i];
            [monthArray addObject:num];
        }
        for (int i=PICKER_MINDATE; i<PICKER_MAXDATE; i++) {
            NSString *num = [NSString stringWithFormat:@"%d",i];
            [yearArray addObject:num];
        }
        
        //最大最小限制
        if (self.maxLimitDate) {
            maxDateModel = [[CustomPickerModel alloc]initWithDate:self.maxLimitDate];
        }else{
            self.maxLimitDate = [self dateFromString:@"204912312359" withFormat:@"yyyyMMdd"];
            maxDateModel = [[CustomPickerModel alloc]initWithDate:self.maxLimitDate];
        }
        //最小限制
        if (self.minLimitDate) {
            minDateModel = [[CustomPickerModel alloc]initWithDate:self.minLimitDate];
        }else{
            self.minLimitDate = [self dateFromString:@"197001010000" withFormat:@"yyyyMMdd"];
            minDateModel = [[CustomPickerModel alloc]initWithDate:self.minLimitDate];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"您的年龄";
    self.view.backgroundColor = CURRENTCOLOR;
    
    if (self.isFromUserInfoSet) {
        [self.rightNavButton setTitle:@"确认" forState:UIControlStateNormal];
        self.rightNavButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.rightNavButton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [self.rightNavButton setTitle:nil forState:UIControlStateNormal];
        [self.rightNavButton setImage:[UIImage imageNamed:@"topIcoRightWrite"] forState:UIControlStateNormal];
    }
    self.rightNavButton.hidden = NO;
    
    //获取当前日期，储存当前时间位置
    indexArray = [self getNowDate:self.ScrollToDate];
    
    _yearPickerView = [[CSPickerView alloc] initWithFrame:CGRectMake(50, self.headerView.bottom+100, 190, mScreenHeight - self.headerView.bottom)];
    _yearPickerView.dataSource = self;
    _yearPickerView.delegate = self;
    _yearPickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                (id)CURRENTCOLOR.CGColor ];
    [self.view addSubview:_yearPickerView];
    
    yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(_yearPickerView.frameWidth-10, _yearPickerView.frameHeight/2-10, 30, 20)];
    yearLabel.text = @"年";
    yearLabel.textColor = [UIColor whiteColor];
    yearLabel.font = [UIFont systemFontOfSize:16];
    [_yearPickerView addSubview:yearLabel];
    
    _monthPickerView = [[CSPickerView alloc] initWithFrame:CGRectMake(_yearPickerView.frameRight + 30, self.headerView.bottom+100, 70, mScreenHeight - self.headerView.bottom)];
    _monthPickerView.dataSource = self;
    _monthPickerView.delegate = self;
    _monthPickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)CURRENTCOLOR.CGColor ];
    [self.view addSubview:_monthPickerView];
    
    monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(_monthPickerView.frameWidth-10, _monthPickerView.frameHeight/2-10, 30, 20)];
    monthLabel.text = @"月";
    monthLabel.textColor = [UIColor whiteColor];
    monthLabel.font = [UIFont systemFontOfSize:16];
    [_monthPickerView addSubview:monthLabel];
    
    _dayPickerView = [[CSPickerView alloc] initWithFrame:CGRectMake(_monthPickerView.frameRight + 30, self.headerView.bottom+100, 70, mScreenHeight - self.headerView.bottom)];
    _dayPickerView.dataSource = self;
    _dayPickerView.delegate = self;
    _dayPickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)CURRENTCOLOR.CGColor ];
    [self.view addSubview:_dayPickerView];
    
    dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dayPickerView.frameWidth-10, _dayPickerView.frameHeight/2-10, 30, 20)];
    dayLabel.text = @"日";
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.font = [UIFont systemFontOfSize:16];
    [_dayPickerView addSubview:dayLabel];
    
    [_yearPickerView setSelectedRow:[indexArray[0] integerValue] animated:NO];
    [_monthPickerView setSelectedRow:[indexArray[1] integerValue] animated:NO];
    [_dayPickerView setSelectedRow:[indexArray[2] integerValue] animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _yearPickerView.frame = CGRectMake(50, self.headerView.bottom+(mScreenHeight - self.headerView.bottom - 430)/3, 100, 430);
    _monthPickerView.frame = CGRectMake(_yearPickerView.frameRight+20, self.headerView.bottom +(mScreenHeight - self.headerView.bottom - 430)/3, 70,430);
    _dayPickerView.frame = CGRectMake(_monthPickerView.frameRight+20, self.headerView.bottom + (mScreenHeight - self.headerView.bottom - 430)/3, 70,430);
    
    yearLabel.frame = CGRectMake(_yearPickerView.frameWidth-10, _yearPickerView.frameHeight/2-10, 30, 20);
    monthLabel.frame = CGRectMake(_monthPickerView.frameWidth-10, _monthPickerView.frameHeight/2-10, 30, 20);
    dayLabel.frame = CGRectMake(_dayPickerView.frameWidth-10, _dayPickerView.frameHeight/2-10, 30, 20);
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
- (NSArray *)getNowDate:(NSDate *)date
{
    NSDate *dateShow;
    if (self.isFromUserInfoSet) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
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
    
    CustomPickerModel *model = [[CustomPickerModel alloc]initWithDate:dateShow];
    
    [self DaysfromYear:[model.year integerValue] andMonth:[model.month integerValue]];
    
    yearIndex = [model.year intValue]- PICKER_MINDATE;
    monthIndex = [model.month intValue]-1;
    dayIndex = [model.day intValue]-1;
    
    NSNumber *year   = [NSNumber numberWithInteger:yearIndex];
    NSNumber *month  = [NSNumber numberWithInteger:monthIndex];
    NSNumber *day    = [NSNumber numberWithInteger:dayIndex];
    
    return @[year,month,day];
}

#pragma mark - 数据处理
//通过日期求星期
- (NSString*)getWeekDayWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day
{
    NSInteger yearInt   = [year integerValue];
    NSInteger monthInt  = [month integerValue];
    NSInteger dayInt    = [day integerValue];
    int c = 20;//世纪
    int y = (int)yearInt -1;//年
    int d = (int)dayInt;
    int m = (int)monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0: weekDay = @"周日";    break;
        case 1: weekDay = @"周一";    break;
        case 2: weekDay = @"周二";    break;
        case 3: weekDay = @"周三";    break;
        case 4: weekDay = @"周四";    break;
        case 5: weekDay = @"周五";    break;
        case 6: weekDay = @"周六";    break;
        default:break;
    }
    return weekDay;
}

//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:{
            [self setdayArray:31];
            return 31;
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11:{
            [self setdayArray:30];
            return 30;
        }
            break;
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

#pragma mark - Picker Delegate and Data Source

- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row
{
     NSString *title;
    if (pickerView == _yearPickerView) {
        title = yearArray[row];
        yearStr = yearArray[row];
        yearIndex = row;
    }
    else if (pickerView == _monthPickerView)
    {
        title = monthArray[row];
        monthStr = monthArray[row];
        monthIndex = row;
    }
    else if (pickerView == _dayPickerView)
    {
        title = dayArray[row];
        dayStr = dayArray[row];
        dayIndex = row;
    }
    
    if (!self.isFromUserInfoSet) {
        if (yearStr && monthStr && dayStr) {
            [UserDataManager shareInstance].registModel.birthday = [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
        }
    }
    
    if (pickerView == _yearPickerView || pickerView == _monthPickerView) {
        [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        if (dayArray.count-1<dayIndex) {
            dayIndex = dayArray.count-1;
        }
        
         [_dayPickerView reloadData];
    }
    
    self.title = title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == kCSPickerViewFrontTableTag ? 60.f : 60.f;
}

- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView
{
    if (pickerView == _yearPickerView) {
        return PICKER_MAXDATE - PICKER_MINDATE;
    }
    if (pickerView == _monthPickerView)
    {
        return PICKER_MONTH;
    }
    if (pickerView == _dayPickerView)
    {
        return  [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];;
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
    if (pickerView == _yearPickerView) {
        cell.textLabel.text = yearArray[row];
        
    }
    if (pickerView == _monthPickerView) {
        cell.textLabel.text = monthArray[row];
        
    }
    if (pickerView == _dayPickerView)
    {
        cell.textLabel.text = dayArray[row];
        
    }
}

#pragma mark - TopRightButton 点击事件
-(void)didTopRightButtonClick:(UIButton *)sender
{
    if (self.isFromUserInfoSet) {
        [self updateAgeRequest];
    }
    else
    {
        SelectStepsViewController *vc = [[SelectStepsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Http Request
-(void)updateAgeRequest
{
    showViewHUD;
    
    [self startRequestWithDict:updateBirthday([APP_DELEGATE.userData.uid integerValue], [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr]) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            showTip([dict objectForKey:@"msg"]);
            
            double delayInSeconds = 1.0;
            __block SelectAgeViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                APP_DELEGATE.userData.baseInfo.birthday = [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
                [bself.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            if (error == nil || [error.userInfo objectForKey:@"msg"] == nil)
            {
                showTip(@"网络连接失败");
            }
            else
            {
                showTip([error.userInfo objectForKey:@"msg"]);
            }
        }
    } url:kRequestUrl(@"user", @"updateBirthday")];
}
@end
