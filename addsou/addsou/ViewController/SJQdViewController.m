//
//  SJQdViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/6/27.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJQdViewController.h"

@interface SJQdViewController ()

@property (nonatomic, strong) SJNavcView *navcView;   /* 自定义导航 */

@end

@implementation SJQdViewController

- (SJNavcView *)navcView{
    if (!_navcView) {
        _navcView = [[SJNavcView alloc] init];
        [self.view addSubview:_navcView];
        [_navcView.goBackBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_navcView.goBackBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        _navcView.titleLabel.text = @"签到赢好礼";
    }
    return _navcView;
}

- (void)go2Back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navcView];
    self.view.backgroundColor = [UIColor whiteColor];
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
