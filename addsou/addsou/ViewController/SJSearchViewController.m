//
//  SJSearchViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchViewController.h"
#import "SJSearchView.h"
#import "SJWebViewController.h"
#import "SJKeywordsCollectionView.h"
#import "SJChooseSmallSearchViewController.h"

@interface SJSearchViewController ()<UITextFieldDelegate, searchCollectionIndexPathDelegate, keyWordsDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSString *searchStr;   /* 搜索字段 */

@property (nonatomic, strong) NSMutableArray *searchArr;   /* 搜索数组 */

@property (nonatomic, strong) SJSearchView *searchView;

@property (nonatomic, strong) NSMutableArray *keyArr;   /* 关键词数组 */

@end

@implementation SJSearchViewController

- (NSMutableArray *)keyArr{
    if (!_keyArr) {
        _keyArr = [[NSMutableArray alloc] init];
    }
    return _keyArr;
}

- (NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc] init];
    }
    return _searchArr;
}

// 切换搜索引擎
- (void)chooseSearch{
    // 如果键盘开启，则先关闭键盘
    if ([_searchView.searchBar isFirstResponder]) {
        [_searchView.searchBar resignFirstResponder];
    }
    
    SJChooseSmallSearchViewController *vc=[[SJChooseSmallSearchViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:vc animated:NO completion:nil];
    
    
}

- (SJSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SJSearchView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
        [_searchView.searchImageBtn addTarget:self action:@selector(chooseSearch) forControlEvents:UIControlEventTouchUpInside];
        _searchView.searchBar.delegate = self;
        _searchView.searchCollectionView.clickDelegate = self;
        _searchView.keyCollection.keyDelegate = self;
        [_searchView.keyCollection.removeBtn addTarget:self action:@selector(removeKeyWrod:) forControlEvents:UIControlEventTouchUpInside];
        if (!UserDefaultObjectForKey(LOCAL_READ_SEARCH)) {
            UserDefaultSetObjectForKey(BAIDUSEARCH, LOCAL_READ_SEARCH)
        }
        NSString *imageStr = nil;
        if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:BAIDUSEARCH]) { //百度
            imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_baidu@3x.png", URLPATH];
        }else if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:SOUGOUSEARCH]){ // 搜狗
            imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_sougou@3x.png", URLPATH];
        }else if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:BIYINGSEARCH]){ // 必应
            imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_biying@3x.png", URLPATH];
        }else if([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:QIHUSEARCH]){ // 360
            imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_360@3x.png", URLPATH];
        }
        [_searchView.searchImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [self.view addSubview:_searchView];
    }
    return _searchView;
}

//点击collectionview关闭键盘
- (void)jumpToHomePage{
//    if ([_searchView.searchBar isFirstResponder]) {
//        [_searchView.searchBar resignFirstResponder];
//    }
    DLog(@"点击空白处，暂时不隐藏键盘")
}



// 关键词页面代理方法，关闭键盘
- (void)takeTheKeyboard{
    [self.searchView.keyCollection.removeBtn setTitle:@"" forState:UIControlStateNormal];
    [self.searchView.keyCollection.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-(_searchView.keyCollection.collectionView.contentSize.height < 50 ? 180 : _searchView.keyCollection.collectionView.contentSize.height));
    }];
    _searchView.keyCollection.removeBtn.tag = 100001;
//    if ([_searchView.searchBar isFirstResponder]) {
//        [_searchView.searchBar resignFirstResponder];
//    }
    DLog(@"点击空白处，暂时不隐藏键盘")
}

// 关键词代理方法更改关键词
- (void)keyWordsIndexPathRow:(NSInteger)index str:(NSString *)str{
    self.searchView.searchBar.text = str;
    if (![_searchView.searchBar isFirstResponder]) {
        [_searchView.searchBar becomeFirstResponder];
    }
    [self searchWithStr:str];
}



// 将要开始编辑时的回调，返回为NO，则不能编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}

//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
}

//将要结束编辑时的回调
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}


// 已经结束编辑的回调
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    
}

// 编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText isEqualToString:@" "]) {
        searchBar.text = @"";
    }else{
        // 搜索操作
        [self searchWithStr:searchBar.text];
    }
}

//搜索按钮点击的回调  (右下角按钮)
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ((self.searchStr == nil || self.searchStr == NULL) || [self.searchStr isKindOfClass:[NSNull class]] || [[self.searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
    }else{
        [self saveSearchAction];
        NSString *str = self.searchStr;
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        SJSearchModel *model = [SJSearchModel new];
        for (int i = 0; i < self.searchArr.count; i++) {
            model = nil;
            model = self.searchArr[i];
            if ([model.searchEngine isEqualToString:UserDefaultObjectForKey(LOCAL_READ_SEARCH)]){
                break;
            }
        }
        
        NSString *str1 = [NSString keywordWithSearchWebUrl:str searchWebUrlStyle:[model.searchEngine integerValue]];
        
        SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:[NSString keywordWithSearchWebUrl:str searchWebUrlStyle:[model.searchEngine integerValue]] andAppImageUrlStr:model.searchImageStr andSuperCode:nil withAppName:model.searchTitle];
        [self.navigationController pushViewController:vc animated:YES];
        DLog(@"点击了搜索");
    }
}


// 取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    DLog(@"取消搜索")
    [self.navigationController popViewControllerAnimated:NO];
}



// 搜索栏的附加试图中切换按钮触发的回调
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    
}







// 删除关键词方法
- (void)removeKeyWrod:(UIButton *)sender{
    if (sender.tag == 100001) {
        [self.searchView.keyCollection.removeBtn setTitle:@"删除所有" forState:UIControlStateNormal];
        [self.searchView.keyCollection.removeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:1];
        [self.searchView.keyCollection.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 32));
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-(_searchView.keyCollection.collectionView.contentSize.height < 50 ? 180 : _searchView.keyCollection.collectionView.contentSize.height));
        }];
        
        sender.tag = 100002;
    }else if (sender.tag == 100002){
        [self.searchView.keyCollection.removeBtn setTitle:@"" forState:UIControlStateNormal];
        [self.searchView.keyCollection.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-(_searchView.keyCollection.collectionView.contentSize.height < 50 ? 180 : _searchView.keyCollection.collectionView.contentSize.height));
        }];
        sender.tag = 100001;
        [UIView animateWithDuration:0.2 animations:^{
            self.searchView.keyCollection.alpha = 0;
        } completion:^(BOOL finished) {
            UserDefaultRemoveObjectForKey(LOCAL_READ_SAVESEARCH)
            [self.searchView.keyCollection.dataArr removeAllObjects];
            [self.searchView.keyCollection reloadCollectionView];
            [self.searchView.keyCollection.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(32, 32));
                make.right.mas_equalTo(-15);
                make.bottom.mas_equalTo(-(_searchView.keyCollection.collectionView.contentSize.height < 50 ? 180 : _searchView.keyCollection.collectionView.contentSize.height));
            }];
        }];
    }
}

// collectionview点击代理方法
- (void)searchCollectionIndexPathRow:(NSInteger)index model:(SJHomeAddressDataModel *)model{
    [self saveSearchAction];
    // 添加历史记录
    [self.homeVM postAddHistoryToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
    }];
    
    SJWebViewController *vc = [[SJWebViewController alloc] initWithUrlStr:model.appurl andAppImageUrlStr:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath] andSuperCode:model.supercode withAppName:model.appname];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if ([_searchView.searchBar isFirstResponder]) {
//        [_searchView.searchBar resignFirstResponder];
//    }
     DLog(@"点击空白处，暂时不隐藏键盘")
}


- (void)dealloc{
    
    self.searchView.keyCollection.keyDelegate = nil;
    self.searchView.searchBar.delegate = nil;
    self.searchView.searchCollectionView.clickDelegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseSearchSmall" object:nil];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![_searchView.searchBar isFirstResponder]) {
        [_searchView.searchBar becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![_searchView.searchBar isFirstResponder]) {
        [_searchView.searchBar becomeFirstResponder];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseSearchSmall:) name:@"chooseSearchSmall" object:nil]; // 选择搜索引擎的通知
    
//    [self  performSelector:@selector(delayMethod) withObject:nil afterDelay:0.0001f];
//    [self.searchView.searchField sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

// 选择完毕搜索引擎后该做的事
- (void)chooseSearchSmall:(NSNotification *)notification{
    if (![_searchView.searchBar isFirstResponder]) {
        [_searchView.searchBar becomeFirstResponder];
    }
    NSString *imageStr = nil;
    if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:BAIDUSEARCH]) { //百度
        imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_baidu@3x.png", URLPATH];
    }else if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:SOUGOUSEARCH]){ // 搜狗
        imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_sougou@3x.png", URLPATH];
    }else if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:BIYINGSEARCH]){ // 必应
        imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_biying@3x.png", URLPATH];
    }else if([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:QIHUSEARCH]){ // 360
        imageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_360@3x.png", URLPATH];
    }
    [_searchView.searchImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
}

// 键盘即将出现时
- (void)keyboardWasShown:(NSNotification*)aNotification{
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat searchHight = kWindowH - keyBoardFrame.size.height;
    self.searchView.frame = CGRectMake(0, 0, kWindowW, searchHight);
}

- (void)delayMethod{
    [self.searchView.searchBar becomeFirstResponder];
}

// 键盘位置即将改变时
- (void)UIKeyboardWillChangeFrame:(NSNotification *)Notification{
    
    CGRect begin = [[[Notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect end = [[[Notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[Notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:0.25 animations:^{
        if(begin.size.height > 0 && (begin.origin.y - end.origin.y > 0)){
            // 键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
            CGFloat searchHight = kWindowH - end.size.height;
            self.searchView.frame = CGRectMake(0, 0, kWindowW, searchHight);
        }
        else if (end.origin.y == kWindowH && begin.origin.y != end.origin.y && duration > 0){
            NSLog(@"%f", end.origin.y);
            NSLog(@"%f", kWindowH);
            //键盘收起
            self.searchView.frame = CGRectMake(0, 0, kWindowW, kWindowH);
        }
        else if ((begin.origin.y - end.origin.y < 0) && duration == 0){
            //键盘切换
            CGFloat searchHight = kWindowH - end.size.height;
            self.searchView.frame = CGRectMake(0, 0, kWindowW, searchHight);
        }
        
    }];
    if ([self.searchView.searchBar.text isEqualToString:@""] && [NSString extractKeyWord]) {
        self.keyArr = [NSString extractKeyWord];
        if (self.keyArr) {
            self.searchView.keyCollection.dataArr = self.keyArr;
            [self.searchView.keyCollection reloadCollectionView];
            [UIView animateWithDuration:0.2 animations:^{
                _searchView.keyCollection.alpha = 1;
            }];
        }
    }
    if(self.searchView.searchBar.text && ![self.searchView.searchBar.text isEqualToString:@""]){
        [UIView animateWithDuration:0.2 animations:^{
            _searchView.keyCollection.alpha = 0;
        }];
    }
}


- (void)searchWithStr:(NSString *)str{
    
    if ([str isEqualToString:@""] && [NSString extractKeyWord]) {
        self.keyArr = [NSString extractKeyWord];
        if (self.keyArr) {
            self.searchView.keyCollection.dataArr = self.keyArr;
            [self.searchView.keyCollection reloadCollectionView];
            [self.searchView.keyCollection.removeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(32, 32));
                make.right.mas_equalTo(-15);
                make.bottom.mas_equalTo(-(_searchView.keyCollection.collectionView.contentSize.height < 50 ? 180 : _searchView.keyCollection.collectionView.contentSize.height));
            }];
            [self.searchView.searchCollectionView.dataArr removeAllObjects];
            [self.searchView.searchCollectionView reloadCollectionView];
            [UIView animateWithDuration:0.2 animations:^{
                _searchView.keyCollection.alpha = 1;
                _searchView.searchCollectionView.alpha = 0;
            }];
        }
    }
    if(str && ![str isEqualToString:@""]){
        [UIView animateWithDuration:0.2 animations:^{
            _searchView.keyCollection.alpha = 0;
            _searchView.searchCollectionView.alpha = 1;
        }];
    }
    
    // 保存需要搜索的字段
    self.searchStr = str;
    
    // 搜索引擎
    SJManager *sjManager =  [SJManager sharedManager];
    [self searchArr];
    [self.searchArr removeAllObjects];
    for (SJSearchModel *model in sjManager.searchArr) {
        model.searchField = str;
        [self.searchArr addObject:model];
    }
    
    if ((self.searchStr == nil || self.searchStr == NULL) || [self.searchStr isKindOfClass:[NSNull class]] || [[self.searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self.searchArr removeAllObjects];
    }
    
    
    if (![str isEqualToString:@""]) {       // 当字符串不为空时，调用搜索接口
        __weak typeof (self) wself = self;
        // 获取搜索结果
        [self.searchVM getSearchResultFromNetWithStr:str CompleteHandle:^(NSError *error) {
            [wself.searchView.searchCollectionView.dataArr removeAllObjects];
            [wself.searchView.searchCollectionView.dataArr addObjectsFromArray:wself.searchVM.dataArr];
            DLog(@"%@", wself.searchView.searchCollectionView.dataArr)
            [wself.searchView.searchCollectionView reloadCollectionView];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 搜索结束动作（包括点击各个页面跳转），用来保存搜索关键词
- (void)saveSearchAction{
    if (!(self.searchStr == nil || self.searchStr == NULL || [self.searchStr isKindOfClass:[NSNull class]] || [[self.searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)) {
        [NSString saveKeyWordWithText:self.searchStr];
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
