//
//  TICKCircleSlider.h
//  TICKCircleSlider
//
//  Created by Milk on 2015.07.05.Sunday.
//  Copyright (c) 2015 Milk. All rights reserved.
//

/*
 参考Reference：
 TB_CircularSlider: https://github.com/ariok/TB_CircularSlider
 PNChart: https://github.com/kevinzhow/PNChart
 VolumeBar: http://code4app.com/ios/Volume-Bar/513180476803fa3845000000
 */

/*
 如果handleImage(valueImage, bakcImage)!=nil, 则使用image渲染，否则
 如果handleGradient(value, back)!=nil, 则使用gradient渲染，否则
 使用纯色来渲染
 */

//TODO: 阴影设置（back，value，handle），阴影时是否将其大小考虑到radius计算中
//TODO: 使用图片（back，value，handle），如带渐变颜色的图片
//TODO: 渐变颜色自定义（back，value，handle）
//TODO: handle是否可交互（即是否为progress）
//TODO: 动画优化（尤其是旋转更改大小时）
//TODO: 使用CALayer方式是否更好
//TODO: 加入起始点标志
//TODO: handle遮盖的内容不显示
//TODO: 起始钟点和结束钟点相同处理(需要考虑越过最大最小值分割点时的处理)
//TODO: 是否允许最大值后越过分割点变为最大值(目前不允许)
//TODO: 渐变色沿着路径绘制
//TODO: __unavailable标示的内容需要完善
//TODO: 自定义渐变颜色起始结束点
//TODO: 边角样式自定义
//TODO: 需要验证其他方式初始化时是否异常


#import <UIKit/UIKit.h>

@class TICKCircleSlider;
@protocol TICKCircleSliderDelegate <NSObject>
@optional
/**
 *  手指离开时或在valueStep时每次一改变就调用，不再继续滑动
 */
- (void)endChangingOfTickCircleSlider:(TICKCircleSlider *)aSlider;

/**
 *  当值改变时（此时设置userInterfaceEnable＝NO后还是可以滑动）
 */
- (void)valueChangedOfTICKCircleSlider:(TICKCircleSlider *)aSlider;
@end

//IB_DESIGNABLE 需要放在@interface前
IB_DESIGNABLE
@interface TICKCircleSlider : UIControl

@property (nonatomic, weak) id<TICKCircleSliderDelegate> delegate;

/**
 *  最小值，接受负数
 */
@property (nonatomic, assign) IBInspectable NSInteger minValue;

/**
 *  最大值，接受负数
 */
@property (nonatomic, assign) IBInspectable NSInteger maxValue;

/**
 *  当前值，接受负数，需要再最大最小值之间
 */
@property (nonatomic, assign) IBInspectable NSInteger value;

/**
 *  起始钟点值，如6:30为6.5, 共0-12个小时
 */
@property (nonatomic, assign) IBInspectable CGFloat startClock;

/**
 *  结束钟点值，如4:30为4.5, 共0-12个小时
 */
@property (nonatomic, assign) IBInspectable CGFloat endClock;

/**
 *  滑动方向，顺时针或逆时针
 */
@property (nonatomic, assign) IBInspectable BOOL clockwise;

/**
 *  如果设为yes，则背景环全部显示，否则只显示startClock到endClock之间的背景环
 */
@property (nonatomic, assign) IBInspectable BOOL showMissedBack;

/**
 *  背景环颜色，如果设置了背景图片，则此颜色忽略
 */
@property (nonatomic, strong) IBInspectable UIColor *backColor;

/**
 *  值环颜色，如果设置了值图片，则此颜色忽略
 */
@property (nonatomic, strong) IBInspectable UIColor *valueColor;

/**
 *  操控点颜色，如果设置了操控点图片，则此颜色忽略
 */
@property (nonatomic, strong) IBInspectable UIColor *handleColor;

/**
 *  背景环图片
 */
@property (nonatomic, strong) IBInspectable UIImage *backImage __unavailable;

/**
 *  值环图片
 */
@property (nonatomic, strong) IBInspectable UIImage *valueImage __unavailable;

/**
 *  操控点图片
 */
@property (nonatomic, strong) IBInspectable UIImage *handleImage;

/**
 *  如果为YES，则背景环使用渐变色，否则使用背景环图片或单一颜色
 */
@property (nonatomic, assign) IBInspectable BOOL backGradient __unavailable;

/**
 *  如果为YES，则值环使用渐变色，否则使用值环图片或单一颜色
 */
@property (nonatomic, assign) IBInspectable BOOL valueGradient;

/**
 *  值环渐变色数组，需要与值环渐变颜色位置数组valueGradientLocations中元素个数相同
 */
@property (nonatomic, strong) NSArray <__kindof UIColor*> *valueGradientColors;

/**
 *  值环渐变色位置数组(CGFloat, 0.0~1.0)，需要与值环渐变颜色数组valueGradientColors中元素个数相同
 */
@property (nonatomic, strong) NSArray <__kindof NSNumber*> *valueGradientLocations;

/**
 *  背景环宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat backWidth;

/**
 *  值环宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat valueWidth;

/**
 *  操控点大小
 */
@property (nonatomic, assign) IBInspectable CGFloat handleSize;

/**
 *  是否使用shapeLayer方式
 */
@property (nonatomic, assign) IBInspectable BOOL useShapeLayer __unavailable;

/**
 *  如果YES，则每次只能递增或递减一个NSInteger值(适合在值改变一个NSInteger后不允许继续滑动的情况)，使用setValue方式无效
 */
@property (nonatomic, assign) IBInspectable BOOL valueStep;

@end
