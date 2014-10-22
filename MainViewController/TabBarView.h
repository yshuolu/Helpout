//
//  TabBarView.h
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>

//
@protocol TabBarViewDelegate;

@interface TabBarView : UIView

@property (nonatomic, weak) id<TabBarViewDelegate> delegate;

@end

//
@protocol TabBarViewDelegate <NSObject>

@optional

- (void)tabSelectedAtIndex:(NSInteger)index;

- (void)addButtonClicked;

@end
