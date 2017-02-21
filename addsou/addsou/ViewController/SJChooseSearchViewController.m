//
//  SJChooseSearchViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/2/21.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJChooseSearchViewController.h"
#import "SJSearchTableView.h"

@interface SJChooseSearchViewController ()

@property (nonatomic, strong) SJSearchTableView *tableView;      // tableview

@property (nonatomic, strong) SJNavcView *navcView;   /* 自定义导航 */

@end

@implementation SJChooseSearchViewController

- (SJSearchTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SJSearchTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
    }
    return _tableView;
}

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [self.view addSubview:_navcView];
        [_navcView.goBackBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_navcView.goBackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = @"选择引擎";
    }
    return _navcView;
}

- (void)go2Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navcView];
    
    
    [self tableView];
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
