//
//  SJKeywordsCollectionView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJKeywordsCollectionView.h"

@interface SJKeywordsCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation SJKeywordsCollectionView

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

// 点击tabbleview关闭键盘并跳转回主页
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    id view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        if (self.keyDelegate && [self.keyDelegate respondsToSelector:@selector(takeTheKeyboard)]) {
            [self.keyDelegate takeTheKeyboard];
        }
        return self;
    }else if ([view isKindOfClass:[self class]]){
        if (self.keyDelegate && [self.keyDelegate respondsToSelector:@selector(takeTheKeyboard)]) {
            [self.keyDelegate takeTheKeyboard];
        }
        return self;
    }else{
        return view;
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //初始化布局类(UICollectionViewLayout的子类)
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.itemSize = CGSizeMake(20, 30);
        //初始化collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.backgroundColor = [UIColor clearColor];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.scrollEnabled = NO;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SJKeywordsCollectionView"];
        
        _collectionView.transform = CGAffineTransformMakeRotation(-M_PI);
        
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(170);
        }];
    }
    return _collectionView;
}

- (UIButton *)removeBtn{
    if (!_removeBtn) {
        _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeBtn setImage:[UIImage imageNamed:@"search_icon_delete"] forState:UIControlStateNormal];
        [_removeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _removeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _removeBtn.backgroundColor = kRGBColor(245, 245, 245);
        _removeBtn.layer.cornerRadius = 16;
        _removeBtn.layer.masksToBounds = YES;
        _removeBtn.tag = 100001;
        [self addSubview:_removeBtn];
        [_removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-180);
        }];
    }
    return _removeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self collectionView];
    }
    return self;
}


//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
//collectionView里有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJKeywordsCollectionView" forIndexPath:indexPath];
    
    UIColor *color = [self arcColorWithLabelAndCell];
    
    cell.layer.cornerRadius = 6;
    cell.contentView.layer.cornerRadius = 15;
    cell.contentView.layer.backgroundColor = [[color colorWithAlphaComponent:0.1] CGColor];
    cell.contentView.layer.masksToBounds = YES;
    
    for (UILabel *subView in cell.contentView.subviews) {
        DLog(@"subView   %@", subView);
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    UILabel *label = [UILabel new];
    // 截取字符串
    label.text = [self.dataArr[indexPath.row] stringByReplacingOccurrencesOfString:LOCAL_READ_UUID withString:@""];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI); //倒置
    return cell;
}

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = CGSizeMake(80, 30);
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.text = [self.dataArr[indexPath.row] stringByReplacingOccurrencesOfString:LOCAL_READ_UUID withString:@""];
    CGFloat width = [UILabel getWidthWithTitle:label.text font:label.font];
    cellSize.width = width + 32;
    
    // 自适应cell宽度
    return cellSize;
}

//设置每组的cell的边界, 具体看下图
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 15, 12, 15);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.keyDelegate && [self.keyDelegate respondsToSelector:@selector(keyWordsIndexPathRow:str:)]) {
        [self.keyDelegate keyWordsIndexPathRow:indexPath.row str:[self.dataArr[indexPath.row] stringByReplacingOccurrencesOfString:LOCAL_READ_UUID withString:@""]];
    }
}


// 随机数取颜色
- (UIColor *)arcColorWithLabelAndCell{
    int x = arc4random() % 4;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:3];
    [arr addObject:kRGBColor(252, 68, 133)];
    [arr addObject:kRGBColor(84, 155, 252)];
    [arr addObject:kRGBColor(254, 86, 65)];
    [arr addObject:kRGBColor(65, 175, 255)];
    return arr[x];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
