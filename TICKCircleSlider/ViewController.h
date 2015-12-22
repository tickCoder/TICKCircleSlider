//
//  ViewController.h
//  TICKCircleSlider
//
//  Created by Milk on 2015.07.05.Sunday.
//  Copyright (c) 2015 Milk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TICKCircleSlider.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet TICKCircleSlider *circleSlider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *maxValueField;
@property (weak, nonatomic) IBOutlet UITextField *minValueField;
@property (weak, nonatomic) IBOutlet UITextField *handleSizeField;
@property (weak, nonatomic) IBOutlet UITextField *backWidthField;
@property (weak, nonatomic) IBOutlet UITextField *valueWidthField;
@property (weak, nonatomic) IBOutlet UISwitch *clockwiseSwitch;
@property (weak, nonatomic) IBOutlet UILabel *startClockLabel;
@property (weak, nonatomic) IBOutlet UISlider *startClockSlider;
@property (weak, nonatomic) IBOutlet UILabel *endClockLabel;
@property (weak, nonatomic) IBOutlet UISlider *endClockSlider;
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UISwitch *showMissedBackTrackSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stepSwitch;
- (IBAction)stepSwitchChanged:(id)sender;

- (IBAction)valueSliderValueChanged:(id)sender;
- (IBAction)startClockSliderValueChanged:(id)sender;
- (IBAction)endClockSliderValueChnaged:(id)sender;
- (IBAction)btnAction:(id)sender;

@end

