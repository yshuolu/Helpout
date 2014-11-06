//
//  HelpManager.h
//  Helpout
//
//  Created by Phineas Lue on 10/30/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "Help.h"
#import "Portal.h"

@interface HelpManager : NSObject

@property (nonatomic, copy) NSString *userId;

+ (id)sharedHelpManager;

- (void)setUser:(id<FBGraphUser>)user withCompletion:(void (^)(NSError *error))completion;

- (void)createTask:(NSDictionary*)params withCompletion:(void (^)(NSError *error))completion;

- (void)getSuggestedTasksWithLocation:(CLLocationCoordinate2D)coordinate andCompletion:(void (^)(NSArray *results, NSError *error))completion;

- (void)getMyHelpoutsWithCompletion:(void (^)(NSArray *results, NSError* error))completion;

- (void)applyAsCandidateForTask:(NSString*)taskId withCompletion:(void(^)(NSError* error))completion;

- (void)getMyCreatedTasksWithCompletion:(void (^)(NSArray *results, NSError *error))completion;

- (void)answerTaskWithTaskId:(NSString*)taskId applicantId:(NSString*)applicantId andCompletion:(void(^)(NSError *error))completion;

- (void)finishTaskWithTaskId:(NSString*)taskId result:(BOOL)result andCompletion:(void(^)(NSError *error))completion;

- (void)getMedalsWithCompletion:(void(^)(NSDictionary *result, NSError *error))completion;

@end
