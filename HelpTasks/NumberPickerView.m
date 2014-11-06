//
//  NumberPickerView.m
//  Helpout
//
//  Created by Phineas Lue on 11/1/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "NumberPickerView.h"

#define DATE_PICKER_HEIGHT 300.

#define BUTTON_SIZE CGSizeMake(60., 30.)

#define VERTICAL_MARGIN 20.

@interface NumberPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *numberPicker;

@end

@implementation NumberPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0., CGRectGetHeight(frame)-DATE_PICKER_HEIGHT, CGRectGetWidth(frame), DATE_PICKER_HEIGHT)];
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        doneButton.frame = CGRectMake(CGRectGetWidth(frame)-BUTTON_SIZE.width-20., 0., BUTTON_SIZE.width, BUTTON_SIZE.height);
        [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:doneButton];
        
        self.numberPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0., CGRectGetMaxY(doneButton.frame)+VERTICAL_MARGIN, CGRectGetWidth(frame), DATE_PICKER_HEIGHT-CGRectGetMaxY(doneButton.frame)-VERTICAL_MARGIN)];
        self.numberPicker.dataSource = self;
        self.numberPicker.delegate = self;
        [containerView addSubview:self.numberPicker];
    }
    
    return self;
}

#pragma mark- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

#pragma mark- UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld helper", row+1];
}

- (void)doneButtonClicked:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(numberPickerViewDidSelectNumber:)]) {
        [self.delegate numberPickerViewDidSelectNumber:[self.numberPicker selectedRowInComponent:0] + 1];
    }
    [self removeFromSuperview];
}

@end
