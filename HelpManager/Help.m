//
//  Help.m
//  Helpout
//
//  Created by Phineas Lue on 11/4/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "Help.h"

@implementation Help
@synthesize coordinate;

- (id)initWithDict:(NSDictionary *)helpDict {
    self = [super init];
    
    if (self) {
        self.title = helpDict[@"name"];
        self.desc = helpDict[@"desc"];
        coordinate = CLLocationCoordinate2DMake([helpDict[@"lat"] doubleValue], [helpDict[@"lng"] doubleValue]);
        self.maxHelpers = [helpDict[@"number_needed"] intValue];
        self.expire = [NSDate dateWithTimeIntervalSince1970:[helpDict[@"need_time"] doubleValue]];
        self.createdAt = [NSDate dateWithTimeIntervalSince1970:[helpDict[@"create_time"] doubleValue]];
        self.createrFacebookId = helpDict[@"creator_facebookid"];
        self.createrName = helpDict[@"creator_name"];
        self.taskId = helpDict[@"id"];
        self.type = [helpDict[@"type"] intValue];
    }
    
    return self;
}


@end
