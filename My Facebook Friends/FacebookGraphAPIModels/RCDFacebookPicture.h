//
//  RCDPicture.h
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDFacebookPicture : NSObject

@property (nonatomic, strong) NSString *urlString;

+ (RCDFacebookPicture *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end