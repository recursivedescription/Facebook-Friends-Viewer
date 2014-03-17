//
//  RCDPaging.m
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookPaging.h"
#import "NSDictionary+RCDTypesafeExtraction.h"

NSString *const kRCDPagingPrevious = @"previous";
NSString *const kRCDPagingNext = @"next";


@interface RCDFacebookPaging ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RCDFacebookPaging

@synthesize previous = _previous;
@synthesize next = _next;


+ (RCDFacebookPaging *)modelObjectWithDictionary:(NSDictionary *)dict
{
    RCDFacebookPaging *instance = [[RCDFacebookPaging alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.previous = [self objectOrNilForKey:kRCDPagingPrevious fromDictionary:dict];
            self.next = [self objectOrNilForKey:kRCDPagingNext fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.previous forKey:kRCDPagingPrevious];
    [mutableDict setValue:self.next forKey:kRCDPagingNext];

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
