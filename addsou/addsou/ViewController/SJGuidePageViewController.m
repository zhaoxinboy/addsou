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

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation SJGuidePageViewController{
    UIButton *nextBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO; // 使右滑返回手势可用
    self.navigationController.navigationBar.hidden = YES; // 隐藏导航栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageArray = @[@"guidepage1", @"guidepage2"];
    [self createScrollview];
    // Do any additional setup after loading the view.
}

- (void)createScrollview{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(kWindowW * self.imageArray.count, kWindowH);//设置内容大小
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.bounces = NO; // 不可回弹
    self.scrollView.pagingEnabled = YES;//是否分页
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWindowW, 0, kWindowW, kWindowH)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.image = [UIImage imageNamed:self.imageArray[i]];
        [self.scrollView addSubview:img];
        BOOL result = i == (self.imageArray.count-1) ? 1:0;
        if (result) {
            nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nextBtn.frame = CGRectMake(kWindowW / 2 - 70, kWindowH - 42 - 50, 140, 42);
            nextBtn.layer.masksToBounds = YES;
            nextBtn.layer.cornerRadius = 21;
            nextBtn.layer.borderColor = [UIColor blackColor].CGColor;
            nextBtn.layer.borderWidth = 1;
            [nextBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [nextBtn addTarget:self action:@selector(buttonToNextView) forControlEvents:UIControlEventTouchUpInside];
            [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [img addSubview:nextBtn];
        }
        img.userInteractionEnabled = YES;
    }
    //    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    //    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 20)];
    //    self.pageControl.backgroundColor = [UIColor grayColor];
    //    [self.view addSubview:self.pageControl];
    //    self.pageControl.numberOfPages = self.imageArray.count;
    //    self.pageControl.currentPage = 0;
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
