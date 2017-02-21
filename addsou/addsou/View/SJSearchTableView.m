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

@implementation SJSearchTableView{
    NSIndexPath *selectIndexPath;
    NSInteger selectInt;
}

- (NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc] init];
        [_searchArr removeAllObjects];
        for (int i = 0; i < 4; i++) {
            SJSearchModel *model = [SJSearchModel new];
            if (i == 0) {
                model.searchTitle = @"百度引擎";
                model.searchField = @"";
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_baidu@3x.png", URLPATH];
                model.searchEngine = BAIDUSEARCH;
            }else if (i == 1){
                model.searchTitle = @"必应引擎";
                model.searchField = @"";
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_biying@3x.png", URLPATH];
                model.searchEngine = BIYINGSEARCH;
            }else if (i == 2){
                model.searchTitle = @"搜狗引擎";
                model.searchField = @"";
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_sougou@3x.png", URLPATH];
                model.searchEngine = SOUGOUSEARCH;
            }else{
                model.searchTitle = @"360引擎";
                model.searchField = @"";
                model.searchImageStr = [NSString stringWithFormat:@"%@/media/tmp/icon_360@3x.png", URLPATH];
                model.searchEngine = QIHUSEARCH;
            }
            [_searchArr addObject:model];
        }
    }
    return _searchArr;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        // 隐藏cell分割线
//        self.separatorStyle = NO;
        // 去掉多余cell
        self.tableFooterView = [UIView new];
        [self registerClass:[SJSearchTableViewCell class] forCellReuseIdentifier:@"SJSearchTableViewCell"];
        [self searchArr];
    }
    return self;
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
    SJSearchModel *model = self.searchArr[indexPath.row];
    [cell.searchImageView sd_setImageWithURL:[NSURL URLWithString:model.searchImageStr] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    cell.titleLabel.text = model.searchTitle;
    
    if ([UserDefaultObjectForKey(LOCAL_READ_SEARCH) isEqualToString:model.searchEngine]) {
        cell.rightBtn.selected = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    // 选中不变色
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndexPath == nil) {
        for (int i = 0; i < self.searchArr.count; i++) {
            SJSearchModel *model = self.searchArr[i];
            if ([model.searchEngine isEqualToString:UserDefaultObjectForKey(LOCAL_READ_SEARCH)]) {
                selectInt = i;
                NSIndexPath *index = [NSIndexPath indexPathForRow:selectInt inSection:0];
                SJSearchTableViewCell * cell = (SJSearchTableViewCell *)[tableView cellForRowAtIndexPath:index];
                [cell UpdateCellWithState:NO];
            }
        }
    }
    if (selectIndexPath != nil && selectIndexPath != indexPath) {
        SJSearchTableViewCell * cell = (SJSearchTableViewCell *)[tableView cellForRowAtIndexPath:selectIndexPath];
        [cell UpdateCellWithState:NO];
    }
    SJSearchTableViewCell * cell = (SJSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell UpdateCellWithState:YES];
    selectIndexPath = indexPath;
    SJSearchModel *model = self.searchArr[indexPath.row];
    UserDefaultSetObjectForKey(model.searchEngine, LOCAL_READ_SEARCH);
    [self showSuccessMsg:[NSString stringWithFormat:@"已选%@", model.searchTitle]];
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
