//
//   NSDictionary+RCDTypesafeExtraction.h
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * Helper methods for ensuring that the values pulled out of a dictionary are of the expected class.
 */
@interface NSDictionary (RCDTypesafeExtraction)

/*!
 * Return the object associated with the given key, if it is an NSString, otherwise nil.
 */
- (NSString *) rcd_stringObjectForKey:(id)key;

/*!
 * Return the object associated with the given key, if it is an NSArray, otherwise nil.
 */
- (NSArray *) rcd_arrayObjectForKey:(id)key;

/*!
 * Return the object associated with the given key, if it is an NSArray, otherwise nil. Any
 * objects contained in the original array which are not of the given class will be filtered out.
 */
- (NSArray *) rcd_arrayObjectForKey:(id)key constrainedToClass:(Class)class;

/*!
 * Return the object associated with the given key, if it is an NSDictionary, otherwise nil.
 */
- (NSDictionary *) rcd_dictionaryObjectForKey:(id)key;

/*!
 * Return the object associated with the given key, if it is an NSURL, or is an NSString
 * of non-zero length, otherwise nil.
 */
- (NSURL *) rcd_URLObjectForKey:(id)key;

/*!
 * Return the object associated with the given key, if it is an NSNumber, or if it is an NSString
 * which can be parsed into an NSNumber, otherwise nil.
 */
- (NSNumber *) rcd_numberValueForKey:(id)key;

/*!
 * Return the value associated with the given key, if it is an NSNumber, or if it is an NSString
 * which can be parsed into a float, otherwise returns 0.0f.
 */
- (float) rcd_floatValueForKey:(id)key;

/*!
 * Return the value associated with the given key, if it is an NSNumber, or if it is an NSString
 * which can be parsed into a float, otherwise returns 0.
 */
- (NSInteger) rcd_integerValueForKey:(id)key;

/*!
 * Return the boolean associated with the given key, if it is an NSNumber, or if it is an NSString
 * which can be parsed into a boolean, otherwise returns NO.
 */
- (BOOL) rcd_boolValueForKey:(id)key;

@end
