//
//  RCDFacebookFriendsLoader.h
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCDFriendsListDataSource;
@class RCDFacebookFriendsLoader;

@protocol RCDFacebookFriendsLoaderDelegate <NSObject>

- (void)facebookfriendsLoader:(RCDFacebookFriendsLoader *)facebookfriendsLoader willRequestFriendsDataWithTask:(NSURLSessionDataTask *)task;

- (void)facebookfriendsLoader:(RCDFacebookFriendsLoader *)facebookfriendsLoader didLoadFriendsData:(NSArray *)friends;

- (void)facebookfriendsLoader:(RCDFacebookFriendsLoader *)facebookfriendsLoader didEncounterError:(NSError *)error;

@end

@interface RCDFacebookFriendsLoader : NSObject

@property (weak, nonatomic)id <RCDFacebookFriendsLoaderDelegate> delegate;

- (instancetype)initWithDataSource:(RCDFriendsListDataSource *)dataSource;
- (void)startLoadingFriends;

- (void)retryFailedRequest;

@end