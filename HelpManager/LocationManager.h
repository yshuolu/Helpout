//
//  LocationManager.h
//  Helpout
//
//  Created by Phineas Lue on 11/1/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationManager : NSObject

+ (id)sharedLocationManager;

- (CLLocationCoordinate2D)currentLocation;

@end
