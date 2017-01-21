//
//  SJSearchCollView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/10.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchCollView.h"
#import "SJKeywordsCollectionViewCell.h"


@implementation SJSearchCollView

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (UIButton *)editorBtn{
    if (!_editorBtn) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editorBtn setTitle:@"点击编辑" forState:UIControlStateNormal];
        [_editorBtn setTitle:@"结束编辑" forState:UIControlStateSelected];
        _editorBtn.layer.masksToBounds = YES;
        _editorBtn.layer.cornerRadius = 4;
        _editorBtn.backgroundColor = kRGBColor(236, 236, 236);;
        _editorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_editorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_editorBtn addTarget:self action:@selector(ClickTheBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editorBtn];
        [_editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 25));
            make.left.mas_equalTo(10);
        }];
    }
    return _editorBtn;
}

- (void)reloadCollectionView{
    if (self.dataArr.count != 0) {
        self.hidden = NO;
    }
    if (self.editorBtn.selected) {
        self.editorBtn.selected = NO;
    }
    [self.collectionView reloadData];
}

- (void)ClickTheBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KeywordsEditStateChanged object:@YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KeywordsEditStateChanged object:@NO];
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = 65;
        //    220 * 365 宽*高
        //设置元素大小
        CGFloat height = 47;
        //        CGFloat height = width * 250.0/220.0;
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
//        myLayout.minimumInteritemSpacing = (kWindowW - 280) / 2;  // 同一列中间隔的cell最小间距
        myLayout.minimumLineSpacing = 1;       // 最小行间距
        myLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //集合视图初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        //注册单元格Cell
        [_collectionView registerClass:[SJKeywordsCollectionViewCell class] forCellWithReuseIdentifier:@"SJSearchCollView"];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.alwaysBounceVertical = NO;
        
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //禁用滚动
        //        _addressCollectionView.scrollEnabled = NO;
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-8);
            make.left.mas_equalTo(80);
        }];


    }
    return _collectionView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        [self editorBtn];
        [self collectionView];
    }
    return self;
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
    
    if (_editorBtn.selected) {
        cell.stateBtn.hidden = NO;
    }else{
        cell.stateBtn.hidden = YES;
    }
    
    return cell;
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
    if (self.editorBtn.selected) {
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
        if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(searchCollectionIndexPathRow:model:)]) {
            SJHomeAddressDataModel *model = self.dataArr[indexPath.item];
            [self.clickDelegate searchCollectionIndexPathRow:indexPath.row model:model];
        }
    }
}

//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
