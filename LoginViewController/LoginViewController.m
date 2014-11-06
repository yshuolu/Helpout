//
//  LoginViewController.m
//  Helpout
//
//  Created by Phineas Lue on 10/17/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"
#import "HelpManager.h"

@interface LoginViewController ()<FBLoginViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background.png"]];
    backgroundView.frame = self.view.bounds;
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundView];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.bounds), 50)];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.font = [UIFont systemFontOfSize:30.];
    titleView.text = @"Welcome to Helpouts";
    [self.view addSubview:titleView];
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"email"]];
    loginView.delegate = self;
    loginView.center = self.view.center;
    loginView.frame = CGRectOffset(loginView.frame, 0, 20.);
    [self.view addSubview:loginView];
}

#pragma mark - FBLoginViewDelegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    if ([[HelpManager sharedHelpManager] userId]) {
        return;
    }
    
    //update the userId of HelperManager
    [[HelpManager sharedHelpManager] setUser:user withCompletion:^(NSError *error) {
        if (!error) {
            MainViewController *mainViewController = [[MainViewController alloc] init];
            [self.navigationController pushViewController:mainViewController animated:YES];
        }else {
            //login error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:@"Login failed! Please check the network connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }];
    
}

@end
