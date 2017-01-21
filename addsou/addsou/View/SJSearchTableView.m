//
//  SJSearchTableViewController.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/9.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJSearchTableView.h"
#import "SJSearchTableViewCell.h"

@interface SJSearchTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SJSearchTableView

- (NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc] init];
    }
    return _searchArr;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        // 隐藏cell分割线
        self.separatorStyle = NO;
        [self registerClass:[SJSearchTableViewCell class] forCellReuseIdentifier:@"SJSearchTableViewCell"];
        self.transform = CGAffineTransformMakeRotation(-M_PI);
        [self searchArr];
    }
    return self;
}

// 点击tabbleview关闭键盘并跳转回主页
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    id view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[self class]]) {
        if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(jumpToHomePage)]) {
            [self.searchDelegate jumpToHomePage];
        }
        return self;
    }else{
        return view;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJSearchTableViewCell *cell = (SJSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SJSearchTableViewCell" forIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI); //倒置
    SJSearchModel *model = self.searchArr[indexPath.row];
    [cell.searchImageView sd_setImageWithURL:[NSURL URLWithString:model.searchImageStr] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    cell.titleLabel.text = self.searchStr;
    cell.rightLabel.text = model.searchTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchIndexPathRow:searchAllStr:model:)]) {
        SJSearchModel *model = self.searchArr[indexPath.row];
        [self.searchDelegate searchIndexPathRow:indexPath.row searchAllStr:[NSString keywordWithSearchWebUrl:self.searchStr searchWebUrlStyle:indexPath.row] model:model];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
