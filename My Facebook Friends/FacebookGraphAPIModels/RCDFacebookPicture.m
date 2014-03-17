//
//  RCDPicture.m
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookPicture.h"
#import "NSDictionary+RCDTypesafeExtraction.h"

NSString *const kRCDPictureData = @"data";
NSString *const kRCDPictureUrl = @"url";


@interface RCDFacebookPicture ()

@end

@implementation RCDFacebookPicture

+ (RCDFacebookPicture *)modelObjectWithDictionary:(NSDictionary *)dict
{
    RCDFacebookPicture *instance = [[RCDFacebookPicture alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *pictureData = [dict rcd_dictionaryObjectForKey:kRCDPictureData];
        self.urlString = [pictureData rcd_stringObjectForKey:kRCDPictureUrl];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.urlString ?: @"nil" forKey:kRCDPictureData];

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
