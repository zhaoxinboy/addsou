//
//  SJSearchCollectionView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/2/20.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchCollectionView.h"
#import "SJKeywordsCollectionViewCell.h"

@implementation SJSearchCollectionView


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        //注册单元格Cell
        [self registerClass:[SJKeywordsCollectionViewCell class] forCellWithReuseIdentifier:@"SJSearchCollView"];
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = FALSE;
        self.showsHorizontalScrollIndicator = FALSE;
        //设置代理
        self.dataSource = self;
        self.delegate = self;

    }
    return self;
}

- (void)reloadCollectionView{
    
    [self reloadData];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    DLog(@"%lu", (unsigned long)self.dataArr.count)
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJKeywordsCollectionViewCell *cell = (SJKeywordsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SJSearchCollView" forIndexPath:indexPath];
    
    SJHomeAddressDataModel *model = self.dataArr[indexPath.item];
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    cell.titleLabel.text = model.appname;
    if ([model.iscollected isEqualToString:@"1"]) {
        cell.stateBtn.selected = YES;
    }else if([model.iscollected isEqualToString:@"0"]){
        cell.stateBtn.selected = NO;
    }
    cell.stateBtn.tag = indexPath.item + 3000;
    [cell.stateBtn addTarget:self action:@selector(didChangeStateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

// 关注按钮点击事件
- (void)didChangeStateBtn:(UIButton *)sender{
    SJHomeAddressDataModel *model = self.dataArr[sender.tag - 3000];
    __weak typeof (self) wself = self;
    if (!sender.selected) {
        // 添加应用
        [self.searchVM postAddAppInfoToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
            if ([wself.searchVM.successStr isEqualToString:@"success"]) {
                model.iscollected = @"1";
                // 更改本地数据防止数据错乱
                [self.dataArr replaceObjectAtIndex:(sender.tag - 3000) withObject:model];
                sender.selected = YES;
            }
        }];
    }else{
        // 删除应用
        [self.searchVM postDeleteCollectAppByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) appid:[NSString stringWithFormat:@"%@", model.qdrid] CompleteHandle:^(NSError *error) {
            if ([wself.searchVM.deleStr isEqualToString:@"success"]) {
                model.iscollected = @"0";
                // 更改本地数据防止数据错乱
                [self.dataArr replaceObjectAtIndex:(sender.tag - 3000) withObject:model];
                sender.selected = NO;
            }
        }];
    }

}

- (SJSearchViewModel *)searchVM{
    if (!_searchVM) {
        _searchVM = [SJSearchViewModel new];
    }
    return _searchVM;
}



//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SJKeywordsCollectionViewCell *cell = (SJKeywordsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(searchCollectionIndexPathRow:model:)]) {
        SJHomeAddressDataModel *model = self.dataArr[indexPath.item];
        [self.clickDelegate searchCollectionIndexPathRow:indexPath.row model:model];
    }
    
    if (cell.stateBtn.selected) {
        SJHomeAddressDataModel *model = self.dataArr[indexPath.item];
        __weak typeof (self) wself = self;
        if (!cell.stateBtn.selected) {
            // 添加应用
            [self.searchVM postAddAppInfoToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
                if ([wself.searchVM.successStr isEqualToString:@"success"]) {
                    model.iscollected = @"1";
                    // 更改本地数据防止数据错乱
                    [self.dataArr replaceObjectAtIndex:indexPath.item withObject:model];
                    cell.stateBtn.selected = YES;
                }
            }];
        }else{
            // 删除应用
            [self.searchVM postDeleteCollectAppByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) appid:[NSString stringWithFormat:@"%@", model.qdrid] CompleteHandle:^(NSError *error) {
                if ([wself.searchVM.deleStr isEqualToString:@"success"]) {
                    model.iscollected = @"0";
                    // 更改本地数据防止数据错乱
                    [self.dataArr replaceObjectAtIndex:indexPath.item withObject:model];
                    cell.stateBtn.selected = NO;
                }
            }];
        }
    }else{
        
    }
}

//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




// 点击collectionview关闭键盘并跳转回主页
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    id view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[self class]]) {
        if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(jumpToHomePage)]) {
            [self.clickDelegate jumpToHomePage];
        }
        return self;
    }else{
        return view;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
