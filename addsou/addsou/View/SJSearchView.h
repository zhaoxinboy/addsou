//
//  SJSearchView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSearchTextField.h"
#import "SJSearchTableView.h"
#import "SJWebViewController.h"
#import "SJKeywordsCollectionView.h"
#import "SJSearchCollectionView.h"

@interface SJSearchView : UIView

@property (nonatomic, strong) UIView *topView;   /* 盛放搜索框和取消按钮的视图 */

@property (nonatomic, strong) UIImageView *searchImageView;      // 搜索引擎图标

@property (nonatomic, strong) UISearchBar *searchBar;   /* 搜索框 */

@property (nonatomic, strong) SJSearchCollectionView *searchCollectionView;   /* 搜索应用结果 */

@property (nonatomic, strong) SJKeywordsCollectionView *keyCollection;   /* 关键词展示 */


@end
