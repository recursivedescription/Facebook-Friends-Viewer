//
//  RCDFacebookUser.h
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCDFacebookPicture;

@interface RCDFacebookUser : NSObject

@property (nonatomic, strong) NSString *facebookUserIdentifier;
@property (nonatomic, strong) RCDFacebookPicture *picture;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *firstName;

+ (RCDFacebookUser *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
