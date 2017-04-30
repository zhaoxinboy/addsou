//
//  SJVoiceHistroyTableViewCell.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/24.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceHistroyTableViewCell.h"

@implementation SJVoiceHistroyTableViewCell

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = kRGBColor(51, 51, 51);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _label;
}


- (void)getModelWithModel:(SJHistoryArrModel *)model{
    self.model = model;
    [self label];
    self.label.text = model.appname;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
