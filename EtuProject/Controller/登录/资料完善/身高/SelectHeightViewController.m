//
//  SelectHeightViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/10.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SelectHeightViewController.h"
#import "CustomPickerModel.h"
#import "SelectWeightViewController.h"

#define PICKER_MAXHEIGHT 250
#define PICKER_MINHEIGHT 120

#define CURRENTCOLOR rgbaColor(0, 191, 134, 1)

@interface SelectHeightViewController ()
{
    //存储数组
    NSMutableArray *heightArray;
    NSArray *indexArray;
    
    //限制model
    CustomPickerModel *maxHeightModel;
    CustomPickerModel *minHeightModel;
    
    //记录位置
    NSInteger heightIndex;
    
    UILabel *cmLabel;
}
@end

@implementation SelectHeightViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        heightArray   = [self ishave:heightArray];
        
        //赋值
        for (int i=PICKER_MINHEIGHT; i<PICKER_MAXHEIGHT; i++) {
            NSString *num = [NSString stringWithFormat:@"%d",i];
            [heightArray addObject:num];
        }
        
        //最大最小限制
        if (self.maxLimitHeight) {
            maxHeightModel = [[CustomPickerModel alloc] initWithData:self.maxLimitHeight type:Model_Height];
        }else{
            self.maxLimitHeight = PICKER_MAXHEIGHT;
            maxHeightModel = [[CustomPickerModel alloc] initWithData:self.maxLimitHeight type:Model_Height];
        }
        //最小限制
        if (self.minLimitHeight) {
            minHeightModel = [[CustomPickerModel alloc]initWithData:self.minLimitHeight type:Model_Height];
        }else{
            self.minLimitHeight = PICKER_MINHEIGHT;
            minHeightModel = [[CustomPickerModel alloc]initWithData:self.minLimitHeight type:Model_Height];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"您的身高";
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
    
    //获取平均身高
    indexArray = [self getNormalHeight:self.ScrollToHeight];
    
    _heightPickerView = [[CSPickerView alloc] initWithFrame:CGRectMake((mScreenWidth - 100)/2, self.headerView.bottom+(mScreenHeight - self.headerView.bottom - 430)/3, 100, 430)];
    _heightPickerView.dataSource = self;
    _heightPickerView.delegate = self;
    _heightPickerView.gradientView.CGColors = @[ (id)CURRENTCOLOR.CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)[CURRENTCOLOR colorWithAlphaComponent:0.0f].CGColor,
                                               (id)CURRENTCOLOR.CGColor ];
    [self.view addSubview:_heightPickerView];
    
    [_heightPickerView setSelectedRow:[indexArray[0] integerValue] animated:NO];
    
    cmLabel = [[UILabel alloc] initWithFrame:CGRectMake(_heightPickerView.frameWidth-10, _heightPickerView.frameHeight/2-10, 30, 20)];
    cmLabel.text = @"CM";
    cmLabel.textColor = [UIColor whiteColor];
    cmLabel.font = [UIFont systemFontOfSize:16];
    [_heightPickerView addSubview:cmLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _heightPickerView.frame = CGRectMake((mScreenWidth - 100)/2, self.headerView.bottom+(mScreenHeight - self.headerView.bottom - 430)/3, 100, 430);
    cmLabel.frame = CGRectMake(_heightPickerView.frameWidth-10, _heightPickerView.frameHeight/2-10, 30, 20);
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

//获取平均身高
- (NSArray *)getNormalHeight:(NSInteger)height
{
    if (self.isFromUserInfoSet) {
        height = [APP_DELEGATE.userData.baseInfo.height integerValue];
    }
    else
    {
        height = 170;
    }
    
    CustomPickerModel *model = [[CustomPickerModel alloc] initWithData:height type:Model_Height];
    
    heightIndex = [model.heightData integerValue] - PICKER_MINHEIGHT;
    
    NSNumber *heigthtData   = [NSNumber numberWithInteger:heightIndex];
    
    return @[heigthtData];
}

#pragma mark - Picker Delegate and Data Source

- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSString *title;
    if (pickerView == _heightPickerView) {
        title = heightArray[row];
        heightIndex = row;
        
        if (!self.isFromUserInfoSet) {
            [UserDataManager shareInstance].registModel.height = heightArray[row];
        }
    }
    
    self.title = title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == kCSPickerViewFrontTableTag ? 60.f : 60.f;
}

- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView
{
    if (pickerView == _heightPickerView) {
        return PICKER_MAXHEIGHT - PICKER_MINHEIGHT;
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
    if (pickerView == _heightPickerView) {
        cell.textLabel.text = heightArray[row];
    }
}

#pragma mark - TopRightButton 点击事件
-(void)didTopRightButtonClick:(UIButton *)sender
{
    if (self.isFromUserInfoSet) {
        [self updateHeightRequest];
    }
    else
    {
        SelectWeightViewController *vc = [[SelectWeightViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma mark - Http Request
-(void)updateHeightRequest
{
    showViewHUD;
    
    [self startRequestWithDict:healthUpdateHeight([APP_DELEGATE.userData.uid integerValue], [heightArray[heightIndex] integerValue]) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            showTip([dict objectForKey:@"msg"]);
            
            double delayInSeconds = 1.0;
            __block SelectHeightViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                APP_DELEGATE.userData.baseInfo.height = heightArray[heightIndex];
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
    } url:kRequestUrl(@"health", @"healthUpdate_height")];
}
@end
