//
//  DetailHelpViewController.m
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "DetailHelpViewController.h"
#import "UIImageView+AFNetworking.h"
#import "HelpManager.h"

@implementation DetailHelpViewController

- (id)initWithHelp:(Help *)help {
    self = [super init];
    
    if (self) {
        self.help = help;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Help";
    
    //
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    //
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20., 20., 30., 30.)];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.cornerRadius = 15.;
    avatarImageView.layer.masksToBounds = YES;
    [avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:AVATAR, self.help.createrFacebookId]]];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60., 20., 200., 30.)];
    nameLabel.text = self.help.createrName;
    
    [scrollView addSubview:avatarImageView];
    [scrollView addSubview:nameLabel];
    
    //
    UIImageView *typeTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home.png"]];
    typeTag.frame = CGRectMake(20., 85., 15., 15.);
    
    [scrollView addSubview:typeTag];
    
    //
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60., 80., 250., 30.)];
    titleLabel.text = @"hello world fsdfsdaf";
    [scrollView addSubview:titleLabel];
    
    //
    UILabel *expireLabel = [[UILabel alloc] initWithFrame:CGRectMake(20., 120., 300., 30)];
    expireLabel.font = [UIFont systemFontOfSize:12.];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
    expireLabel.text = [NSString stringWithFormat:@"Please before: %@", [formatter stringFromDate:[NSDate date]]];
    
    [scrollView addSubview:expireLabel];
    
    //
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(20., 180., 300., 200.)];
    descriptionView.userInteractionEnabled = NO;
    descriptionView.text = self.help.desc;
    
    [scrollView addSubview:descriptionView];
    
    //
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [applyButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
    applyButton.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-200.) / 2, 400., 200., 40.);
    applyButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [applyButton setTitle:@"Give a hand" forState:UIControlStateNormal];
    
    if (self.hideApply) {
        applyButton.hidden = YES;
    }
    
    [scrollView addSubview:applyButton];
}

- (void)apply:(UIButton*)button {
    [[HelpManager sharedHelpManager] applyAsCandidateForTask:self.help.taskId withCompletion:^(NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Apply failed!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else {
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have been a candidate for this task" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [success show];
        }
    }];
}

@end
