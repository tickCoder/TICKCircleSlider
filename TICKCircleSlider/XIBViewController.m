//
//  XIBViewController.m
//  TICKCircleSlider
//
//  Created by Server on 2016.01.22.
//  Copyright © 2016 Milk. All rights reserved.
//

#import "XIBViewController.h"
#import <CMPopTipView.h>

#import "TICKCircleSlider.h"

@interface XIBViewController () <UITextFieldDelegate, TICKCircleSliderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet TICKCircleSlider *circleSlider;
@property (weak, nonatomic) IBOutlet UITextField *minValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *gradientTextField;
@property (weak, nonatomic) IBOutlet UITextField *backWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *handleTextField;
@property (weak, nonatomic) IBOutlet UITextField *startClockTextField;
@property (weak, nonatomic) IBOutlet UITextField *endClockTextField;
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UILabel *configStatusLabel;

@property (weak, nonatomic) IBOutlet UISwitch *showDismissSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *clockwiseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *valueStepSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *imageHandleSwitch;

@property (nonatomic, strong) CMPopTipView *popTipView;

- (IBAction)helpBtnAction:(id)sender;
- (IBAction)showDismissAction:(id)sender;
- (IBAction)closewiseAction:(id)sender;
- (IBAction)changeValueAction:(id)sender;
- (IBAction)minValueBtnAction:(id)sender;
- (IBAction)maxValueBtnAction:(id)sender;
- (IBAction)gradientCountBtnAction:(id)sender;
- (IBAction)backWidthBtnAction:(id)sender;
- (IBAction)valueWidthBtnAction:(id)sender;
- (IBAction)handleSizeBtnAction:(id)sender;
- (IBAction)startClockBtnAction:(id)sender;
- (IBAction)endClockBtnAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;

@end

@implementation XIBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.circleSlider.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _configStatusLabel.text = @"";
    _minValueTextField.text = [NSString stringWithFormat:@"%d", _circleSlider.minValue];
    _maxValueTextField.text = [NSString stringWithFormat:@"%d", _circleSlider.maxValue];
    _backWidthTextField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.backWidth];
    _valueWidthTextField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.valueWidth];
    _handleTextField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.handleSize];
    _startClockTextField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.startClock];
    _endClockTextField.text = [NSString stringWithFormat:@"%.2f", _circleSlider.endClock];
    _clockwiseSwitch.on = _circleSlider.clockwise;
    _showDismissSwitch.on = _circleSlider.showMissedBack;
    _valueLabel.text = [NSString stringWithFormat:@"%d", _circleSlider.value];
    
    _valueSlider.minimumValue = _circleSlider.minValue;
    _valueSlider.maximumValue = _circleSlider.maxValue;
    _valueSlider.value = _circleSlider.value;
    _valueStepSwitch.on = _circleSlider.valueStep;
    _imageHandleSwitch.on = _circleSlider.handleImage?YES:NO;
    _gradientTextField.text = [NSString stringWithFormat:@"%d", _circleSlider.valueGradientColors.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [_minValueTextField resignFirstResponder];
    [_maxValueTextField resignFirstResponder];
    [_gradientTextField resignFirstResponder];
    [_backWidthTextField resignFirstResponder];
    [_valueWidthTextField resignFirstResponder];
    [_handleTextField resignFirstResponder];
    [_startClockTextField resignFirstResponder];
    [_endClockTextField resignFirstResponder];
}

#pragma mark - Setter & Getter
- (CMPopTipView *)popTipView {
    if (!_popTipView) {
        _popTipView = [[CMPopTipView alloc] initWithMessage:@""];
        _popTipView.dismissTapAnywhere = YES;
    }
    return _popTipView;
}


#pragma mark - Response
- (IBAction)helpBtnAction:(id)sender {
}

- (IBAction)showDismissAction:(id)sender {
    _circleSlider.showMissedBack =  _showDismissSwitch.isOn;
}

- (IBAction)closewiseAction:(id)sender {
    _circleSlider.clockwise = _clockwiseSwitch.isOn;
}

- (IBAction)changeValueAction:(id)sender {
    [self saveBtnAction:sender];
    _configStatusLabel.text = [NSString stringWithFormat:@"%@时针：从%.2f点钟到%.2f点钟", _circleSlider.clockwise?@"顺":@"逆", _circleSlider.startClock, _circleSlider.endClock];
    _valueLabel.text = [NSString stringWithFormat:@"%d", _circleSlider.value];
}

- (IBAction)saveBtnAction:(id)sender {
    CGFloat tMinValue = [_minValueTextField.text floatValue];
    CGFloat tMaxValue = [_maxValueTextField.text floatValue];
    CGFloat tBackWidth = [_backWidthTextField.text floatValue];
    CGFloat tValueWidth = [_valueWidthTextField.text floatValue];
    CGFloat tHandleSize = [_handleTextField.text floatValue];
    CGFloat tStartClock = [_startClockTextField.text floatValue];
    CGFloat tEndClock = [_endClockTextField.text floatValue];
    BOOL clockwise = _clockwiseSwitch.isOn;
    BOOL showMissed = _showDismissSwitch.isOn;
    BOOL valueStep = _valueStepSwitch.isOn;
    BOOL imageHandle = _imageHandleSwitch.isOn;
    if ([_gradientTextField.text intValue]>=2) {
        // 使用渐变色
    }
    
    _valueSlider.minimumValue = tMinValue;
    _valueSlider.maximumValue = tMaxValue;
    _circleSlider.showMissedBack = showMissed;
    _circleSlider.clockwise = clockwise;
    _circleSlider.valueStep = valueStep;
    _circleSlider.minValue = tMinValue;
    _circleSlider.maxValue = tMaxValue;
    _circleSlider.backWidth = tBackWidth;
    _circleSlider.valueWidth = tValueWidth;
    _circleSlider.handleSize = tHandleSize;
    _circleSlider.startClock = tStartClock;
    _circleSlider.endClock = tEndClock;
    if (imageHandle) {
        _circleSlider.handleImage = [UIImage imageNamed:@"handleImage"];
    } else {
        _circleSlider.handleImage = nil;
    }
    if ([_gradientTextField.text intValue] >= 2) {
        _circleSlider.valueGradient = YES;
        _circleSlider.valueGradientColors = @[[UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000],
                                              [UIColor colorWithRed:0.000 green:0.502 blue:0.502 alpha:1.000],
                                              [UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000],
                                              [UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000]];
        _circleSlider.valueGradientLocations = @[@(0), @(0.3), @(0.6), @(1.0)];
    } else {
        _circleSlider.valueGradient = NO;
        _circleSlider.valueGradientColors = nil;
        _circleSlider.valueGradientLocations = nil;
    }
    _circleSlider.value = _valueSlider.value;
}

#pragma mark info Btn
- (IBAction)minValueBtnAction:(id)sender {
    self.popTipView.message = @"最小值minValue，NSInteger，包括负数，需要比最大值小";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

- (IBAction)maxValueBtnAction:(id)sender {
    self.popTipView.message = @"最大值maxValue，NSInteger，包括负数，需要比最小值大";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

- (IBAction)gradientCountBtnAction:(id)sender {
    self.popTipView.message = @"渐变颜色数量，NSInteger（需要与渐变颜色array中的数量相等，Demo中仅使用了4种颜色）";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

- (IBAction)backWidthBtnAction:(id)sender {
    self.popTipView.message = @"背景track宽度backWidth，CGFloat，需要大于0";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

- (IBAction)valueWidthBtnAction:(id)sender {
    self.popTipView.message = @"值track宽度valueWidth，CGFloat，需要大于0";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

- (IBAction)handleSizeBtnAction:(id)sender {
    self.popTipView.message = @"handle大小handleSize，CGFloat，需要大于0";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

- (IBAction)startClockBtnAction:(id)sender {
    self.popTipView.message = @"起始钟点startClock，CGFloat，接受0-12，不可与结束钟点相同";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

- (IBAction)endClockBtnAction:(id)sender {
    self.popTipView.message = @"结束钟点encClock，CGFloat，接受0-12，不可与起始钟点相同";
    [self.popTipView presentPointingAtView:sender inView:self.view animated:YES];
}

#pragma mark - delegate
#pragma mark <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _minValueTextField) {
        [_maxValueTextField becomeFirstResponder];
    } else if (textField == _maxValueTextField) {
        [_gradientTextField becomeFirstResponder];
    } else if (textField == _gradientTextField) {
        [_backWidthTextField becomeFirstResponder];
    } else if (textField == _backWidthTextField) {
        [_valueWidthTextField becomeFirstResponder];
    } else if (textField == _valueWidthTextField) {
        [_handleTextField becomeFirstResponder];
    } else if (textField == _handleTextField) {
        [_startClockTextField becomeFirstResponder];
    } else if (textField == _startClockTextField) {
        [_endClockTextField becomeFirstResponder];
    } else if (textField == _endClockTextField) {
        [_endClockTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark <TICKCircleSliderDelegate>
- (void)endChangingOfTickCircleSlider:(TICKCircleSlider *)aSlider {
    NSLog(@"%s,%d", __PRETTY_FUNCTION__, aSlider.value);
    _valueLabel.text = [NSString stringWithFormat:@"%d", aSlider.value];
    _valueSlider.value = aSlider.value;
}

- (void)valueChangedOfTICKCircleSlider:(TICKCircleSlider *)aSlider {
    NSLog(@"%s,%d", __PRETTY_FUNCTION__, aSlider.value);
    _valueLabel.text = [NSString stringWithFormat:@"%d", aSlider.value];
    _valueSlider.value = aSlider.value;
}
@end
