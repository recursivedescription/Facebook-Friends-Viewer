//
//  RCDFacebookLoginViewController.m
//  My Facebook Friends
//
//  Created by Recursive Description on 3/14/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookLoginViewController.h"
#import "RCDFacebookSessionManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString* const RCDFacebookFriendsListVCIdentifier = @"ToFacebookFriendsListVC";

@interface RCDFacebookLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loggedInUserLabel;
@property (strong, nonatomic) RCDFacebookSessionManager *facebookSessionManager;
@property (assign, nonatomic, getter = isLoggedIn) BOOL loggedIn;

- (IBAction)loginButtonTapped:(id)sender;

@end

@implementation RCDFacebookLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loggedInUserLabel.hidden = YES;
	self.facebookSessionManager = [RCDFacebookSessionManager manager];
}

- (IBAction)loginButtonTapped:(id)sender {
    
    if (!self.loggedIn) {
        [self performLogin];
    }else {
        [self performLogout];
    }
}

- (void)performLogin {
        
    [SVProgressHUD showWithStatus:@"Logging in..."];
    [self.facebookSessionManager loginWithPermissions:@"user_friends" completionHandler:^(BOOL isSuccessful, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (isSuccessful) {
            self.loggedIn = YES;
            NSString *userFullName = self.facebookSessionManager.activeFacebookAccount.userFullName;
            if (userFullName) {
                self.loggedInUserLabel.text = userFullName;
                self.loggedInUserLabel.hidden = NO;
            }
            [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
            [self performSegueWithIdentifier:RCDFacebookFriendsListVCIdentifier sender:self];
        }else {
            [self handleLoginError:error];
        }
    }];
}

- (void)handleLoginError:(NSError *)error {

    NSString *errorMessage;
    switch (error.code) {
        case RCDFacebookSessionManagerErrorAccessDeniedOrNoAccountsConfigured:
            errorMessage = @"Please make sure that you have configured your facebook account in settings and granted access to this app";
            break;
        case RCDFacebookSessionManagerNetworkError:
            errorMessage = @"Please check your internet connection and try again";
            break;
        default:
            errorMessage = @"Possibly, you haven't configured a facebook account in settings or haven't granted us access to you account. Also, please check your internet connection. If you still experience problems, contact customer support";
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)performLogout {

    self.loggedInUserLabel.text = nil;
    self.loggedInUserLabel.hidden = YES;
    [self.loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [self.facebookSessionManager logout];
    self.loggedIn = NO;
}

@end