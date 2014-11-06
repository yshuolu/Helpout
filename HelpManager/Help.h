//
//  Help.h
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    General,
    Car,
    House,
    Computer,
    Cleaning
} TASK_TYPE;

@interface Help : NSObject<MKAnnotation> {
    @private
    CLLocationCoordinate2D coordinate;
}

- (id)initWithDict:(NSDictionary*)helpDict;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *taskId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSDate *expire;

@property (nonatomic) NSInteger maxHelpers;

@property (nonatomic, copy) NSString *createrFacebookId;

@property (nonatomic, copy) NSString *createrName;

@property (nonatomic) TASK_TYPE type;

//@property (nonatomic) BOOL closed;

//@property (nonatomic, strong) 

@end
