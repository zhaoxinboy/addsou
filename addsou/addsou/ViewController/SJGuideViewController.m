//
//  SJGuideViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/2/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJGuideViewController.h"

@interface SJGuideViewController ()

@property (nonatomic, strong) UIBezierPath *bezierPathChange;      // 换一换按钮的贝塞尔曲线

@property (nonatomic, strong) UIImageView *changeImageView;      // 换一换按钮的提示图

@property (nonatomic, strong) UIBezierPath *bezierPathSearch;      // 搜索按钮的贝塞尔曲线

@property (nonatomic, strong) UIImageView *searchImageView;      // 搜索按钮提示图

@property (nonatomic, strong) UIBezierPath *bezierPathBook;        // 书签按钮的贝塞尔曲线

@property (nonatomic, strong) UIImageView *bookImageView;      // 书签按钮提示图

@property (nonatomic, strong) UIButton *changeBtn;      // 更换按钮

@property (nonatomic, strong) UIImageView *knowImageView;      // 知道了图片

@property (nonatomic, strong) UIButton *knowBtn;      // 知道了按钮

@end

@implementation SJGuideViewController

- (void)dealloc{
    // 设置状态为不是第一次打开，在不升级的情况下不再进入引导图和引导流程
    NSString *str = [NSString stringWithFormat:@"%@%@", APPVERSION, APPBUILDVERSION];
    UserDefaultSetObjectForKey(str, LOCAL_READ_FIRSTOPEN)
    UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRST)
    UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRSTGUIDE)
}

- (UIBezierPath *)bezierPathChange{
    if (!_bezierPathChange) {
        _bezierPathChange = [UIBezierPath bezierPathWithRect:self.view.bounds];
        CGRect frame = [SJManager sharedManager].changeFrame;
        frame.origin.x = frame.origin.x - 10;
        frame.size.width = frame.size.width + 20;
        [_bezierPathChange appendPath:[[UIBezierPath bezierPathWithRect:frame] bezierPathByReversingPath]];
    }
    return _bezierPathChange;
}

- (UIImageView *)changeImageView{
    if (!_changeImageView) {
        _changeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prompt_change"]];
        _changeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_changeImageView];
        [_changeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(241), SJ_ADAPTER_HEIGHT(78)));
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-(kWindowW - _changeFrame.origin.x));
        }];
    }
    return _changeImageView;
}

- (UIBezierPath *)bezierPathSearch{
    if (!_bezierPathSearch) {
        _bezierPathSearch = [UIBezierPath bezierPathWithRect:self.view.bounds];
        CGRect searchFrame = [SJManager sharedManager].searchFrame;
        [_bezierPathSearch appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(searchFrame.origin.x + searchFrame.size.height / 2, searchFrame.origin.y + searchFrame.size.height / 2) radius:(searchFrame.size.height / 2) startAngle:0 endAngle:M_PI * 2 clockwise:NO]];
    }
    return _bezierPathSearch;
}

- (UIImageView *)searchImageView{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prompt_search"]];
        _searchImageView.hidden = YES;
        _searchImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_searchImageView];
        [_searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(252), SJ_ADAPTER_HEIGHT(82)));
            make.right.mas_equalTo(-(kWindowW - _searchFrame.origin.x - _searchFrame.size.width / 2 - SJ_ADAPTER_WIDTH(8)));
            make.bottom.mas_equalTo(-(kWindowH - _searchFrame.origin.y + 5));
        }];
    }
    return _searchImageView;
}

- (UIBezierPath *)bezierPathBook{
    if (!_bezierPathBook) {
        _bezierPathBook = [UIBezierPath bezierPathWithRect:self.view.bounds];
        CGRect bookFrame = [SJManager sharedManager].bookFrame;
        [_bezierPathBook appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(bookFrame.origin.x + bookFrame.size.height / 2, bookFrame.origin.y + bookFrame.size.height / 2) radius:(bookFrame.size.height / 2) startAngle:0 endAngle:M_PI * 2 clockwise:NO]];
    }
    return _bezierPathBook;
}

- (UIImageView *)bookImageView{
    if (!_bookImageView) {
        _bookImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prompt_label"]];
        _bookImageView.hidden = YES;
        _bookImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_bookImageView];
        [_bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SJ_ADAPTER_WIDTH(252), SJ_ADAPTER_HEIGHT(82)));
            make.right.mas_equalTo(-(kWindowW - _bookFrame.origin.x - _bookFrame.size.width / 2 - SJ_ADAPTER_WIDTH(8)));
            make.bottom.mas_equalTo(-(kWindowH - _bookFrame.origin.y + 5));
        }];
    }
    return _searchImageView;
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn addTarget:self action:@selector(changeGuideImage:) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.tag = GuideViewStyle1;
        [self.view addSubview:_changeBtn];
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _changeBtn;
}

- (UIImageView *)knowImageView{
    if (!_knowImageView) {
        _knowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prompt_attention"]];
        _knowImageView.hidden = YES;
        _knowImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_knowImageView];
        [_knowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _knowImageView;
}

- (UIButton *)knowBtn{
    if (!_knowBtn) {
        _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowBtn setImage:[UIImage imageNamed:@"butt_know"] forState:UIControlStateNormal];
        _knowBtn.hidden = YES;
        [_knowBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_knowBtn];
        [_knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(120, 40));
            make.bottom.mas_equalTo(-SJ_ADAPTER_HEIGHT(125));
        }];
    }
    return _knowBtn;
}

- (void)go2Back{
    // 设置状态为不是第一次打开，在不升级的情况下不再进入引导图和引导流程
    NSString *str = [NSString stringWithFormat:@"%@%@", APPVERSION, APPBUILDVERSION];
    UserDefaultSetObjectForKey(str, LOCAL_READ_FIRSTOPEN)
    UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRST)
    UserDefaultSetObjectForKey(@"1", LOCAL_READ_FIRSTGUIDE)
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)changeGuideImage:(UIButton *)sender{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    switch (sender.tag) {
        case GuideViewStyle1:
            shapeLayer.path = _bezierPathSearch.CGPath;
            shapeLayer.lineWidth = SJ_ADAPTER_HEIGHT(15);
            shapeLayer.strokeColor = kRGBAColor(0, 0, 0, 0.3).CGColor;
            self.view.layer.mask = shapeLayer;
            _changeImageView.hidden = YES;
            _searchImageView.hidden = NO;
            _changeBtn.tag = GuideViewStyle2;
            break;
        case GuideViewStyle2:
            shapeLayer.path = _bezierPathBook.CGPath;
            shapeLayer.lineWidth = 15.0f;
            shapeLayer.strokeColor = kRGBAColor(0, 0, 0, 0.3).CGColor;
            self.view.layer.mask = shapeLayer;
            _searchImageView.hidden = YES;
            _bookImageView.hidden = NO;
            _changeBtn.tag = GuideViewStyle3;
            break;
        case GuideViewStyle3:
            shapeLayer.path = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
            self.view.layer.mask = shapeLayer;
            _bookImageView.hidden = YES;
            _changeBtn.hidden = YES;
            _knowImageView.hidden = NO;
            _knowBtn.hidden = NO;
            _changeBtn.tag = GuideViewStyle4;
            break;
            
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBAColor(0, 0, 0, 0.7);
    
    self.searchFrame = [SJManager sharedManager].searchFrame;
    self.bookFrame = [SJManager sharedManager].bookFrame;
    self.changeFrame = [SJManager sharedManager].changeFrame;
    
    [self bezierPathChange];
    [self changeImageView];
    [self bezierPathSearch];
    [self searchImageView];
    [self bezierPathBook];
    [self bookImageView];
    [self knowImageView];
    
    [self changeBtn];
    [self knowBtn];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = _bezierPathChange.CGPath;
    self.view.layer.mask = shapeLayer;
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
