//
//  RCDFriendsListDataSource.m
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFriendsListDataSource.h"
#import "RCDFacebookUserWithImageCell.h"
#import "RCDFacebookUser.h"
#import "RCDFacebookPicture.h"

static NSString* const FacebookNameAndImageCellIdentifer = @"FBNameAndImageCell";

@interface RCDFriendsListDataSource ()

//all friends
@property (strong, nonatomic) NSMutableSet *allFriends;

//sorted list of friends
@property (strong, nonatomic) NSArray *sortedFriends;

//ordered and filtered list of friends. This will be used by the collectionViewDataSource methods
@property (strong, nonatomic) NSArray *processedFriends;

@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSString *filterString;


@end

@implementation RCDFriendsListDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.allFriends = [NSMutableSet set];
        NSSortDescriptor *firstNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *lastNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
        self.sortDescriptors = @[firstNameDescriptor, lastNameDescriptor];
    }
    return self;
}
- (void)addFriendsData:(NSArray *)friendsData {
    
    [self.allFriends addObjectsFromArray:friendsData];
    self.sortedFriends = [self.allFriends sortedArrayUsingDescriptors:self.sortDescriptors];
    self.processedFriends = [self filteredArrayFromArray:self.sortedFriends usingFilterString:self.filterString];
}

- (NSArray *)filteredArrayFromArray:(NSArray *)originalArray usingFilterString:(NSString *)filterString {
    
    if (!filterString) {
        return originalArray;
    }
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"firstName BEGINSWITH[c] %@ || lastName BEGINSWITH[c] %@ || name BEGINSWITH[c] %@", filterString, filterString, filterString];
    return [originalArray filteredArrayUsingPredicate:predicate];
}


- (void)filterFriendNamesWithString:(NSString *)filterStringOrNil {
    
    if ([filterStringOrNil isEqualToString:self.filterString]) {
        return;
    }
    self.filterString = filterStringOrNil;
    self.processedFriends = [self filteredArrayFromArray:self.sortedFriends usingFilterString:self.filterString];
}

- (void)clearFriendsData {
    
    [self.allFriends removeAllObjects];
    self.sortedFriends = nil;
    self.processedFriends = nil;
}

#pragma mark - CollectionView datasource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.processedFriends.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCDFacebookUserWithImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FacebookNameAndImageCellIdentifer forIndexPath:indexPath];
    
    if (indexPath.row < self.processedFriends.count) {
        RCDFacebookUser *facebookUser = self.processedFriends[indexPath.row];
        [cell configureWithImageURLString:facebookUser.picture.urlString name:facebookUser.name];
    }
    return cell;
}

@end