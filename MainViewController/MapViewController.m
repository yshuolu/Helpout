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
#import "LocationManager.h"
#import "UIImageView+AFNetworking.h"

#define TABBAR_HEIGHT 80.

#define MAP_VIEW_CONTROLLER_TOGGLE_OFFSET 200.

@interface MapViewController ()<MKMapViewDelegate, TabBarViewDelegate, SearchBarViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) SearchBarView *searchBar;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add map view
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    CLLocationCoordinate2D currentCoordinate = [[LocationManager sharedLocationManager] currentLocation];
    self.mapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude), 1000, 1000);
//    self.mapView.showsUserLocation = YES;
    
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
    
    
    //fetch suggested tasks
    [self updateHelpAnnotations];
}

- (void)updateHelpAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    CLLocationCoordinate2D currentCoordinate = [[LocationManager sharedLocationManager] currentLocation];
    [[HelpManager sharedHelpManager] getSuggestedTasksWithLocation:currentCoordinate andCompletion:^(NSArray *results, NSError *error) {
        if (!error) {
            //load annotation
            for (Help *help in results) {
                [self.mapView addAnnotation:help];
            }
        }
    }];
}

#pragma mark - TabBarViewDelegate
- (void)tabSelectedAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(tabSelectedAtIndex:)]) {
        [self.delegate tabSelectedAtIndex:index];
    }
}

- (void)addButtonClicked {
    if ([self.delegate respondsToSelector:@selector(addButtonClicked)]) {
        [self.delegate addButtonClicked];
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

- (void)refreshButtonClicked {
    [self updateHelpAnnotations];
}

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

#pragma mark- MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"HelpIdentifier"];
    
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"HelpIdentifier"];
    }
    
    NSString *tagName;
    switch (((Help*)annotation).type) {
        case 0:
            tagName = @"general";
            break;
        
        case 1:
            tagName = @"car";
            break;
            
        case 2:
            tagName = @"house";
            break;
            
        case 3:
            tagName = @"computer";
            break;
            
        case 4:
            tagName = @"cleaning";
            break;
            
        default:
            tagName = @"general";
            break;
    }
    annotationView.image = [UIImage imageNamed:tagName];
    annotationView.canShowCallout = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = button;
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.cornerRadius = 15.;
    avatarImageView.layer.masksToBounds = YES;
    [avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:AVATAR, ((Help*)annotation).createrFacebookId]]];
    
    annotationView.leftCalloutAccessoryView = avatarImageView;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([self.delegate respondsToSelector:@selector(showDetailHelp:)]) {
        [self.delegate showDetailHelp:view.annotation];
    }
}

- (void)showDetailHelp:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(showDetailHelp:)]) {
        MKAnnotationView *annotationView = (MKAnnotationView*)button.superview;
        Help *help = annotationView.annotation;
        [self.delegate showDetailHelp:help];
    }
}

@end
