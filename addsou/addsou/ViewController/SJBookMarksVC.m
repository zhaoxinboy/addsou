//
//  SJBookMarksVC.m
//  addsou
//
//  Created by 杨兆欣 on 2017/2/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJBookMarksVC.h"
#import "SJBookMarksHomeView.h"
#import "SJWebViewController.h"
#import "SJNoBookView.h"

@interface SJBookMarksVC ()<iCarouselDelegate, iCarouselDataSource, deleteCellDelegate>

@property (nonatomic, strong) iCarousel *carousel;

@property (nonatomic, assign) CGSize cardSize;

@property (nonatomic, strong) UIButton *closeBtn;   /* 关闭按钮 */

@property (nonatomic, strong) UILabel *nullLabel;// 无数据时显示的文字

@property (nonatomic, strong) NSMutableArray *dataArray; //书签数据源

@property (nonatomic, strong) SJNoBookView *noBookView;   /* 无书签时的view */

@end

@implementation SJBookMarksVC

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

- (iCarousel *)carousel{
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_carousel];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeCustom;
        _carousel.vertical = YES;
        _carousel.bounceDistance = 0.2f;
        _carousel.viewpointOffset = CGSizeMake(0, 0);
    }
    return _carousel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    if (_carousel) {
        [self.dataArray removeAllObjects];
        self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
        NSEnumerator *enumerator = [self.dataArray reverseObjectEnumerator];
        self.dataArray = (NSMutableArray*)[enumerator allObjects];
        if (self.dataArray.count == 0) {
            self.carousel.alpha = 0;
            self.noBookView.alpha = 1;
        }else{
            self.noBookView.alpha = 0;
            self.carousel.alpha = 1;
            [self.carousel reloadData];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.dataArray removeAllObjects];
    self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
    NSEnumerator *enumerator = [self.dataArray reverseObjectEnumerator];
    self.dataArray = (NSMutableArray*)[enumerator allObjects];
    
    [self noBookView];
    
    self.cardSize = CGSizeMake(kWindowW - SJ_ADAPTER_WIDTH(36), kWindowH - SJ_ADAPTER_HEIGHT(66));
    
    [self carousel];
    
    [self closeBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.dataArray.count;;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.cardSize.height;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionVisibleItems:
        {
            return 10;
        }
            
            //可以打开这里看一下效果
            //        case iCarouselOptionWrap:
            //        {
            //            return YES;
            //        }
            
        default:
            break;
    }
    
    return value;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *cardView = view;
    if (!cardView)
    {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
        SJBookMarksHomeView *bookMarksView = [[SJBookMarksHomeView alloc] initWithFrame:cardView.bounds];
        bookMarksView.userInteractionEnabled = true;
        bookMarksView.tag = 101;
        [cardView addSubview:bookMarksView];
    }
    
    SJBookMarksHomeView *bookMarksView = (SJBookMarksHomeView *)[cardView viewWithTag:101];
    QDRBookViewModel *model = self.dataArray[index];
    if (model.imageData) {
        UIImage *image = [self Base64StrToUIImage:model.imageData];
        bookMarksView.titleContentView.image = image;
    }
    bookMarksView.title.text = model.appName;
    bookMarksView.titleLabel.text = model.titlestr;
    [bookMarksView.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.titleData] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    bookMarksView.deleteBtn.tag = index + 1000;
    bookMarksView.deledeDelegate = self;
    
    // 阴影效果
    cardView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 0);
    cardView.layer.shadowOpacity = 1;
    
    return cardView;
}


// 删除cell的代理方法
- (void)deleteCellWithButton:(UIButton *)sender{
    NSInteger index = sender.tag - 1000;
    QDRBookViewModel *deleModel = self.dataArray[index];
    if ([[FMDBManager sharedFMDBManager] deleteBookView:deleModel]){
        [self showSuccessMsg:@"删除书签成功"];
        [self.dataArray removeObjectAtIndex:index];
        
        //点击可删除itemView
        [_carousel removeItemAtIndex:index animated:YES];
        
        if (self.dataArray.count == 0) {
            self.carousel.alpha = 0;
            self.noBookView.alpha = 1;
        }else{
            self.noBookView.alpha = 0;
            self.carousel.alpha = 1;
            [self.carousel reloadData];
        }
    }else{
        [self showSuccessMsg:@"删除书签失败，请重试"];
    }
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    
    return CATransform3DScale(CATransform3DTranslate(transform, 0, translation * self.cardSize.width, offset), scale, scale, 1.0f);
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    for ( UIView *view in carousel.visibleItemViews)
    {
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:view]];
        
        if ( offset < -3.0 )
        {
            view.alpha = 0.0f;
        }
        else if ( offset < -2.0f)
        {
            view.alpha = offset + 3.0f;
        }
        else
        {
            view.alpha = 1.0f;
        }
    }
}

//形变是线性的就ok了
- (CGFloat)scaleByOffset:(CGFloat)offset
{
    return offset * 0.04f + 1.0f;
}

//位移通过得到的公式来计算
- (CGFloat)translationByOffset:(CGFloat)offset
{
    CGFloat z = 5.0f/4.0f;
    CGFloat n = 5.0f/8.0f;
    
    //z/n是临界值 >=这个值时 我们就把itemView放到比较远的地方不让他显示在屏幕上就可以了
    if ( offset >= z/n )
    {
        return 3.0f;
    }
    
    return 1/(z-n*offset)-1/z;
}


// 卡片的点击方法
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
    QDRBookViewModel *model = self.dataArray[index];
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:model.url andAppImageUrlStr:model.titleData andSuperCode:model.superCode withAppName:model.appName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
