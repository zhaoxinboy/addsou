//
//  SubCollectionViewCell.m
//  MHJProjectTwo
//
//  Created by tangmi on 16/6/8.
//  Copyright © 2016年 tangmi. All rights reserved.
//

#import "SubCollectionViewCell.h"
#define angelToRandian(x)  ((x)/180.0*M_PI)
static NSString *animationKey = @"PagingShakeAnimation";

@interface SubCollectionViewCell ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SubCollectionViewCell

- (UIImageView *)headerButton{
    if (!_headerButton) {
        _headerButton = [UIImageView new];
        _headerButton.layer.masksToBounds = YES;
        _headerButton.layer.cornerRadius = 2;
        _headerButton.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_headerButton];
        [_headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(self.contentView.frame.size.width - 20);
        }];
    }
    return _headerButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = kRGBColor(51, 51, 51);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _titleLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton new];
        [_deleteButton setImage:[UIImage imageNamed:@"shanchu_icon"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
        [self.contentView addSubview:_deleteButton];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _deleteButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headerButton];
        [self titleLabel];
        [self deleteButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShake:) name:editStateChanged object:nil];
    }
    return self;
}

- (void)clickDeleteButton:(UIButton*)sender {
    
    DLog(@"delete")
    //删除功能
    [[NSNotificationCenter defaultCenter] postNotificationName:deleteCell object:self];
    
}

- (void)handleShake:(NSNotification*)sender
{
    if ([sender.object intValue] == YES) {
        
        self.deleteButton.hidden = NO;
        self.deleteButton.userInteractionEnabled = YES;
    
    }else{
        self.deleteButton.hidden = YES;

    }
}
//
//- (void)shake
//{
//    if ([self.layer animationForKey:animationKey]) {
//        return;
//    }
//    CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
//    anim.keyPath=@"transform.rotation";
//    anim.values=@[@(angelToRandian(-5)),@(angelToRandian(5)),@(angelToRandian(-5))];
//    anim.repeatCount=MAXFLOAT;
//    anim.duration=0.2;
//    [self.layer addAnimation:anim forKey:animationKey];
//}

//- (void)stopShake
//{
//    [self.layer removeAllAnimations];
//}


@end
