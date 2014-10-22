//
//  SearchBarView.h
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchBarViewDelegate;

@interface SearchBarView : UIView

@property (nonatomic, weak) id<SearchBarViewDelegate> delegate;

@end

@protocol SearchBarViewDelegate <NSObject>

- (void)moreButtonClicked;

- (void)refreshButtonClicked;

@end
