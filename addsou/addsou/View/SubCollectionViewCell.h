//
//  SubCollectionViewCell.h
//  MHJProjectTwo
//
//  Created by tangmi on 16/6/8.
//  Copyright © 2016年 tangmi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *reusableCell = @"SubCollectionViewCell";

static NSString *editStateChanged = @"editStateChanged";

static NSString *deleteCell = @"deleteCellNotification";

@interface SubCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *headerButton;


@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *deleteButton;


- (void)shake;

- (void)stopShake;

@end
