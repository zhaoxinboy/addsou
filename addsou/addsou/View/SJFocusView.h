//
//  SJFocusView.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/6.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCollectionViewCell.h"
#import "PagingCollectionViewLayout.h"

#import "CircleLayout.h"
#import "XWDragCellCollectionView.h"

@interface SJFocusView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, XWDragCellCollectionViewDelegate, XWDragCellCollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataAll;

@property (nonatomic, strong) XWDragCellCollectionView *homeCollectionV;

@end
