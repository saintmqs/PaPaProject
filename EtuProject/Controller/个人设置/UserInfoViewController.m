//
//  UserInfoViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SettingsViewController.h"
#import "UserInfoTableViewCell.h"
#import "Login.h"

#import "EditNickNameViewController.h"

#import "SelectSexViewController.h"
#import "SelectHeightViewController.h"
#import "SelectWeightViewController.h"
#import "SelectAgeViewController.h"
#import "SelectStepsViewController.h"

#import "JGActionSheet.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,JGActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *userInfoTable;
    
    NSArray *titlesArray;
    
    NSArray *detailsArray;
    
    NSData *headImageData;
}
@end

@implementation UserInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (detailsArray) {
        
        BaseInfo *baseInfo = APP_DELEGATE.userData.baseInfo;
        
        NSString *sex = [baseInfo.sex integerValue] == 1 ? @"男" : @"女";
        NSString *height = [NSString stringWithFormat:@"%@cm",baseInfo.height];
        NSString *weight = [NSString stringWithFormat:@"%@kg",baseInfo.weight];
        NSString *steps = [NSString stringWithFormat:@"%@步",baseInfo.step];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:baseInfo.birthday];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *birthday = [formatter stringFromDate:date];
        
        NSArray *dataArray = [NSArray arrayWithObjects:@[baseInfo.nickname,baseInfo.phone], @[sex,height,weight,birthday,steps], nil];
        
        detailsArray = dataArray;
        
        [userInfoTable reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"个人信息";
    self.headerView.backgroundColor = rgbaColor(0, 155, 232, 1);

    [self.rightNavButton setImage:[UIImage imageNamed:@"topIcoInstall"] forState:UIControlStateNormal];
    self.rightNavButton.hidden = NO;
    
    _infoHeadView = [[UserInfoHeadView alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, 170)];
    _infoHeadView.delegate = self;
    [self.view addSubview:_infoHeadView];
    
    titlesArray = [NSArray arrayWithObjects:@[@"昵    称：",@"手    机："], @[@"性    别：",@"身    高：",@"体    重：",@"生    日：",@"目    标："], nil];
    
    userInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _infoHeadView.frameBottom, mScreenWidth, mScreenHeight-_infoHeadView.frameBottom)];
    userInfoTable.dataSource = self;
    userInfoTable.delegate = self;
    userInfoTable.backgroundColor = [UIColor clearColor];
    userInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    userInfoTable.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.view addSubview:userInfoTable];
    
    //获取用户基本信息
    [self requestUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopRightButtonClick:(UIButton *)sender
{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - UITableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titlesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSArray *sectionTitles = [titlesArray objectAtIndex:indexPath.section];
    NSArray *sectionDetails = [detailsArray objectAtIndex:indexPath.section];
    cell.titleLabel.text = [sectionTitles objectAtIndex:indexPath.row];
    cell.detailLabel.text = [sectionDetails objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.seperateLine.hidden = indexPath.row == 4;
                cell.detailLabel.frame = CGRectMake(mScreenWidth/2 - 40, (60-30)/2, mScreenWidth/2, 30);
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.seperateLine.hidden = indexPath.row == 1;
                cell.detailLabel.frame = CGRectMake(mScreenWidth/2 - 20, (60-30)/2, mScreenWidth/2, 30);
                cell.detailLabel.textColor = [UIColor lightGrayColor];
            }
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.seperateLine.hidden = indexPath.row == 4;
            cell.detailLabel.frame = CGRectMake(mScreenWidth/2 - 40, (60-30)/2, mScreenWidth/2, 30);
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //编辑昵称
                    EditNickNameViewController *vc = [[EditNickNameViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                    
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //编辑性别
                    SelectSexViewController *vc = [[SelectSexViewController alloc] init];
                    vc.isFromUserInfoSet = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    //编辑身高
                    SelectHeightViewController *vc = [[SelectHeightViewController alloc] init];
                    vc.isFromUserInfoSet = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //编辑体重
                    SelectWeightViewController *vc = [[SelectWeightViewController alloc] init];
                    vc.isFromUserInfoSet = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    //编辑生日
                    SelectAgeViewController *vc = [[SelectAgeViewController alloc] init];
                    vc.isFromUserInfoSet = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 4:
                {
                    //编辑步数
                    SelectStepsViewController *vc = [[SelectStepsViewController alloc] init];
                    vc.isFromUserInfoSet = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UserInfoHeadView Delegate
- (void)editHeadImage
{
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"拍照", @"从手机相册选择"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    NSArray *sections = @[section, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel]];
    JGActionSheet* actionSheet = [[JGActionSheet alloc] initWithSections:sections];
    actionSheet.delegate = self;
    
    weakObj(self);
    [actionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        if (indexPath.section == 0)
        {
            NSLog(@"row: %ld", (long)indexPath.row);
            UIImagePickerController *  imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = bself;
            imagePickerController.allowsEditing = YES;
            if(indexPath.row == 0)
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [bself presentViewController:imagePickerController animated:YES completion:nil];
        }
        [sheet dismissAnimated:YES];
    }];
    
    [actionSheet showInView:self.navigationController.view animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        headImageData = UIImageJPEGRepresentation(image,0.5);
    }
    
    showViewHUD;
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [headImageData base64EncodedStringWithOptions:0];
    base64Encoded = strFormat(@"data:image/jpg;base64,%@",base64Encoded);
    
    [self startRequestWithDict:updateAvater([APP_DELEGATE.userData.uid integerValue], base64Encoded) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            showTip([dict objectForKey:@"msg"]);
            
            if ([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = [dict objectForKey:@"data"];
                APP_DELEGATE.userData.avatar = [data objectForKey:@"avater"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAvatar" object:nil];
            }
            
            [self.infoHeadView.headImageView setImage:[[UIImage alloc] initWithData:headImageData] forState:UIControlStateNormal];
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
        
    } url:kRequestUrl(@"user", @"updateAvater")];
}

#pragma mark - Http Request
-(void)requestUserInfo
{
    showViewHUD;
    [self startRequestWithDict:getUserInfo([APP_DELEGATE.userData.uid integerValue]) completeBlock:^(ASIHTTPRequest *request, NSDictionary *dict, NSError *error) {
        
        hideViewHUD;
        
        if (!error) {
            BaseInfo *baseInfo = [[BaseInfo alloc] initWithDictionary:[dict objectForKey:@"data"] error:nil];
            APP_DELEGATE.userData.baseInfo = baseInfo;
            
            NSString *sex = [baseInfo.sex integerValue] == 1 ? @"男" : @"女";
            NSString *height = [NSString stringWithFormat:@"%@cm",baseInfo.height];
            NSString *weight = [NSString stringWithFormat:@"%@kg",baseInfo.weight];
            NSString *steps = [NSString stringWithFormat:@"%@步",baseInfo.step];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:baseInfo.birthday];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd日"];
            NSString *birthday = [formatter stringFromDate:date];
            
            NSArray *dataArray = [NSArray arrayWithObjects:@[baseInfo.nickname,baseInfo.phone], @[sex,height,weight,birthday,steps], nil];
            
            detailsArray = [NSArray arrayWithArray:dataArray];
            [userInfoTable reloadData];
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
    } url:kRequestUrl(@"user", @"getUserInfo")];
}
@end
