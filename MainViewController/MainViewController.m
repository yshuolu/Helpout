//
//  MainViewController.m
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"
#import "SettingViewController.h"
#import "CreateTaskViewController.h"
#import "DetailHelpViewController.h"
#import "MyHelpoutsViewController.h"
#import "MyTasksViewController.h"
#import "MedalViewController.h"

@interface MainViewController ()<MapViewControllerDelegate, SettingViewControllerDelegate>

@property (nonatomic, strong) MapViewController *mapViewController;

@property (nonatomic, strong) SettingViewController *settingViewController;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.settingViewController = [[SettingViewController alloc] init];
    self.settingViewController.view.frame = self.view.bounds;
    self.settingViewController.delegate = self;
    
    [self.view addSubview:self.settingViewController.view];
    
    self.mapViewController = [[MapViewController alloc] init];
    self.mapViewController.view.frame = self.view.bounds;
    self.mapViewController.delegate = self;
    
    [self.view addSubview:self.mapViewController.view];
}

#pragma mark - MapViewControllerDelegate

- (void)tabSelectedAtIndex:(NSInteger)index {
    if (index == 0) {
        MyHelpoutsViewController *myHelpoutsViewController = [[MyHelpoutsViewController alloc] init];
        [self.navigationController pushViewController:myHelpoutsViewController animated:YES];
    }else if (index == 1) {
        MyTasksViewController *myTasksViewController = [[MyTasksViewController alloc] init];
        [self.navigationController pushViewController:myTasksViewController animated:YES];
    }else if (index == 2) {
        MedalViewController *medalViewController = [[MedalViewController alloc] init];
        [self.navigationController pushViewController:medalViewController animated:YES];
    }
}

- (void)addButtonClicked {
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CreateTaskViewController *createTaskViewController = [[CreateTaskViewController alloc] initWithBackgroundImage:currentImage];
    
    [self.navigationController pushViewController:createTaskViewController animated:YES];
}

- (void)showDetailHelp:(Help *)help {
    DetailHelpViewController *detailHelpViewController = [[DetailHelpViewController alloc] initWithHelp:help];
    [self.navigationController pushViewController:detailHelpViewController animated:YES];
}

#pragma mark - SettingViewControllerDelegate
- (void)settingViewControllerLogout:(SettingViewController *)settingViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
