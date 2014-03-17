//
//  RCDFacebookFriendListResponse.h
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCDFacebookPaging;

@interface RCDFacebookFriendListResponse : NSObject

/*!
 *  An array of RCDFacebookUser objects
 */
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) RCDFacebookPaging *paging;

+ (RCDFacebookFriendListResponse *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
