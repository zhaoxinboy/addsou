//
//  SJHomePageViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJHomePageViewController.h"
#import "SJHomePageLayout.h"
#import "SJHomePageCollectionViewCell.h"
#import "SJNavigationBar.h"
#import "SJFocusView.h"
#import "SJTransitionManager.h"
#import "SJWebViewController.h"
#import "SJBookMarksViewController.h"
#import "SJBookMarksVC.h"
#import "SJSearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <AddressBook/AddressBook.h>
#import "QDRClearCacheView.h"
#import "SJNoNetView.h"
#import "SJGuideViewController.h"



@interface SJHomePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, removeDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;   /* 展示卡片 */

@property (nonatomic, strong) SJNavigationBar *sjNavigationBar;   /* 导航栏 */

@property (nonatomic, strong) UIButton *searchBtn;   /* 搜索按钮 */

@property (nonatomic, strong) UIButton *bookBtn;   /* 书签按钮 */

@property (nonatomic, strong) SJOptimizationView *optimizationView;   /* 推荐视图 */

@property (nonatomic, strong) SJFocusView *focusView;   /* 关注视图 */
//模拟数据
@property (nonatomic,strong) NSMutableArray *tempDesArray;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;   /* 活动指示器 */

@property (nonatomic, strong) QDRClearCacheView *localtionView;   /* 是否跳转到可定位页面 */

@property (nonatomic, strong) SJNoNetView *noNetView;   /* 无网络图 */


@end

@implementation SJHomePageViewController{
    CLLocationManager *locationManager;  // 获取地理位置管理者
    NSString *mCurrentAddress;  // 当前地址
    int dataShowIndex;
    UIButton *noInternetBtn;        // 无网络连接按钮
    NSInteger internetInt;
    NSInteger isrelodfocusView;   //是否刷新关注视图，用于搜索页面添加或删除之后的刷新，初始为0，可刷新状态为1
}

- (SJNoNetView *)noNetView{
    if (!_noNetView) {
        _noNetView = [[SJNoNetView alloc] init];
        [self.view addSubview:_noNetView];
    }
    return _noNetView;
}

- (QDRClearCacheView *)localtionView{
    if (!_localtionView) {
        _localtionView = [[QDRClearCacheView alloc] initWithTarget:self];
        [_localtionView.determineBtn addTarget:self action:@selector(go2localtion) forControlEvents:UIControlEventTouchUpInside];
        _localtionView.delegate = self;
        _localtionView.clearCacheLabel.text = @"定位权限";
        _localtionView.isClearLabel.text = @"是否开启定位？";
    }
    return _localtionView;
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_activityView];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _activityView;
}

- (NSMutableArray *)tempDesArray{
    if (!_tempDesArray) {
        _tempDesArray = [[NSMutableArray alloc] init];
    }
    return _tempDesArray;
}

- (UIButton *)bookBtn{
    if (!_bookBtn) {
        _bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bookBtn setImage:[UIImage imageNamed:@"page_Focus_label"] forState:UIControlStateNormal];
        _bookBtn.layer.masksToBounds = YES;
        _bookBtn.layer.cornerRadius = SJ_ADAPTER_HEIGHT(22);
        [_bookBtn addTarget:self action:@selector(jump2book) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bookBtn];
        [_bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(23));
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44)));
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(26));
        }];
        
    }
    return _bookBtn;
}

- (void)jump2book{
    
//    SJBookMarksVC *vc = [[SJBookMarksVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    SJBookMarksViewController *vc = [[SJBookMarksViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    DLog(@"跳转到书签页面")
}


- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"page_icon_search"] forState:UIControlStateNormal];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = SJ_ADAPTER_HEIGHT(22);
        [_searchBtn addTarget:self action:@selector(jump2search) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SJ_ADAPTER_WIDTH(70));
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44)));
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(26));
        }];
        // 把要展示的按钮的位置传入，用于绘制贝塞尔曲线
        [SJManager sharedManager].searchFrame = CGRectMake(kWindowW - SJ_ADAPTER_WIDTH(70) - SJ_ADAPTER_HEIGHT(44), kWindowH - SJ_ADAPTER_HEIGHT(26) - SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44), SJ_ADAPTER_HEIGHT(44));
    }
    return _searchBtn;
}

- (void)jump2search{
    SJSearchViewController *vc = [[SJSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    
    DLog(@"跳转到搜索页面")
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.transitioningDelegate = self;
//        self.modalPresentationStyle = UIModalPresentationCustom;
//    }
//    return self;
//}

- (SJFocusView *)focusView{
    if (!_focusView) {
        _focusView = [[SJFocusView alloc] initWithFrame:CGRectMake(0, 0, kWindowW - SJ_ADAPTER_WIDTH(20), kWindowH - SJ_ADAPTER_HEIGHT(167))];
    }
    return _focusView;
}

- (SJOptimizationView *)optimizationView{
    if (!_optimizationView) {
        _optimizationView = [[SJOptimizationView alloc] init];
        [self getHomePageTime];
        [_optimizationView.logoIamgeView sd_setImageWithURL:[NSURL URLWithString:UserDefaultObjectForKey(LOCAL_READ_HEADERURL)] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [_optimizationView.changeBtn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _optimizationView;
}

- (void)btnOnClick {
    // 每次请求12个数据，保存在本地12个，显示6个  然后再次点击刷新时判断本地有没有，如果有的话不执行网络请求，把本地的值展示出来，如果没有，重新获取12个循环操作
    if (!self.tempDesArray.count || !self.tempDesArray) {
        [self.recommendVM getAppRecommendByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
            if (!self.recommendVM.dataArr.count || !self.recommendVM.dataArr) {
                [self showErrorMsg:@"刷新失败，请重试"];
            }else{
                NSArray *arr0 = @[self.recommendVM.dataArr[0], self.recommendVM.dataArr[1], self.recommendVM.dataArr[2], self.recommendVM.dataArr[3], self.recommendVM.dataArr[4], self.recommendVM.dataArr[5]];
                NSArray *arr1 = @[self.recommendVM.dataArr[6], self.recommendVM.dataArr[7], self.recommendVM.dataArr[8], self.recommendVM.dataArr[9], self.recommendVM.dataArr[10], self.recommendVM.dataArr[11]];
                [self.tempDesArray addObject:arr1];
                _optimizationView.tempDataArray = @[arr0];
                dataShowIndex = dataShowIndex >= _optimizationView.tempDataArray.count ? 0 : dataShowIndex;
                _optimizationView.myJikeScrollView.myNextArr = _optimizationView.tempDataArray[dataShowIndex];
                _optimizationView.myJikeScrollView.myNextArr = _optimizationView.tempDataArray[dataShowIndex];
                
                dataShowIndex++;
            }
        }];
    }else{
        _optimizationView.tempDataArray = @[self.tempDesArray.firstObject];
        [self.tempDesArray removeAllObjects];
        dataShowIndex = dataShowIndex >= _optimizationView.tempDataArray.count ? 0 : dataShowIndex;
        _optimizationView.myJikeScrollView.myNextArr = _optimizationView.tempDataArray[dataShowIndex];
        _optimizationView.myJikeScrollView.myNextArr = _optimizationView.tempDataArray[dataShowIndex];
        dataShowIndex++;
    }
}


- (SJNavigationBar *)sjNavigationBar{
    if (!_sjNavigationBar) {
        _sjNavigationBar = [[SJNavigationBar alloc] init];
        [self.view addSubview:_sjNavigationBar];
        [_sjNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW, 64));
        }];
        [_sjNavigationBar.leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        // 获取时间显示
        [_sjNavigationBar.dateView dateViewGetDate];
        _sjNavigationBar.centerLabel.text = @"优选";
        
    }
    return _sjNavigationBar;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        SJHomePageLayout *layout = [[SJHomePageLayout alloc] init];
        layout.itemSize = CGSizeMake(kWindowW - SJ_ADAPTER_WIDTH(20), kWindowH - SJ_ADAPTER_HEIGHT(167));
        layout.minimumLineSpacing = SJ_ADAPTER_WIDTH(20);//设置cell的间距
        layout.sectionInset = UIEdgeInsetsMake(SJ_ADAPTER_HEIGHT(15), SJ_ADAPTER_WIDTH(10), SJ_ADAPTER_HEIGHT(88), SJ_ADAPTER_WIDTH(10));//设置四周的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kWindowW, kWindowH - 64) collectionViewLayout:layout];
        [_collectionView registerClass:[SJHomePageCollectionViewCell class] forCellWithReuseIdentifier:@"SJHomePageCollectionViewCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        _collectionView.bounces = NO;
//        _collectionView.pagingEnabled = YES;
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_collectionView];
        
        
        [self bookBtn];
        [self searchBtn];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (isrelodfocusView == 1) {
        [self.homeVM getAddressDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
            [self.focusView dragCellCollectionView:nil newDataArrayAfterMove:@[self.homeVM.dataArr]];
            [self.focusView.homeCollectionV reloadData];
        }];
    }
    
    self.navigationController.navigationBarHidden = NO; // 使右滑返回手势可用
    self.navigationController.navigationBar.hidden = YES; // 隐藏导航栏
    [self getHomePageTime];
}

- (void)getHomePageTime{
    if (_optimizationView) {
        NSDateComponents *comps = [NSString getDateInfo];
        // 时间判断  用于首页
        NSString *str = @"";
        if (comps.hour > 4 && comps.hour < 9) {
            _optimizationView.titleLabel.text = @"嗨，早上好";
            str = @"2";
        }else if (comps.hour > 8 && comps.hour < 12){
            _optimizationView.titleLabel.text = @"嗨，上午好";
            str = @"6";
        }else if (comps.hour > 11 && comps.hour < 15){
            _optimizationView.titleLabel.text = @"嗨，中午好";
            str = @"3";
        }else if (comps.hour > 14 && comps.hour < 19){
            _optimizationView.titleLabel.text = @"嗨，下午好";
            str = @"7";
        }else if (comps.hour > 18 && comps.hour < 23){
            _optimizationView.titleLabel.text = @"嗨，晚上啦";
            str = @"4";
        }else if (comps.hour > 22 && comps.hour < 5){
            _optimizationView.titleLabel.text = @"嗨, 深夜啦";
            str = @"5";
        }else{
            _optimizationView.titleLabel.text = @"哈喽~";
            str = @"1";
        }
        [self.recommendVM getshowDocByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) soupType:str CompleteHandle:^(NSError *error) {
            _optimizationView.textLabel.text = self.recommendVM.contentStr;
        }];
    }
}

- (void)getNetWork{
    __weak typeof (self) wself = self;
    if (!UserDefaultObjectForKey(LOCAL_READ_FIRST) || !UserDefaultObjectForKey(LOCAL_READ_TOKEN)) { //首次打开APP
        [self.loginVM postFirstRegistWithSign:LOCAL_READ_UUID andSerialnumber:LOCAL_READ_UUID companyid:LOCAL_READ_COMPANYID NetCompleteHandle:^(NSError *error) {
            [wself.homeVM getDataFromNetWithUserId:[UserDefaultObjectForKey(LOCAL_READ_USERID) integerValue] CompleteHandle:^(NSError *error) {
                [wself.recommendVM getAppRecommendByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
                    [wself.homeVM getAddressDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                        [_activityView stopAnimating];
                        if ((!wself.recommendVM.dataArr || !wself.recommendVM.dataArr.count) && (!wself.homeVM.dataArr || !wself.homeVM.dataArr.count)){
                            //array是空或nil
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [wself addNoInternet];
                            });
                        }else{
                            // 回到主线程刷新UI
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [wself optimizationView];
                                NSArray *arr0 = @[wself.recommendVM.dataArr[0], wself.recommendVM.dataArr[6]];
                                NSArray *arr1 = @[wself.recommendVM.dataArr[1], wself.recommendVM.dataArr[7]];
                                NSArray *arr2 = @[wself.recommendVM.dataArr[2], wself.recommendVM.dataArr[8]];
                                NSArray *arr3 = @[wself.recommendVM.dataArr[3], wself.recommendVM.dataArr[9]];
                                NSArray *arr4 = @[wself.recommendVM.dataArr[4], wself.recommendVM.dataArr[10]];
                                NSArray *arr5 = @[wself.recommendVM.dataArr[5], wself.recommendVM.dataArr[11]];
                                NSArray *arr = @[arr0, arr1, arr2, arr3, arr4, arr5];
                                _optimizationView.myJikeScrollView.myFirstArr = arr;
                                [wself focusView];
                                [wself.focusView dragCellCollectionView:nil newDataArrayAfterMove:@[wself.homeVM.dataArr]];
                                [wself.focusView.homeCollectionV reloadData];
                                [wself collectionView];
                                // 定位
                                [self InitLocation];
                                [locationManager requestWhenInUseAuthorization];
                                [locationManager startUpdatingLocation];
                                
                                isrelodfocusView = 1;
                                
                                // 进入引导流程图
                                if (!UserDefaultObjectForKey(LOCAL_READ_FIRSTGUIDE)){
                                    [wself.optimizationView setNeedsLayout];
                                    [wself.optimizationView layoutIfNeeded];
                                    // 把要展示的按钮的位置传入，用于绘制贝塞尔曲线
                                    CGRect changeFrame = _optimizationView.changeBtn.frame;
                                    changeFrame.origin.x = changeFrame.origin.x + SJ_ADAPTER_WIDTH(10);
                                    changeFrame.origin.y = changeFrame.origin.y + 64 + 20 +SJ_ADAPTER_HEIGHT(15);
                                    [SJManager sharedManager].changeFrame = changeFrame;
                                    
                                    [self.view setNeedsLayout];
                                    [self.view layoutIfNeeded];
                                    // 把要展示的按钮的位置传入，用于绘制贝塞尔曲线
                                    [SJManager sharedManager].bookFrame = _bookBtn.frame;
                                    [SJManager sharedManager].searchFrame = _searchBtn.frame;
                                    
                                    SJGuideViewController *vc=[[SJGuideViewController alloc] init];
                                    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                                    
                                    [wself presentViewController:vc animated:NO completion:nil];
                                }
                            });
                        }
                        
                    }];
                }];
            }];
        }];
    }else{
        [self.loginVM postDataFromWithUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME] passWord:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] NetCompleteHandle:^(NSError *error) {
            [wself.homeVM getDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                [wself.recommendVM getAppRecommendByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
                    [wself.homeVM getAddressDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                        [_activityView stopAnimating];
                        if ((!wself.recommendVM.dataArr || !wself.recommendVM.dataArr.count) && (!wself.homeVM.dataArr || !wself.homeVM.dataArr.count)){
                            //array是空或nil
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [wself addNoInternet];
                            });
                        }else{
                            // 回到主线程刷新UI
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [wself optimizationView];
                                DLog(@"%@", wself.recommendVM.dataArr);
                                NSArray *arr0 = @[wself.recommendVM.dataArr[0], wself.recommendVM.dataArr[6]];
                                NSArray *arr1 = @[wself.recommendVM.dataArr[1], wself.recommendVM.dataArr[7]];
                                NSArray *arr2 = @[wself.recommendVM.dataArr[2], wself.recommendVM.dataArr[8]];
                                NSArray *arr3 = @[wself.recommendVM.dataArr[3], wself.recommendVM.dataArr[9]];
                                NSArray *arr4 = @[wself.recommendVM.dataArr[4], wself.recommendVM.dataArr[10]];
                                NSArray *arr5 = @[wself.recommendVM.dataArr[5], wself.recommendVM.dataArr[11]];
                                NSArray *arr = @[arr0, arr1, arr2, arr3, arr4, arr5];
                                _optimizationView.myJikeScrollView.myFirstArr = arr;
                                [wself focusView];
                                [wself.focusView dragCellCollectionView:nil newDataArrayAfterMove:@[wself.homeVM.dataArr]];
                                [wself.focusView.homeCollectionV reloadData];
                                [wself collectionView];
                                // 定位
                                [wself InitLocation];
                                [locationManager requestWhenInUseAuthorization];
                                [locationManager startUpdatingLocation];
                                
                                isrelodfocusView = 1;
                                
                                
                            });
                        }
                    }];
                }];
            }];
        }];
    }
}

- (void)addNoInternet
{
    [self showErrorMsg:@"暂无网络"];
    if (!_noNetView){
        [self noNetView];
    }
    if (!noInternetBtn) {
        noInternetBtn = [UIButton new];
        [noInternetBtn addTarget:self action:@selector(judgeInt) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:noInternetBtn];
        [noInternetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
}

- (void)judgeInt
{
    if (internetInt == 1 || internetInt == 2) {
        if (_noNetView) {
            [self setNoNetView:nil];
        }
        if (noInternetBtn) {
            [noInternetBtn removeFromSuperview];
        }
        [_activityView startAnimating];
        // 网络
        [self getNetWork];
    }else{
        [_activityView stopAnimating];
        [self addNoInternet];       // 添加无网络时底部按钮
    }
}

- (void)dealloc{
    // 移除全部通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isrelodfocusView = 0;
    
    // 网络监听
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"未知");
                internetInt = -1;
//                [wself showErrorMsg:@"暂无网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"没有网络");
                internetInt = 0;
//                [wself showErrorMsg:@"暂无网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"3G|4G");
                internetInt = 1;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"WiFi");
                internetInt = 2;
                break;
            default:
                break;
        }
    }];
    [manger startMonitoring]; // 开始监听
    
    
    
    self.view.backgroundColor = kRGBColor(236, 236, 236);
    
    [self activityView];
    [self.activityView startAnimating];//活动指示器开始
    
    [self sjNavigationBar];
    
    
    [self getNetWork];
    
    
    
    // 从后台进入前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(someMethod:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    
    // cell跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionViewCellJump:)
                                                 name:@"collectionViewCellJump"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JiKeScrollViewJump:) name:@"JiKeScrollViewJump" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusViewRefresh:) name:@"focusViewRefresh" object:nil];
    
    
    
    
    // Do any additional setup after loading the view.
}

// 从后台进入前台
- (void)someMethod:(NSNotification *)notification{
    [self getHomePageTime];
}

//定位
- (void)InitLocation {
    //初始化定位服务管理对象
    if(locationManager == nil){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        locationManager.distanceFilter = 1000.0f;
    }
}

// 添加或者删除链接后，刷新关注列表
- (void)focusViewRefresh:(NSNotification *)noti{
    [self.homeVM getAddressDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
        [self.focusView dragCellCollectionView:nil newDataArrayAfterMove:@[self.homeVM.dataArr]];
        [self.focusView.homeCollectionV reloadData];
    }];
}

// 智能推荐跳转
- (void)JiKeScrollViewJump:(NSNotification *)noti{
    SJHomeAddressDataModel *model = noti.object;
    // 添加历史记录
    [self.homeVM postAddHistoryToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
        
    }];
    // 跳转
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:model.appurl andAppImageUrlStr:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath] andSuperCode:model.supercode withAppName:model.appname];
    [self.navigationController pushViewController:vc animated:YES];
}

// cell跳转
- (void)collectionViewCellJump:(NSNotification *)noti{
    SJHomeAddressDataModel *model = (SJHomeAddressDataModel *)noti.object;
    NSInteger i = [model.qdrid integerValue];
    // 添加历史记录
    [self.homeVM postAddHistoryToUserFromNetWithUrlId:i andUserID:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
        
    }];
    // 跳转
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:model.appurl andAppImageUrlStr:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath] andSuperCode:model.supercode withAppName:model.appname];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJHomePageCollectionViewCell *cell = (SJHomePageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SJHomePageCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.optimizationView];
    }else{
        [cell.contentView addSubview:self.focusView];
    }
    return cell;
}

// 正在拖拽
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self topTitleLabelText:scrollView];
}


// 拖拽完了
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self topTitleLabelText:scrollView];
}

// 减速完了
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self topTitleLabelText:scrollView];
}

- (void)topTitleLabelText:(UIScrollView *)scrollView{
    // 滑动过程中关闭抖动
    if (self.focusView.homeCollectionV.select) {
        [self.focusView.homeCollectionV xw_stopEditingModel];
        self.focusView.homeCollectionV.select = !self.focusView.homeCollectionV.select;
    }
    
    if (scrollView.contentOffset.x < (kWindowW / 2)) {
        _sjNavigationBar.centerLabel.text = @"优选";
    }else{
        _sjNavigationBar.centerLabel.text = @"关注";
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Core Location委托方法用于实现位置的更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray *)locations
{
    CLLocation * currLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if ([placemarks count] > 0) {
                           CLPlacemark *placemark = placemarks[0];
                           NSDictionary *addressDictionary = placemark.addressDictionary;
                           NSString *address = [addressDictionary objectForKey:(NSString *) kABPersonAddressStreetKey];
                           address = address == nil ? @"": address;
                           NSString *state = [addressDictionary objectForKey:(NSString *) kABPersonAddressStateKey];
                           state = state == nil ? @"": state;
                           NSString *city = [addressDictionary objectForKey:(NSString *) kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           mCurrentAddress = [[NSString alloc] initWithFormat:@"%@", city];
                           
                           NSLog(@"经纬度  %f,%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude);
                           NSLog(@"%@", mCurrentAddress);
                           
                           // 地理位置上传
                           [self.homeVM postAddLocationByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] itude:[NSString stringWithFormat:@"%f,%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude] location:mCurrentAddress CompleteHandle:^(NSError *error) {
                               
                           }];
                           
                           [locationManager stopUpdatingLocation];
                       }
                   }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"error: %@",error);
}

-(void)locationManager:(nonnull CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            //用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            DLog(@"用户还未决定");
            break;
        }
            //访问受限(苹果预留选项,暂时没用)
        case kCLAuthorizationStatusRestricted:
        {
            DLog(@"访问受限");
            break;
        }
            //定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            //定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled]){
                DLog(@"定位开启，但被拒");
                /*在此处, 应该提醒用户给此应用授权, 并跳转到"设置"界面让用户进行授权
                                 在iOS8.0之后跳转到"设置"界面代码*/
                if (UserDefaultObjectForKey(LOCAL_READ_LOCALTION) && ![UserDefaultObjectForKey(LOCAL_READ_LOCALTION) isEqualToString:@"0"]) {
                    NSInteger i = [UserDefaultObjectForKey(LOCAL_READ_LOCALTION) integerValue];
                    NSString *str = [NSString stringWithFormat:@"%ld", (long)(i + 1)];
                    UserDefaultSetObjectForKey(str, LOCAL_READ_LOCALTION)
                    if (([UserDefaultObjectForKey(LOCAL_READ_LOCALTION) integerValue] % 3 == 0)) {
                        [self localtionView];
                        [_localtionView openSelf];
                    }
                }
                if (!UserDefaultObjectForKey(LOCAL_READ_LOCALTION)) {
                    UserDefaultSetObjectForKey(@"1", LOCAL_READ_LOCALTION)
                }
            }else{
                DLog(@"定位关闭，不可用");
            }
            break;
        }
            //获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            UserDefaultRemoveObjectForKey(LOCAL_READ_LOCALTION)
            DLog(@"获得前台定位授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            UserDefaultRemoveObjectForKey(LOCAL_READ_LOCALTION)
            DLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}

- (void)go2localtion{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:settingURL]){
        [[UIApplication sharedApplication] openURL:settingURL];
        UserDefaultSetObjectForKey(@"0", LOCAL_READ_LOCALTION);
    }
    [_localtionView closeSelf];
}

- (void)removeClearView{
    
    [self setLocaltionView:nil];
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
