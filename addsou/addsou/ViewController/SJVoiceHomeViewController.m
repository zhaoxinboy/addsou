//
//  SJVoiceHomeViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/20.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceHomeViewController.h"
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
#import "SJVoiceView.h"
#import "DVoiceTouchView.h"
#import "NSString+Common.h"
#import "SJVoiceNoKeyView.h"
#import "SJVoiceHistroyTable.h"
#import "SJSearchCollectionView.h"
#import "SJVoiceHelper.h"

@interface SJVoiceHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, CLLocationManagerDelegate, removeDelegate, SJVoiceViewDelegate, UIScrollViewDelegate, searchCollectionIndexPathDelegate, SJVoiceHistroyTabelDelegate>

@property (nonatomic, strong) SJNavigationBar *sjNavigationBar;   /* 导航栏 */

@property (nonatomic, strong) SJSearchCollectionView *searchView;      // 搜索结果

@property (nonatomic, strong) SJVoiceView *voiceView;      // 语音视图

@property (nonatomic,strong) NSMutableArray *tempDesArray;  //模拟数据

@property (nonatomic, strong) UIActivityIndicatorView *activityView;   /* 活动指示器 */

@property (nonatomic, strong) QDRClearCacheView *localtionView;   /* 是否跳转到可定位页面 */

@property (nonatomic, strong) SJNoNetView *noNetView;   /* 无网络图 */

@property (nonatomic, strong) SJVoiceHelper *voiceHelper;      // 语音帮助类

@end

@implementation SJVoiceHomeViewController{
    CLLocationManager *locationManager;  // 获取地理位置管理者
    NSString *mCurrentAddress;  // 当前地址
    int dataShowIndex;
    UIButton *noInternetBtn;        // 无网络连接按钮
    NSInteger internetInt;
    NSInteger isrelodfocusView;   //是否刷新关注视图，用于搜索页面添加或删除之后的刷新，初始为0，可刷新状态为1
}

#pragma mark - 语音相关
-(void)touchDidBegan{
    if (!self.voiceHelper.voiceIconImage) {
        
        UIView *voiceImageSuperView = [[UIView alloc] init];
        voiceImageSuperView.layer.masksToBounds = YES;
        voiceImageSuperView.layer.cornerRadius = 10;
        [self.view addSubview:voiceImageSuperView];
        voiceImageSuperView.backgroundColor = kRGBAColor(0, 0, 0, 0.6);
        self.voiceHelper.voiceImageSuperView = voiceImageSuperView;
        __weak typeof(self)weakSelf = self;
        [voiceImageSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.view);
            make.size.mas_equalTo(CGSizeMake(140, 140));
        }];
        
        
        UIImageView *voiceIconImage = [[UIImageView alloc] init];
        self.voiceHelper.voiceIconImage = voiceIconImage;
        [voiceImageSuperView addSubview:voiceIconImage];
        [voiceIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(voiceImageSuperView).insets(UIEdgeInsetsMake(20, 35, 0, 0));
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        self.voiceHelper.voiceTuBeView = [[SJVoiceTuBeView alloc] initWithframe:CGRectMake(0, 0, 70, 70) VoiceColor:[UIColor whiteColor] volumeColor:[UIColor whiteColor] isColid:YES lineWidth:2];
        [voiceIconImage addSubview:self.voiceHelper.voiceTuBeView];
        
        
        UILabel *voiceIocnTitleLable = [[UILabel alloc] init];
        self.voiceHelper.voiceIocnTitleLable = voiceIocnTitleLable;
        [voiceIconImage addSubview:voiceIocnTitleLable];
        voiceIocnTitleLable.textColor = [UIColor whiteColor];
        voiceIocnTitleLable.font = [UIFont systemFontOfSize:12];
        voiceIocnTitleLable.text = @"松开搜索，上滑取消";
        [voiceIocnTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(voiceImageSuperView).offset(-15);
            make.centerX.equalTo(voiceImageSuperView);
        }];
    }
    self.voiceHelper.voiceImageSuperView.hidden = NO;
    self.voiceHelper.voiceIconImage.image = [UIImage imageNamed:@""];
    self.voiceHelper.voiceIocnTitleLable.text = @"松开搜索，上滑取消";
    self.voiceHelper.voiceIsCancel = NO;
    self.voiceHelper.voiceString = [[NSString alloc] init];
    self.voiceHelper.voiceRecognitionIsEnd = NO;
    self.voiceHelper.touchIsEnd = NO;
//    [_voiceView.voiceBtn.voiceButton setTitle:@"松开发送" forState:UIControlStateNormal];
    [self.voiceHelper.identifyHelper detectionStart];
    [self.voiceHelper.identifyHelper startBtnHandler];
}

-(void)setSelectedImage:(UIImage *)selectedImage{
    [_voiceView.voiceBtn.voiceButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
}

-(void)setNormalImage:(UIImage *)normalImage{
    [_voiceView.voiceBtn.voiceButton setBackgroundImage:normalImage forState:UIControlStateNormal];
}

-(void)inputButtonAction:(UIButton *)button{
    
}

- (void) onVolumeChangedImgisrIdentifyDelegate: (UIImage*)Img{
//    if (!self.voiceIsCancel) {
//        self.voiceIconImage.image = Img;
//    }
    
}

-(void)touchupglide{
    self.voiceHelper.voiceIsCancel = YES;
    self.voiceHelper.voiceIocnTitleLable.text = @"松开手指，取消搜索";
    self.voiceHelper.voiceTuBeView.hidden = YES;
    self.voiceHelper.voiceIconImage.image = [UIImage imageNamed:@"松开"];
}

-(void)touchDown{
    self.voiceHelper.voiceIsCancel = NO;
    self.voiceHelper.voiceTuBeView.hidden = NO;
    self.voiceHelper.voiceIocnTitleLable.text = @"松开搜索，上滑取消";
    self.voiceHelper.voiceIconImage.image = [UIImage imageNamed:@""];
}

-(void)touchDidEnd{
    self.voiceHelper.voiceImageSuperView.hidden = YES;
    if (self.voiceHelper.voiceIsCancel==YES) {
        [self.voiceHelper.identifyHelper detectionStart];
    }else{
        [self.voiceHelper.identifyHelper stopListening];
    }
    self.voiceHelper.touchIsEnd = YES;
}


#pragma mark - 搜索代理方法
// collectionview点击代理方法
- (void)searchCollectionIndexPathRow:(NSInteger)index model:(SJHomeAddressDataModel *)model{
    // 添加历史记录
    [self.homeVM postAddHistoryToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
    }];
    
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:model.appurl andAppImageUrlStr:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath] andSuperCode:model.supercode withAppName:model.appname];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 历史记录点击跳转事件
- (void)jumpdidSelectRowAtIndexPathWithModel:(SJHistoryArrModel *)model{
    SJHistoryArrModel *md = (SJHistoryArrModel *)model;
    // 跳转
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:md.appurl andAppImageUrlStr:[NSString stringWithFormat:@"%@%@", URLPATH, md.applogopath] andSuperCode:md.supercode withAppName:md.appname];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 懒加载

- (SJVoiceHelper *)voiceHelper{
    if (!_voiceHelper) {
        _voiceHelper = [SJVoiceHelper sharedInstance];
        __weak typeof(self)wself = self;
        //结果block
        _voiceHelper.resultBlock = ^(NSString *resultStr, BOOL isLast) {
            if ([resultStr length] > 0) {
                wself.voiceHelper.voiceString =  [wself.voiceHelper.voiceString stringByAppendingString:resultStr];
                
            }
            if (isLast && wself.voiceHelper.touchIsEnd) {
                if (!wself.voiceHelper.voiceIsCancel && [wself.voiceHelper.voiceString length] > 0) {
                    wself.voiceHelper.voiceString = [NSString stringDeleteString:wself.voiceHelper.voiceString];
                    wself.voiceView.voiceLabel.text = wself.voiceHelper.voiceString;
                }
            }
        };
        // 错误block
        _voiceHelper.errorBlock = ^(IFlySpeechError *error) {
            DLog(@"语音错误信息====%@", error.errorDesc);
            if ([error.errorDesc isEqualToString:@"没有说话"]) {
                [wself showSuccessMsg:@"录音时间太短！"];
                wself.voiceView.voiceLabel.text = @"点击说话";
            }else if([error.errorDesc isEqualToString:@"服务正常"] && ![NSString isBlankString:wself.voiceHelper.voiceString]){
                wself.voiceView.voiceLabel.text = wself.voiceHelper.voiceString;
                // 获取搜索结果
                [wself.searchVM getSearchResultFromNetWithStr:wself.voiceHelper.voiceString CompleteHandle:^(NSError *error) {
                    if (wself.searchVM.dataArr.count == 0) {
                        wself.searchView.alpha = 0;
                        [wself.voiceView isHiddenLabel:YES and:NO];
                        SJManager *sjManager = [SJManager sharedManager];
                        NSString *str = wself.voiceHelper.voiceString;
                        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        SJSearchModel *model = [SJSearchModel new];
                        for (int i = 0; i < sjManager.searchArr.count; i++) {
                            model = nil;
                            model = sjManager.searchArr[i];
                            if ([model.searchEngine isEqualToString:UserDefaultObjectForKey(LOCAL_READ_SEARCH)]){
                                break;
                            }
                        }
                        SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:[NSString keywordWithSearchWebUrl:str searchWebUrlStyle:[model.searchEngine integerValue]] andAppImageUrlStr:model.searchImageStr andSuperCode:nil withAppName:model.searchTitle];
                        [wself.navigationController pushViewController:vc animated:YES];
                    }else{
                        wself.searchView.alpha = 1;
                        
                        [wself.voiceView isHiddenLabel:YES and:YES];
                        [wself.searchView.dataArr removeAllObjects];
                        [wself.searchView.dataArr addObjectsFromArray:wself.searchVM.dataArr];
                        DLog(@"%@", wself.searchView.dataArr)
                        [wself.searchView reloadCollectionView];
                        
                        if (wself.searchVM.dataArr.count == 1) {
                            SJHomeAddressDataModel *model = (SJHomeAddressDataModel *)wself.searchVM.dataArr[0];
                            [wself searchCollectionIndexPathRow:0 model:model];
                        }
                    }
                }];
                
            }else{
                wself.searchView.alpha = 0;
                [wself showSuccessMsg:@"未能获取到语音信息，请重试！"];
                wself.voiceView.voiceLabel.text = @"点击说话";
            }
        };
        // 改变block
        _voiceHelper.imageChangeBlock = ^(CGFloat i) {
            [wself.voiceHelper.voiceTuBeView.topView updateVoiceViewWithVolume:i];
        };
    }
    return _voiceHelper;
}

- (SJSearchCollectionView *)searchView{
    if (!_searchView) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = SJ_ADAPTER_WIDTH(82);
        //设置元素大小
        CGFloat height = SJ_ADAPTER_HEIGHT(100);
        if (kWindowW <= 320) {
            height = SJ_ADAPTER_HEIGHT(115);
        }
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(60, 10, 40, 10);
        //        myLayout.minimumInteritemSpacing = (kWindowW - 280) / 2;  // 同一列中间隔的cell最小间距
        myLayout.minimumLineSpacing = 40;       // 最小行间距
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _searchView = [[SJSearchCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        _searchView.alpha = 0;
        _searchView.clickDelegate = self;
        [self.view addSubview:_searchView];
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW, kWindowH - 64 - SJ_ADAPTER_HEIGHT(210)));
        }];
    }
    return _searchView;
}

- (SJVoiceView *)voiceView{
    if (!_voiceView) {
        _voiceView = [[SJVoiceView alloc] init];
        _voiceView.voiceDelegate = self;
        [self.view addSubview:_voiceView];
        
        _voiceView.voiceBtn.areaY = -40;//设置滑动高度
        _voiceView.voiceBtn.clickTime = 0.5;//设置长按时间
        __weak typeof(self)weakSelf = self;
        _voiceView.voiceBtn.touchBegan = ^(){
            //开始长按
            [weakSelf touchDidBegan];
            
            [weakSelf.voiceView changeTimerWithBool:YES];
        };
        _voiceView.voiceBtn.upglide = ^(){
            //在区域内
            [weakSelf touchupglide];
            
            [weakSelf.voiceView changeTimerWithBool:NO];
        };
        _voiceView.voiceBtn.down = ^(){
            //不在区域内
            [weakSelf touchDown];
            
            [weakSelf.voiceView changeTimerWithBool:YES];
        };
        _voiceView.voiceBtn.touchEnd = ^(){
            //松开
            [weakSelf touchDidEnd];
            [weakSelf.voiceView changeTimerWithBool:NO];
            
        };
    }
    return _voiceView;
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

- (void)go2localtion{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:settingURL]){
        [[UIApplication sharedApplication] openURL:settingURL];
        UserDefaultSetObjectForKey(@"0", LOCAL_READ_LOCALTION);
    }
    [_localtionView closeSelf];
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
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





- (SJNavigationBar *)sjNavigationBar{
    if (!_sjNavigationBar) {
        _sjNavigationBar = [[SJNavigationBar alloc] init];
        _sjNavigationBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_sjNavigationBar];
        [_sjNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW, 64));
        }];
        [_sjNavigationBar.leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        // 获取时间显示
        [_sjNavigationBar.dateView dateViewGetDate];
        _sjNavigationBar.centerLabel.hidden = YES;
    }
    return _sjNavigationBar;
}

//定位
- (void)InitLocation{
    //初始化定位服务管理对象
    if(locationManager == nil){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        locationManager.distanceFilter = 1000.0f;
    }
}

#pragma mark Core Location委托方法用于实现位置的更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray *)locations{
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    DLog(@"error: %@",error);
}

-(void)locationManager:(nonnull CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
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



#pragma mark - removeDelegate
- (void)removeClearView{
    
    [self setLocaltionView:nil];
}


#pragma mark - 语音视图代理方法，按钮点击方法
- (void)voiceViewDelegateBtnClick:(UIButton *)sender{
    SJBookMarksViewController *bvc = nil;
    SJSearchViewController *svc = nil;
    switch (sender.tag) {
        case SJVoiceViewTagBookBtn:
            bvc = [[SJBookMarksViewController alloc] init];
            [self.navigationController pushViewController:bvc animated:YES];
            DLog(@"跳转到书签页面")
            break;
        case SJVoiceViewTagSearchBtn:
            svc = [[SJSearchViewController alloc] init];
            [self.navigationController pushViewController:svc animated:NO];
            DLog(@"跳转到搜索页面")
            break;
            
        default:
            break;
    }
}


#pragma mark - 网络请求
- (void)getNetWork{
    __weak typeof (self) wself = self;
    if (!UserDefaultObjectForKey(LOCAL_READ_FIRST) || !UserDefaultObjectForKey(LOCAL_READ_TOKEN)) { //首次打开APP
        [self.loginVM postFirstRegistWithSign:LOCAL_READ_UUID andSerialnumber:LOCAL_READ_UUID companyid:LOCAL_READ_COMPANYID NetCompleteHandle:^(NSError *error) {
            [wself.homeVM getDataFromNetWithUserId:[UserDefaultObjectForKey(LOCAL_READ_USERID) integerValue] CompleteHandle:^(NSError *error) {
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
                            // 定位
                            if (VERSIONS == 1) {
                                [wself InitLocation];
                                [locationManager requestWhenInUseAuthorization];
                                [locationManager startUpdatingLocation];
                            }
                            
                            
                            isrelodfocusView = 1;
                            
                            // 进入引导流程图
                            if (!UserDefaultObjectForKey(LOCAL_READ_FIRSTGUIDE)){
                                wself.voiceView.hidden = NO;
                                
                                [wself searchView];
                                
                                // 把要展示的按钮的位置传入，用于绘制贝塞尔曲线
                                
                                // 没图   不想做  注释掉
                                
                                //                                    CGRect voiceFrame = [_voiceView convertRect:_voiceView.voiceBtn.frame toView:self.view];
                                //                                    [SJManager sharedManager].voiceFrame = voiceFrame;
                                //
                                //                                    [self.view setNeedsLayout];
                                //                                    [self.view layoutIfNeeded];
                                //                                    // 把要展示的按钮的位置传入，用于绘制贝塞尔曲线
                                //                                    [SJManager sharedManager].bookFrame = [_voiceView convertRect:_voiceView.bookBtn.frame toView:self.view];
                                //                                    [SJManager sharedManager].searchFrame = [_voiceView convertRect:_voiceView.searchBtn.frame toView:self.view];
                                //
                                //                                    SJGuideViewController *vc=[[SJGuideViewController alloc] init];
                                //                                    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                                //
                                //                                    [wself presentViewController:vc animated:NO completion:nil];
                                
                                NSString *str = [NSString stringWithFormat:@"%@%@", APPVERSION, APPBUILDVERSION];
                                UserDefaultSetObjectForKey(str, LOCAL_READ_FIRSTOPEN)
                                UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRST)
                                UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRSTGUIDE)
                                
                            }
                        });
                    }
                }];
            }];
        }];
    }else{
        [self.loginVM postDataFromWithUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME] passWord:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] NetCompleteHandle:^(NSError *error) {
            [wself.homeVM getDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
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
                            wself.voiceView.hidden = NO;
                            
                            [wself searchView];
                            
                            if (VERSIONS == 1) {
                                // 定位
                                [wself InitLocation];
                                [locationManager requestWhenInUseAuthorization];
                                [locationManager startUpdatingLocation];
                            }
                            
                            
                            isrelodfocusView = 1;
                            
                        });
                    }
                }];
            }];
        }];
    }
}


#pragma mark - 无网络状态
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
    if (_voiceView) {
        _voiceView.hidden = YES;
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


#pragma mark - 控制器生命周期

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO; // 使右滑返回手势可用
    self.navigationController.navigationBar.hidden = YES; // 隐藏导航栏
    
    self.voiceView.voiceLabel.text = @"点击说话";
}

// 视图即将消失，关闭话筒
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.voiceView changeTimerWithBool:NO];
    [self touchDidEnd];
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
    [self voiceView];
    [self voiceHelper];
    [self getNetWork];
    
    
    
    // cell跳转通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionViewCellJump:)
                                                 name:@"collectionViewCellJump"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusViewRefresh:) name:@"focusViewRefresh" object:nil];
    
    if (VERSIONS == 2) {
        // 首页搜索结果添加/删除APP通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusViewRefresh:) name:@"SJVoiceHomeViewController" object:nil];
    }
    

    // Do any additional setup after loading the view.
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

// 添加或者删除链接后，刷新关注列表
- (void)focusViewRefresh:(NSNotification *)noti{
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
