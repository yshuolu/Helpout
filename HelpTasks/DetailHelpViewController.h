//
//  DetailHelpViewController.h
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpManager.h"

@interface DetailHelpViewController : UIViewController

@property (nonatomic, strong) Help *help;

@property (nonatomic) BOOL hideApply;

- (id)initWithHelp:(Help*)help;

@end
