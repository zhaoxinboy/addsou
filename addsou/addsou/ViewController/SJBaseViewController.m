//
//  SJBaseViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/4.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJBaseViewController.h"

@interface SJBaseViewController ()

@end

@implementation SJBaseViewController

- (SJLoginViewModel *)loginVM{
    if (!_loginVM) {
        _loginVM = [SJLoginViewModel new];
    }
    return _loginVM;
}

- (SJSearchViewModel *)searchVM{
    if (!_searchVM) {
        _searchVM = [SJSearchViewModel new];
    }
    return _searchVM;
}

- (SJHomePageViewModel *)homeVM{
    if (!_homeVM) {
        _homeVM = [SJHomePageViewModel new];
    }
    return _homeVM;
}

- (SJHistoryViewModel *)historyVM{
    if (!_historyVM) {
        _historyVM = [SJHistoryViewModel new];
    }
    return _historyVM;
}

- (SJRecommendViewModel *)recommendVM{
    if (!_recommendVM) {
        _recommendVM = [SJRecommendViewModel new];
    }
    return _recommendVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
