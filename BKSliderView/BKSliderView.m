//
//  BKSliderView.m
//  MainTestProgram
//
//  Created by biggerlens on 2021/1/5.
//  Copyright © 2021 zjn. All rights reserved.
//

#import "BKSliderView.h"
@interface BKSliderView ()
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
/// [手指拖动]图标控件
@property(nonatomic, strong) UIImageView *thumbImgView;
/// [中间分割线标识]控件
@property(nonatomic, strong) UIView *centerLineView;
/// 滑动条的数值
@property(nonatomic, assign) CGFloat value;
@end
@implementation BKSliderView
/// 初始化对象
/// @param type 滑动条类型
/// @param title 滑动条控件的标题
/// @param thumbIcon [滑动条图标]名称
/// @param minValue 最小值
/// @param maxValue 最大值
+ (instancetype)customByType:(BKSliderType)type
                       title:(NSString*)title
                   thumbIcon:(NSString*)thumbIcon
                    minValue:(CGFloat)minValue
                    maxValue:(CGFloat)maxValue{
    BKSliderView *customView = [[self alloc] init];
    customView.type = type;
    customView.title = title;
    customView.thumbIcon = thumbIcon;
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

/// 设置滑动条的数值
/// @param value 数值
- (void)setValueOfSlider:(CGFloat)value{
    if (value > self.maxValue) {
        value = self.maxValue;
    } else if (value < self.minValue) {
        value = self.minValue;
    }
    self.value = value;
    
    //更新[手指拖动]图标控件的布局
    CGFloat rate = (self.value - self.minValue)/(self.maxValue - self.minValue);
    CGFloat thumbX = rate * self.emptyProgressView.width;
    [self.thumbImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.emptyProgressView.mas_centerY);
        make.width.height.equalTo(self.mas_height).multipliedBy(0.8);
        make.centerX.mas_equalTo(thumbX - self.emptyProgressView.width/2);
    }];
    
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
    self.minValue = minValue;
    self.maxValue = maxValue;
    
    CGFloat defaultValue = minValue;
    if (self.type == BKOneWaySlider) {
        defaultValue = minValue;
        self.centerLineView.hidden = YES;
    } else if (self.type == BKTwoWaySlider){
        defaultValue = minValue + (maxValue - minValue)/2.0;
        self.centerLineView.hidden = NO;
    }
    
    [self setValueOfSlider:defaultValue];
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
    
    //[手指拖动]图标控件的对象
    self.thumbImgView = [[UIImageView alloc] init];
    [self.thumbImgView setImage:[UIImage imageNamed:self.thumbIcon]];
    self.thumbImgView.contentMode = UIViewContentModeCenter;
    self.thumbImgView.userInteractionEnabled = YES;
    //[拖动手势]的定义以及创建:
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOfThumbImgViewAction:)];
    [self.thumbImgView addGestureRecognizer:pan];
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
    
    //根据自动布局的约束,更新frame
    [self layoutIfNeeded];
}

/// 加载滑动条样式
- (void)loadSliderStyle{
    [self addSubview:self.thumbImgView];
    //滑动条控件数值需要更新滑动条布局后才能更新,所以需要延迟1ms,刷新一次自动布局
    int thumbTime = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(thumbTime * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        if (self.type == BKOneWaySlider) {
            //[手指拖动]图标控件的布局
            [self.thumbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.emptyProgressView.mas_centerY);
                make.width.height.equalTo(self.mas_height).multipliedBy(0.8);
                make.centerX.mas_equalTo(-self.emptyProgressView.width/2);
            }];
            //单向滑动条需要默认隐藏[中间分割线标识]控件
            self.centerLineView.hidden = YES;
        } else if (self.type == BKTwoWaySlider) {
            //[手指拖动]图标控件的布局
            [self.thumbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.emptyProgressView.mas_centerY);
                make.width.height.equalTo(self.mas_height).multipliedBy(0.8);
                make.centerX.mas_equalTo(0);
            }];
        }
        //根据自动布局的约束,更新frame
        [self layoutIfNeeded];
    });
    
    //根据自动布局的约束,更新frame
    [self layoutIfNeeded];
    //滑动条控件数值需要更新滑动条布局后才能更新,所以需要延迟1ms,刷新一次自动布局
    int timeSec = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeSec * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        /// 更新[数值文本控件]的对应数值
        [self updateValueLab];
        /// 更新进度条的视图状态
        [self updateFullProgress];
    });
}

/// 拖动手势响应事件
/// @param sender 手势对象
- (void)panOfThumbImgViewAction:(UIPanGestureRecognizer*)sender{
    //当前触点在父视图坐标系的位置(该方法自带边界容错,不需要自己单独做边界容错)
    CGPoint touchPoint = [sender locationInView:sender.view.superview];
    CGFloat minX = CGRectGetMinX(self.emptyProgressView.frame);
    CGFloat maxX = CGRectGetMaxX(self.emptyProgressView.frame);
    //防止拖动后越界(拖动的操作试图超出其父试图)的容错处理
    if(touchPoint.x < minX ||
       touchPoint.x > maxX){
        return;
    }
    
    //进行操作试图的位移变化
    UIView *gestureView = sender.view;
    [gestureView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.emptyProgressView.mas_centerY);
        make.width.height.equalTo(self.mas_height).multipliedBy(0.8);
        make.centerX.mas_equalTo(touchPoint.x - gestureView.superview.width/2);
    }];
    
    //根据自动布局的约束,更新frame
    [self layoutIfNeeded];
    /// 设置进度条的值
    [self updateFullProgress];
    /// 更新[数值文本控件]的对应数值
    [self updateValueLab];
    
    //对外提供滑动条在滑动[过程中]数值变化的方法
    if ([self.mainDelegate respondsToSelector:@selector(sliderValueInChangeDelegateAction:)]) {
        [self.mainDelegate sliderValueInChangeDelegateAction:self.value];
    }
    
    if (sender.state == UIGestureRecognizerStateCancelled ||
        sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateFailed) {
        //对外提供滑动条在滑动[结束后]数值变化的方法
        if([self.mainDelegate respondsToSelector:@selector(sliderValueEndDelegateAction:)]){
            [self.mainDelegate sliderValueEndDelegateAction:self.value];
        }
    }
}

/// 更新进度条的视图状态
- (void)updateFullProgress{
    [self.fullProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.emptyProgressView);
        CGFloat middleXOfThumb = CGRectGetMidX(self.thumbImgView.frame);
        CGFloat middleXOfEmptyProgress = CGRectGetMidX(self.emptyProgressView.frame);
        CGFloat minXOfEmptyProgress = CGRectGetMinX(self.emptyProgressView.frame);
        CGFloat sitaWidth = middleXOfThumb - minXOfEmptyProgress;
        if (self.type == BKOneWaySlider) {
            sitaWidth = middleXOfThumb - minXOfEmptyProgress;
            make.centerX.mas_equalTo(sitaWidth/2 - self.emptyProgressView.width/2);
            make.width.mas_equalTo(sitaWidth);
        } else if(self.type == BKTwoWaySlider) {
            sitaWidth = middleXOfThumb - middleXOfEmptyProgress;
            CGFloat width = sitaWidth;
            if (width < 0) {
                width = -width;
            }
            make.centerX.mas_equalTo(sitaWidth/2);
            make.width.mas_equalTo(width);
        }
    }];
}

/// 更新[数值文本控件]的对应数值
- (void)updateValueLab{
    CGFloat minXOfEmptyProgress = CGRectGetMinX(self.emptyProgressView.frame);
    CGFloat maxXOfEmptyProgress = CGRectGetMaxX(self.emptyProgressView.frame);
    CGFloat currentXOfThumb = CGRectGetMidX(self.thumbImgView.frame);
    CGFloat rate = (currentXOfThumb - minXOfEmptyProgress)/(maxXOfEmptyProgress - minXOfEmptyProgress);
    CGFloat value = self.minValue + rate*(self.maxValue-self.minValue);
    
    if (self.maxValue - self.minValue < 10) {
        if ([[NSString stringWithFormat:@"%.1lf", value] isEqualToString:@"-0.0"]) {
            value = 0.0f;
        }
        self.rightValueLab.text = [NSString stringWithFormat:@"%.1lf", value];
    } else {
        if ([[NSString stringWithFormat:@"%.0lf", value] isEqualToString:@"-0"]) {
            value = 0.0f;
        }
        self.rightValueLab.text = [NSString stringWithFormat:@"%.0lf", value];
    }
    self.value = value;
}

@end
