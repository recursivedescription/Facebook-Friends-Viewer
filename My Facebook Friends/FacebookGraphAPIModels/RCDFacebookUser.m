//
//  RCDFacebookUser.m
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookUser.h"
#import "RCDFacebookPicture.h"
#import "NSDictionary+RCDTypesafeExtraction.h"


NSString *const kRCDFacebookUserId = @"id";
NSString *const kRCDFacebookUserPicture = @"picture";
NSString *const kRCDFacebookUserLastName = @"last_name";
NSString *const kRCDFacebookUserName = @"name";
NSString *const kRCDFacebookUserFirstName = @"first_name";


@interface RCDFacebookUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RCDFacebookUser

@synthesize facebookUserIdentifier = _facebookUserIdentifier;
@synthesize picture = _picture;
@synthesize lastName = _lastName;
@synthesize name = _name;
@synthesize firstName = _firstName;


+ (RCDFacebookUser *)modelObjectWithDictionary:(NSDictionary *)dict
{
    RCDFacebookUser *instance = [[RCDFacebookUser alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.facebookUserIdentifier = [self objectOrNilForKey:kRCDFacebookUserId fromDictionary:dict];
            self.picture = [RCDFacebookPicture modelObjectWithDictionary:[dict objectForKey:kRCDFacebookUserPicture]];
            self.lastName = [self objectOrNilForKey:kRCDFacebookUserLastName fromDictionary:dict];
            self.name = [self objectOrNilForKey:kRCDFacebookUserName fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kRCDFacebookUserFirstName fromDictionary:dict];

    }
    
    return self;
    
}

#pragma mark - property overrides

- (NSString *)firstName {
    if (_firstName) {
        return _firstName;
    }else {
        return @"";
    }
}

- (NSString *)lastName {
    if (_lastName) {
        return _lastName;
    }else {
        return @"";
    }
}

//let facebookUserIdentifier be the unique identifier for storing in collections
- (BOOL)isEqual:(id)object {
    
	if (object == self)
		return YES;
	if (!object || ![object isKindOfClass:[self class]])
		return NO;
    if ((self.facebookUserIdentifier || [object facebookUserIdentifier]) && ![self.facebookUserIdentifier isEqualToString:[object facebookUserIdentifier]])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    
	NSUInteger prime = 31;
	NSUInteger result = 1;
	result = prime * result + (!self.facebookUserIdentifier ? 0 : [self.facebookUserIdentifier hash]);
    return result;
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.facebookUserIdentifier forKey:kRCDFacebookUserId];
    [mutableDict setValue:[self.picture dictionaryRepresentation] forKey:kRCDFacebookUserPicture];
    [mutableDict setValue:self.lastName forKey:kRCDFacebookUserLastName];
    [mutableDict setValue:self.name forKey:kRCDFacebookUserName];
    [mutableDict setValue:self.firstName forKey:kRCDFacebookUserFirstName];

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
