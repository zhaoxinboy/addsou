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

@interface SJBookMarksViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) UICollectionView *collectionView;   /* 展示卡片 */

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
        [_closeBtn setImage:[UIImage imageNamed:@"label_button_close"] forState:UIControlStateNormal];
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

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        SJHomePageLayout *layout = [[SJHomePageLayout alloc] init];
        layout.itemSize = CGSizeMake(SJ_ADAPTER_WIDTH(300), SJ_ADAPTER_HEIGHT(480));
        layout.minimumLineSpacing = SJ_ADAPTER_WIDTH(18);//设置cell的间距
        layout.sectionInset = UIEdgeInsetsMake(SJ_ADAPTER_HEIGHT(32), SJ_ADAPTER_WIDTH(38), SJ_ADAPTER_HEIGHT(88), SJ_ADAPTER_WIDTH(38));//设置四周的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [_collectionView registerClass:[SJBookMarksHomeCollectionViewCell class] forCellWithReuseIdentifier:@"SJBookMarksHomeCollectionViewCell"];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.alwaysBounceVertical = NO;
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    if (_collectionView) {
        [self.dataArray removeAllObjects];
        self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
        NSEnumerator *enumerator = [self.dataArray reverseObjectEnumerator];
        self.dataArray = (NSMutableArray*)[enumerator allObjects];
        if (self.dataArray.count == 0) {
            self.collectionView.alpha = 0;
            self.noBookView.alpha = 1;
        }else{
            self.noBookView.alpha = 0;
            self.collectionView.alpha = 1;
            [self.collectionView reloadData];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(51, 51, 51);
    [self.dataArray removeAllObjects];
    self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
    NSEnumerator *enumerator = [self.dataArray reverseObjectEnumerator];
    self.dataArray = (NSMutableArray*)[enumerator allObjects];
    [self collectionView];
    
    
    [self noBookView];
    
    [self closeBtn];
    // Do any additional setup after loading the view.
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
    cell.titleLabel.text = model.titlestr;
    cell.deleteImage.image = [UIImage imageNamed:@"label_icon_delete"];
    cell.deleteBtn.tag = indexPath.item + 1000;
    [cell.deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QDRBookViewModel *model = self.dataArray[indexPath.row];
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:model.url andAppImageUrlStr:model.titleData andSuperCode:model.superCode];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)deleteCell:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(sender.tag - 1000) inSection:0];
    QDRBookViewModel *deleModel = self.dataArray[indexPath.item];
    if ([[FMDBManager sharedFMDBManager] deleteBookView:deleModel]){
        [self showSuccessMsg:@"删除书签成功"];
        [self.dataArray removeObjectAtIndex:indexPath.item];
        [self.collectionView reloadData];
        
        if (self.dataArray.count == 0) {
            self.collectionView.alpha = 0;
            self.noBookView.alpha = 1;
        }else{
            self.noBookView.alpha = 0;
            self.collectionView.alpha = 1;
            [self.collectionView reloadData];
        }
    }else{
        [self showSuccessMsg:@"删除书签失败，请重试"];
    }
    
    
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
