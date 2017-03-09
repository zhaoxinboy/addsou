//
//  SJChooseSmallSearchViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/8.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJChooseSmallSearchViewController.h"
#import "SJSearchTableView.h"

@interface SJChooseSmallSearchViewController ()<chooseSearchSmallDelegate>

@property (nonatomic, strong) SJSearchTableView *tableView;      // tableview

@end

@implementation SJChooseSmallSearchViewController


- (SJSearchTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SJSearchTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.chooseDelegate = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW, 44 * _tableView.searchArr.count));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(44 * _tableView.searchArr.count);
        }];
    }
    return _tableView;
}

// 选择引擎后的跳转方法
- (void)jumpToSearch{
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW, 44 * _tableView.searchArr.count));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(44 * _tableView.searchArr.count);
        }];
        [_tableView.superview layoutIfNeeded];//强制绘制
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    
    // 通知搜索页面，如果键盘不在弹出状态，弹出
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseSearchSmall" object:nil];
}


// 点击空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self jumpToSearch];
    
}

- (void)dealloc{
    self.tableView.chooseDelegate = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWindowW, 44 * _tableView.searchArr.count));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [_tableView.superview layoutIfNeeded];//强制绘制
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBAColor(0, 0, 0, 0.7);
    
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
