//
//  SJManager.m
//  addsou
//
//  Created by 杨兆欣 on 2017/2/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJManager.h"

@implementation SJManager

+ (SJManager *)sharedManager {
    static SJManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc] init];
        [_searchArr removeAllObjects];
        for (int i = 0; i < 4; i++) {
            SJSearchModel *model = [SJSearchModel new];
            if (i == 0) {
                model.searchTitle = @"百度搜索";
//                model.searchField = str;
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_baidu@3x.png", URLPATH];
                model.searchEngine = BAIDUSEARCH;
            }else if (i == 1){
                model.searchTitle = @"必应搜索";
//                model.searchField = str;
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_biying@3x.png", URLPATH];
                model.searchEngine = BIYINGSEARCH;
            }else if (i == 2){
                model.searchTitle = @"搜狗搜索";
//                model.searchField = str;
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_sougou@3x.png", URLPATH];
                model.searchEngine = SOUGOUSEARCH;
            }else{
                model.searchTitle = @"360搜索";
//                model.searchField = str;
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_360@3x.png", URLPATH];
                model.searchEngine = QIHUSEARCH;
            }
            [_searchArr addObject:model];
        }
    }
    return _searchArr;
}




@end
