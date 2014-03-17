//
//  RCDFacebookFriendsListViewController.m
//  My Facebook Friends
//
//  Created by Recursive Description on 3/14/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookFriendsListViewController.h"
#import "RCDFriendsListDataSource.h"
#import "RCDFacebookFriendsLoader.h"
#import <AFNetworking/UIActivityIndicatorView+AFNetworking.h>

@interface RCDFacebookFriendsListViewController () <UISearchBarDelegate, RCDFacebookFriendsLoaderDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) RCDFriendsListDataSource *dataSource;
@property (strong, nonatomic) RCDFacebookFriendsLoader *friendsLoader;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation RCDFacebookFriendsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Facebook Friends";
    self.dataSource = [[RCDFriendsListDataSource alloc]init];
    self.collectionView.dataSource = self.dataSource;
    self.friendsLoader = [[RCDFacebookFriendsLoader alloc]initWithDataSource:self.dataSource];
    self.friendsLoader.delegate = self;
    [self.friendsLoader startLoadingFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - RCDFacebookFriendsLoaderDelegate methods

- (void)facebookfriendsLoader:(RCDFacebookFriendsLoader *)facebookfriendsLoader willRequestFriendsDataWithTask:(NSURLSessionDataTask *)task {
    [self.activityIndicatorView setAnimatingWithStateOfTask:task];
}


- (void)facebookfriendsLoader:(RCDFacebookFriendsLoader *)facebookfriendsLoader didLoadFriendsData:(NSArray *)friends {
    [self.collectionView reloadData];
}

- (void)facebookfriendsLoader:(RCDFacebookFriendsLoader *)facebookfriendsLoader didEncounterError:(NSError *)error {
    [self handleError:error];
}

- (void)handleError:(NSError *)error {
    
    //just looking for common network errors here. Any production ready app would essentially handle other errors including API side errors as
    //like that in NSError+FBError.h in the facebook SDK
    NSString *errorMessage = @"Oops! somthing isn't right. Please try after some time or contact customer service if the problem persits";
    NSError *underLyingError = error.userInfo[NSUnderlyingErrorKey];
    if ([underLyingError.domain isEqualToString:NSURLErrorDomain]) {
        switch (underLyingError.code) {
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorCannotConnectToHost:
                errorMessage  = @"Please check your internet connection and try again";
                break;
            default:
                break;
        }
    }
    //Alerts aren't cool, but sometime they are better than not displaying errors at all
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error loading friends" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UISearchBar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    if (searchBar.text && ![searchBar.text isEqualToString:@""]) {
        [self.dataSource filterFriendNamesWithString:searchBar.text];
        [self.collectionView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
        [self.dataSource filterFriendNamesWithString:[searchBar.text isEqualToString:@""] ? nil : searchBar.text];
        [self.collectionView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.dataSource filterFriendNamesWithString:nil];
    [self.collectionView reloadData];
}

@end
