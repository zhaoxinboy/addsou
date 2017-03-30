//
//  SJWebSettingViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/22.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJWebSettingViewController.h"
#import "SJWebViewController.h"


@interface SJWebSettingViewController ()

@property (nonatomic, strong) UIView *setView;      // 🐷视图

@property (nonatomic, strong) NSMutableArray *btnArr;      // 按钮的数组


@end




@implementation SJWebSettingViewController{
    CGFloat btnW;
    CGFloat viewW;
}

- (NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
        btnW = 50.0;
        viewW = ((kWindowW - 20) / 3);
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]] forState:UIControlStateNormal];
            btn.tag = 30000 + i;
            switch (i) {
                case 0:
                    [btn setTitle:@"添加书签" forState:UIControlStateNormal];
                    [btn setTitle:@"删除书签" forState:UIControlStateSelected];
                    [btn setImage:[UIImage imageNamed:@"icon_add_sel"] forState:UIControlStateSelected];
                    break;
                case 1:
                    [btn setTitle:@"分享" forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"icon_add_sel"] forState:UIControlStateSelected];
                    break;
                case 2:
                    [btn setTitle:@"刷新" forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"icon_add_sel"] forState:UIControlStateSelected];
                    break;
                case 3:
                    [btn setTitle:@"前进" forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"icon_add_sel"] forState:UIControlStateSelected];
                    break;
                case 4:
                    [btn setTitle:@"书签" forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"icon_add_sel"] forState:UIControlStateSelected];
                    break;
                default:
                    break;
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:btnW / 3 * 2];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btnArr addObject:btn];
        }
    }
    return _btnArr;
}



#pragma mark - 每个按钮的点击事件

- (void)btnClick:(UIButton *)sender{
    
    if (self.setDelegate && [self.setDelegate respondsToSelector:@selector(everyBtnClick:)]) {
        [self.setDelegate everyBtnClick:sender];
    }
    
    [self upOrDownSetViewWithBool:NO];
    
    
    
    
}



- (UIView *)setView{
    if (!_setView) {
        _setView = [[UIView alloc] init];
        _setView.backgroundColor = [UIColor whiteColor];
        _setView.layer.masksToBounds = YES;
        _setView.layer.cornerRadius = 6;
        [self.view addSubview:_setView];
        [_setView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(viewW * 3, btnW * 2 + 20 + 20 + 10));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(viewW * 2);
        }];
        UIView *view = [UIView new];
        [_setView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(20);
        }];
        
        for (int i = 0; i < self.btnArr.count; i++) {
            UIView *smallView = [UIView new];
            [view addSubview:smallView];
            [smallView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(viewW, btnW + 10));
                make.left.mas_equalTo(((i + 3) % 3) * viewW);
                make.top.mas_equalTo((i < 3) ? 0 : btnW + 10);
            }];
            UIButton *btn = self.btnArr[i];
            [smallView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(btnW, btnW));
                make.center.mas_equalTo(0);
            }];
        }
    }
    return _setView;
}

#pragma mark - 点击空白处动作
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![[touches anyObject].view isEqual:self.setView]) {
        [self upOrDownSetViewWithBool:NO];
    }
    
    
}

#pragma mark - 视图的动作
- (void)upOrDownSetViewWithBool:(BOOL)boo{
    
    [self.setView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(boo ? -10 : btnW * 2 + 20 + 20 + 10);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.setView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!boo) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}


#pragma mark - 控制器生命周期

- (void)loadView{
    [super loadView];
    
    [self btnArr];
    [self setView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self upOrDownSetViewWithBool:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBAColor(0, 0, 0, 0.4);
    
    [self judgeBtnState];
    
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    self.setDelegate = NULL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 各个按钮的状态确认
- (void)judgeBtnState{
    SJWebViewController *vc = (SJWebViewController *)self.setDelegate;
    if (![vc.sjWebView.webView canGoForward]) {
        UIButton *btn = self.btnArr[3];
        btn.userInteractionEnabled = NO;
        btn.alpha = 0.4;
    }
    
    NSMutableArray *arr = [[FMDBManager sharedFMDBManager] getAllBookView];
    for (int i = 0; i < arr.count; i++) {
        QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
        model = arr[i];
        DLog(@"%@",[vc.sjWebView.webView.URL absoluteString]);
        if ([model.url isEqualToString:[vc.sjWebView.webView.URL absoluteString]]) {
            UIButton *btn = self.btnArr[0];
            btn.selected = YES;
        }
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
