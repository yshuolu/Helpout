//
//  SettingViewController.h
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingViewControllerDelegate;
@interface SettingViewController : UIViewController

@property (nonatomic, weak) id<SettingViewControllerDelegate> delegate;

@end

@protocol SettingViewControllerDelegate <NSObject>

@optional

- (void)settingViewControllerLogout:(SettingViewController*)settingViewController;

@end
