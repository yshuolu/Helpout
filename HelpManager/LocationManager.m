//
//  LocationManager.m
//  Helpout
//
//  Created by Phineas Lue on 11/1/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

+ (id)sharedLocationManager {
    static LocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[LocationManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
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

- (CLLocationCoordinate2D)currentLocation {
    return self.locationManager.location.coordinate;
}

#pragma mark- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //nothing to do
}

@end
