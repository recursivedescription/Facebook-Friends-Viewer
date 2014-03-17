//
//  RCDFacebookFriendsLoader.m
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookFriendsLoader.h"
#import "RCDFacebookSessionManager.h"
#import "RCDFriendsListDataSource.h"
#import <AFNetworking/AFNetworking.h>
#import "RCDFacebookFriendListResponse.h"
#import "NSDictionary+RCDTypesafeExtraction.h"

@interface RCDFacebookFriendsLoader ()

@property (strong, nonatomic) RCDFacebookSessionManager *facebookSessionManager;
@property (strong, nonatomic) RCDFriendsListDataSource *dataSource;
@property (strong, nonatomic) NSURLSessionDataTask *urlSessionDataTask;

@end

@implementation RCDFacebookFriendsLoader

- (instancetype)initWithDataSource:(RCDFriendsListDataSource *)dataSource {
    
    if (self = [super init]) {
        self.dataSource = dataSource;
        self.facebookSessionManager = [RCDFacebookSessionManager manager];
    }
    return self;
}

- (void)startLoadingFriends {
    
    [self.urlSessionDataTask cancel];
    NSString *urlString = @"https://graph.facebook.com/me/friends?fields=name,first_name,last_name,picture.width(100).height(100)" ;
    NSDictionary *parameters = @{@"fields":@"name,first_name,last_name,picture.width(100).height(100)",
                                 };
    [self loadFriendsWithURLString:urlString parameters:parameters];
}

- (void)loadFriendsWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters{
    
    __weak typeof(self) weakSelf = self;
    self.urlSessionDataTask = [self.facebookSessionManager GET:urlString parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
    
            [weakSelf loadingCompletedForTask:task response:responseObject error:nil];
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
            [weakSelf loadingCompletedForTask:task response:nil error:error];
        }
    ];
}

- (void)loadingCompletedForTask:(NSURLSessionDataTask *)task response:(id)response
                   error:(NSError *)error {
    if (error) {
        if ([self.delegate respondsToSelector:@selector(facebookfriendsLoader:didEncounterError:)]) {
            [self.delegate facebookfriendsLoader:self didEncounterError:error];
        }
    }else {
        RCDFacebookFriendListResponse *friendsListResponse = [RCDFacebookFriendListResponse modelObjectWithDictionary:response];
        //it's possible that the API might have retuned a 2xx response, (eg in case of a permissions error)
        //https://developers.facebook.com/docs/graph-api/using-graph-api/
        if (!friendsListResponse) {
            //An API (likely)/parser(less likely) error has occured
            [self facebookAPIerrorFromResponse:friendsListResponse];
            if ([self.delegate respondsToSelector:@selector(facebookfriendsLoader:didEncounterError:)]) {
                [self.delegate facebookfriendsLoader:self didEncounterError:error];
            }
        }else if (friendsListResponse.friends) {
            [self.dataSource addFriendsData:friendsListResponse.friends];
            if ([self.delegate respondsToSelector:@selector(facebookfriendsLoader:didLoadFriendsData:)]) {
                [self.delegate facebookfriendsLoader:self didLoadFriendsData:friendsListResponse.friends];
            }
        }
    }
}

- (NSError *)facebookAPIerrorFromResponse:(id)response {
    
    NSDictionary *userInfo;
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *errorDict = [(NSDictionary *)response rcd_dictionaryObjectForKey:@"error"];
        //look for dozens of error possibilities in facebook API
        //
        //
        //this does really nothing
        userInfo = @{NSLocalizedDescriptionKey: [errorDict description]};
    }
    NSError *error = [NSError errorWithDomain:@"RCDFacebookAPIErrorDomain" code:1 userInfo:userInfo];
    //log it, send to bug tracking service etc, etc....
    return error;
}

- (void)cancel {
    [self.urlSessionDataTask cancel];
}

- (void)retryFailedRequest {
    if (self.urlSessionDataTask) {
        //TODO:: run the request again
    }
}
@end