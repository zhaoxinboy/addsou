//
//  SJUserViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/12.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJUserViewController.h"
#import "SJUserTableViewCell.h"
#import "SJUserTableHeaderFooterView.h"
#import "QDRClearCacheView.h"

@interface SJUserViewController ()<UITableViewDelegate, UITableViewDataSource, removeDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SJUserTableHeaderFooterView *headerView;   /* 头部属性 */

@property (nonatomic, strong) QDRClearCacheView *clearView;

@property (nonatomic, strong) QDRClearCacheView *goOutView;

@property (nonatomic, strong) QDRClearCacheView *isGoOutView;   /* 是否退出登录 */


@end

@implementation SJUserViewController{
    NSIndexPath *SindexPath;
}

- (QDRClearCacheView *)goOutView{
    if (!_goOutView) {
        _goOutView = [[QDRClearCacheView alloc] initWithTarget:self];
        [_goOutView.determineBtn addTarget:self action:@selector(go2out) forControlEvents:UIControlEventTouchUpInside];
        _goOutView.delegate = self;
        _goOutView.clearCacheLabel.text = @"退出登录";
        _goOutView.isClearLabel.text = @"是否退出？";
    }
    return _goOutView;
}

- (void)go2out{
    // 友盟退出登录
    [MobClick profileSignOff];
    // 登录状态设为100表示退出登录
    UserDefaultSetObjectForKey(NOLOGIN, LOCAL_READ_ISLOGIN)
    [self.tableView reloadData];
    [_goOutView closeSelf];
}

- (QDRClearCacheView *)clearView{
    if (!_clearView) {
        _clearView = [[QDRClearCacheView alloc] initWithTarget:self];
        [_clearView.determineBtn addTarget:self action:@selector(cleanSD) forControlEvents:UIControlEventTouchUpInside];
        _clearView.delegate = self;
    }
    return _clearView;
}

- (void)cleanSD{
    [self sdCleanCache];
    SJUserTableViewCell *cell = (SJUserTableViewCell *)[self.tableView cellForRowAtIndexPath:SindexPath];
    cell.rightLabel.text = [NSString stringWithFormat:@"%0.2f M", [self sdFolderSize]];
    [_clearView closeSelf];
}

- (void)removeClearView{
    [self setClearView:nil];
    [self setGoOutView:nil];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRGBColor(235, 235, 235);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SJUserTableViewCell class] forCellReuseIdentifier:@"SJUserTableViewCell"];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"SJUserViewController"];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //去掉多余的cell
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"SJUserViewController" name:nil object:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

// 监听，即将显示刷新
- (void)SJUserViewControllerRefresh:(NSNotification *)noti{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SJUserViewControllerRefresh:) name:@"SJUserViewController" object:nil];
    
    
    self.indexPath = [NSIndexPath indexPathForRow:100 inSection:100];
    
    [self tableView];
    
    [self clearView];
    [self goOutView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger i = 5;
    if (![UserDefaultObjectForKey(LOCAL_READ_ISLOGIN) isEqualToString:NOLOGIN]) {
        i = 6;
    }
    return i;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJUserTableViewCell"];
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.leftLabel.text = @"浏览记录";
        cell.rightLabel.text = @"";
    }else if (indexPath.row == 1){
        cell.leftLabel.text = @"搜索引擎";
        if (UserDefaultObjectForKey(LOCAL_READ_SEARCH)) {
            UserDefaultSetObjectForKey(BAIDUSEARCH, LOCAL_READ_SEARCH)
        }
        if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:BAIDUSEARCH]) {
            cell.rightLabel.text = @"百度";
        }else if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:SOUGOUSEARCH]){
            cell.rightLabel.text = @"搜狗";
        }else if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:BIYINGSEARCH]){
            cell.rightLabel.text = @"必应";
        }else if([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:QIHUSEARCH]){
            cell.rightLabel.text = @"360";
        }
    }else if (indexPath.row == 2){
        cell.leftLabel.text = @"用户反馈";
    }else if (indexPath.row == 3){
        cell.leftLabel.text = @"赞我一下";
    }else if (indexPath.row == 4){
        cell.leftLabel.text = @"关于搜加";
        cell.rightLabel.text = [NSString stringWithFormat:@"v%@", APPVERSION];
    }else if (indexPath.row == 5){
        cell.leftLabel.text = @"清除缓存";
        cell.rightLabel.text = [NSString stringWithFormat:@"%0.2f M", [self sdFolderSize]];
    }else if (indexPath.row == 6){
        cell.leftLabel.text = @"退出登录";
        cell.rightLabel.text = @"";
    }
    
    
    return cell;
}

// 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    if (indexPath.row == 4) {
        if ([self sdFolderSize] == 0) {
            [self showSuccessMsg:@"已经清理的很干净了"];
        }else{
            SindexPath = indexPath;
            [self clearView];
            [_clearView openSelf];
        }
    }else if(indexPath.row == 5){
        [self goOutView];
        [_goOutView openSelf];
    }else if (indexPath.row == 2){
        // 跳转到APPSTORE
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1195055909?mt=8"]];
    }else{
        [self.sideMenuViewController hideMenuViewController];
    }
    self.indexPath = [NSIndexPath indexPathForRow:100 inSection:100];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    view.tintColor = [UIColor clearColor];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SJ_ADAPTER_HEIGHT(210);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SJUserViewController"];
    
    if (!_headerView) {
        _headerView = [[SJUserTableHeaderFooterView alloc] init];
        [headerView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWindowW, SJ_ADAPTER_HEIGHT(210)));
        }];
        [_headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:UserDefaultObjectForKey(LOCAL_READ_HEADERURL)] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [_headerView.headerBtn addTarget:self action:@selector(aboutLogin) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.logBtn addTarget:self action:@selector(aboutLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    _headerView.backgroundColor = kRGBColor(236, 236, 236);
    
    // 登录状态
    __weak typeof (self) wself = self;
    if (![UserDefaultObjectForKey(LOCAL_READ_ISLOGIN) isEqualToString:NOLOGIN]) {
        [self.loginVM getUserInfoByUserid:[UserDefaultObjectForKey(LOCAL_READ_USERID) integerValue] NetCompleteHandle:^(NSError *error) {
            if (wself.loginVM.isLoginModel.username) {
                if ([UserDefaultObjectForKey(LOCAL_READ_ISLOGIN) isEqualToString:PHONELOGIN]) {
                    _headerView.nameLabel.text = wself.loginVM.isLoginModel.username;
                }else{
                    _headerView.nameLabel.text = wself.loginVM.isLoginModel.nickname;
                }
                _headerView.logBtn.alpha = 0;
                _headerView.nameLabel.alpha = 1;
            }
        }];
    }else{
        _headerView.logBtn.alpha = 1;
        _headerView.nameLabel.alpha = 0;
    }
    
    return headerView;
}

// 登录相关
- (void)aboutLogin{
    if ([UserDefaultObjectForKey(LOCAL_READ_ISLOGIN) isEqualToString:NOLOGIN]) {
        self.intBtn = 1;
        [self.sideMenuViewController hideMenuViewController];
        self.intBtn = 0;
    }else{
        [self goOutView];
        [_goOutView openSelf];
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
