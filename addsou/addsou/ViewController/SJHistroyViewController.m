//
//  SJHistroyViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJHistroyViewController.h"
#import "ULBCollectionViewFlowLayout.h"
#import "QDRHistoryCollectionViewCell.h"
#import "SJWebViewController.h"
#import "QDRClearCacheView.h"

@interface SJHistroyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ULBCollectionViewDelegateFlowLayout, removeDelegate>

@property (nonatomic, strong) QDRClearCacheView *clearView;

@property (nonatomic, strong) SJNavcView *navcView;   // 自定义导航

@property (nonatomic, strong) UICollectionView *collectionView;



@end

@implementation SJHistroyViewController

- (QDRClearCacheView *)clearView{
    if (!_clearView) {
        _clearView = [[QDRClearCacheView alloc] initWithTarget:self];
        _clearView.clearCacheLabel.text = @"清除记录";
        _clearView.isClearLabel.text = @"是否清除记录";
        [_clearView.determineBtn addTarget:self action:@selector(cleanHistroy) forControlEvents:UIControlEventTouchUpInside];
        _clearView.delegate = self;
    }
    return _clearView;
}

// 清空历史记录
- (void)cleanHistroy{
    __weak typeof(self)wself = self;
    [self.historyVM postDeleteHistoryAppByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
        if ([wself.historyVM.clearStatus isEqualToString:@"0"]) {
            [wself.historyVM.dataArr removeAllObjects];
            [wself.collectionView reloadData];
            [_clearView closeSelf];
        }
    }];
}

- (void)removeClearView{
    [self setClearView:nil];
}


// section背景颜色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return [UIColor whiteColor];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        ULBCollectionViewFlowLayout *myLayout = [[ULBCollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = (kWindowW - 60) / 2;
        //设置元素大小
        CGFloat height = QDR_HISTORY_HEIGHT;
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(38, 10, 38, 10);
        myLayout.minimumInteritemSpacing = 30;
        myLayout.minimumLineSpacing = 30;
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //集合视图初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        //注册单元格Cell
        [_collectionView registerClass:[QDRHistoryCollectionViewCell class] forCellWithReuseIdentifier:@"QDRHistoryCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.alwaysBounceVertical = YES;
        
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //禁用滚动
        //        _addressCollectionView.scrollEnabled = NO;
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
        
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyVM.rowNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(self.historyVM.rowNumber > 0){ return 1; }
    else{ return 0; }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDRHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRHistoryCollectionViewCell" forIndexPath:indexPath];
    NSLog(@"%@", [self.historyVM imageURLForRow:indexPath.row].absoluteString);
    if (self.historyVM.rowNumber != 0) {
        [cell.imageView sd_setImageWithURL:[self.historyVM imageURLForRow:indexPath.row]];
        cell.titleLabel.text = [self.historyVM appNameForRow:indexPath.row];
        
    }
    return cell;
}



//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加历史记录
    [self.homeVM postAddHistoryToUserFromNetWithUrlId:[self.historyVM appIdForRow:indexPath.row] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
    }];
    SJHistoryArrModel *model = (SJHistoryArrModel *)self.historyVM.dataArr[indexPath.row];
    SJWebViewController *webvc = [[SJWebViewController alloc] initWithUrlStr:model.appurl andAppImageUrlStr:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath] andSuperCode:model.supercode withAppName:model.appname];
    [self.navigationController pushViewController:webvc animated:YES];
}

//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 组头高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 15);
//    
//}

- (void)getNetWorking
{
    __weak typeof (self) wself = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]) {
        [self.historyVM getHistoryByUseridWithUserid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
            if (wself.historyVM.rowNumber > 0) {
                wself.navcView.rightBtn.alpha = 1;
                // 回到主线程刷新UI
                [wself.collectionView reloadData];
            }else{
                wself.navcView.rightBtn.alpha = 0;
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [_navcView.goBackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = @"浏览记录";
        _navcView.rightBtn.alpha = 1;
        [_navcView.rightBtn setTitle:@"清除记录" forState:UIControlStateNormal];
        _navcView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_navcView.rightBtn setTitleColor:kRGBColor(51, 51, 51) forState:UIControlStateNormal];
        [_navcView.rightBtn addTarget:self action:@selector(deleteHistroy) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_navcView];
    }
    return _navcView;
}

// 清除记录
- (void)deleteHistroy{
    [self clearView];
    [_clearView openSelf];
}

- (void)go2Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kRGBColor(227, 227, 227);
    
    [self collectionView];
    [self navcView];
    [self getNetWorking];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
