//
//  SJKeywordsCollectionViewCell.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/19.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *KeywordsReusableCell = @"KeywordsSubCollectionViewCell";

static NSString *KeywordsEditStateChanged = @"KeywordsEditStateChanged";

static NSString *KeywordsAddCell = @"KeywordsAddCellNotification";

@interface SJKeywordsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;   /* 图片 */

@property (nonatomic, strong) UILabel *titleLabel;   /* 名称 */

@property (nonatomic, strong) UIButton *stateBtn;   /* 状态按钮 */

- (void)shake;

- (void)stopShake;

@end
