//
//  SJSearchView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchView.h"

@implementation SJSearchView

- (SJSearchCollView *)searchCollectionView{
    if (!_searchCollectionView) {
        _searchCollectionView = [[SJSearchCollView alloc] init];
        _searchCollectionView.frame = CGRectMake(0, self.frame.size.height - 51, kWindowW, 51);
        [self addSubview:_searchCollectionView];
    }
    return _searchCollectionView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kWindowH - 90, kWindowW, 90);
        self.backgroundColor = kRGBColor(235, 235, 235);
        [self topView];
        [self searchBar];
        [self searchCollectionView];
        [self tabbleView];
        [self keyCollection];
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
            make.bottom.mas_equalTo(-51);
            make.height.mas_equalTo(44);
        }];
    }
    return _topView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, kWindowW - 10 - 10, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.showsCancelButton = YES;
        _searchBar.barTintColor = [UIColor blackColor];
        
        [self.topView addSubview:_searchBar];
    }
    return _searchBar;
}

//- (UITextField *)searchField{
//    if (!_searchField) {
//        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, kWindowW - 15 - 60, 34)];
//        _searchField.placeholder = @"关键词或网址";
//        [_searchField setValue:kRGBColor(153, 153, 153) forKeyPath:@"_placeholderLabel.color"];
//        [_searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//        _searchField.backgroundColor = kRGBColor(245, 245, 245);
//        _searchField.font = [UIFont systemFontOfSize:14];
//        _searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//        _searchField.leftViewMode = UITextFieldViewModeAlways;
////        [_searchField customWithPlaceholder:@"关键词或网址" color:kRGBColor(153, 153, 153) font:[UIFont systemFontOfSize:14]];
//        _searchField.returnKeyType = UIReturnKeyDone;
//        _searchField.borderStyle = UITextBorderStyleNone;
//        _searchField.textAlignment = NSTextAlignmentLeft;
////        _searchField.keyboardType = UIKeyboardTypeDefault;
//        _searchField.autocorrectionType = UITextAutocorrectionTypeYes;
//        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _searchField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        _searchField.layer.cornerRadius = 3;
//        _searchField.layer.masksToBounds = YES;
////        _searchField.secureTextEntry = NO;
//        [_topView addSubview:_searchField];
//    }
//    return _searchField;
//}

//- (UIButton *)cancelBtn{
//    if (!_cancelBtn) {
//        _cancelBtn = [UIButton new];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
//        [_cancelBtn setTitleColor:kRGBColor(51, 51, 51) forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [_topView addSubview:_cancelBtn];
//        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.mas_equalTo(0);
//            make.size.mas_equalTo(CGSizeMake(60, 44));
//        }];
//    }
//    return _cancelBtn;
//}

- (SJSearchTableView *)tabbleView{
    if (!_tabbleView) {
        _tabbleView = [[SJSearchTableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, self.frame.size.height - 95) style:UITableViewStylePlain];
        [self addSubview:_tabbleView];
    }
    return _tabbleView;
}

- (SJKeywordsCollectionView *)keyCollection{
    if (!_keyCollection) {
        _keyCollection = [[SJKeywordsCollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, self.frame.size.height - 95)];
        [self addSubview:_keyCollection];
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
