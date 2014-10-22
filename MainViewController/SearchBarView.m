//
//  SearchBarView.m
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "SearchBarView.h"

#define SETTING_ITEM_TAG 8888
#define REFRESH_ITEM_TAG 8889

@implementation SearchBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //
        UIVisualEffectView *blurMaskView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        blurMaskView.frame = self.bounds;
        [self addSubview:blurMaskView];

        //add UIToolBar
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.bounds), 44)];
        //set toolbar transparent
        [toolBar setShadowImage:[UIImage alloc] forToolbarPosition:UIBarPositionAny];
        [toolBar setBackgroundImage:[UIImage alloc] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarItemClicked:)];
        settingItem.tag = SETTING_ITEM_TAG;
        
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)]];
        searchItem.width = 200.;
        
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(toolbarItemClicked:)];
        refreshItem.tag = REFRESH_ITEM_TAG;
        
        toolBar.items = @[flexibleSpace, settingItem, flexibleSpace, searchItem, flexibleSpace, refreshItem, flexibleSpace];
        
        [blurMaskView addSubview:toolBar];
    }
    
    return self;
}

- (void)toolbarItemClicked:(UIBarButtonItem*)item {
    if (item.tag == SETTING_ITEM_TAG && [self.delegate respondsToSelector:@selector(moreButtonClicked)]) {
        [self.delegate moreButtonClicked];
    }else if (item.tag == REFRESH_ITEM_TAG && [self.delegate respondsToSelector:@selector(refreshButtonClicked)]) {
        [self.delegate refreshButtonClicked];
    }
}

@end
