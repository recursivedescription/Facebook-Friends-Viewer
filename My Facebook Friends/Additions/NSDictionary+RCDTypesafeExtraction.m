//
//   NSDictionary+RCDTypesafeExtraction.h
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "NSDictionary+RCDTypesafeExtraction.h"

@implementation NSDictionary (RCDTypesafeExtraction)

- (id) rcd_objectForKey:(id)key requiredType:(Class)type {
    id obj = self[key];
    return [obj isKindOfClass:type] ? obj : nil;
}


- (NSString *) rcd_stringObjectForKey:(id)key {
    return [self rcd_objectForKey:key requiredType:[NSString class]];
}

- (NSNumber *) rcd_numberObjectForKey:(id)key {
    return [self rcd_objectForKey:key requiredType:[NSNumber class]];
}

- (NSArray *) rcd_arrayObjectForKey:(id)key {
    return [self rcd_objectForKey:key requiredType:[NSArray class]];
}

- (NSArray *) rcd_arrayObjectForKey:(id)key constrainedToClass:(Class)class {
    NSArray *unsafeArray = [self rcd_objectForKey:key requiredType:[NSArray class]];
    if (!unsafeArray) { return nil; }
    
    // Only keep objects matching the given class
    return [unsafeArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:class];
    }]];
}

- (NSDictionary *) rcd_dictionaryObjectForKey:(id)key {
    return [self rcd_objectForKey:key requiredType:[NSDictionary class]];
}

- (NSURL *) rcd_URLObjectForKey:(id)key {
    NSURL *url = [self rcd_objectForKey:key requiredType:[NSURL class]];
    if (url) { return url; }
    
    // Convert from string
    NSString *str = [self rcd_objectForKey:key requiredType:[NSString class]];
    if ([str length] > 0) {
        return [[NSURL alloc] initWithString:str];
    }
    return nil;
}

- (NSNumber *) rcd_numberValueForKey:(id)key {
    NSNumber *numberObject = [self rcd_numberObjectForKey:key];
    if (numberObject) {
        return numberObject;
    }
    NSString *numberString = [self rcd_stringObjectForKey:key];
    if ([numberString length]>0) {
        return @([numberString floatValue]);
    }
    return nil;
}

- (float) rcd_floatValueForKey:(id)key {
    NSNumber *numberObject = [self rcd_numberObjectForKey:key];
    if (numberObject) {
        return [numberObject floatValue];
    }
    NSString *numberString = [self rcd_stringObjectForKey:key];
    if (numberString) {
        return [numberString floatValue];
    }
    return 0.0f;
}

- (NSInteger) rcd_integerValueForKey:(id)key {
    NSNumber *numberObject = [self rcd_numberObjectForKey:key];
    if (numberObject) {
        return [numberObject integerValue];
    }
    NSString *numberString = [self rcd_stringObjectForKey:key];
    if (numberString) {
        return [numberString integerValue];
    }
    return 0;
}

- (BOOL) rcd_boolValueForKey:(id)key {
    NSNumber *numberObject = [self rcd_numberObjectForKey:key];
    if (numberObject) {
        return [numberObject boolValue];
    }
    NSString *numberString = [self rcd_stringObjectForKey:key];
    if (numberString) {
        return [numberString boolValue];
    }
    return NO;
}

@end
