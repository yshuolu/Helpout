//
//  MedalViewController.m
//  Helpout
//
//  Created by Phineas Lue on 11/5/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "MedalViewController.h"
#import "HelpManager.h"

#define MEDAL_SIZE CGSizeMake(80., 80.)

@implementation MedalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Medals";
    
    UILabel *medalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 20., CGRectGetWidth(self.view.bounds), 30)];
    [self.view addSubview:medalLabel];
    
    [[HelpManager sharedHelpManager] getMedalsWithCompletion:^(NSDictionary *result, NSError *error) {
        [self showMedalList:result[@"honors"]];
    }];
}

- (void)showMedalList:(NSArray*)medalList {
    int count = 0;
    for (NSDictionary *medalDict in medalList) {
        MedalView *medalView = [[MedalView alloc] initWithDict:medalDict];
        int row = count / 3;
        int col = count % 3;
        
        medalView.frame = CGRectMake((col+1)*30+60*col, 80*(row+1), MEDAL_SIZE.width, MEDAL_SIZE.height);
        [self.view addSubview:medalView];
        
        count++;
    }
}

@end

@interface MedalView()

@property (nonatomic, strong) NSDictionary *medalDict;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MedalView

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.medalDict = dict;
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home.png"]];
        self.imageView.frame = CGRectMake(10., 5., 60., 50.);
        
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 60., 80., 20.)];
        self.titleLabel.font = [UIFont systemFontOfSize:12.];
        [self addSubview:self.titleLabel];
        self.titleLabel.text = dict[@"name"];
    }
    
    return self;
}

@end
