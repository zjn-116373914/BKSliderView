//
//  MainViewController.m
//  MainTestProgram
//
//  Created by zjn on 2017/8/29.
//  Copyright © 2017年 zjn. All rights reserved.
//

#import "MainViewController.h"
#import "BKSliderView.h"
@interface MainViewController ()<BKSliderViewProtocol>
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
    
    self.mainSlider = [BKSliderView customByType:BKOneWaySlider title:@"强度" minValue:0 maxValue:100];
    [self.mainSlider setThumbIconByImageName:@"BFFBSlider_Thumb"];
    [self.view addSubview:self.mainSlider];
    [self.mainSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(50);
    }];
    self.mainSlider.mainDelegate = self;
}

/// 修改图像的操作试图的[拖动手势]操作
-(void)panGestureAction:(UIPanGestureRecognizer *)sender{
    //下列指令是重点:表示sender拖动以后的位置与sender所指向的view距离之差(位移值)
    CGPoint pp = [sender translationInView:sender.view.superview];
    //防止拖动后越界(拖动的操作试图超出其父试图)的容错处理
    UIView *superView = sender.view.superview;
    if(sender.view.center.y+pp.y < 0 ||
       sender.view.center.y+pp.y > superView.frame.size.height ||
       sender.view.center.x+pp.x < 0 ||
       sender.view.center.x+pp.x > superView.frame.size.width){
        return;
    }
    //进行操作试图的位移变化
    UIView *gestureView = sender.view;
    gestureView.center = CGPointMake(gestureView.center.x + pp.x, gestureView.center.y + pp.y);
    [sender setTranslation:CGPointZero inView:sender.view.superview];
}

/// 滑动条数值改变[过程中]的响应事件
- (void)sliderValueInChangeDelegateAction:(CGFloat)value{
    NSLog(@"value = %lf", value);
}

/// 滑动条数值改变[结束后]的响应事件
- (void)sliderValueEndDelegateAction:(CGFloat)value{
    NSLog(@"value = %lf", value);
}

///导航栏的[确认]按钮控件的点击事件
- (void)mainBtnAction{
    NSLog(@"核心按钮的点击事件!");
    
    [self.mainSlider setStyleByType:BKTwoWaySlider minValue:-50 maxValue:50];
}

#pragma mark =========== 初始化控制器 end ===========
@end
