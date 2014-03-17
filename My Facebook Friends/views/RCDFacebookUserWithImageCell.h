//
//  RCDFacebookUserWithImageCelll.h
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDFacebookUser.h"

@interface RCDFacebookUserWithImageCell : UICollectionViewCell

- (void)configureWithImageURLString:(NSString *)urlString name:(NSString *)name;

@end