//
//  DatePickerView.m
//  Helpout
//
//  Created by Phineas Lue on 11/1/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "DatePickerView.h"

#define DATE_PICKER_HEIGHT 300.

#define BUTTON_SIZE CGSizeMake(60., 30.)

#define VERTICAL_MARGIN 20.

@interface DatePickerView()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation DatePickerView

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
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0., CGRectGetMaxY(doneButton.frame)+VERTICAL_MARGIN, CGRectGetWidth(frame), DATE_PICKER_HEIGHT-CGRectGetMaxY(doneButton.frame)-VERTICAL_MARGIN)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [containerView addSubview:self.datePicker];
    }
    
    return self;
}

- (void)doneButtonClicked:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidSelectDate:)]) {
        [self.delegate datePickerViewDidSelectDate:self.datePicker.date];
    }
    [self removeFromSuperview];
}

@end
