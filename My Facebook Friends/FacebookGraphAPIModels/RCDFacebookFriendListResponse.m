//
//  RCDFacebookFriendListResponse.m
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookFriendListResponse.h"
#import "RCDFacebookPaging.h"
#import "RCDFacebookUser.h"
#import "NSDictionary+RCDTypesafeExtraction.h"

NSString *const kRCDFacebookFriendListResponsePaging = @"paging";
NSString *const kRCDFacebookFriendListResponseFacebookUser = @"data";


@interface RCDFacebookFriendListResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RCDFacebookFriendListResponse

@synthesize paging = _paging;
@synthesize friends = _friends;


+ (RCDFacebookFriendListResponse *)modelObjectWithDictionary:(NSDictionary *)dict
{
    RCDFacebookFriendListResponse *instance = [[RCDFacebookFriendListResponse alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.paging = [RCDFacebookPaging modelObjectWithDictionary:[dict objectForKey:kRCDFacebookFriendListResponsePaging]];
    NSObject *receivedRCDFacebookUser = [dict objectForKey:kRCDFacebookFriendListResponseFacebookUser];
    NSMutableArray *parsedRCDFacebookUser = [NSMutableArray array];
    if ([receivedRCDFacebookUser isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedRCDFacebookUser) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRCDFacebookUser addObject:[RCDFacebookUser modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedRCDFacebookUser isKindOfClass:[NSDictionary class]]) {
       [parsedRCDFacebookUser addObject:[RCDFacebookUser modelObjectWithDictionary:(NSDictionary *)receivedRCDFacebookUser]];
    }

    self.friends = [NSArray arrayWithArray:parsedRCDFacebookUser];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.paging dictionaryRepresentation] forKey:kRCDFacebookFriendListResponsePaging];
NSMutableArray *tempArrayForFacebookUser = [NSMutableArray array];
    for (NSObject *subArrayObject in self.friends) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFacebookUser addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFacebookUser addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFacebookUser] forKey:@"kRCDFacebookFriendListResponseFacebookUser"];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
