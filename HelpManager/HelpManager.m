//
//  HelpManager.m
//  Helpout
//
//  Created by Phineas Lue on 10/30/14.
//  Copyright (c) 2014 Phineas Lue. All rights reserved.
//

#import "HelpManager.h"

@interface HelpManager() {
    @private
    
    AFHTTPRequestOperationManager *_networkManager;
}

@property (nonatomic, readonly) AFHTTPRequestOperationManager* networkManager;

@end

@implementation HelpManager

+ (id)sharedHelpManager {
    static HelpManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HelpManager alloc] init];
    });
    
    return sharedManager;
}

- (AFHTTPRequestOperationManager *)networkManager {
    if (!_networkManager) {
        _networkManager = [AFHTTPRequestOperationManager manager];
    }
    
    return _networkManager;
}

- (void)setUser:(id<FBGraphUser>)user withCompletion:(void (^)(NSError *error))completion {
        //send signin request to server
        //transfer user object to property list
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"facebookid"] = user.objectID;
        params[@"email"] = [user performSelector:NSSelectorFromString(@"email")];
        params[@"name"] = user.name;
        params[@"firstName"] = user.first_name;
        params[@"lastName"] = user.last_name;
        params[@"gender"] = [user performSelector:NSSelectorFromString(@"gender")];
        
        [self.networkManager POST:[REMOTE stringByAppendingPathComponent:LOGIN] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.userId = [responseObject objectForKey:@"id"];
            //update the userid to disk
            [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            completion(nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(error);
        }];
}


- (void)createTask:(NSMutableDictionary *)params withCompletion:(void (^)(NSError *))completion {
    params[@"userid"] = self.userId;
    [self.networkManager POST:[REMOTE stringByAppendingString:CREATE_TASK] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
}

- (void)getSuggestedTasksWithLocation:(CLLocationCoordinate2D)coordinate andCompletion:(void (^)(NSArray *results, NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lng"] = [NSNumber numberWithDouble:coordinate.longitude];
    params[@"lat"] = [NSNumber numberWithDouble:coordinate.latitude];
    params[@"userid"] = self.userId;
    params[@"limit"] = @10;
    params[@"dis"] = @1;
    
    [self.networkManager POST:[REMOTE stringByAppendingString:SUGGESTED_TASK] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSArray class]]) {
            completion(responseObject, [NSError errorWithDomain:@"Get server error" code:0 userInfo:nil]);
        }else{
            NSMutableArray *results = [NSMutableArray array];
            for (NSDictionary *helpDict in responseObject) {
                Help *help = [[Help alloc] initWithDict:helpDict];
                [results addObject:help];
            }
            completion([NSArray arrayWithArray:results], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)getMyHelpoutsWithCompletion:(void (^)(NSArray *, NSError *))completion {
    [self.networkManager GET:[NSString stringWithFormat:[REMOTE stringByAppendingString:MY_HELP_OUTS], self.userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject[@"applied_tasks"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)applyAsCandidateForTask:(NSString *)taskId withCompletion:(void (^)(NSError *))completion {
    NSDictionary *params = @{
                             @"userid": self.userId,
                             @"taskid": taskId
                             };
    
    [self.networkManager POST:[REMOTE stringByAppendingPathComponent:APPLY_TASK] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"code"] isEqualToNumber:@200]) {
            completion([NSError errorWithDomain:@"Apply error" code:0 userInfo:nil]);
        }else {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
}

- (void)getMyCreatedTasksWithCompletion:(void (^)(NSArray *, NSError *))completion {
    [self.networkManager GET:[NSString stringWithFormat:[REMOTE stringByAppendingPathComponent:MY_CREATED_TASKS], self.userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject[@"created_tasks"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)answerTaskWithTaskId:(NSString *)taskId applicantId:(NSString *)applicantId andCompletion:(void (^)(NSError *))completion {
    NSDictionary *params = @{
                             @"userid": self.userId,
                             @"taskid": taskId,
                             @"applicantid": applicantId,
                             @"status": @"True"
                             };
    
    [self.networkManager POST:[REMOTE stringByAppendingPathComponent:ANSWER_TASK] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
}

- (void)finishTaskWithTaskId:(NSString *)taskId result:(BOOL)result andCompletion:(void (^)(NSError *))completion {
    NSDictionary *parmas = @{
                             @"userid": self.userId,
                             @"taskid": taskId,
                             @"result": result ? @"True" : @"False"
                             };
    
    [self.networkManager POST:[REMOTE stringByAppendingPathComponent:FINISH_TASK] parameters:parmas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
}

@end
