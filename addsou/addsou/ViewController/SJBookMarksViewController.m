//
//  SJBookMarksViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJBookMarksViewController.h"
#import "SJHomePageLayout.h"
#import "SJBookMarksHomeCollectionViewCell.h"
#import "SJWebViewController.h"
#import "SJNoBookView.h"
#import "CardLayout.h"
#import "SJBookMarksLayout.h"

@interface SJBookMarksViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UIScrollViewDelegate, CardLayoutDelegate>


@property (nonatomic, strong) UICollectionView *collectionView;   /* 展示卡片 */

@property (nonatomic, strong) CardLayout* cardLayout;   // 布局

@property (nonatomic, strong) UIButton *closeBtn;   /* 关闭按钮 */

@property (nonatomic, strong) UILabel *nullLabel;// 无数据时显示的文字

@property (nonatomic, strong) NSMutableArray *dataArray; //书签数据源

@property (nonatomic, strong) SJNoBookView *noBookView;   /* 无书签时的view */

@end

@implementation SJBookMarksViewController

- (SJNoBookView *)noBookView{
    if (!_noBookView) {
        _noBookView = [[SJNoBookView alloc] init];
        [self.view addSubview:_noBookView];
        _noBookView.alpha = 0;
    }
    return _noBookView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        _closeBtn.layer.cornerRadius = 30;
        _closeBtn.layer.masksToBounds = YES;
        [_closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo((kWindowW <= 320) ? (-20) : (-30));
        }];
    }
    return _closeBtn;
}

- (void)closeSelf{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)nullLabel{
    if (!_nullLabel) {
        _nullLabel = [UILabel new];
        _nullLabel.textColor = [UIColor whiteColor];
        _nullLabel.font = [UIFont systemFontOfSize:16];
        _nullLabel.textAlignment = NSTextAlignmentCenter;
        _nullLabel.text = @"暂无书签，快去添加自己喜欢的网页吧！";
    }
    return _nullLabel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)updateBlur:(CGFloat)blur ForRow:(NSInteger)row
{
    if (![self.cardLayout isKindOfClass:[CardLayout class]]) {
        return;
    }
    SJBookMarksHomeCollectionViewCell* cell = (SJBookMarksHomeCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setBlur:blur];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        self.cardLayout =  [[CardLayout alloc]initWithOffsetY:400];
        self.cardLayout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.cardLayout];
        [_collectionView registerClass:[SJBookMarksHomeCollectionViewCell class] forCellWithReuseIdentifier:@"SJBookMarksHomeCollectionViewCell"];
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        _collectionView.bounces = YES;
//        _collectionView.pagingEnabled = YES;
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_collectionView) {
        [self.dataArray removeAllObjects];
        self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
//        NSEnumerator *enumerator = [self.dataArray reverseObjectEnumerator];
//        self.dataArray = (NSMutableArray*)[enumerator allObjects];
        if (self.dataArray.count == 0) {
            self.collectionView.alpha = 0;
            self.noBookView.alpha = 1;
            self.view.backgroundColor = [UIColor whiteColor];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            self.view.backgroundColor = [UIColor blackColor];
            self.noBookView.alpha = 0;
            self.collectionView.alpha = 1;
            [self.collectionView reloadData];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.dataArray removeAllObjects];
    self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
//    NSEnumerator *enumerator = [self.dataArray reverseObjectEnumerator];
//    self.dataArray = (NSMutableArray*)[enumerator allObjects];
    [self collectionView];
    
    
    [self noBookView];
    
    [self closeBtn];
    
    // 删除cell的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionViewdeleteCell:) name:@"deleteBookMarksCell" object:nil];
    // Do any additional setup after loading the view.
    
}

- (void)collectionViewdeleteCell:(NSNotification*)noti{
    SJBookMarksHomeCollectionViewCell *cell = noti.object;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    QDRBookViewModel *deleModel = self.dataArray[indexPath.item];
    if ([[FMDBManager sharedFMDBManager] deleteBookView:deleModel]){
        [self showSuccessMsg:@"删除书签成功"];
        [self.dataArray removeObjectAtIndex:indexPath.item];
        
        ///Animation
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath,]];
        } completion:^(BOOL finished) {
            
        }];
        
        if (self.dataArray.count == 0) {
            self.view.backgroundColor = [UIColor whiteColor];
            self.collectionView.alpha = 0;
            self.noBookView.alpha = 1;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
    }else{
        [self showSuccessMsg:@"删除书签失败，请重试"];
    }
}

- (void)dealloc{
    if (self.dataArray.count == 0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteBookMarksCell" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJBookMarksHomeCollectionViewCell *cell = (SJBookMarksHomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SJBookMarksHomeCollectionViewCell" forIndexPath:indexPath];
    QDRBookViewModel *model = self.dataArray[indexPath.row];
    if (model.imageData) {
        UIImage *image = [self Base64StrToUIImage:model.imageData];
        cell.titleContentView.image = image;
    }
    cell.title.text = model.appName;
    cell.titleLabel.text = model.titlestr;
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.titleData] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    
    return cell;
}

//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QDRBookViewModel *model = self.dataArray[indexPath.row];
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:model.url andAppImageUrlStr:model.titleData andSuperCode:model.superCode withAppName:model.appName];
    [self.navigationController pushViewController:vc animated:YES];
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
