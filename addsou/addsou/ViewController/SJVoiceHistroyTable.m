//
//  SJVoiceHistroyTable.m
//  addsou
//
//  Created by 杨兆欣 on 2017/4/24.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJVoiceHistroyTable.h"
#import "SJVoiceHistroyTableViewCell.h"

@interface SJVoiceHistroyTable ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SJVoiceHistroyTable

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


- (void)getDataArrWithArr:(NSMutableArray *)dataArr{
    self.dataArr = dataArr;
    [self reloadData];
}



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:(CGRect)frame style:(UITableViewStyle)style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        [self registerClass:[SJVoiceHistroyTableViewCell class] forCellReuseIdentifier:@"SJVoiceHistroyTableViewCell"];
    }
    return self;
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJVoiceHistroyTableViewCell *cell = (SJVoiceHistroyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SJVoiceHistroyTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    SJHistoryArrModel *model = (SJHistoryArrModel *)self.dataArr[indexPath.row];
    [cell getModelWithModel:model];
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SJHistoryArrModel *model = (SJHistoryArrModel *)self.dataArr[indexPath.row];
    if (self.tableDelegate && [self.tableDelegate respondsToSelector:@selector(jumpdidSelectRowAtIndexPathWithModel:)]) {
        [self.tableDelegate jumpdidSelectRowAtIndexPathWithModel:model];
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
