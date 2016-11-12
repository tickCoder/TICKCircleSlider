//
//  TICKCircleSlider.m
//  TICKCircleSlider
//
//  Created by Milk on 2015.07.05.Sunday.
//  Copyright (c) 2015 Milk. All rights reserved.
//

#import "TICKCircleSlider.h"

@interface TICKCircleSlider ()

/**
 *  钟点值允许的最小值，恒为0，初始化时设置
 */
@property (nonatomic, assign) CGFloat minClock;

/**
 *  钟点值允许的最小值，恒为12，初始化时设置
 */
@property (nonatomic, assign) CGFloat maxClock;

/**
 *  此View的最小边长度，以使得backTrack, valueTrack, handle都在这个范围内绘制
 */
@property (nonatomic, assign) CGFloat minEdge;

/**
 *  backTrack的半径
 */
@property (nonatomic, assign) CGFloat backTrackRadius;

/**
 *  valueTrack的半径
 */
@property (nonatomic, assign) CGFloat valueTrackRadius;

/**
 *  handle的半径
 */
@property (nonatomic, assign) CGFloat handleRadius;

/**
 *  返回backTrack, valueTrack, handleSize中最大的半径
 */
@property (nonatomic, assign) CGFloat maxRadius;

/**
 *  中点
 */
@property (nonatomic, assign) CGPoint centerPoint;

/**
 *  控制是否接受下一步移动（用于是否step，即是否每次只改变一个值）
 */
@property (nonatomic, assign) BOOL willReceiveNext;

@end

@implementation TICKCircleSlider

#pragma mark - Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _tick_initCircleSlider];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _tick_initCircleSlider];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _tick_initCircleSlider];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([self _tick_checkInitialValue]) {
        CGContextRef aCtx = UIGraphicsGetCurrentContext();
        [self _tick_drawBackTrackWithContext:aCtx];
        [self _tick_drawValueTrackWithContext:aCtx];
        [self _tick_drawHandleWithContext:aCtx];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];// 使用autolayout＋旋转屏幕时调用
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

#pragma mark UIControlEvents
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint tPoint = [touch locationInView:self];
    [self _tick_moveHandleToTouchPoint:tPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (_delegate && [_delegate respondsToSelector:@selector(valueChangedOfTICKCircleSlider:)]) {
        [_delegate valueChangedOfTICKCircleSlider:self];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    CGPoint tPrePoint = [touch previousLocationInView:self];
    CGPoint tPont = [touch locationInView:self];
    if (CGPointEqualToPoint(tPrePoint, tPont)) {
        return;
    }
    [self _tick_sendEndChangeEvent];
}

#pragma mark - Public
#pragma mark - Setter/Getter
- (void)setValue:(NSInteger)value {
    if (value < _minValue || value > _maxValue) {
        return;
    }
    _value = value;
    [self setNeedsDisplay];
}

- (CGFloat)backTrackRadius {
    return MIN(self.maxRadius, self.minEdge/2.0-_backWidth/2.0);
}

- (CGFloat)valueTrackRadius {
    return MIN(self.maxRadius, self.minEdge/2.0-_valueWidth/2.0);
}

- (CGFloat)handleRadius {
    return MIN(self.maxRadius, self.minEdge/2.0-_handleSize/2.0);
}

- (CGFloat)minEdge {
    return MIN(self.frame.size.width, self.frame.size.height);
}

- (CGFloat)maxRadius {
    CGFloat tMaxWidth = MAX(MAX(_backWidth, _valueWidth), _handleSize);
    return self.minEdge / 2.0 - tMaxWidth / 2.0;
}

- (CGPoint)centerPoint {
    CGFloat tCenterX = CGRectGetMidX(self.bounds);
    CGFloat tCenterY = CGRectGetMidY(self.bounds);
    return CGPointMake(tCenterX, tCenterY);
}

#pragma mark - Private
- (void)_tick_initCircleSlider {
    _minClock = 0;
    _maxClock = 12;
    _minValue = 0;
    _maxValue = 10;
    _value = 0;
    _startClock = _minClock;
    _endClock = _maxClock;
    _clockwise = YES;
    _showMissedBack = YES;
    _backColor = [UIColor blackColor];
    _valueColor = [UIColor greenColor];
    _handleColor = [UIColor redColor];
    _backImage = _valueImage = _handleImage = nil;
    _backGradient = _valueGradient = NO;
    _valueGradientColors = nil;
    _valueGradientLocations = nil;
    _backWidth = 20;
    _valueWidth = 10;
    _handleSize = 5;
    _willReceiveNext = YES;
    _valueStep = NO;
}

- (BOOL)_tick_checkInitialValue {
    if (_minValue >= _maxValue) return NO;
    if (_startClock == _endClock) return NO;
    if (_value < _minValue || _value > _maxValue) return NO;
    if (_startClock < _minClock || _endClock < _minClock) return NO;
    if (_startClock > _maxClock || _endClock > _maxClock) return NO;
    if (_clockwise && _startClock == 12 && _endClock == 0) return NO;
    if(!_clockwise && _startClock == 0 && _endClock == 12) return NO;
    return YES;
}

- (CGPoint)_tick_handleCenterFromValue:(NSInteger)aValue {
    CGFloat tValueClock = [self _tick_clockFromValue:aValue];
    CGFloat tValueRadians = [self _tick_radiansFromClock:tValueClock];
    CGPoint tCircleCenter = self.centerPoint;

    // 返回四舍五入整数值
    // 通过圆心的直线与圆的交点A、B，与圆上任意第三点C，三点组成的三角形为直角三角形
    CGPoint tResult;
    tResult.x = roundf(tCircleCenter.x + self.maxRadius*cos(tValueRadians));
    tResult.y = roundf(tCircleCenter.y + self.maxRadius*sin(tValueRadians));

    return tResult;
}

- (void)_tick_moveHandleToTouchPoint:(CGPoint)aPoint {
    // 把point转化为value，clock等
    // 计算此点到圆心的直线A、与圆的交点(此点即为handle的中心点)
    CGPoint tCircleCenter = self.centerPoint;

    float tAngle = [self _tick_angleFromNorthWithCenter:tCircleCenter anyPoint:aPoint];
    NSInteger tValue = roundf([self _tick_valueFromAngle:tAngle]);
    
    if (_valueStep) {
        if (!_willReceiveNext) {
            return;
        }
        // 防止突然跳跃
        if((tValue>_value && tValue-_value<(_maxValue-_minValue)/2.0) ||
           (tValue<_value && _value-tValue<(_maxValue-_minValue)/2.0)) {
            if (tValue > _value && _value < _maxValue) {
                self.willReceiveNext = NO;
                self.value = _value + 1;
                [self _tick_sendEndChangeEvent];
            } else if (tValue < _value && _value > _minValue) {
                self.willReceiveNext = NO;
                self.value = _value - 1;
                [self _tick_sendEndChangeEvent];
            }
        }
    } else {
        // 防止突然跳跃
        if((tValue>_value && tValue-_value<(_maxValue-_minValue)/2.0) ||
           (tValue<_value && _value-tValue<(_maxValue-_minValue)/2.0)) {
            self.value = tValue;
        }
    }
}

- (void)_tick_sendEndChangeEvent {
    if (!self.isTracking && _delegate && [_delegate respondsToSelector:@selector(endChangingOfTickCircleSlider:)]) {
        [_delegate endChangingOfTickCircleSlider:self];
        self.willReceiveNext = YES;
    }
}

/**
 *  圆内任意一点到北部North点的夹角
 *
 *  @param aCenter 圆心
 *  @param aPoint  圆内任意一点
 *
 *  @return 夹角
 */
- (CGFloat)_tick_angleFromNorthWithCenter:(CGPoint)aCenter anyPoint:(CGPoint)aPoint {
    // Sourcecode from Apple example clockControl with some changed (static inline)
    // Calculate the direction in degrees from a center point to an arbitrary position.
    CGPoint v = CGPointMake(aPoint.x-aCenter.x,aPoint.y-aCenter.y);
    float vmag = sqrt(v.x * v.x + v.y * v.y), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = [self _tick_degreeFromRadians:radians];
    return (result >=0  ? result : result + 360.0);
}


#pragma mark draw
/**
 *  绘制背景环
 *
 *  @param aCtx UIGraphicsGetCurrentContext()
 */
- (void)_tick_drawBackTrackWithContext:(CGContextRef)aCtx {
    CGPoint tCenter = self.centerPoint;
    CGFloat tRadius = self.backTrackRadius;
    
    CGFloat tStartRadians=0;
    CGFloat tEndRadians=0;
    if (_showMissedBack) {
        tStartRadians = [self _tick_radiansFromClock:_clockwise?0:12];
        tEndRadians = [self _tick_radiansFromClock:_clockwise?12:0];
    } else {
        tStartRadians = [self _tick_radiansFromClock:_startClock];
        tEndRadians = [self _tick_radiansFromClock:_endClock];
    }
    
    if (tStartRadians == tEndRadians) {
        if (_clockwise) {
            tEndRadians += M_PI * 2.0;
        } else {
            tEndRadians -= M_PI * 2.0;
        }
    }
    
    int tClockwise = _clockwise ? 0 : 1;
    
    CGContextAddArc(aCtx, tCenter.x, tCenter.y, tRadius, tStartRadians, tEndRadians, tClockwise);
    [_backColor setStroke];
    CGContextSetLineWidth(aCtx, _backWidth);
    CGContextSetLineCap(aCtx, kCGLineCapRound);
    CGContextDrawPath(aCtx, kCGPathStroke);
}

/**
 *  绘制value环
 *
 *  @param aCtx UIGraphicsGetCurrentContext()
 */
- (void)_tick_drawValueTrackWithContext:(CGContextRef)aCtx {
    CGPoint tCenter = self.centerPoint;
    CGFloat tRadius = self.valueTrackRadius;
    
    CGFloat tStartClock = [self _tick_clockFromValue:_minValue];
    CGFloat tEndClock = [self _tick_clockFromValue:_value];
    CGFloat tStartRadians = [self _tick_radiansFromClock:tStartClock];
    CGFloat tEndRadians = [self _tick_radiansFromClock:tEndClock];

    int tClockwise = self.clockwise ? 0 : 1;

    CGContextAddArc(aCtx, tCenter.x, tCenter.y, tRadius, tStartRadians, tEndRadians, tClockwise);
    [_valueColor setStroke];
    CGContextSetLineWidth(aCtx, _valueWidth);
    CGContextSetLineCap(aCtx, kCGLineCapRound);
    CGContextSetShouldAntialias(aCtx, YES);
    //TODO: 此处还可以有更多设置
    // 绘制阴影
    // CGContextSetShadowWithColor(aCtx, self.valueTrackShadowOffset, self.valueTrackShadowBlur, self.valueTrackShadowColor.CGColor);
    CGContextDrawPath(aCtx, kCGPathStroke);

    if(_valueGradient && _valueGradientColors.count >= 2 && _valueGradientLocations.count >= 2) {
        [self _tick_drawValueGradientWithContext:aCtx];
    }
}

/**
 *  绘制handle
 *
 *  @param aCtx UIGraphicsGetCurrentContext()
 */
- (void)_tick_drawHandleWithContext:(CGContextRef)aCtx {
    CGContextSaveGState(aCtx);
    CGPoint tHandleCenter = [self _tick_handleCenterFromValue:_value];

    CGRect tHandleRect = CGRectMake(tHandleCenter.x-_handleSize/2.0,
                                    tHandleCenter.y-_handleSize/2.0,
                                    _handleSize, _handleSize);
    if(_handleImage) {
        CGImageRef image = self.handleImage.CGImage;
        CGContextDrawImage(aCtx, tHandleRect, image);
    } else {
        [_handleColor set];
        CGContextFillEllipseInRect(aCtx, tHandleRect);
    }
    CGContextRestoreGState(aCtx);
}

- (void)_tick_drawValueGradientWithContext:(CGContextRef)aCtx {
    CGPoint tCenter = self.centerPoint;
    CGFloat tRadius = self.maxRadius;
    CGFloat tStartClock = [self _tick_clockFromValue:_minValue];
    CGFloat tEndClock = [self _tick_clockFromValue:_value];
    CGFloat tStartRadians = [self _tick_radiansFromClock:tStartClock];
    CGFloat tEndRadians = [self _tick_radiansFromClock:tEndClock];
    tStartRadians = 2.0 * M_PI - tStartRadians;
    tEndRadians = 2.0 * M_PI - tEndRadians;

    int tClockwise = self.clockwise ? 1 : 0;

    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef tImageCtx = UIGraphicsGetCurrentContext();

    CGContextAddArc(tImageCtx, tCenter.x, tCenter.y, tRadius, tStartRadians, tEndRadians, tClockwise);
    // [[UIColor greenColor] set];

    // Shadow
    // CGContextSetShadowWithColor(tImageCtx, self.valueTrackShadowOffset, self.valueTrackShadowBlur, self.valueTrackShadowColor.CGColor);

    CGContextSetLineWidth(tImageCtx, _valueWidth);
    CGContextSetLineCap(tImageCtx, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(tImageCtx, true);
    CGContextSetShouldAntialias(tImageCtx, true);
    CGContextDrawPath(tImageCtx, kCGPathStroke);

    CGImageRef tMaskImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();

    CGContextSaveGState(aCtx);

    CGContextClipToMask(aCtx, self.bounds, tMaskImage);
    CGImageRelease(tMaskImage);

    CGColorSpaceRef tBaseSpace = CGColorSpaceCreateDeviceRGB();

    // colors array
    NSUInteger tColorsCount = self.valueGradientColors.count;
    CGColorRef tColors[tColorsCount];
    for (NSUInteger i=0; i<self.valueGradientColors.count; i++) {
        UIColor *tUIColor = [self.valueGradientColors objectAtIndex:i];
        CGColorRef tColorRef = tUIColor.CGColor;
        tColors[i] = tColorRef;
    }
    CFArrayRef tColorsArray= CFArrayCreate(kCFAllocatorDefault, (void *)tColors, (CFIndex)tColorsCount, NULL);

    // locations array
    CGGradientRef tGradient;
    if(self.valueGradientLocations && self.valueGradientLocations.count > 0) {
        NSUInteger tLocationsCount = self.valueGradientLocations.count;
        CGFloat tLocationsArray[self.valueGradientLocations.count];
        for (NSUInteger i=0; i<tLocationsCount; i++) {
            CGFloat tLocation = [[self.valueGradientLocations objectAtIndex:i] doubleValue];
            tLocationsArray[i] = tLocation;
        }
        tGradient = CGGradientCreateWithColors(tBaseSpace, tColorsArray, tLocationsArray);
    } else {
        tGradient = CGGradientCreateWithColors(tBaseSpace, tColorsArray, NULL);
    }
    CGColorSpaceRelease(tBaseSpace), tBaseSpace = NULL;

    //Gradient direction
    CGRect tRect = self.bounds;
    CGPoint tStartPoint = CGPointMake(CGRectGetMidX(tRect), CGRectGetMinY(tRect));
    CGPoint tEndPoint = CGPointMake(CGRectGetMidX(tRect), CGRectGetMaxY(tRect));
    
    //Draw the gradient
    CGContextDrawLinearGradient(aCtx, tGradient, tStartPoint, tEndPoint, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(tGradient), tGradient = NULL;
    
    CGContextRestoreGState(aCtx);

}

#pragma mark convertion of clock, radians, value, angle
/**
 *  计算两个钟点值间的距离，将顺时针、逆时针考虑在内
 *
 *  @param aStartClock 起始钟点值
 *  @param aEndClock   结束钟点值
 *  @param aClockwise  顺时针或逆时针
 *
 *  @return 距离，恒大于0
 */
- (CGFloat)_tick_distanceBetweenClocks {
    if (fabs(_startClock - _endClock) == 12.0) {
        return 12.0;
    }
    
    /*
     如果是逆时针，将其转为顺时针方式，如：start3点到end11点转为t_start11点到t_end3点
     若t_start>t_end,则length为(12-11)+3及(12-t_start)+t_end
     若t_start<t_end,则length为t_end-t_start
     如果是顺时针，参上
     */
    CGFloat tLength = 0.0;
    CGFloat tStart = _startClock;
    CGFloat tEnd = _endClock;
    if (!_clockwise) {
        tStart = _endClock;
        tEnd = _startClock;
    }
    if (tStart > tEnd) {
        tLength = (12.0 - tStart) + tEnd;
    } else {
        tLength = tEnd -  tStart;
    }
    return tLength;
}

/**
 *  将钟点数，如6:30(6.5)转为弧度radians(0:-0.5PI; 3:0PI/2PI; 6:0.5PI; 9:1PI; 12:1.5PI)
 *
 *  @param aClock 钟点数
 *
 *  @return 弧度
 */
- (CGFloat)_tick_radiansFromClock:(CGFloat)aClock {
    return aClock / 12.0 * M_PI * 2.0 - M_PI / 2.0;
}

/**
 *  将Value值（如0.3）转为钟点值
 *
 *  @param aValue value值
 *
 *  @return 钟点值
 */
- (CGFloat)_tick_clockFromValue:(CGFloat)aValue {
    CGFloat tClockLength = [self _tick_distanceBetweenClocks];
    // 根据tClockIndex/tClockLength = tValue/(self.maxValue-self.minValue)计算value值
    CGFloat tClockIndex = (aValue-_minValue) * tClockLength / (_maxValue - _minValue);
    if(_clockwise) {
        CGFloat tClock = tClockIndex + _startClock;
        return tClock > 12 ? tClock - 12.0 : tClock;
    } else {
        CGFloat tClock = _startClock - tClockIndex;
        return tClock < 0 ? tClock + 12.0 : tClock;
    }
}

- (CGFloat)_tick_degreeFromRadians:(CGFloat)aRadians {
    return 180.0 * aRadians / M_PI;
}

- (CGFloat)_tick_valueFromAngle:(CGFloat)aAngle {
    CGFloat tClock = [self _tick_clockFromAngle:aAngle];
    return [self _tick_valueFromClock:tClock];
}

- (CGFloat)_tick_clockFromAngle:(CGFloat)aAngle {
    // clock/12.0 = (aAngle+90.0)/360.0
    CGFloat tClock = (aAngle + 90.0) * 12.0 / 360.0;
    return tClock > 12.0 ? tClock - 12.0 : tClock;
}

- (CGFloat)_tick_valueFromClock:(CGFloat)aClock {
    CGFloat tClockLength = [self _tick_distanceBetweenClocks];
    CGFloat tClockIndex = 0;
    if(_clockwise) {
        if(aClock < _startClock) aClock += 12;// 如果目的clock小于起始clcok，则目的clock增加一圈
        tClockIndex = aClock - _startClock;
    } else {
        // 逆时针，根据顺时针反向考虑
        // 起始点相等
        if(_startClock == aClock) tClockIndex = 0;
        // 因为是逆时针，如果起始点>目的点,则＝起始点-目的点
        else if(_startClock > aClock) tClockIndex = _startClock - aClock;
        // 因为是逆时针，如果起始点<目的点,则起始点需＋12
        else tClockIndex = _startClock + 12 - aClock;
    }
    NSLog(@"aClock:%.2f", tClockIndex);

    // 根据tClockIndex/tClockLength = tValueIndex/(self.maxValue-self.minValue)计算value值
    // clockIndex/clockLength = valueIndex/valueLength
    CGFloat tValueIndex = tClockIndex / tClockLength * (_maxValue-_minValue) ;
    CGFloat tValue = tValueIndex + _minValue;
    return tValue;
}

#pragma mark - OLD OLD OLD OLD
#pragma mark TODO: shapeLayer 示例
- (void)_tick_shapeLayerExample
{
    CGPoint tCircleCenter = self.centerPoint;
    CGFloat tCircleRadius = self.maxRadius;
    CGFloat tStartRadians = [self _tick_radiansFromClock:0];
    CGFloat tEndRadians = [self _tick_radiansFromClock:12];
    
    UIBezierPath *backTrackPath = [UIBezierPath bezierPathWithArcCenter:tCircleCenter
                                                        radius:tCircleRadius
                                                    startAngle:tStartRadians
                                                      endAngle:tEndRadians
                                                      clockwise:self.clockwise];
    CAShapeLayer *backTrackLayer = [CAShapeLayer layer];
    backTrackLayer.path = backTrackPath.CGPath;
    backTrackLayer.lineCap = kCALineCapButt;
    backTrackLayer.strokeColor = _backColor.CGColor;
    backTrackLayer.fillColor = [UIColor clearColor].CGColor;
    backTrackLayer.lineWidth = _backWidth;
    backTrackLayer.zPosition = 0;
    [self.layer addSublayer:backTrackLayer];
}

//
///*!
// *  @brief  绘制Value渐变色
// *
// *  @param aCtx 上下文
// */
//- (void)tick_drawGradientWithContext:(CGContextRef)aCtx
//{
//    CGFloat tCircleCenterX = self.frame.size.width/2.0;
//    CGFloat tCircleCenterY = self.frame.size.height/2.0;
//    CGFloat tCircleRadius = self.maxTrackRadius;
//    CGFloat tStartRadians = [self tick_radiansFromValue:self.minValue];
//    CGFloat tEndRadians = [self tick_radiansFromValue:self.value];
//    tStartRadians = 2.0 * M_PI - tStartRadians;
//    tEndRadians = 2.0 * M_PI - tEndRadians;
//    
//    int tClockwise = self.clockwise ? 1 : 0;
//    
//    UIGraphicsBeginImageContext(self.frame.size);
//    CGContextRef tImageCtx = UIGraphicsGetCurrentContext();
//    
//    CGContextAddArc(tImageCtx, tCircleCenterX, tCircleCenterY, tCircleRadius, tStartRadians, tEndRadians, tClockwise);
//    [[UIColor greenColor] set];
//    
//    if(self.valueTrackShadowShow)
//    {
//        CGContextSetShadowWithColor(tImageCtx, self.valueTrackShadowOffset, self.valueTrackShadowBlur, self.valueTrackShadowColor.CGColor);
//    }
//    
//    CGContextSetLineWidth(tImageCtx, self.valueTrackWidth);
//    CGContextSetLineCap(tImageCtx, kCGLineCapRound);
//    CGContextSetAllowsAntialiasing(tImageCtx, true);
//    CGContextSetShouldAntialias(tImageCtx, true);
//    CGContextDrawPath(tImageCtx, kCGPathStroke);
//
//    CGImageRef tMaskImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
//    UIGraphicsEndImageContext();
//
//    CGContextSaveGState(aCtx);
//    
//    CGContextClipToMask(aCtx, self.bounds, tMaskImage);
//    CGImageRelease(tMaskImage);
//    
//    CGColorSpaceRef tBaseSpace = CGColorSpaceCreateDeviceRGB();
//    
//    // colors array
//    NSUInteger tColorsCount = self.valueTrackGradientColors.count;
//    CGColorRef tColors[tColorsCount];
//    for (NSUInteger i=0; i<self.valueTrackGradientColors.count; i++)
//    {
//        UIColor *tUIColor = [self.valueTrackGradientColors objectAtIndex:i];
//        CGColorRef tColorRef = tUIColor.CGColor;
//        tColors[i] = tColorRef;
//    }
//    CFArrayRef tColorsArray= CFArrayCreate(kCFAllocatorDefault, (void *)tColors, (CFIndex)tColorsCount, NULL);
//    
//    // locations array
//    CGGradientRef tGradient;
//    if(self.valueTrackGradientLocations && self.valueTrackGradientLocations.count > 0)
//    {
//        NSUInteger tLocationsCount = self.valueTrackGradientLocations.count;
//        CGFloat tLocationsArray[self.valueTrackGradientLocations.count];
//        for (NSUInteger i=0; i<tLocationsCount; i++)
//        {
//            CGFloat tLocation = [[self.valueTrackGradientLocations objectAtIndex:i] doubleValue];
//            tLocationsArray[i] = tLocation;
//        }
//        tGradient = CGGradientCreateWithColors(tBaseSpace, tColorsArray, tLocationsArray);
//    }
//    else
//    {
//        tGradient = CGGradientCreateWithColors(tBaseSpace, tColorsArray, NULL);
//    }
//    
//    CGColorSpaceRelease(tBaseSpace), tBaseSpace = NULL;
//    
//    //Gradient direction
//    CGRect tRect = self.bounds;
//    CGPoint tStartPoint = CGPointMake(CGRectGetMidX(tRect), CGRectGetMinY(tRect));
//    CGPoint tEndPoint = CGPointMake(CGRectGetMidX(tRect), CGRectGetMaxY(tRect));
//    
//    //Draw the gradient
//    CGContextDrawLinearGradient(aCtx, tGradient, tStartPoint, tEndPoint, kCGGradientDrawsBeforeStartLocation);
//    CGGradientRelease(tGradient), tGradient = NULL;
//    
//    CGContextRestoreGState(aCtx);
//}
//


///*!
// *  @brief  将clock值转化为radians值
// *
// *  @param aClock clock值
// *
// *  @return radians值(0点:-0.5PI; 3点:0PI/2PI; 6点:0.5PI; 9点:1PI; 12点:1.5PI)
// */
//- (CGFloat)tick_radiansFromClock:(CGFloat)aClock
//{
//    return aClock / 12.0 * M_PI * 2.0 - M_PI / 2.0;
//}
//
///*!
// *  @brief  将clock值转化为angle值
// *
// *  @param aClock clcok值
// *
// *  @return angle值(0点:-90°; 3点:0°; 6点:90°; 9点:180°; 12点:270°)
// */
//- (CGFloat)tick_angleFromClock:(CGFloat)aClock
//{
//    return aClock / 12.0 * 360.0 - 90.0;
//}
//
///*!
// *  @brief  将clock值转化为value值
// *
// *  @param aClock clock值
// *
// *  @return value值([self.minValue, self.maxValue])
// */
//- (CGFloat)tick_valueFromClock:(CGFloat)aClock
//{
//    CGFloat tClockLength = [self tick_distanceBetweenStartEndClock];
//    CGFloat tClockIndex = 0;
//    if(self.clockwise)
//    {
//        if(aClock < self.startClock) aClock += 12;// 如果目的clock小于起始clcok，则目的clock增加一圈
//        tClockIndex = aClock - self.startClock;
//    }
//    else
//    {
//        // 逆时针，根据顺时针反向考虑
//        // 起始点相等
//        if(self.startClock == aClock) tClockIndex = 0;
//        // 因为是逆时针，如果起始点>目的点,则＝起始点-目的点
//        else if(self.startClock > aClock) tClockIndex = self.startClock - aClock;
//        // 因为是逆时针，如果起始点<目的点,则起始点需＋12
//        else tClockIndex = self.startClock + 12 - aClock;
//    }
//    
//    // 根据tClockIndex/tClockLength = tValue/(self.maxValue-self.minValue)计算value值
//    CGFloat tValue = tClockIndex * (self.maxValue-self.minValue) / tClockLength;
//    return tValue;
//}
//
///*!
// *  @brief  将value至转化为radians值
// *
// *  @param aValue value值（[self.minValue, self.maxValue]）
// *
// *  @return radians值
// */
//- (CGFloat)tick_radiansFromValue:(CGFloat)aValue
//{
//    CGFloat tClock = [self tick_clockFromValue:aValue];
//    return [self tick_radiansFromClock:tClock];
//}
//
///*!
// *  @brief  将value转化为angle值
// *
// *  @param aValue value值（[self.minValue, self.maxValue]）
// *
// *  @return angle值
// */
//- (CGFloat)tick_angleFromValue:(CGFloat)aValue
//{
//    CGFloat tClock = [self tick_clockFromValue:aValue];
//    return [self tick_angleFromClock:tClock];
//}
//
///*!
// *  @brief  将value转化为clock值
// *
// *  @param aValue value值（[self.minValue, self.maxValue]）
// *
// *  @return clock值
// */
//- (CGFloat)tick_clockFromValue:(CGFloat)aValue
//{
//    CGFloat tClockLength = [self tick_distanceBetweenStartEndClock];
//    // 根据tClockIndex/tClockLength = tValue/(self.maxValue-self.minValue)计算value值
//    CGFloat tClockIndex = aValue * tClockLength / (self.maxValue-self.minValue);
//    if(self.clockwise)
//    {
//        CGFloat tClock = tClockIndex + self.startClock;
//        return tClock > 12 ? tClock - 12.0 : tClock;
//    }
//    else
//    {
//        CGFloat tClock = self.startClock - tClockIndex;
//        return tClock < 0 ? tClock + 12.0 : tClock;
//    }
//}
//
///*!
// *  @brief  将angle值转化为clock值
// *
// *  @param aAngle angle值
// *
// *  @return clock值
// */
//- (CGFloat)tick_clockFromAngle:(CGFloat)aAngle
//{
//    // clock/12.0 = (aAngle+90.0)/360.0
//    CGFloat tClock = (aAngle + 90.0) * 12.0 / 360.0;
//    return tClock > 12.0 ? tClock - 12.0 : tClock;
//}
//
///*!
// *  @brief  将angle值转化为value值
// *
// *  @param aAngle angle值
// *
// *  @return value值
// */
//- (CGFloat)tick_valueFromAngle:(CGFloat)aAngle
//{
//    CGFloat tClock = [self tick_clockFromAngle:aAngle];
//    return [self tick_valueFromClock:tClock];
//}
//
///*!
// *  @brief  将angle值转化为radians值
// *
// *  @param aAngle angle值
// *
// *  @return radians值
// */
//- (CGFloat)tick_radiansFromAngle:(CGFloat)aAngle
//{
//    CGFloat tClock = [self tick_clockFromAngle:aAngle];
//    return [self tick_radiansFromClock:tClock];
//}
//
//#pragma mark Radians, Angle, SQR
//- (CGFloat)tick_radiansFromDegree:(CGFloat)aDegree
//{
//    return M_PI * aDegree / 180.0;
//}
//
//- (CGFloat)tick_degreeFromRadians:(CGFloat)aRadians
//{
//    return 180.0 * aRadians / M_PI;
//}
//
//- (CGFloat)tick_squareOfValue:(CGFloat)aValue
//{
//    return aValue * aValue;
//}



@end
