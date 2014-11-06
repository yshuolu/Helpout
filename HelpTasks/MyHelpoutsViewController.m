//
//  MyHelpoutsViewController.m
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "MyHelpoutsViewController.h"
#import "HelpManager.h"
#import "TaskPanelViewController.h"

@interface MyHelpoutsViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *helpArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyHelpoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"My Helpouts";
    
    //
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];

    [self updateHelpList];
}

- (void)updateHelpList {
    [[HelpManager sharedHelpManager] getMyCreatedTasksWithCompletion:^(NSArray *results, NSError *error) {
        if (!error) {
            self.helpArray = results;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.helpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    NSDictionary *help = self.helpArray[indexPath.row];
    cell.textLabel.text = help[@"name"];
    cell.detailTextLabel.text = help[@"desc"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskPanelViewController *taskPanelViewController = [[TaskPanelViewController alloc] initWithHelpDict:self.helpArray[indexPath.row]];
    
    [self.navigationController pushViewController:taskPanelViewController animated:YES];
}

@end
