//
//  MapViewController.h
//  Helpout
//
//  Created by Phineas Lue on 10/12/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapViewControllerDelegate;

@interface MapViewController : UIViewController

@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;

@end

@protocol MapViewControllerDelegate <NSObject>

@optional

- (void)tabSelectedAtIndex:(NSInteger)index;

@end
