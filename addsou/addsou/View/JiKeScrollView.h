//
//  JiKeScrollView.h
//  JiKeScrollView
//
//  Created by 李龙 on 16/11/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiKeScrollView : UIView

@property (nonatomic, strong) NSArray *myFirstArr;   /* 第一次加载的数据 */

@property (nonatomic, strong) NSArray *myNextArr;   /* 再次刷新加载的数据 */


@end
