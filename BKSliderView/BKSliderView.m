//
//  BKSliderView.m
//  MainTestProgram
//
//  Created by biggerlens on 2021/1/5.
//  Copyright © 2021 zjn. All rights reserved.
//

#import "BKSliderView.h"
@interface BKSliderView ()
/// 核心滑动条控件
@property (nonatomic, strong) UISlider *mainSlider;
/// 滑动条样式类型
@property(nonatomic, assign) BKSliderType type;
/// [标题]字符内容
@property(nonatomic, strong) NSString *title;
/// [滑动条图标]名称
@property(nonatomic, strong) NSString *thumbIcon;
/// [空值]进度条
@property(nonatomic, strong) UIView *emptyProgressView;
/// [满值]进度条
@property(nonatomic, strong) UIView *fullProgressView;
/// [中间分割线标识]控件
@property(nonatomic, strong) UIView *centerLineView;
/// 滑动条的数值
@property(nonatomic, assign) CGFloat value;
@end
@implementation BKSliderView
/// 初始化对象
/// @param type 滑动条类型
/// @param title 滑动条控件的标题
/// @param minValue 最小值
/// @param maxValue 最大值
+ (instancetype)customByType:(BKSliderType)type
                       title:(NSString*)title
                    minValue:(CGFloat)minValue
                    maxValue:(CGFloat)maxValue{
    BKSliderView *customView = [[self alloc] init];
    customView.type = type;
    customView.title = title;
    customView.minValue = minValue;
    customView.maxValue = maxValue;
    
    /// 加载交互视图
    [customView loadUserInterface];
    /// 加载视图布局
    [customView loadLayout];
    /// 加载滑动条样式
    [customView loadSliderStyle];
    return customView;
}

/// 加载交互视图
- (void)loadUserInterface{
    //[左侧][标题]文本控件的对象
    self.leftTitleLab = [[UILabel alloc] init];
    self.leftTitleLab.text = self.title;
    self.leftTitleLab.textColor = UIColor.darkGrayColor;
    self.leftTitleLab.font = [UIFont systemFontOfSize:20];
    self.leftTitleLab.textAlignment = NSTextAlignmentCenter;
    self.leftTitleLab.numberOfLines = 1;
    self.leftTitleLab.adjustsFontSizeToFitWidth = YES;
    
    //[右侧][数值]文本控件的对象
    self.rightValueLab = [[UILabel alloc] init];
    self.rightValueLab.textColor = UIColor.darkGrayColor;
    self.rightValueLab.font = [UIFont systemFontOfSize:20];
    self.rightValueLab.textAlignment = NSTextAlignmentCenter;
    self.rightValueLab.numberOfLines = 1;
    self.rightValueLab.adjustsFontSizeToFitWidth = YES;
    self.rightValueLab.text = [NSString stringWithFormat:@"%.1lf",
                               self.minValue + (self.maxValue-self.minValue)/2];
    
    //[空值]进度条的对象
    self.emptyProgressView = [[UIView alloc] init];
    self.emptyProgressView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0f];
    self.emptyProgressView.userInteractionEnabled = NO;
    
    //[满值]进度条的对象
    self.fullProgressView = [[UIView alloc] init];
    self.fullProgressView.backgroundColor = [UIColor colorWithRed:88.0/255.0 green:162.0/255.0 blue:249.0/255.0 alpha:1.0f];
    self.fullProgressView.userInteractionEnabled = NO;
    
    self.centerLineView = [[UIView alloc] init];
    self.centerLineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    self.centerLineView.userInteractionEnabled = NO;
    
    self.mainSlider = [[UISlider alloc] init];
    self.mainSlider.minimumTrackTintColor = UIColor.clearColor;
    self.mainSlider.maximumTrackTintColor = UIColor.clearColor;
    self.mainSlider.maximumValue = self.maxValue;
    self.mainSlider.minimumValue = self.minValue;
    /* =========== 滑动条滑动[过程中]的响应事件 start =========== */
    [self.mainSlider addTarget:self action:@selector(sliderValueInChangeAction:) forControlEvents:UIControlEventValueChanged];
    /* =========== 滑动条滑动[过程中]的响应事件 end =========== */
    /* =========== 滑动条滑动[结束后]的响应事件(结束触发事件,三个方法必须加,一个都不能少) start =========== */
    [self.mainSlider addTarget:self action:@selector(sliderValueEndAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainSlider addTarget:self action:@selector(sliderValueEndAction:) forControlEvents:UIControlEventTouchUpOutside];
    [self.mainSlider addTarget:self action:@selector(sliderValueEndAction:) forControlEvents:UIControlEventTouchCancel];
    /* =========== 滑动条滑动[结束后]的响应事件(结束触发事件,三个方法必须加,一个都不能少) end =========== */
}

/// 加载视图布局
- (void)loadLayout{
    //[左侧][标题]文本控件的布局
    [self addSubview:self.leftTitleLab];
    [self.leftTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.equalTo(self.mas_height);
        make.left.mas_equalTo(0);
        make.width.equalTo(self.mas_width).multipliedBy(0.2);
    }];
    
    //[右侧][数值]文本控件的布局
    [self addSubview:self.rightValueLab];
    [self.rightValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.equalTo(self.mas_height);
        make.right.mas_equalTo(0);
        make.width.equalTo(self.mas_width).multipliedBy(0.2);
    }];
    
    //[空值]进度条的布局
    [self addSubview:self.emptyProgressView];
    [self.emptyProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLab.mas_right);
        make.right.equalTo(self.rightValueLab.mas_left);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(2.5f);
    }];
    
    //[满值]进度条的布局
    [self addSubview:self.fullProgressView];
    [self.fullProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.emptyProgressView);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(0);
    }];
    
    //[中间分割线标识]控件的布局
    [self addSubview:self.centerLineView];
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.emptyProgressView);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(7.5f);
    }];
    
    [self addSubview:self.mainSlider];
    [self.mainSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyProgressView.mas_centerX);
        make.centerY.equalTo(self.emptyProgressView.mas_centerY);
        make.width.equalTo(self.emptyProgressView.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    //根据自动布局的约束,更新frame
    [self layoutIfNeeded];
}

/// 加载滑动条样式
- (void)loadSliderStyle{
    CGFloat defaultValue = self.minValue;
    if (self.type == BKOneWaySlider) {
        defaultValue = self.minValue;
        self.centerLineView.hidden = YES;
    } else if (self.type == BKTwoWaySlider) {
        defaultValue = self.minValue + 0.5*(self.maxValue - self.minValue);
        self.centerLineView.hidden = NO;
    }
    
    //设置滑动条的数值
    [self setValueOfSlider:defaultValue];
}

/// 设置滑动条的数值
/// @param value 数值
- (void)setValueOfSlider:(CGFloat)value{
    self.mainSlider.value = self.value = value;
    
    //根据自动布局的约束,更新frame
    [self layoutIfNeeded];
    /// 设置进度条的值
    [self updateFullProgress];
    /// 更新[数值文本控件]的对应数值
    [self updateValueLab];
}

/// 改变滑动条的样式
/// @param type 样式类型
/// @param minValue 最小值
/// @param maxValue 最大值
- (void)setStyleByType:(BKSliderType)type
              minValue:(CGFloat)minValue
              maxValue:(CGFloat)maxValue{
    self.type = type;
    self.minValue = self.mainSlider.minimumValue = minValue;
    self.maxValue = self.mainSlider.maximumValue = maxValue;
    
    [self loadSliderStyle];
}

/// 设置滑动条拖动图标
/// @param imageName 图标名称
-(void)setThumbIconByImageName:(NSString *)imageName{
    self.thumbIcon = imageName;
    [self.mainSlider setThumbImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

/// 拖动条的拖动过程中的事件
- (void)sliderValueInChangeAction:(UISlider*)sender{    
    self.value = sender.value;
    //更新[数值文本控件]的对应数值
    [self updateValueLab];
    //更新进度条的视图状态
    [self updateFullProgress];
    
    //滑动条数值改变[结束后]的响应事件
    if ([self.mainDelegate respondsToSelector:@selector(sliderValueEndDelegateAction:)]) {
        [self.mainDelegate sliderValueEndDelegateAction:self.value];
    }
}

/// 拖动条的拖动结束后的事件
- (void)sliderValueEndAction:(UISlider*)sender{
    self.value = sender.value;
    //更新[数值文本控件]的对应数值
    [self updateValueLab];
    //更新进度条的视图状态
    [self updateFullProgress];
    
    //滑动条数值改变[过程中]的响应事件
    if ([self.mainDelegate respondsToSelector:@selector(sliderValueInChangeDelegateAction:)]) {
        [self.mainDelegate sliderValueInChangeDelegateAction:self.value];
    }
}

/// 更新进度条的视图状态
- (void)updateFullProgress{
    [self.fullProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.emptyProgressView);
        CGFloat emptyProgressWidth = CGRectGetWidth(self.emptyProgressView.frame);
        //通过自定义滑动条控件的类型判断进度条效果
        if (self.type == BKOneWaySlider) {
            //如果是[单向滑动条],进行单向进度
            CGFloat rate = 1.0f*(self.value - self.minValue)/(self.maxValue - self.minValue);
            make.left.equalTo(self.emptyProgressView.mas_left);
            make.width.equalTo(self.emptyProgressView.mas_width).multipliedBy(rate);
        } else if(self.type == BKTwoWaySlider) {
            CGFloat rate = 1.0f*(self.value - self.minValue)/(self.maxValue - self.minValue);
            CGFloat centerRate = rate - 0.5;//中间比例
            if (centerRate >= 0) {
                make.left.equalTo(self.emptyProgressView.mas_left).offset(0.5*emptyProgressWidth);
                make.width.equalTo(self.emptyProgressView.mas_width).multipliedBy(centerRate);
            } else {
                centerRate = -centerRate;
                make.right.equalTo(self.emptyProgressView.mas_right).offset(-0.5*emptyProgressWidth);
                make.width.equalTo(self.emptyProgressView.mas_width).multipliedBy(centerRate);
            }
        }
    }];
}

/// 更新[数值文本控件]的对应数值
- (void)updateValueLab{
    self.rightValueLab.text = [NSString stringWithFormat:@"%.0lf", self.value];
}

@end
