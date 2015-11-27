//
//  HomeViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/11/5.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "HomeViewController.h"
#import "HomePageProgressItem.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HomePageProgressItem *item = [[HomePageProgressItem alloc] initWithFrame:CGRectMake(0, self.headerView.frameBottom, mScreenWidth, 250)];
    [self.view addSubview:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


#pragma mark - Gradient View

@implementation HomeGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.userInteractionEnabled = NO;
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)setLocations:(NSArray *)locations
{
    ((CAGradientLayer *)self.layer).locations = locations;
}

- (void)setCGColors:(NSArray *)CGColors
{
    ((CAGradientLayer *)self.layer).colors = CGColors;
}

@end
