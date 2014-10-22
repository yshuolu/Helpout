//
//  MapViewController.m
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "TabBarView.h"
#import "SearchBarView.h"

#define TABBAR_HEIGHT 80.

#define MAP_VIEW_CONTROLLER_TOGGLE_OFFSET 200.

@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, TabBarViewDelegate, SearchBarViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) SearchBarView *searchBar;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation MapViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add map view
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    CLLocationCoordinate2D currentCoordinate = self.locationManager.location.coordinate;
    self.mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude), 1000, 1000);
    self.mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
 
    // add TabBarView
    TabBarView *tabBarView = [[TabBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - TABBAR_HEIGHT, CGRectGetWidth(self.view.frame), TABBAR_HEIGHT)];
    tabBarView.delegate = self;
    
    [self.view addSubview:tabBarView];
    
    // add search bar
    self.searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 20 + 44)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    //
    self.coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restoreMapViewController:)];
    [self.coverView addGestureRecognizer:tapRecognizer];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - TabBarViewDelegate
- (void)tabSelectedAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(tabSelectedAtIndex:)]) {
        [self.delegate tabSelectedAtIndex:index];
    }
}

#pragma mark - SearchBarViewDelegate
- (void)moreButtonClicked {
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = CGRectOffset(self.view.frame, MAP_VIEW_CONTROLLER_TOGGLE_OFFSET, 0.);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view addSubview:self.coverView];
        }
    }];
    
}

- (void)refreshButtonClicked {}

#pragma mark - UITapGestureRecognizer
- (void)restoreMapViewController:(UITapGestureRecognizer*)recognizer {
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = CGRectOffset(self.view.frame, -MAP_VIEW_CONTROLLER_TOGGLE_OFFSET, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.coverView removeFromSuperview];
        }
    }];
    
}

@end
