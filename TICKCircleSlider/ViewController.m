//
//  ViewController.m
//  TICKCircleSlider
//
//  Created by Milk on 2015.07.05.Sunday.
//  Copyright (c) 2015 Milk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate, TICKCircleSliderDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.circleSlider.backgroundColor = [UIColor grayColor];
//    self.circleSlider.opaque = NO;
//    self.circleSlider.value = 10;
//    self.circleSlider.maxValue = 15;
//    self.circleSlider.minValue = 0;
//    
//    self.circleSlider.clockwise = YES;
//    self.circleSlider.startClock = 6.9;
//    self.circleSlider.endClock = 5.1;
//    
//    self.circleSlider.showMissedBackTrack = NO;
//    
//    self.circleSlider.handleSize = 26;
//    self.circleSlider.backTrackWidth = 8;
//    self.circleSlider.valueTrackWidth = 10;
//    self.circleSlider.valueTrackGradient = YES;
//    
//    self.circleSlider.useShapeLayer = NO;
//    
//    self.circleSlider.handleColor = [UIColor redColor];
//    self.circleSlider.backTrackColor = [UIColor whiteColor];
//    self.circleSlider.valueTrackColor = [UIColor orangeColor];
//    [self.circleSlider addTarget:self action:@selector(circleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    
//    self.circleSlider.valueTrackGradientColors = @[[UIColor greenColor], [UIColor blueColor], [UIColor orangeColor]];
//    self.circleSlider.valueTrackGradientLocations = @[@(0.1), @(0.7), @(0.9)];
//    
//    self.circleSlider.valueTrackShadowShow = YES;
//    self.circleSlider.valueTrackShadowBlur = 10;
//    self.circleSlider.valueTrackShadowColor = [UIColor blackColor];
//    self.circleSlider.valueTrackShadowOffset = CGSizeMake(0, 0);
//    
//    self.circleSlider.handleShadowBlur = 10;
//    self.circleSlider.handleShadowShow = YES;
//    self.circleSlider.handleShadowColor = [UIColor purpleColor];
//    self.circleSlider.handleShadowOffset = CGSizeMake(0, 5);
    
    [self.circleSlider addTarget:self action:@selector(circleSliderValueChangedEnd:) forControlEvents:UIControlEventValueChanged];
    [self.circleSlider addTarget:self action:@selector(outtouch:) forControlEvents:UIControlEventTouchDragExit];
    [self.circleSlider addTarget:self action:@selector(endTracking:) forControlEvents:-100];
    self.circleSlider.delegate = self;
    self.circleSlider.valueStep = _stepSwitch.isOn;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadCircleSliderStatus];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TEMP

#pragma mark - Private
- (void)reloadCircleSliderStatus
{
    self.valueSlider.maximumValue = _circleSlider.maxValue;
    self.valueSlider.minimumValue = _circleSlider.minValue;
    self.valueSlider.value = _circleSlider.value;
    
    self.valueLabel.text = [NSString stringWithFormat:@"value:%ld", (long)_circleSlider.value];
    self.maxValueField.text = [NSString stringWithFormat:@"%ld", (long)_circleSlider.maxValue];
    self.minValueField.text = [NSString stringWithFormat:@"%ld", (long)_circleSlider.minValue];
    
    self.handleSizeField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.handleSize];
    self.backWidthField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.backTrackWidth];
    self.valueWidthField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.valueTrackWidth];
    
    self.clockwiseSwitch.on = _circleSlider.clockwise;
    self.showMissedBackTrackSwitch.on = _circleSlider.showMissedBackTrack;
    self.startClockLabel.text = [NSString stringWithFormat:@"startClock:%.2f", _circleSlider.startClock];
    self.startClockSlider.value = _circleSlider.startClock;
    self.endClockLabel.text = [NSString stringWithFormat:@"endClock:%.2f", _circleSlider.endClock];
    self.endClockSlider.value = _circleSlider.endClock;
}

- (IBAction)btnAction:(id)sender
{
    // 改变参数，保存变化
    
    int value = (int)self.valueSlider.value;
    int maxValue = [self.maxValueField.text intValue];
    int minValue = [self.minValueField.text intValue];
    
    CGFloat handleSize = [self.handleSizeField.text floatValue];
    CGFloat backWidth = [self.backWidthField.text floatValue];
    CGFloat valueWidth = [self.valueWidthField.text floatValue];
    
    BOOL clockwise = self.clockwiseSwitch.isOn;
    BOOL showMissed = self.showMissedBackTrackSwitch.isOn;
    CGFloat startClock = self.startClockSlider.value;
    CGFloat endClock = self.endClockSlider.value;
    
    _circleSlider.maxValue = maxValue;
    _circleSlider.minValue = minValue;
    _circleSlider.handleSize = handleSize;
    _circleSlider.backTrackWidth = backWidth;
    _circleSlider.valueTrackWidth = valueWidth;
    _circleSlider.clockwise = clockwise;
    _circleSlider.showMissedBackTrack = showMissed;
    _circleSlider.startClock = startClock;
    _circleSlider.endClock = endClock;
    
    _circleSlider.value = value;
    // [_circleSlider layoutIfNeeded];
    
    [self reloadCircleSliderStatus];
}
- (IBAction)stepSwitchChanged:(id)sender {
    self.circleSlider.valueStep = _stepSwitch.isOn;
}

- (IBAction)valueSliderValueChanged:(id)sender
{
    int value = (int)self.valueSlider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"value:%.f", self.valueSlider.value];
    _circleSlider.value = value;
}

- (IBAction)startClockSliderValueChanged:(id)sender
{
    self.startClockLabel.text = [NSString stringWithFormat:@"startClock:%.2f", _startClockSlider.value];
}

- (IBAction)endClockSliderValueChnaged:(id)sender
{
   self.endClockLabel.text = [NSString stringWithFormat:@"endClock:%.2f", _endClockSlider.value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)circleSliderValueChanged:(TICKCircleSlider *)aSender
{
    [self reloadCircleSliderStatus];
}

- (void)circleSliderValueChangedEnd:(TICKCircleSlider *)aSender {
    //NSLog(@"end: %d", aSender.value);
}

- (void)outtouch:(TICKCircleSlider *)aSender {
    //NSLog(@"outtouch");
}

- (void)endTracking:(TICKCircleSlider *)aSender {
    //NSLog(@"endTracking out");
}

- (void)endChangeOfTickCircleSlider:(TICKCircleSlider *)aSlider {
    NSLog(@"endChangeOfTickCircleSlider:%d", aSlider.value);
    //aSlider.userInteractionEnabled = NO;
    //[self performSelector:@selector(delay) withObject:nil afterDelay:5.0];
    aSlider;
}

- (void)delay {
    //_circleSlider.userInteractionEnabled = YES;
}


@end
