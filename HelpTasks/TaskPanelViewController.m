//
//  TaskPanelViewController.m
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "TaskPanelViewController.h"

@interface TaskPanelViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *helpDict;

@property (nonatomic, strong) NSMutableArray *selectedIndex;

@property (nonatomic) NSInteger limit;

@end

@implementation TaskPanelViewController

- (id)initWithHelpDict:(NSDictionary *)helpDict {
    self = [super init];
    
    if (self) {
        self.helpDict = helpDict;
        
        //init selectedIndex
        self.selectedIndex = [NSMutableArray array];
        self.limit = [self.helpDict[@"number_needed"] integerValue];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return [self.helpDict[@"challengers"] count];
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.helpDict[@"desc"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Need helper Number: %@", self.helpDict[@"number_needed"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.textLabel.text = self.helpDict[@"challengers"][indexPath.row][@"applicant"][@"name"];
        if ([self.selectedIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.helpDict[@"status"] isEqualToString:@"please help"]) {
        return;
    }
    
    if (![self.selectedIndex containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        if (self.selectedIndex.count >= self.limit) {
            return;
        }
        [self.selectedIndex addObject:[NSNumber numberWithInteger:indexPath.row]];
        
        if (self.selectedIndex.count == self.limit) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:self action:@selector(confirm:)];
        }
        
    }else {
        [self.selectedIndex removeObject:[NSNumber numberWithInteger:indexPath.row]];
        
        if (self.selectedIndex.count < self.limit) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)confirm:(UIBarButtonItem*)item {
    
}

@end
