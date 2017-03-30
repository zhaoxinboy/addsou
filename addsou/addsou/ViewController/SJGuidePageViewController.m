//
//  SJGuidePageViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJGuidePageViewController.h"
#import "AppDelegate.h"
#import "SJHomePageViewController.h"
#import "SJBaseNavigationViewController.h"

@interface SJGuidePageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *backView;      // 背景图

@property (nonatomic, strong) UILabel *label1;      // 顶层label

@property (nonatomic, strong) UILabel *label2;      // 小号label

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSArray *imageArray;

@property (nonatomic, strong) UIButton  *nextBtn;      // 进入按钮

@end

@implementation SJGuidePageViewController


#pragma  mark - 子控件懒加载

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(kWindowW / 2 - 70, kWindowH - 42 - 50, 140, 42);
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = SJ_ADAPTER_HEIGHT(20);
        _nextBtn.layer.borderColor = kRGBColor(51, 51, 51).CGColor;
        _nextBtn.layer.borderWidth = 1;
        [_nextBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(buttonToNextView) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitleColor:kRGBColor(51, 51, 51) forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [self.view addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(140), SJ_ADAPTER_HEIGHT(40)));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(33));
        }];
    }
    return _nextBtn;
}

- (UILabel *)label1{
    if (!_label1) {
        _label1 = [UILabel new];
        _label1.text = @"个性化推荐";
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = [UIFont systemFontOfSize:24];
        _label1.textColor = [UIColor whiteColor];
        [self.view addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(44));
        }];
    }
    return _label1;
}

- (UILabel *)label2{
    if (!_label2) {
        _label2 = [UILabel new];
        _label2.text = @"智能模式 想你所想 全新体验";
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.font = [UIFont systemFontOfSize:18];
        _label2.textColor = [UIColor whiteColor];
        _label2.alpha = 0.8;
        [self.view addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(_label1.mas_bottom).mas_equalTo(SJ_ADAPTER_HEIGHT(12));
        }];
    }
    return _label2;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
        _backView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, SJ_ADAPTER_HEIGHT(415))];
        view.backgroundColor = kRGBColor(51, 51, 51);
        [_backView addSubview:view];
    }
    return _backView;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"one", @"two", @"three"];
    }
    return _imageArray;
}


- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SJ_ADAPTER_HEIGHT(532), self.view.frame.size.width, 20)];
        _pageControl.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_pageControl];
        _pageControl.numberOfPages = self.imageArray.count;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = kRGBColor(239, 239, 239);
        _pageControl.currentPageIndicatorTintColor = kRGBColor(153, 153, 153);
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(kWindowW * self.imageArray.count, kWindowH);//设置内容大小
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = NO; // 不可回弹
        _scrollView.pagingEnabled = YES;//是否分页
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        
        for (int i = 0; i < self.imageArray.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * kWindowW, 0, kWindowW, kWindowH)];
            view.backgroundColor = [UIColor clearColor];
            [self.scrollView addSubview:view];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageArray[i]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [view addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(276), SJ_ADAPTER_HEIGHT(412)));
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(SJ_ADAPTER_HEIGHT(120));
            }];
        }
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];

    }
    return _scrollView;
}

#pragma mark - 滚动代理  scroll减速完毕调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取滚动位置
    //页码
    int pageNo= scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = pageNo;
    
    if (pageNo == 0) {
        _label1.text = @"个性化推荐";
        _label2.text = @"智能模式 想你所想 全新体验";
    }else if (pageNo == 1){
        _label1.text = @"关键词记忆";
        _label2.text = @"省时 省心 省力 记忆不丢失";
    }else if (pageNo == 2){
        _label1.text = @"标签记录";
        _label2.text = @"记忆中的所想 一键直达";
    }
    
    
}

#pragma mark - 控制器生命周期

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO; // 使右滑返回手势可用
    self.navigationController.navigationBar.hidden = YES; // 隐藏导航栏
}

- (void)loadView{
    [super loadView];
    [self backView];
    self.view = self.backView;
    [self imageArray];
    [self scrollView];
    [self pageControl];
    [self label1];
    [self label2];
    [self nextBtn];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
}

- (void)buttonToNextView{
    //创建动画
    CATransition *animation = [CATransition animation];
    //设置运动轨迹的速度
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //设置动画类型为立方体动画
    animation.type = @"fade";
    //设置动画时长
    animation.duration =0.5f;
    //设置运动的方向
//    animation.subtype =kCATransitionFromRight;
    //控制器间跳转动画
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NSString *str = [NSString stringWithFormat:@"%@%@", APPVERSION, APPBUILDVERSION];
    UserDefaultSetObjectForKey(str, LOCAL_READ_FIRSTOPEN)
    
    
    [self presentViewController:myDelegate.sideMenuViewController animated:NO completion:nil];
    
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
