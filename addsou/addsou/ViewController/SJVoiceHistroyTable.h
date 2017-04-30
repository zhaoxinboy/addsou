//
//  SJVoiceHistroyTable.h
//  addsou
//
//  Created by 杨兆欣 on 2017/4/24.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJVoiceHistroyTabelDelegate <NSObject>

- (void)jumpdidSelectRowAtIndexPathWithModel:(SJHistoryArrModel *)model;

@end

@interface SJVoiceHistroyTable : UITableView

@property (nonatomic, weak) id <SJVoiceHistroyTabelDelegate> tableDelegate;

@property (nonatomic, strong) NSMutableArray *dataArr;      // 数据源

- (void)getDataArrWithArr:(NSMutableArray *)dataArr;

@end
