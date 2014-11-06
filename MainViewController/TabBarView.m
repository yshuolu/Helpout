//
//  TabBarView.m
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "TabBarView.h"

#define ADD_BUTTON_SIZE CGSizeMake(40., 40.)

@implementation TabBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //tab size
        CGSize tabSize = CGSizeMake(CGRectGetWidth(self.frame)/3, CGRectGetHeight(self.frame) - ADD_BUTTON_SIZE.height/2);
        
        //the blur mask
        UIVisualEffectView *blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        
        blurBackgroundView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - tabSize.height, CGRectGetWidth(self.bounds), tabSize.height);
        
        [self addSubview:blurBackgroundView];
        
        //create three tabs
        for (int i=0; i<=2; i++) {
            UIButton *tab = [UIButton buttonWithType:UIButtonTypeCustom];
            tab.frame = CGRectMake(i * tabSize.width, 0, tabSize.width, tabSize.height);
            
            //set tab title
            NSString *tabName;
            if (i==0) {
                tabName = @"My Helpouts";
            }else if (i==1){
                tabName = @"My Tasks";
            }else {
                tabName = @"Medals";
            }
            
            [tab setTitle:tabName forState:UIControlStateNormal];
            tab.titleLabel.font = [UIFont systemFontOfSize:13.];
            [tab setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [tab setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [tab setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            //add click event for tab
            [tab addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            tab.tag = i;
            
            [blurBackgroundView.contentView addSubview:tab];
        }
        
        //add button
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake( (CGRectGetWidth(self.bounds) - ADD_BUTTON_SIZE.width) / 2, 0, ADD_BUTTON_SIZE.width, ADD_BUTTON_SIZE.height);
        addButton.layer.cornerRadius = ADD_BUTTON_SIZE.width / 2;
        [addButton setImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:addButton];
    }
    
    return self;
}

- (void)tabTapped:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(tabSelectedAtIndex:)]) {
        [self.delegate tabSelectedAtIndex:button.tag];
    }
}

- (void)addButtonClicked:(UIButton*)addButton {
    if ([self.delegate respondsToSelector:@selector(addButtonClicked)]) {
        [self.delegate addButtonClicked];
    }
}

@end
