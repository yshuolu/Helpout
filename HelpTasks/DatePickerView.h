//
//  DatePickerView.h
//  Helpout
//
//  Created by Phineas Lue on 11/1/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate;
@interface DatePickerView : UIView

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;

@end

@protocol DatePickerViewDelegate <NSObject>

- (void)datePickerViewDidSelectDate:(NSDate*)date;

@end