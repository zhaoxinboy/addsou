//
//  SJSearchCollectionView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/2/20.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSearchViewModel.h"

@protocol searchCollectionIndexPathDelegate <NSObject>

- (void)searchCollectionIndexPathRow:(NSInteger)index model:(SJHomeAddressDataModel *)model;

- (void)jumpToHomePage;

@end

@interface SJSearchCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) id<searchCollectionIndexPathDelegate> clickDelegate;   /* 点击方法代理 */

@property (nonatomic, strong) NSMutableArray *dataArr;   /* 数据源 */

@property (nonatomic, strong) SJSearchViewModel *searchVM;   /* 添加删除VM */

- (void)reloadCollectionView;

@end
