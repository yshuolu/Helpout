//
//  TaskPanelViewController.h
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskPanelViewController : UIViewController

- (id)initWithHelpDict:(NSDictionary*)helpDict;

@end

@interface TaskInfoView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *descriptionLabel;

@property (nonatomic, strong) UILabel *helperNumberLabel;

@end
