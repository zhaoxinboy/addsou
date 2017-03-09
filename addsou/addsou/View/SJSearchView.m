//
//  SJSearchView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchView.h"

@implementation SJSearchView

- (SJSearchCollectionView *)searchCollectionView{
    if (!_searchCollectionView) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = SJ_ADAPTER_WIDTH(82);
        //设置元素大小
        CGFloat height = SJ_ADAPTER_HEIGHT(100);
        if (kWindowW <= 320) {
            height = SJ_ADAPTER_HEIGHT(115);
        }
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(60, 10, 40, 10);
        //        myLayout.minimumInteritemSpacing = (kWindowW - 280) / 2;  // 同一列中间隔的cell最小间距
        myLayout.minimumLineSpacing = 40;       // 最小行间距
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _searchCollectionView = [[SJSearchCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        [self addSubview:_searchCollectionView];
        [_searchCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-44);
        }];
    }
    return _searchCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self searchCollectionView];
        [self keyCollection];
        [self topView];
        [self searchBar];
    }
    return self;
}



- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        _topView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _topView.layer.shadowOffset = CGSizeMake(0, 0);
        _topView.layer.shadowOpacity = 1;
    }
    return _topView;
}

- (UIButton *)searchImageBtn{
    if (!_searchImageBtn) {
        _searchImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topView addSubview:_searchImageBtn];
        [_searchImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _searchImageBtn;
}

- (UIImageView *)searchImageView{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] init];
        _searchImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_topView addSubview:_searchImageView];
        [_searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _searchImageView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 0, kWindowW - 10 - 50, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.showsCancelButton = YES;
        _searchBar.barTintColor = [UIColor blackColor];
        
        [self.topView addSubview:_searchBar];
    }
    return _searchBar;
}

- (SJKeywordsCollectionView *)keyCollection{
    if (!_keyCollection) {
        _keyCollection = [[SJKeywordsCollectionView alloc] initWithFrame:CGRectZero];
        _keyCollection.backgroundColor = [UIColor whiteColor];
        [self addSubview:_keyCollection];
        [_keyCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-44);
        }];
    }
    return _keyCollection;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
