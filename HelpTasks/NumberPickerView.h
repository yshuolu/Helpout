//
//  NumberPickerView.h
//  Helpout
//
//  Created by Phineas Lue on 11/1/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberPickerViewDelegate;
@interface NumberPickerView : UIView

@property (nonatomic, weak) id<NumberPickerViewDelegate> delegate;

@end

@protocol NumberPickerViewDelegate <NSObject>

- (void)numberPickerViewDidSelectNumber:(NSInteger)number;

@end