//
//  QDRAboutUsViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/29.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRAboutUsViewController.h"


@interface QDRAboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) SJNavcView *navcView;   /* 自定义导航 */


@end

@implementation QDRAboutUsViewController


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRAboutUsViewController"];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kWindowW, 0, 0)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
        
    }
    return _tableView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = [UIColor grayColor];
        _textView.text = @"      北京大文明时代信息技术有限公司，专注为手机容量“瘦身”，特此推出一款轻量级的工具类APP搜加。搜加汇集了时下最实用的各类H5应用，让用户真正做到打开一款应用，使用千款应用。您在使用搜加提供的各项服务之前，请您务必审慎阅读，充分理解本协议各条款内容，包括但不限于免除或者限制责任的条款。如您不同意本服务协议及/或随时对其的修改，您可以主动停止使用搜加提供的服务；您一旦使用搜加的服务，即视为您已了解并完全同意本服务协议各项内容，包括搜加对服务协议随时所做的任何修改，并成为搜加的用户。";
        _textView.userInteractionEnabled = NO;
    }
    return _textView;
}

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [self.view addSubview:_navcView];
        [_navcView.goBackBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_navcView.goBackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = @"关于搜加";
    }
    return _navcView;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_HEADERURL]]];
    }
    return _headerImageView;
}


- (void)go2Back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navcView];
    
    [self textView];
    [self headerImageView];
    [self tableView];
    // Do any additional setup after loading the view.
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRAboutUsViewController" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_headerImageView];
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }else{
        [cell.contentView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row == 0 ? 100 : kWindowH - 164 - 64 - 20;
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
