//
//  TaskPanelViewController.m
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "TaskPanelViewController.h"
#import "HelpManager.h"

@interface TaskPanelViewController()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *helpDict;

@property (nonatomic, strong) NSMutableArray *selectedIndex;

@property (nonatomic) NSInteger limit;

@property (nonatomic) BOOL isUpdating;

@end

@implementation TaskPanelViewController

- (id)initWithHelpDict:(NSDictionary *)helpDict {
    self = [super init];
    
    if (self) {
        self.helpDict = helpDict;
        
        //init selectedIndex
        self.selectedIndex = [NSMutableArray array];
        self.limit = [self.helpDict[@"number_needed"] integerValue];
        self.isUpdating = NO;
        
        for (NSDictionary *challenger in self.helpDict[@"challengers"]) {
            if ([challenger[@"status"] isEqualToString:@"wa"]) {
                [self.selectedIndex addObject:[NSNumber numberWithBool:NO]];
            }else {
                [self.selectedIndex addObject:[NSNumber numberWithBool:YES]];
            }
        }
        
        NSString *status = self.helpDict[@"status"];
        if ([status isEqualToString:@"ongoing"]) {
            [self showDoneButton];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)showDoneButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(confirm:)];
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return [self.helpDict[@"challengers"] count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = self.helpDict[@"challengers"][indexPath.row][@"applicant"][@"name"];
    if ([self.selectedIndex[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        TaskInfoView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TaskInfo"];
        
        if (!headerView) {
            headerView = [[TaskInfoView alloc] initWithReuseIdentifier:@"TaskInfo"];
        }
        
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        headerView.titleLabel.text = self.helpDict[@"name"];
        headerView.descriptionLabel.text = self.helpDict[@"desc"];
        headerView.helperNumberLabel.text = [NSString stringWithFormat:@"helper number: %@", self.helpDict[@"number_needed"]];
        
        return headerView;
    }else {
        UITableViewHeaderFooterView *helperHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HelperHeader"];
        
        if (!helperHeader) {
            helperHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HelperHeader"];
        }
        
        helperHeader.textLabel.text = @"Helpers";
        
        return helperHeader;
    }

}

#pragma mark- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200.;
    }else {
        return 40.;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.helpDict[@"status"] isEqualToString:@"please help"] || self.isUpdating) {
        return;
    }
    
    self.isUpdating = YES;
    [[HelpManager sharedHelpManager] answerTaskWithTaskId:self.helpDict[@"id"] applicantId:self.helpDict[@"challengers"][indexPath.row][@"applicant"][@"id"] andCompletion:^(NSError *error) {
        if (!error) {
            self.selectedIndex[indexPath.row] = @YES;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.isUpdating = NO;
            
            //check if the task can be done
            NSInteger count = 0;
            for (NSNumber *boolNumber in self.selectedIndex) {
                if ([boolNumber boolValue] == YES) {
                    count += 1;
                }
            }
            
            if (count == self.limit) {
                [self showDoneButton];
            }
        }
    }];
    
}

- (void)confirm:(UIBarButtonItem*)item {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Finish task" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Success", @"Fail", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[HelpManager sharedHelpManager] finishTaskWithTaskId:self.helpDict[@"id"] result:YES andCompletion:^(NSError *error) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Success" style:UIBarButtonItemStylePlain target:nil action:nil];
        }];
    }else {
        [[HelpManager sharedHelpManager] finishTaskWithTaskId:self.helpDict[@"id"] result:NO andCompletion:^(NSError *error) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Fail" style:UIBarButtonItemStylePlain target:nil action:nil];
        }];
    }
}

@end

@implementation TaskInfoView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20., 20., 300., 30.)];
        [self.contentView addSubview:self.titleLabel];
        
        self.descriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(20., 60., 300., 50.)];
        self.descriptionLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:self.descriptionLabel];
        
        self.helperNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(100., 180., 200., 20.)];
        self.helperNumberLabel.font = [UIFont systemFontOfSize:12.];
        [self.contentView addSubview:self.helperNumberLabel];
    }
    
    return self;
}

@end
