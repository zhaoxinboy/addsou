//
//  QDRAboutUsViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/29.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRAboutUsViewController.h"
#import "SJAgreementViewController.h"

@interface QDRAboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) SJNavcView *navcView;   /* 自定义导航 */

@property (nonatomic, strong) UIButton *agreementBtn;      // 法律按钮


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
        if ([LOCAL_READ_ISOTHER isEqualToString:LOCAL_READ_SOUJIA]) {
            _textView.text = @"      北京大文明时代信息技术有限公司，专注为手机容量“瘦身”，特此推出一款轻量级的工具类APP搜加。搜加汇集了时下最实用的各类H5应用，让用户真正做到打开一款应用，使用千款应用。您在使用搜加提供的各项服务之前，请您务必审慎阅读，充分理解本协议各条款内容，包括但不限于免除或者限制责任的条款。如您不同意本服务协议及/或随时对其的修改，您可以主动停止使用搜加提供的服务；您一旦使用搜加的服务，即视为您已了解并完全同意本服务协议各项内容，包括搜加对服务协议随时所做的任何修改，并成为搜加的用户。";
        }else{
            _textView.text = @"      阅览室- 一款拥有智能推荐的阅读器，集合国内多数阅读平台。智能搜索等多项人性化功能，让您追书不再愁！在这里可以找到时下最热门资讯，无论是娱乐头条，还是武侠历史，各类丰富独特的书籍资源，应有尽有！手机阅读的时代已经到来，我们为您准备了最新、最热门、最经典的文化盛宴。";
        }
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
        if ([LOCAL_READ_ISOTHER isEqualToString:LOCAL_READ_SOUJIA]) {
            _navcView.titleLabel.text = @"关于搜加";
        }else if(VERSIONS == 2){
            _navcView.titleLabel.text = @"关于语搜";
        }else{
            _navcView.titleLabel.text = @"关于阅览室";
        }
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

- (UIButton *)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if ([LOCAL_READ_ISOTHER isEqualToString:LOCAL_READ_SOUJIA]) {
            [_agreementBtn setTitle:@"搜加法律条款" forState:UIControlStateNormal];
        }else if (VERSIONS == 2){
            [_agreementBtn setTitle:@"语搜法律条款" forState:UIControlStateNormal];
        }else{
            [_agreementBtn setTitle:@"阅览室法律条款" forState:UIControlStateNormal];
        }
        [_agreementBtn addTarget:self action:@selector(goAgreement) forControlEvents:UIControlEventTouchUpInside];
        [_agreementBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:_agreementBtn];
        [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _agreementBtn;
}

- (void)goAgreement{
    SJAgreementViewController *vc = [[SJAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    [self agreementBtn];
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
