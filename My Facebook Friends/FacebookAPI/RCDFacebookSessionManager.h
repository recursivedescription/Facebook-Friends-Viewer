//
//  RCDFacebookSessionManager.h
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AFNetworking/AFNetworking.h>

extern NSString * const RCDFacebookSessionManagerErrorDomain;

typedef NS_ENUM(NSInteger, RCDFacebookSessionManagerError) {
    
    RCDFacebookSessionManagerErrorUnknown = 0,
    RCDFacebookSessionManagerErrorAccessDeniedOrNoAccountsConfigured = 1,
    RCDFacebookSessionManagerNetworkError = 2,   //All other network errors
};

typedef void(^RCDFacebookLoginCompletionHandler)(BOOL isSuccessful, NSError *error);

@interface RCDFacebookSessionManager : AFHTTPSessionManager

@property (strong, nonatomic, readonly) ACAccount *activeFacebookAccount;

/*!
 *  The shared singleton
 *
 */
+ (instancetype)manager;

/*!
 *  Attempts to authenticate the app with the facebook API with the given set of graph API permissions
 *  and notifies the result via a callback block.
 *  Uses native iOS authentication mechanism (authentication via safari and via facebook app switching is not supported
 *  @param permissions:       a string containing comma values of graph API permissionas documented at
 *         https://developers.facebook.com/docs/facebook-login/permissions/
 *         eg: @"user_location, user_friends, friends_birthday"
 *  @param completionHandler:  A block that notifies the result of authentication. Called on the main thread
                                On success, `isSuccessful`
                               is set to YES and `error` is set to nil. On Failure, `isSuccessful` is set to NO
                               and `error` indicates the error occured. The error object has
                               RCDFacebookSessionManagerErrorDomain as the domain and the error code is set to one one  RCDFacebookSessionManagerError values. More specific error may be present in NSUnderlyingErrorKey in the infoDictionary
 */
- (void)loginWithPermissions:(NSString *)permissions completionHandler:(RCDFacebookLoginCompletionHandler)completionHandler;

- (void)logout;

@end