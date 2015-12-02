//
//  SportRecordViewController.m
//  EtuProject
//
//  Created by 王家兴 on 15/12/1.
//  Copyright © 2015年 王家兴. All rights reserved.
//

#import "SportRecordViewController.h"

@interface SportRecordViewController ()
{
    SportRecordGradientView *gradientView;
}
@end

@implementation SportRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftNavButton.hidden = NO;
    
    self.titleLabel.text = @"活动记录";
    
    CGFloat viewFrameHeight;
    CGFloat viewFrameY;
    if (!iPhone4) {
        viewFrameY = self.headerView.frameBottom+90/4;
        viewFrameHeight = 380;
    }
    else
    {
        viewFrameY = self.headerView.frameBottom+20/4;
        viewFrameHeight = 280;
    }
    
    gradientView = [[SportRecordGradientView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, viewFrameY + viewFrameHeight)];
    gradientView.locations = @[ @0.0f, @1.f];
    gradientView.CGColors = @[  (id)rgbaColor(2, 147, 223, 1).CGColor,
                                (id)rgbaColor(21, 88, 168, 1).CGColor ];
    
    [self.view insertSubview:gradientView belowSubview:self.headerView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTopLeftButtonClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(backToHome)]) {
        [_delegate backToHome];
    }
}
@end

#pragma mark - Gradient View

@implementation SportRecordGradientView

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

