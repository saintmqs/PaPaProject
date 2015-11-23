//
//  CustomPicker.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/7.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "CustomPicker.h"
#import "CustomPickerModel.h"

#define PICKER_MAXDATE 2050
#define PICKER_MINDATE 1970

#define PICKER_MONTH 12

#define PICKER_MAXHEIGHT 
#define PICKER_MINHEIGHT

#define PICKER_MAXWEIGHT
#define PICKER_MINWEIGHT

#define PICKER_MAXSTEP
#define PICKER_MINSTEP

@interface CustomPicker()
{
    UIPickerView *myPickerView;
    
    //存储数组
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    
    NSMutableArray *heightArray;
    NSMutableArray *weightArray;
    NSMutableArray *stepArray;
    
    //限制model
    CustomPickerModel *maxDateModel;
    CustomPickerModel *minDateModel;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger heightIndex;
    NSInteger weightIndex;
    NSInteger stepIndex;
}

@property (nonatomic, copy) FinishBlock finishBlock;

@end

@implementation CustomPicker

-(id)initWithframe:(CGRect)frame Delegate:(id<CustomPickerDelegate>)delegate PickerStyle:(PickerStyle)pickerStyle
{
    self.pickerStyle = pickerStyle;
    self.delegate = delegate;
    return [self initWithFrame:frame];
}

- (id)initWithframe:(CGRect)frame PickerStyle:(PickerStyle)pickerStyle didSelected:(FinishBlock)finishBlock
{
    self.pickerStyle = pickerStyle;
    self.finishBlock = finishBlock;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
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

//进行初始化
- (void)drawRect:(CGRect)rect
{
    self.frame = CGRectMake(0, mNavBarHeight + 150, mScreenWidth, mScreenHeight-mNavBarHeight - 300);
    
    switch (self.pickerStyle) {
        case PickerStyle_YearMonthDay:
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
            
            //获取当前日期，储存当前时间位置
            NSArray *indexArray = [self getNowDate:self.ScrollToDate];
            
            if (!myPickerView) {
                myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                myPickerView.showsSelectionIndicator = NO;
                myPickerView.backgroundColor = [UIColor clearColor];
                myPickerView.delegate = self;
                myPickerView.dataSource = self;
                [self addSubview:myPickerView];
            }
            //调整为现在的时间
            for (int i=0; i<indexArray.count; i++) {
                [myPickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:NO];
            }
        }
            break;
        case PickerStyle_Height:
        {
            
        }
            break;
        case PickerStyle_Weight:
        {
            
        }
            break;
        case PickerStyle_Step:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 调整颜色

//获取当前时间解析及位置
- (NSArray *)getNowDate:(NSDate *)date
{
    NSDate *dateShow;
    if (date) {
        dateShow = date;
    }else{
        dateShow = [NSDate date];
    }
    
    CustomPickerModel *model = [[CustomPickerModel alloc]initWithDate:dateShow];
    
    [self DaysfromYear:[model.year integerValue] andMonth:[model.month integerValue]];
    
    yearIndex = [model.year intValue]-PICKER_MINDATE;
    monthIndex = [model.month intValue]-1;
    dayIndex = [model.day intValue]-1;
    
    NSNumber *year   = [NSNumber numberWithInteger:yearIndex];
    NSNumber *month  = [NSNumber numberWithInteger:monthIndex];
    NSNumber *day    = [NSNumber numberWithInteger:dayIndex];

    
    if (self.pickerStyle == PickerStyle_YearMonthDay)
        return @[year,month,day];
    return nil;
}

- (void)creatValuePointXs:(NSArray *)xArr withNames:(NSArray *)names
{
    for (int i=0; i<xArr.count; i++) {
        [self addLabelWithNames:names[i] withPointX:[xArr[i] intValue]];
    }
}

- (void)addLabelWithNames:(NSString *)name withPointX:(NSInteger)point_x
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point_x, self.frameHeight/2 - 10, 20, 20)];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    if (self.pickerStyle == PickerStyle_YearMonthDay){
        if (iOS7) {
            [self creatValuePointXs:@[@"120",@"200",@"270"]
                          withNames:@[@"年",@"月",@"日"]];
        }
        return 3;
    }
    
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    if (self.pickerStyle == PickerStyle_YearMonthDay)
    {
        if (component == 0) return PICKER_MAXDATE-PICKER_MINDATE;
        if (component == 1) return PICKER_MONTH;
        if (component == 2){
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (self.pickerStyle) {

        case PickerStyle_YearMonthDay:{
            if (component==0) return 100;
            if (component==1) return 100;
            if (component==2) return 100;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    switch (self.pickerStyle) {
            
        case PickerStyle_YearMonthDay:{
            if (component==0) return 50;
            if (component==1) return 50;
            if (component==2) return 50;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.pickerStyle) {
        case PickerStyle_YearMonthDay:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    [self playTheDelegate];
}

#pragma mark - 代理回调方法
- (void)playTheDelegate
{
    NSDate *date = [self dateFromString:[NSString stringWithFormat:@"%@%@%@",yearArray[yearIndex],monthArray[monthIndex],dayArray[dayIndex]] withFormat:@"yyyyMMdd"];
    if ([date compare:self.minLimitDate] == NSOrderedAscending) {
        NSArray *array = [self getNowDate:self.minLimitDate];
        for (int i=0; i<array.count; i++) {
            [myPickerView selectRow:[array[i] integerValue] inComponent:i animated:YES];
        }
    }else if ([date compare:self.maxLimitDate] == NSOrderedDescending){
        NSArray *array = [self getNowDate:self.maxLimitDate];
        for (int i=0; i<array.count; i++) {
            [myPickerView selectRow:[array[i] integerValue] inComponent:i animated:YES];
        }
    }
    
    NSString *strWeekDay = [self getWeekDayWithYear:yearArray[yearIndex] month:monthArray[monthIndex] day:dayArray[dayIndex]];
    
    //block 回调
    if (self.finishBlock) {
//        self.finishBlock(yearArray[yearIndex],
//                         monthArray[monthIndex],
//                         dayArray[dayIndex],
//                         hourArray[hourIndex],
//                         minuteArray[minuteIndex],
//                         strWeekDay);
    }
    //代理回调
    [self.delegate customPicker:self
                           year:yearArray[yearIndex]
                          month:monthArray[monthIndex]
                            day:dayArray[dayIndex]
                         height:weightArray[weightIndex]
                         weight:heightArray[heightIndex]
                           step:stepArray[stepIndex]
                         ];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:40]];
    }
    UIColor *textColor = [UIColor whiteColor];
    NSString *title;
    
    switch (self.pickerStyle) {
        case PickerStyle_YearMonthDay:{
            if (component==0) {
                title = yearArray[row];
//                textColor = [self returnYearColorRow:row];
            }
            if (component==1) {
                title = monthArray[row];
//                textColor = [self returnMonthColorRow:row];
            }
            if (component==2) {
                title = dayArray[row];
//                textColor = [self returnDayColorRow:row];
            }
        }
            break;
        default:
            break;
    }
    customLabel.text = title;
    customLabel.textColor = textColor;
    return customLabel;
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

@end
