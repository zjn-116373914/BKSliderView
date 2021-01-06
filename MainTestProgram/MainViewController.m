//
//  MainViewController.m
//  MainTestProgram
//
//  Created by zjn on 2017/8/29.
//  Copyright © 2017年 zjn. All rights reserved.
//

#import "MainViewController.h"
#import "BKSliderView.h"
@interface MainViewController ()
/// 背景视图
@property (nonatomic, strong) UIImageView *backgroundImgView;
/// 背景视图
@property (nonatomic, strong) BKSliderView *mainSlider;
@end
@implementation MainViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUserInterface];
}
#pragma mark - =========== 初始化控制器 start ===========
/// 初始化UI交互界面
- (void)initUserInterface{
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(mainBtnAction)];
    self.navigationItem.rightBarButtonItems = @[rightBarBtn];
    
    self.backgroundImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resources01.png"]];
    self.backgroundImgView.frame = CGRectMake(0, KNavBarHeight + KStatusHeight, KScreenWidth, KScreenHeight - KNavBarHeight - KStatusHeight);
    [self.view addSubview:self.backgroundImgView];
    self.backgroundImgView.userInteractionEnabled = YES;
    self.backgroundImgView.hidden = YES;
    
    self.mainSlider = [BKSliderView customByTitle:@"强度" type:BKTwoWaySlider minValue:-5 maxValue:5];
    [self.view addSubview:self.mainSlider];
    [self.mainSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(50);
    }];
}

///导航栏的[确认]按钮控件的点击事件
- (void)mainBtnAction{
    NSLog(@"核心按钮的点击事件!");
    
    [self.mainSlider setValueOfSlider:0.8f];
}
#pragma mark =========== 初始化控制器 end ===========
@end
