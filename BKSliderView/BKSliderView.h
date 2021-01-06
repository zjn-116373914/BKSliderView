//
//  BKSliderView.h
//  MainTestProgram
//
//  Created by biggerlens on 2021/1/5.
//  Copyright © 2021 zjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKSliderView : UIView
/// 滑动条类型的枚举
typedef NS_ENUM(NSInteger, BKSliderType) {
    BKOneWaySlider,///<单向滑动条控件(最左端为0,只能向右单向滑动)
    BKTwoWaySlider,///<双向滑动条控件(中间为0,可分别向左右两边滑动)
};
/// 初始化对象
/// @param title 滑动条控件的标题
/// @param type 滑动条类型
/// @param minValue 最小值
/// @param maxValue 最大值
+ (instancetype)customByTitle:(NSString*)title
                         type:(BKSliderType)type
                     minValue:(CGFloat)minValue
                     maxValue:(CGFloat)maxValue;
/// 设置滑动条的数值
/// @param value 数值
- (void)setValueOfSlider:(CGFloat)value;

/// 滑动条类型
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
@end

NS_ASSUME_NONNULL_END
