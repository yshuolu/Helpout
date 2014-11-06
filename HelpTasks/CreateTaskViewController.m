//
//  CreateTaskViewController.m
//  Helpout
//
//  Created by Phineas Lue on 10/30/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "CreateTaskViewController.h"
#import "HelpManager.h"
#import "DatePickerView.h"
#import "NumberPickerView.h"
#import "LocationManager.h"

#define LEFT_MARGIN 20.
#define TEXT_FIELD_HEIGHT 44.
#define TEXT_FIELD_WIDTH CGRectGetWidth(self.view.bounds)- LEFT_MARGIN*2
#define VERTICAL_MARGIN 20.
#define PICKER_HEIGHT 300.

@interface CreateTaskViewController()<DatePickerViewDelegate, NumberPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UITextField *titleView;

@property (nonatomic, strong) UISegmentedControl *segmentView;

@property (nonatomic, strong) UITextView *descriptionView;

@property (nonatomic, strong) UIButton *expireButton;

@property (nonatomic, strong) UIButton *maxHelperButton;

@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic) BOOL needScrollUP;

@end

@implementation CreateTaskViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithBackgroundImage:(UIImage *)backgroundImage {
    self = [super init];
    
    if (self) {
        self.backgroundImage = backgroundImage;
        
        self.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"", @"title",
                       @"", @"description",
                       @0, @"type",
                       [NSNumber numberWithLong:(long)[[NSDate date] timeIntervalSince1970]], @"expire",
                       @1, @"maxhelpers", nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
        
        self.needScrollUP = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.title = @"Post a help";
    self.navigationController.navigationBarHidden = NO;
    
    //Post button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(submitTask:)];
    
    //
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    //
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = backgroundView.bounds;
    [backgroundView addSubview:blurView];
    
    //
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds)+1);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    //create all needed input views
    //title text field
    self.titleView = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 100., TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    self.titleView.textColor = [UIColor lightTextColor];
    self.titleView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Subject" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
    self.titleView.returnKeyType = UIReturnKeyDone;
    self.titleView.delegate = self;
    [self.scrollView addSubview:self.titleView];
    
    //type segmented control
    self.segmentView = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"general.png"], [UIImage imageNamed:@"car.png"], [UIImage imageNamed:@"house.png"], [UIImage imageNamed:@"computer.png"], [UIImage imageNamed:@"cleaning"]]];
    self.segmentView.selectedSegmentIndex = 0;
    self.segmentView.frame = CGRectMake(LEFT_MARGIN, CGRectGetMaxY(self.titleView.frame)+VERTICAL_MARGIN, TEXT_FIELD_WIDTH, 30.);
    [self.scrollView addSubview:self.segmentView];
    
    //expire
    UILabel *expireLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, CGRectGetMaxY(self.segmentView.frame)+VERTICAL_MARGIN, 200., TEXT_FIELD_HEIGHT)];
    expireLabel.textColor = [UIColor lightTextColor];
    expireLabel.text = @"Expire Date:";
    [self.scrollView addSubview:expireLabel];
    
    self.expireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.expireButton.frame = CGRectMake(CGRectGetMaxX(expireLabel.frame), CGRectGetMaxY(self.segmentView.frame)+VERTICAL_MARGIN, TEXT_FIELD_WIDTH-CGRectGetWidth(expireLabel.bounds), TEXT_FIELD_HEIGHT);
    [self.expireButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.expireButton setTitle:@"Today" forState:UIControlStateNormal];
    [self.expireButton addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.expireButton];
    
    //max helper
    UILabel *helperLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, CGRectGetMaxY(expireLabel.frame)+VERTICAL_MARGIN, 200., TEXT_FIELD_HEIGHT)];
    helperLabel.textColor = [UIColor lightTextColor];
    helperLabel.text = @"Helper Number:";
    [self.scrollView addSubview:helperLabel];
    
    self.maxHelperButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.maxHelperButton.frame = CGRectMake(CGRectGetMaxX(helperLabel.frame), helperLabel.frame.origin.y, TEXT_FIELD_WIDTH-CGRectGetWidth(helperLabel.bounds), TEXT_FIELD_HEIGHT);
    [self.maxHelperButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.maxHelperButton setTitle:@"1" forState:UIControlStateNormal];
    [self.maxHelperButton addTarget:self action:@selector(showNumberPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.maxHelperButton];
    
    //description textview
    self.descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, CGRectGetMaxY(helperLabel.frame)+VERTICAL_MARGIN, TEXT_FIELD_WIDTH, 100.)];
    self.descriptionView.backgroundColor = [UIColor clearColor];
    self.descriptionView.text = @"What's more";
    self.descriptionView.font = [UIFont systemFontOfSize:13.];
    self.descriptionView.textColor = [UIColor lightTextColor];
    self.descriptionView.delegate = self;
    [self.scrollView addSubview:self.descriptionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.titleView becomeFirstResponder];
}

#pragma mark- Expire Button
- (void)showDatePicker:(UIButton*)button {
    [self.titleView resignFirstResponder];
    [self.descriptionView resignFirstResponder];
    
    DatePickerView *datePickerView = [[DatePickerView alloc] initWithFrame:self.view.bounds];
    datePickerView.delegate = self;
    
    [self.view addSubview:datePickerView];
}

#pragma mark- Max Helper Button
- (void)showNumberPicker:(UIButton*)button {
    [self.titleView resignFirstResponder];
    [self.descriptionView resignFirstResponder];
    
    NumberPickerView *numberPickerView = [[NumberPickerView alloc] initWithFrame:self.view.bounds];
    numberPickerView.delegate = self;
    
    [self.view addSubview:numberPickerView];
}

#pragma mark- DatePickerView delegate
- (void)datePickerViewDidSelectDate:(NSDate *)date {
    self.params[@"expire"] = [NSNumber numberWithLong:(long)[date timeIntervalSince1970]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd";
    [self.expireButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}

#pragma mark- NumberPickerView delegate
- (void)numberPickerViewDidSelectNumber:(NSInteger)number {
    self.params[@"maxhelpers"] = [NSNumber numberWithInteger:number];
    
    [self.maxHelperButton setTitle:[NSString stringWithFormat:@"%ld", number] forState:UIControlStateNormal];
}

//
- (void)submitTask:(UIBarButtonItem*)item {
    self.params[@"title"] = self.titleView.text;
    self.params[@"description"] = self.descriptionView.text;
    self.params[@"type"] = [NSNumber numberWithInteger:self.segmentView.selectedSegmentIndex];
    //get lng and lat
    CLLocationCoordinate2D coordinate = [[LocationManager sharedLocationManager] currentLocation];
    self.params[@"lng"] = [NSNumber numberWithDouble:coordinate.longitude];
    self.params[@"lat"] = [NSNumber numberWithDouble:coordinate.latitude];
    
    [[HelpManager sharedHelpManager] createTask:self.params withCompletion:^(NSError *error) {
        //
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- UITextViewFieldDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.needScrollUP = YES;
    
    return YES;
}

#pragma mark- Keyboard
- (void)keyboardWillShow:(NSNotification*)notification {
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0., 0., keyboardSize.height, 0.);
    if (self.needScrollUP) {
        [self.scrollView scrollRectToVisible:self.descriptionView.frame animated:YES];
    }
}

- (void)keyboardWillDisappear:(NSNotification*)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
}
@end

