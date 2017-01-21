//
//  SJHomePageCollectionViewCell.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJHomePageCollectionViewCell.h"

@implementation SJHomePageCollectionViewCell





- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 6;
        self.contentView.layer.cornerRadius = 10.0f;
        self.contentView.layer.borderWidth = 0.5f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.layer.masksToBounds = YES;
        
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 6.0f;
        self.layer.shadowOpacity = 0.5f;
        self.layer.masksToBounds = NO;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
    }
    return self;
}

@end
