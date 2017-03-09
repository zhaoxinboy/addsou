//
//  SJSearchTableViewController.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseSearchSmallDelegate <NSObject>

- (void)jumpToSearch;

@end

@interface SJSearchTableView : UITableView

@property (nonatomic, assign) id<chooseSearchSmallDelegate> chooseDelegate;      // 选择后的代理跳转

@property (nonatomic, strong) NSString *searchStr;   /* 搜索字段 */

@property (nonatomic, strong) NSMutableArray *searchArr;   /* 搜索数组 */

@end
