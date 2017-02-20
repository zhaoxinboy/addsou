//
//  SJFocusView.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/6.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJFocusView.h"

@implementation SJFocusView{
    BOOL _select;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        PagingCollectionViewLayout *layout = [[PagingCollectionViewLayout alloc]init];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = SJ_ADAPTER_WIDTH(74);

        //设置元素大小
        CGFloat height = (kWindowW <= 320) ? SJ_ADAPTER_HEIGHT(98) : SJ_ADAPTER_HEIGHT(88);
        //        CGFloat height = width * 250.0/220.0;
        layout.itemSize = CGSizeMake(width, height);
        //四周边距
        layout.sectionInset = UIEdgeInsetsMake(13, 3, 13, 3);
        layout.minimumInteritemSpacing = 1;  // 同一列中间隔的cell最小间距
        layout.minimumLineSpacing = 19;       // 最小行间距
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        
        
        CircleLayout *myLayout = [[CircleLayout alloc]init];
        myLayout.center = self.center;
        myLayout.radius = 10;
        myLayout.cellCount = 13;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(70, 85);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 2;
        
        
        self.homeCollectionV = [[XWDragCellCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        self.homeCollectionV.backgroundColor = [UIColor clearColor];
        self.homeCollectionV.tag = 100;
        self.homeCollectionV.delegate = self;
        self.homeCollectionV.dataSource = self;
        self.homeCollectionV.shakeLevel = 3.0f;
        [self.homeCollectionV setMinimumPressDuration:1];
        self.homeCollectionV.showsVerticalScrollIndicator = NO;
        self.homeCollectionV.showsHorizontalScrollIndicator = NO;
//        self.homeCollectionV.pagingEnabled = YES;
        self.homeCollectionV.alwaysBounceVertical = NO;
        self.homeCollectionV.showsVerticalScrollIndicator = FALSE;
        [self addSubview:self.homeCollectionV];
        //注册单元格
        [self.homeCollectionV registerClass:[SubCollectionViewCell class] forCellWithReuseIdentifier:reusableCell];
        
        _select = NO;

    }
    return self;
}


- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    
    self.dataAll = newDataArray;
    
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    return  self.dataAll;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    DLog(@"%@", self.dataAll)
    DLog(@"%lu", (unsigned long)self.dataAll.count)
    return self.dataAll.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataAll[section];
    return array.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableCell forIndexPath:indexPath];
    NSString *name;
    NSArray *array =  self.dataAll[indexPath.section];
    
    SJHomeAddressDataModel *model = [array objectAtIndex:indexPath.item];
    
    if (model) {
        //    name = [array objectAtIndex:indexPath.item];
        name = [NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath];
        //    cell.backgroundColor = [UIColor greenColor];
        //    [cell.headerButton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [cell.headerButton sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:name]];
        if ([cell.layer animationForKey:@"shake"]) {
            cell.deleteButton.hidden = NO;
        }
        //    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
        cell.titleLabel.text = model.appname;
    }
    return cell;
}

//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array =  self.dataAll[indexPath.section];
    SJHomeAddressDataModel *model = [array objectAtIndex:indexPath.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionViewCellJump" object:model];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
