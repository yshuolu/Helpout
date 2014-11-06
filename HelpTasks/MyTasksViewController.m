//
//  MyTasksViewController.m
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "MyTasksViewController.h"
#import "HelpManager.h"
#import "UIImageView+AFNetworking.h"
#import "DetailHelpViewController.h"

@interface MyTasksViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *helpArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"My Tasks";
    
    //
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    [self updateHelpList];
}

- (void)updateHelpList {
    [[HelpManager sharedHelpManager] getMyHelpoutsWithCompletion:^(NSArray *results, NSError *error) {
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = self.helpArray[indexPath.row][@"task"][@"name"];
    cell.detailTextLabel.text = self.helpArray[indexPath.row][@"task"][@"desc"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Help *help = [[Help alloc] initWithDict:self.helpArray[indexPath.row][@"task"]];
    
    DetailHelpViewController *detailHelpViewController = [[DetailHelpViewController alloc] initWithHelp:help];
    detailHelpViewController.hideApply = YES;
    
    [self.navigationController pushViewController:detailHelpViewController animated:YES];
}

@end
