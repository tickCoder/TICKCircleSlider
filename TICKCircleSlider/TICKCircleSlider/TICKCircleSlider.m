//
//  TICKCircleSlider.m
//  TICKCircleSlider
//
//  Created by Milk on 2015.07.05.Sunday.
//  Copyright (c) 2015 Milk. All rights reserved.
//

#import "TICKCircleSlider.h"

@interface TICKCircleSlider ()
@property (nonatomic, assign) CGFloat maxTrackRadius;// handles' included

@property (nonatomic, strong) CAShapeLayer *valueTrackLayer;
@property (nonatomic, strong) CAShapeLayer *backTrackLayer;
@property (nonatomic, strong) CAShapeLayer *handleLayer;
@property (nonatomic, strong) UIBezierPath *valueTrackPath;
@property (nonatomic, strong) UIBezierPath *backTrackPath;
@property (nonatomic, strong) UIBezierPath *handlePath;
\
@end

@implementation TICKCircleSlider

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self tick_initCircleSlider];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self tick_initCircleSlider];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tick_initCircleSlider];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)prepareForInterfaceBuilder
{
    [super prepareForInterfaceBuilder];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if(![self tick_checkInitialValueValidate]) return;
    
    if(self.useShapeLayer)
    {
        // CALayer方式
        [self tick_addBackTrackShapeLayer];
        [self tick_addValueTrackShapeLayer];
        [self tick_addHandleShapeLayer];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(![self tick_checkInitialValueValidate]) return;
    
    if(!self.useShapeLayer)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self tick_drawBackTrackWithContext:ctx];
        [self tick_drawValueTrackWithContext:ctx];
        [self tick_drawHandleWithContext:ctx];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

#pragma mark UIControlEvents
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint tPoint = [touch locationInView:self];
    [self tick_moveHandleToTouchPoint:tPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark - Private
/*!
 *  @brief  检查赋予的值是否有错误
 *
 *  @return YES：无错误；NO：有错误；
 */
- (BOOL)tick_checkInitialValueValidate
{
    // 逻辑错误
    if(self.startClock<0||self.endClock<0) return NO;
    if(self.minValue!=0||self.maxValue<0||self.value<0) return NO;
    if(self.maxValue <= self.minValue) return NO;
    if(self.startClock == self.endClock) return NO;
    if(self.clockwise && self.startClock == 12 && self.endClock == 0) return NO;
    if(!self.clockwise && self.startClock == 0 && self.endClock == 12) return NO;
    
    return YES;
}

/*!
 *  @brief  初始化属性默认值
 */
- (void)tick_initCircleSlider
{
    // 填写默认属性
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backTrackColor = [UIColor whiteColor];
    self.valueTrackColor = [UIColor orangeColor];
    self.handleColor = [UIColor blueColor];
    
    self.minValue = 0;
    self.maxValue = 12;
    self.value = 5;
    
    self.backTrackImage = nil;
    self.valueTrackImage = nil;
    self.handleImage = nil;
    
    self.backTrackGradient = NO;
    self.valueTrackGradient = NO;
    
    self.showMissedBackTrack = YES;
    self.clockwise = YES;
    
    self.backTrackWidth = 12;
    self.valueTrackWidth = 6;
    self.handleSize = 8;
    
    self.startClock = 0;
    self.endClock = 12;
    
    self.valueTrackShadowShow = NO;
    self.handleShadowShow = NO;
    
    self.useShapeLayer = NO;
}

#pragma mark method0: TODO: useShapeLayer
- (void)tick_addBackTrackShapeLayer
{
    CGPoint tCircleCenter = [self tick_circleCenter];
    CGFloat tCircleRadius = self.maxTrackRadius;
    CGFloat tStartRadians = [self tick_radiansFromClock:0];
    CGFloat tEndRadians = [self tick_radiansFromClock:12];
    
    self.backTrackPath = [UIBezierPath bezierPathWithArcCenter:tCircleCenter
                                                        radius:tCircleRadius
                                                    startAngle:tStartRadians
                                                      endAngle:tEndRadians
                                                     clockwise:self.clockwise];
    self.backTrackLayer = [CAShapeLayer layer];
    _backTrackLayer.path = self.backTrackPath.CGPath;
    _backTrackLayer.lineCap = kCALineCapButt;
    _backTrackLayer.strokeColor = self.backTrackColor.CGColor;
    _backTrackLayer.fillColor = [UIColor clearColor].CGColor;
    _backTrackLayer.lineWidth = _backTrackWidth;
    _backTrackLayer.zPosition = 0;
    [self.layer addSublayer:_backTrackLayer];
}

- (void)tick_addValueTrackShapeLayer
{
    CGPoint tCircleCenter = [self tick_circleCenter];
    CGFloat tCircleRadius = self.maxTrackRadius;
    CGFloat tStartRadians = [self tick_radiansFromClock:self.startClock];
    CGFloat tEndRadians = [self tick_radiansFromClock:self.startClock];
    
    self.valueTrackPath = [UIBezierPath bezierPathWithArcCenter:tCircleCenter
                                                         radius:tCircleRadius
                                                     startAngle:tStartRadians
                                                       endAngle:tEndRadians
                                                      clockwise:self.clockwise];
    self.valueTrackLayer = [CAShapeLayer layer];
    _valueTrackLayer.path = self.valueTrackPath.CGPath;
    _valueTrackLayer.lineCap = kCALineCapButt;
    _valueTrackLayer.strokeColor = self.valueTrackColor.CGColor;
    _valueTrackLayer.fillColor = [UIColor clearColor].CGColor;
    _valueTrackLayer.lineWidth = _valueTrackWidth;
    _valueTrackLayer.zPosition = 1;
    [self.layer addSublayer:_valueTrackLayer];
}

- (void)tick_addHandleShapeLayer
{
    CGPoint tHandleCenter = [self tick_handleCenterFromValue:self.value];
    CGFloat tHandleRadius = self.handleSize / 2.0;
    
    CGPoint tHandleOrigin = CGPointMake(tHandleCenter.x-tHandleRadius, tHandleCenter.y-tHandleRadius);
    CGRect tHandleRect = CGRectMake(tHandleOrigin.x, tHandleOrigin.y, self.handleSize, self.handleSize);
    self.handlePath = [UIBezierPath bezierPathWithRoundedRect:tHandleRect cornerRadius:tHandleRadius];
    
    self.handleLayer = [CAShapeLayer layer];
    _handleLayer.path = self.handlePath.CGPath;
    _handleLayer.lineCap = kCALineCapButt;
    //_handleLayer.strokeColor = [UIColor clearColor].CGColor;
    _handleLayer.fillColor = self.handleColor.CGColor;
    _handleLayer.lineWidth = _handleSize/2.0;
    _handleLayer.zPosition = 2;
    [self.layer addSublayer:_handleLayer];
}

#pragma mark method1: !useShapeLayer
/*!
 *  @brief  绘制背景环
 *
 *  @param aCtx 上下文
 */
- (void)tick_drawBackTrackWithContext:(CGContextRef)aCtx
{
    /* Add an arc of a circle to the context's path, possibly preceded by a
     straight line segment. `(x, y)' is the center of the arc; `radius' is its
     radius; `startAngle' is the angle to the first endpoint of the arc;
     `endAngle' is the angle to the second endpoint of the arc; and
     `clockwise' is 1 if the arc is to be drawn clockwise, 0 otherwise.
     `startAngle' and `endAngle' are measured in radians. */
    
    /*
     http://stackoverflow.com/questions/16974258/cgcontextaddarc-counterclockwise-instead-of-clockwise
     
     The clockwise parameter determines the direction in which the arc is created; the actual direction of the final path is dependent on the current transformation matrix of the graphics context. For example, on iOS, a UIView flips the Y-coordinate by scaling the Y values by -1. In a flipped coordinate system, specifying a clockwise arc results in a counterclockwise arc after the transformation is applied.
     
     You can alleviate this in your code by using the transformation matrix to flip your context:
     
     CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
     CGContextScaleCTM(ctx, 1.0, -1.0);
     You probably want to flip it back when you are finished with your drawing i.e.
     
     CGContextSaveGState(ctx);
     CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
     CGContextScaleCTM(ctx, 1.0, -1.0);
     
     // Draw...
     
     CGContextRestoreGState(ctx);
     */
    
    CGFloat tCircleCenterX = self.frame.size.width/2.0;
    CGFloat tCircleCenterY = self.frame.size.height/2.0;
    CGFloat tCircleRadius = self.maxTrackRadius;
    
    CGFloat tStartRadians=0;
    CGFloat tEndRadians=0;
    if(self.showMissedBackTrack)
    {
        tStartRadians = [self tick_radiansFromClock:self.clockwise?0:12];
        tEndRadians = [self tick_radiansFromClock:self.clockwise?12:0];
    }
    else
    {
        tStartRadians = [self tick_radiansFromClock:self.startClock];
        tEndRadians = [self tick_radiansFromClock:self.endClock];
    }
    
    if(tStartRadians == tEndRadians)
    {
        if(self.clockwise) tEndRadians += M_PI * 2.0;
        else tEndRadians -= M_PI * 2.0;
    }
    
    int tClockwise = self.clockwise ? 0 : 1;
    
    CGContextAddArc(aCtx, tCircleCenterX, tCircleCenterY, tCircleRadius, tStartRadians, tEndRadians, tClockwise);
    [self.backTrackColor setStroke];
    CGContextSetLineWidth(aCtx, self.backTrackWidth);
    CGContextSetLineCap(aCtx, kCGLineCapRound);
    CGContextDrawPath(aCtx, kCGPathStroke);
}

/*!
 *  @brief  绘制Value环
 *
 *  @param aCtx 上下文
 */
- (void)tick_drawValueTrackWithContext:(CGContextRef)aCtx
{
    CGFloat tCircleCenterX = self.frame.size.width/2.0;
    CGFloat tCircleCenterY = self.frame.size.height/2.0;
    CGFloat tCircleRadius = self.maxTrackRadius;
    CGFloat tStartRadians = [self tick_radiansFromValue:self.minValue];
    CGFloat tEndRadians = [self tick_radiansFromValue:self.value];
    
    int tClockwise = self.clockwise ? 0 : 1;
    
    CGContextAddArc(aCtx, tCircleCenterX, tCircleCenterY, tCircleRadius, tStartRadians, tEndRadians, tClockwise);
    [self.valueTrackColor setStroke];
    CGContextSetLineWidth(aCtx, self.valueTrackWidth);
    CGContextSetLineCap(aCtx, kCGLineCapRound);
    
    if(self.valueTrackShadowShow && (!self.valueTrackGradientColors || self.valueTrackGradientColors.count==0))
    {
        CGContextSetShadowWithColor(aCtx, self.valueTrackShadowOffset, self.valueTrackShadowBlur, self.valueTrackShadowColor.CGColor);
    }
    CGContextDrawPath(aCtx, kCGPathStroke);
    
    if(self.valueTrackGradientColors && self.valueTrackGradientColors.count > 0)
    {
        [self tick_drawGradientWithContext:aCtx];
    }
}

/*!
 *  @brief  绘制Value渐变色
 *
 *  @param aCtx 上下文
 */
- (void)tick_drawGradientWithContext:(CGContextRef)aCtx
{
    CGFloat tCircleCenterX = self.frame.size.width/2.0;
    CGFloat tCircleCenterY = self.frame.size.height/2.0;
    CGFloat tCircleRadius = self.maxTrackRadius;
    CGFloat tStartRadians = [self tick_radiansFromValue:self.minValue];
    CGFloat tEndRadians = [self tick_radiansFromValue:self.value];
    tStartRadians = 2.0 * M_PI - tStartRadians;
    tEndRadians = 2.0 * M_PI - tEndRadians;
    
    int tClockwise = self.clockwise ? 1 : 0;
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef tImageCtx = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(tImageCtx, tCircleCenterX, tCircleCenterY, tCircleRadius, tStartRadians, tEndRadians, tClockwise);
    [[UIColor greenColor] set];
    
    if(self.valueTrackShadowShow)
    {
        CGContextSetShadowWithColor(tImageCtx, self.valueTrackShadowOffset, self.valueTrackShadowBlur, self.valueTrackShadowColor.CGColor);
    }
    
    CGContextSetLineWidth(tImageCtx, self.valueTrackWidth);
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
    NSUInteger tColorsCount = self.valueTrackGradientColors.count;
    CGColorRef tColors[tColorsCount];
    for (NSUInteger i=0; i<self.valueTrackGradientColors.count; i++)
    {
        UIColor *tUIColor = [self.valueTrackGradientColors objectAtIndex:i];
        CGColorRef tColorRef = tUIColor.CGColor;
        tColors[i] = tColorRef;
    }
    CFArrayRef tColorsArray= CFArrayCreate(kCFAllocatorDefault, (void *)tColors, (CFIndex)tColorsCount, NULL);
    
    // locations array
    CGGradientRef tGradient;
    if(self.valueTrackGradientLocations && self.valueTrackGradientLocations.count > 0)
    {
        NSUInteger tLocationsCount = self.valueTrackGradientLocations.count;
        CGFloat tLocationsArray[self.valueTrackGradientLocations.count];
        for (NSUInteger i=0; i<tLocationsCount; i++)
        {
            CGFloat tLocation = [[self.valueTrackGradientLocations objectAtIndex:i] doubleValue];
            tLocationsArray[i] = tLocation;
        }
        tGradient = CGGradientCreateWithColors(tBaseSpace, tColorsArray, tLocationsArray);
    }
    else
    {
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

/*!
 *  @brief  绘制handle
 *
 *  @param aCtx 上下文
 */
- (void)tick_drawHandleWithContext:(CGContextRef)aCtx
{
    CGContextSaveGState(aCtx);
    CGPoint tHandleCenter = [self tick_handleCenterFromValue:self.value];
    [self.handleColor set];
    
    if(self.handleShadowShow)
    {
        CGContextSetShadowWithColor(aCtx, self.handleShadowOffset, self.handleShadowBlur, self.handleShadowColor.CGColor);
    }
    
    CGRect tHandleRect = CGRectMake(tHandleCenter.x-self.handleSize/2.0, tHandleCenter.y-self.handleSize/2.0, self.handleSize, self.handleSize);
    
    if(self.handleImage)
    {
        CGImageRef image = self.handleImage.CGImage;
        CGContextDrawImage(aCtx, tHandleRect, image);
    }
    else
    {
        CGContextFillEllipseInRect(aCtx, tHandleRect);
    }

    CGContextRestoreGState(aCtx);
}

/*!
 *  @brief  根据value变化，计算handle的中心点坐标
 *
 *  @param aValue value值
 *
 *  @return handle中心点坐标
 */
- (CGPoint)tick_handleCenterFromValue:(NSInteger)aValue
{
    CGFloat tValueRadians = [self tick_radiansFromValue:aValue];
    CGPoint tCircleCenter = [self tick_circleCenter];
    
    // 返回四舍五入整数值
    // 通过圆心的直线与圆的交点A、B，与圆上任意第三点C，三点组成的三角形为直角三角形
    CGPoint tResult;
    tResult.x = roundf(tCircleCenter.x + self.maxTrackRadius*cos(tValueRadians));
    tResult.y = roundf(tCircleCenter.y + self.maxTrackRadius*sin(tValueRadians));
    
    return tResult;
}

#pragma mark move handle
/*!
 *  @brief  touch点变化时，移动handle位置
 *
 *  @param aPoint touch点
 */
- (void)tick_moveHandleToTouchPoint:(CGPoint)aPoint
{
    // 把point转化为value，clock等
    // 计算此点到圆心的直线A、与圆的交点(此点即为handle的中心点)
    CGPoint tCircleCenter = [self tick_circleCenter];
    // CGFloat tCircleRadius = self.maxTrackRadius;
    
    float tAngle = [self tick_angleFromNorthWithCenter:tCircleCenter anyPoint:aPoint];
    NSInteger tValue = roundf([self tick_valueFromAngle:tAngle]);
    
    // 防止突然跳跃
    if((tValue>self.value && tValue-self.value<(self.maxValue-self.minValue)/2.0) ||
       (tValue<self.value && self.value-tValue<(self.maxValue-self.minValue)/2.0))
    {
        self.value = tValue;
    }
    
}

/*!
 *  @brief  Slider的中心点，也是valueTrack, backTrack的中心点
 *
 *  @return 中心点
 */
- (CGPoint)tick_circleCenter
{
    CGFloat tCircleCenterX = self.frame.size.width/2.0;
    CGFloat tCircleCenterY = self.frame.size.height/2.0;
    CGPoint tCircleCenter = CGPointMake(tCircleCenterX, tCircleCenterY);
    return tCircleCenter;
}

#pragma mark convertion of clock, value, radian, angle
/*!
 *  @brief  根据clockwise判断两个clock之间经过的距离
 *
 *  @return 两个clock之间的距离（如11点到12点＋逆时针＝11.0）
 */
- (CGFloat)tick_distanceBetweenStartEndClock
{
    CGFloat tClockLength = self.endClock - self.startClock;
    if(self.clockwise)
    {
        if(tClockLength > 0) tClockLength = tClockLength;// 如顺时针3点到11点=11-3=8
        else if(tClockLength < 0) tClockLength = tClockLength + 12;// 如1顺时针0点到1点=1-10+12=3
        else tClockLength = 12;// 一个整圆0->12
    }
    else
    {
        if(tClockLength > 0) tClockLength = 12 - tClockLength;// 如逆时针3点11点=12-(11-3)=4
        else if(tClockLength < 0 ) tClockLength = fabs(tClockLength);// 如逆时针11点到3点=|3-11|=8
        else tClockLength = 12;// 一个整圆0->12
    }
    
    return tClockLength;
}

/*!
 *  @brief  将clock值转化为radians值
 *
 *  @param aClock clock值
 *
 *  @return radians值(0点:-0.5PI; 3点:0PI/2PI; 6点:0.5PI; 9点:1PI; 12点:1.5PI)
 */
- (CGFloat)tick_radiansFromClock:(CGFloat)aClock
{
    return aClock / 12.0 * M_PI * 2.0 - M_PI / 2.0;
}

/*!
 *  @brief  将clock值转化为angle值
 *
 *  @param aClock clcok值
 *
 *  @return angle值(0点:-90°; 3点:0°; 6点:90°; 9点:180°; 12点:270°)
 */
- (CGFloat)tick_angleFromClock:(CGFloat)aClock
{
    return aClock / 12.0 * 360.0 - 90.0;
}

/*!
 *  @brief  将clock值转化为value值
 *
 *  @param aClock clock值
 *
 *  @return value值([self.minValue, self.maxValue])
 */
- (CGFloat)tick_valueFromClock:(CGFloat)aClock
{
    CGFloat tClockLength = [self tick_distanceBetweenStartEndClock];
    CGFloat tClockIndex = 0;
    if(self.clockwise)
    {
        if(aClock < self.startClock) aClock += 12;// 如果目的clock小于起始clcok，则目的clock增加一圈
        tClockIndex = aClock - self.startClock;
    }
    else
    {
        // 逆时针，根据顺时针反向考虑
        // 起始点相等
        if(self.startClock == aClock) tClockIndex = 0;
        // 因为是逆时针，如果起始点>目的点,则＝起始点-目的点
        else if(self.startClock > aClock) tClockIndex = self.startClock - aClock;
        // 因为是逆时针，如果起始点<目的点,则起始点需＋12
        else tClockIndex = self.startClock + 12 - aClock;
    }
    
    // 根据tClockIndex/tClockLength = tValue/(self.maxValue-self.minValue)计算value值
    CGFloat tValue = tClockIndex * (self.maxValue-self.minValue) / tClockLength;
    return tValue;
}

/*!
 *  @brief  将value至转化为radians值
 *
 *  @param aValue value值（[self.minValue, self.maxValue]）
 *
 *  @return radians值
 */
- (CGFloat)tick_radiansFromValue:(CGFloat)aValue
{
    CGFloat tClock = [self tick_clockFromValue:aValue];
    return [self tick_radiansFromClock:tClock];
}

/*!
 *  @brief  将value转化为angle值
 *
 *  @param aValue value值（[self.minValue, self.maxValue]）
 *
 *  @return angle值
 */
- (CGFloat)tick_angleFromValue:(CGFloat)aValue
{
    CGFloat tClock = [self tick_clockFromValue:aValue];
    return [self tick_angleFromClock:tClock];
}

/*!
 *  @brief  将value转化为clock值
 *
 *  @param aValue value值（[self.minValue, self.maxValue]）
 *
 *  @return clock值
 */
- (CGFloat)tick_clockFromValue:(CGFloat)aValue
{
    CGFloat tClockLength = [self tick_distanceBetweenStartEndClock];
    // 根据tClockIndex/tClockLength = tValue/(self.maxValue-self.minValue)计算value值
    CGFloat tClockIndex = aValue * tClockLength / (self.maxValue-self.minValue);
    if(self.clockwise)
    {
        CGFloat tClock = tClockIndex + self.startClock;
        return tClock > 12 ? tClock - 12.0 : tClock;
    }
    else
    {
        CGFloat tClock = self.startClock - tClockIndex;
        return tClock < 0 ? tClock + 12.0 : tClock;
    }
}

/*!
 *  @brief  将angle值转化为clock值
 *
 *  @param aAngle angle值
 *
 *  @return clock值
 */
- (CGFloat)tick_clockFromAngle:(CGFloat)aAngle
{
    // clock/12.0 = (aAngle+90.0)/360.0
    CGFloat tClock = (aAngle + 90.0) * 12.0 / 360.0;
    return tClock > 12.0 ? tClock - 12.0 : tClock;
}

/*!
 *  @brief  将angle值转化为value值
 *
 *  @param aAngle angle值
 *
 *  @return value值
 */
- (CGFloat)tick_valueFromAngle:(CGFloat)aAngle
{
    CGFloat tClock = [self tick_clockFromAngle:aAngle];
    return [self tick_valueFromClock:tClock];
}

/*!
 *  @brief  将angle值转化为radians值
 *
 *  @param aAngle angle值
 *
 *  @return radians值
 */
- (CGFloat)tick_radiansFromAngle:(CGFloat)aAngle
{
    CGFloat tClock = [self tick_clockFromAngle:aAngle];
    return [self tick_radiansFromClock:tClock];
}

#pragma mark Radians, Angle, SQR
- (CGFloat)tick_radiansFromDegree:(CGFloat)aDegree
{
    return M_PI * aDegree / 180.0;
}

- (CGFloat)tick_degreeFromRadians:(CGFloat)aRadians
{
    return 180.0 * aRadians / M_PI;
}

- (CGFloat)tick_squareOfValue:(CGFloat)aValue
{
    return aValue * aValue;
}

/*!
 *  @brief  圆内任意一点到北部North点的夹角
 *
 *  @param aCenter 圆心
 *  @param aPoint  圆内任意一点
 *
 *  @return 夹角
 */
- (CGFloat)tick_angleFromNorthWithCenter:(CGPoint)aCenter anyPoint:(CGPoint)aPoint
{
    // Sourcecode from Apple example clockControl-some changed (static inline)
    // Calculate the direction in degrees from a center point to an arbitrary position.
    CGPoint v = CGPointMake(aPoint.x-aCenter.x,aPoint.y-aCenter.y);
    float vmag = sqrt(v.x * v.x + v.y * v.y), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = [self tick_degreeFromRadians:radians];
    return (result >=0  ? result : result + 360.0);
}

#pragma mark - Public
#pragma mark - Setter & Getter
/*!
 *  @brief  根据backTrackWidth、valueTrackWidth、handleSize大小关系，找出半径
 *
 *  @return 半径
 */
- (CGFloat)maxTrackRadius
{
    CGFloat tMinLenght = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat tMaxWidth = MAX(MAX(self.backTrackWidth, self.valueTrackWidth), self.handleSize);
    
    return tMinLenght / 2.0 - tMaxWidth / 2.0;
}

/*!
 *  @brief  value值变化时，重绘
 *
 *  @param value value值
 */
- (void)setValue:(NSInteger)value
{
    if(![self tick_checkInitialValueValidate]) return;
    if(value == _value || value > self.maxValue)
        return;
    _value = value;
    [self setNeedsDisplay];
}

/*!
 *  @brief  使用何种方式操作（目前仅使用drawRect）
 *
 *  @param useShapeLayer 是否使用shapeLayer方式
 */
- (void)setUseShapeLayer:(BOOL)useShapeLayer
{
    _useShapeLayer = NO;
}

@end