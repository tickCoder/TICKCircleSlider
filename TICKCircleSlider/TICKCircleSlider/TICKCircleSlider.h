//
//  TICKCircleSlider.h
//  TICKCircleSlider
//
//  Created by Milk on 2015.07.05.Sunday.
//  Copyright (c) 2015 Milk. All rights reserved.
//

/*
 参考：
 TB_CircularSlider: https://github.com/ariok/TB_CircularSlider
 PNChart: https://github.com/kevinzhow/PNChart
 VolumeBar: http://code4app.com/ios/Volume-Bar/513180476803fa3845000000
 */

/*
 如果handleImage(valueImage, bakcImage)!=nil, 则使用image渲染，否则
 如果handleGradient(value, back)!=nil, 则使用gradient渲染，否则
 使用纯色来渲染
 */


//TODO:back阴影选择

//TODO:value使用图片
//TODO:back使用图片

//TODO:handle渐变颜色自定义
//TODO:back简便颜色自定义

//TODO:value可以为小数、负数
//TODO:handle是否选择（即是否为progress）
//TODO:delegate提供
//TODO:默认值
//TODO:动画

//TODO:使用CALayer方式


#import <UIKit/UIKit.h>

IB_DESIGNABLE

@class TICKCircleSlider;
@protocol TICKCircleSliderDelegate <NSObject>
- (void)endChangeOfTickCircleSlider:(TICKCircleSlider *)aSlider;
@end

@interface TICKCircleSlider : UIControl

@property (nonatomic, weak) id<TICKCircleSliderDelegate> delegate;

@property (nonatomic, strong) IBInspectable UIColor *backTrackColor;
@property (nonatomic, strong) IBInspectable UIColor *valueTrackColor;
@property (nonatomic, strong) IBInspectable UIColor *handleColor;

@property (nonatomic, assign) IBInspectable NSInteger minValue;
@property (nonatomic, assign) IBInspectable NSInteger maxValue;
@property (nonatomic, assign) IBInspectable NSInteger value;

@property (nonatomic, strong) IBInspectable UIImage *backTrackImage;
@property (nonatomic, strong) IBInspectable UIImage *valueTrackImage;
@property (nonatomic, strong) IBInspectable UIImage *handleImage;

@property (nonatomic, assign) IBInspectable BOOL backTrackGradient;
@property (nonatomic, assign) IBInspectable BOOL valueTrackGradient;

@property (nonatomic, assign) IBInspectable BOOL showMissedBackTrack;
@property (nonatomic, assign) IBInspectable BOOL clockwise;

@property (nonatomic, assign) IBInspectable CGFloat backTrackWidth;
@property (nonatomic, assign) IBInspectable CGFloat valueTrackWidth;
@property (nonatomic, assign) IBInspectable CGFloat handleSize;

@property (nonatomic, assign) IBInspectable CGFloat startClock;
@property (nonatomic, assign) IBInspectable CGFloat endClock;

@property (nonatomic, assign) IBInspectable BOOL valueTrackShadowShow;
@property (nonatomic, assign) IBInspectable CGSize valueTrackShadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat valueTrackShadowBlur;
@property (nonatomic, strong) IBInspectable UIColor *valueTrackShadowColor;

@property (nonatomic, assign) IBInspectable BOOL handleShadowShow;
@property (nonatomic, assign) IBInspectable CGSize handleShadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat handleShadowBlur;
@property (nonatomic, strong) IBInspectable UIColor *handleShadowColor;

@property (nonatomic, assign) IBInspectable BOOL useShapeLayer;

@property (nonatomic, strong) NSArray *valueTrackGradientColors;
@property (nonatomic, strong) NSArray *valueTrackGradientLocations;

@property (nonatomic, assign) BOOL valueSticky;/**<是否自动跳到最近的整数值，目前无用，所有value都是整数*/
@property (nonatomic, assign) BOOL valueStep;/**<是否在每改变一个值就发送一次endChangeOfTickCircleSlider:*/

@end
