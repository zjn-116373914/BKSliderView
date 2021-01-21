//
//  BKSliderView.h
//  MainTestProgram
//
//  Created by biggerlens on 2021/1/5.
//  Copyright © 2021 zjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 滑动条控件的协议
@protocol BKSliderViewProtocol <NSObject>
/// 滑动条数值改变[过程中]的响应事件
- (void)sliderValueInChangeDelegateAction:(CGFloat)value;

/// 滑动条数值改变[结束后]的响应事件
- (void)sliderValueEndDelegateAction:(CGFloat)value;
@end

@interface BKSliderView : UIView
/// 滑动条类型的枚举
typedef NS_ENUM(NSInteger, BKSliderType) {
    BKOneWaySlider,///<单向滑动条控件(最左端为0,只能向右单向滑动)
    BKTwoWaySlider,///<双向滑动条控件(中间为0,可分别向左右两边滑动)
};
/// 初始化对象
/// @param type 滑动条类型
/// @param title 滑动条控件的标题
/// @param minValue 最小值
/// @param maxValue 最大值
+ (instancetype)customByType:(BKSliderType)type
                       title:(NSString*)title
                    minValue:(CGFloat)minValue
                    maxValue:(CGFloat)maxValue;
/// 改变滑动条的样式
/// @param type 样式类型
/// @param minValue 最小值
/// @param maxValue 最大值
- (void)setStyleByType:(BKSliderType)type
              minValue:(CGFloat)minValue
              maxValue:(CGFloat)maxValue;

/// 设置滑动条拖动图标
/// @param imageName 图标名称
-(void)setThumbIconByImageName:(NSString *)imageName;

/// 设置滑动条的数值
/// @param value 数值
- (void)setValueOfSlider:(CGFloat)value;
/// 滑动条样式类型
@property(nonatomic, assign, readonly) BKSliderType type;
/// [左侧][标题]文本控件
@property(nonatomic, strong) UILabel *leftTitleLab;
/// [右侧][数值]文本控件
@property(nonatomic, strong) UILabel *rightValueLab;
/// 最大值
@property(nonatomic, assign) CGFloat maxValue;
/// 最小值
@property(nonatomic, assign) CGFloat minValue;
/// 滑动条的数值
@property(nonatomic, assign, readonly) CGFloat value;
/// 滑动条控件的代理对象
@property (nonatomic, assign) id<BKSliderViewProtocol> mainDelegate;
@end

NS_ASSUME_NONNULL_END
