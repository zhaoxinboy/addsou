//
//  SJKeywordsCollectionView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol keyWordsDelegate <NSObject>

- (void)keyWordsIndexPathRow:(NSInteger)index str:(NSString *)str;

- (void)takeTheKeyboard;

@end

@interface SJKeywordsCollectionView : UIView

@property (nonatomic, assign) id<keyWordsDelegate> keyDelegate;   /* 代理方法 */

@property (nonatomic, strong) NSMutableArray *dataArr;   /* 数据源 */

@property (nonatomic, strong) UICollectionView *collectionView;   /* 展示 */

@property (nonatomic, strong) UIButton *removeBtn;   /* 删除关键词按钮 */

@end
