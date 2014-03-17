//
//  RCDFriendsListDataSource.h
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDFriendsListDataSource : NSObject<UICollectionViewDataSource>

/*!
 *  Add RCDFacebookUser objects to the data source
 *
 *  @param friendsData An Array of RCDFacebookUser objects
 */
- (void)addFriendsData:(NSArray *)friendsData;


/*!
 *  filters friends data by matching the specified string
 *  string with their names
 *  @param filterString the filer string to use. if it is nil, the filter is cleared
 */
- (void)filterFriendNamesWithString:(NSString *)filterStringOrNil;

/*!
 *  removes all friends from the datasource
 */
- (void)clearFriendsData;

@end