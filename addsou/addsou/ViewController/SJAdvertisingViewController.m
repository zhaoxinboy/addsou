//
//  SJAdvertisingViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/28.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJAdvertisingViewController.h"
#import "SJAdvertisingTableViewCell.h"

static CGFloat headerH = 120;

@interface SJAdvertisingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIActivityIndicatorView *activityView;   /* 活动指示器 */

@property (nonatomic, strong) UILabel *noAdLabel;      // 没有广告时的提示语

@property (nonatomic, strong) UIView *headerView;      //

@property (nonatomic, strong) UISwitch *adSwitch;      // 广告开关

@property (nonatomic, strong) UILabel *adLabel;      // 管理用户标识的广告

@property (nonatomic, strong) UILabel *filterLabel;      // 广告过滤

@property (nonatomic, strong) NSMutableArray *fmdbArr;      // 数据库中的数据

@property (nonatomic, strong) NSMutableArray *dataArr;      // 去重后的数据

@property (nonatomic, strong) SJNavcView *navcView;   /* 自定义导航 */

@property (nonatomic, strong) UITableView *tabView;      // 广告列表
@end

@implementation SJAdvertisingViewController

#pragma mark - 子控件懒加载
- (UILabel *)noAdLabel{
    if (!_noAdLabel) {
        _noAdLabel = [UILabel new];
        _noAdLabel.font = [UIFont systemFontOfSize:12];
        _noAdLabel.text = @"没有已标识的广告，可在站点中对广告长按进行标识";
        _noAdLabel.numberOfLines = 0;
        _noAdLabel.alpha = 0;
        _noAdLabel.textAlignment = NSTextAlignmentCenter;
        _noAdLabel.textColor = kRGBColor(111, 111, 111);
        [self.view addSubview:_noAdLabel];
        [_noAdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.mas_equalTo(headerH + 64 + 20);
        }];
    }
    return _noAdLabel;
}


- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_activityView];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(headerH + 64 + 88);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _activityView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW, headerH));
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
    }
    return _headerView;
}

- (UILabel *)filterLabel{
    if (!_filterLabel) {
        UIView *view = [UIView new];
        [self.headerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(headerH / 2);
        }];
        _filterLabel = [UILabel new];
        _filterLabel.text = @"广告过滤";
        _filterLabel.font = [UIFont systemFontOfSize:14];
        _filterLabel.textColor = [UIColor blackColor];
        [view addSubview:_filterLabel];
        [_filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _filterLabel;
}

- (UISwitch *)adSwitch{
    if (!_adSwitch) {
        _adSwitch = [[UISwitch alloc] init];
        _adSwitch.onTintColor = kRGBColor(155, 155, 155);
        if ([UserDefaultObjectForKey(LOCAL_READ_ISFILTERAD) isEqualToString:@"1"]) {//此时广告过滤是打开的
            _adSwitch.on = YES;
        }else{
            _adSwitch.on = NO;
        }
        [_adSwitch addTarget:self action:@selector(changeFilterAd:) forControlEvents:UIControlEventValueChanged];
        [_headerView addSubview:_adSwitch];
        [_adSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-25);
            make.centerY.mas_equalTo(_filterLabel.mas_centerY);
        }];
    }
    return _adSwitch;
}

- (void)changeFilterAd:(UISwitch *)sender{
    if (sender.on) {
        UserDefaultSetObjectForKey(@"1", LOCAL_READ_ISFILTERAD);
        _adLabel.alpha = 1;
        if (_noAdLabel.alpha != 0) {
            _noAdLabel.alpha = 1;
        }
    }else{
        UserDefaultSetObjectForKey(@"0", LOCAL_READ_ISFILTERAD);
        _adLabel.alpha = 0.3;
        if (_noAdLabel.alpha == 1) {
            _noAdLabel.alpha = 0.3;
        }
    }
    [self selfTableViewReloadData];
}

- (UILabel *)adLabel{
    if (!_adLabel) {
        UIView *view = [UIView new];
        [_headerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(headerH / 2);
        }];
        _adLabel = [UILabel new];
        if ([UserDefaultObjectForKey(LOCAL_READ_ISFILTERAD) isEqualToString:@"0"]) {
            _adLabel.alpha = 0.3;
        }
        _adLabel.text = @"管理用户标识的广告";
        _adLabel.font = [UIFont systemFontOfSize:14];
        _adLabel.textColor = [UIColor blackColor];
        [view addSubview:_adLabel];
        [_adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _adLabel;
}

- (NSMutableArray *)fmdbArr{
    if (!_fmdbArr) {
        _fmdbArr = [[FMDBURLManager sharedFMDBUrlManager] getAllUrlModel];
    }
    return _fmdbArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [self.view addSubview:_navcView];
        [_navcView.goBackBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_navcView.goBackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = @"广告过滤";
    }
    return _navcView;
}

- (void)go2Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tabView{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabView.backgroundColor = [UIColor whiteColor];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        // 隐藏cell分割线
        _tabView.separatorStyle = NO;
        // 去掉多余cell
        _tabView.tableFooterView = [UIView new];
        [_tabView registerClass:[SJAdvertisingTableViewCell class] forCellReuseIdentifier:@"SJAdvertisingTableViewCell"];
        [self.view addSubview:_tabView];
        [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(headerH + 64);
        }];
    }
    return _tabView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJAdvertisingTableViewCell *cell = (SJAdvertisingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SJAdvertisingTableViewCell" forIndexPath:indexPath];
    
    SJUrlModel *model = self.dataArr[indexPath.row];
    [cell getModel:model];
    [cell getCellAlpha:_adSwitch.on];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    // 选中不变色
    return cell;
}

#pragma mark - 通知删除某cell
- (void)removeAdCell:(NSNotification *)notification{
    SJAdvertisingTableViewCell *cell = (SJAdvertisingTableViewCell *)notification.object;
    [_dataArr removeObject:cell.model];
    [self selfTableViewReloadData];
    for (SJUrlModel *urlModel in _fmdbArr) {
        if ([urlModel.url isEqualToString:cell.model.url]) {
            [[FMDBURLManager sharedFMDBUrlManager] deleteUrlModel:urlModel];
        }
    }
    
}



#pragma mark - tab刷新操作
- (void)selfTableViewReloadData{
    if (self.dataArr.count == 0) {
        self.noAdLabel.alpha = 1;
    }
    if (self.activityView.animating) {
        [self.activityView stopAnimating];
    }
    [_tabView reloadData];
}

#pragma mark - 控制器生命周期
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeAdCell" object:nil];
}

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self fmdbArr];
    [self dataArr];
    [self headerView];
    [self filterLabel];
    [self adSwitch];
    [self adLabel];
    
    [self tabView];
    [self activityView];
    [_activityView startAnimating];
    [self noAdLabel];
    
    for (SJUrlModel *model in _fmdbArr) {
        if (_dataArr.count == 0) {
            [_dataArr addObject:model];
        }else{
            BOOL modelBool = YES;
            for (SJUrlModel *datamodel in _dataArr) {
                if ([datamodel.url isEqualToString:model.url]) {
                    modelBool = NO;
                }
            }
            if (modelBool) {
                [_dataArr addObject:model];
            }
        }
    }
    [self selfTableViewReloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navcView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAdCell:) name:@"removeAdCell" object:nil];
    
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
