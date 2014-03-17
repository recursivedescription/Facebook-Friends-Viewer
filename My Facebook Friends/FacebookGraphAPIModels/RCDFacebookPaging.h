//
//  RCDPaging.h
//
//  Created by Recursive Description on 3/16/14
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RCDFacebookPaging : NSObject

@property (nonatomic, strong) NSString *previous;
@property (nonatomic, strong) NSString *next;

+ (RCDFacebookPaging *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
