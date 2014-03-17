//
//  RCDFacebookSessionManager.m
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookSessionManager.h"

static NSString* const RCDFacebookAppId = @"Your app id here";
NSString * const RCDFacebookSessionManagerErrorDomain = @"com.recursivedescription.FBSessionManagerErrorDomain";
NSString * const RCDFacebookBaseURL = @"https://graph.facebook.com";

@interface RCDFacebookSessionManager ()
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic, readwrite) ACAccount *activeFacebookAccount;

@end

@implementation RCDFacebookSessionManager

+ (instancetype)manager {
    
    static RCDFacebookSessionManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super manager];
        sharedInstance.accountStore = [[ACAccountStore alloc]init];
    });
    return sharedInstance;
}

- (void)loginWithPermissions:(NSString *)permissions completionHandler:(RCDFacebookLoginCompletionHandler)completionHandler {
    
    ACAccountType *facebookAccountType =  [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObject:RCDFacebookAppId forKey:ACFacebookAppIdKey];
    if (permissions && permissions.length > 0) {
        options[@"ACFacebookAppIdKey"] = RCDFacebookAppId;
    }
    __weak typeof (self) weakSelf = self;
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
        NSError *sessionManagerError;
        if (!granted) {
            [self handleLoginError:error completionHandler:completionHandler];
        }else {
            self.activeFacebookAccount = [[weakSelf.accountStore accountsWithAccountType:facebookAccountType]firstObject];
            //at this point, we should have a logged-in account, but let's not assume it
            if (!self.activeFacebookAccount) {
                sessionManagerError = [self facebookSessionManagerErrorWithErrorType:RCDFacebookSessionManagerErrorAccessDeniedOrNoAccountsConfigured underlyingErrorOrNil:nil];
            }
            [self notifyCompletionHandler:completionHandler success:!sessionManagerError error:sessionManagerError];
        }
    }];
    
}

- (void)handleLoginError:(NSError *)error completionHandler:(RCDFacebookLoginCompletionHandler)completionHandler {
    
    RCDFacebookSessionManagerError errorCode =  RCDFacebookSessionManagerErrorUnknown;
    if ([error.domain isEqualToString:@"com.apple.accounts"]) {
        //We can use error codes from ACError.h but unfortunately these error codes are not well documented for each of the services.
       //We can try to make the best guess to narrow down the error as much as possible
        if (error.code == 6) {
            //bad network connection
            errorCode = RCDFacebookSessionManagerNetworkError;
        }else if (error.code == 7){
            //most likely there is no facebook account configured in settings.app
            errorCode = RCDFacebookSessionManagerErrorAccessDeniedOrNoAccountsConfigured;
        }
    }
    // we shouldn't assume that `error` will be non-nil if `granted` is NO
    //create our own error object with relevant code and set the system error (in case we have have it) as underlying error in the userInfo dictionary.
    NSError *sessionManagerError = [self facebookSessionManagerErrorWithErrorType:errorCode underlyingErrorOrNil:error];
    [self notifyCompletionHandler:completionHandler success:NO error:sessionManagerError];

}

- (void)logout{
    __weak typeof (self) weakSelf = self;
    [self.accountStore removeAccount:self.activeFacebookAccount withCompletionHandler:^(BOOL success, NSError *error) {
        weakSelf.activeFacebookAccount = nil;
    }];
}


#pragma mark - helper methods
/*!
 *  calls the completion handler on the main thread with given sucess and error values
 */
- (void)notifyCompletionHandler:(void(^)(BOOL isSuccessful, NSError *error))comletionHandler success:(BOOL)success error:(NSError *)error {
   //always call the completion handler on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        if (comletionHandler) {
            comletionHandler(success, error);
        }
    });
}

- (NSError *)facebookSessionManagerErrorWithErrorType:(RCDFacebookSessionManagerError)errorType underlyingErrorOrNil:(NSError *)underlyingError {
    
    NSDictionary *userInfo = (underlyingError != nil) ? @{NSUnderlyingErrorKey: underlyingError} : nil;
    NSError *error = [NSError errorWithDomain:RCDFacebookSessionManagerErrorDomain code:errorType userInfo:userInfo];
    return error;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSMutableDictionary *paramtersWithAccessToken = parameters ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
    NSString *accessToken = self.activeFacebookAccount.credential.oauthToken;
    if (accessToken) {
        paramtersWithAccessToken[@"access_token"] = accessToken;
    }
    return [super GET:URLString parameters:paramtersWithAccessToken success:success failure:failure];
}
@end