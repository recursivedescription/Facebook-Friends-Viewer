//
//  RCDFacebookUserWithImageCell.m
//  My Facebook Friends
//
//  Created by Recursive Description on 3/16/14.
//  Copyright (c) 2014 Recursive Description. All rights reserved.
//

#import "RCDFacebookUserWithImageCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSInteger const kProfileImageViewTag = 11;
static NSInteger const kNameLabelTag = 12;

@interface RCDFacebookUserWithImageCell ()

@property (weak, nonatomic) UIImageView *profileImageView;
@property (weak, nonatomic) UILabel *nameLabel;

@end

@implementation RCDFacebookUserWithImageCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeCell];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self initializeCell];
}

- (void)initializeCell {
    
    self.profileImageView = (UIImageView *)[self viewWithTag:kProfileImageViewTag];
    self.profileImageView.image = [UIImage imageNamed:@"friendicon"];
    self.nameLabel = (UILabel *)[self viewWithTag:kNameLabelTag];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    [self.profileImageView cancelImageRequestOperation];
    self.profileImageView.image = [UIImage imageNamed:@"friendicon"];
}

- (void)configureWithImageURLString:(NSString *)urlString name:(NSString *)name {

    if (urlString) {
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"friendicon"]];
    }
    self.nameLabel.text = name;
}

@end