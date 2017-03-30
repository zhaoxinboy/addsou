//
//  SJContextMenuHelper.h
//  addsou
//
//  Created by 杨兆欣 on 2017/3/27.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJWebViewController.h"

@class SJContextMenuHelper;
@protocol contextMenuHelperDelegate <NSObject>

- (void)contextMenuHelper:(SJContextMenuHelper *)contextMenuHelper didLongPressElements:(Elements *)elements gestureRecognizer:(UILongPressGestureRecognizer *)gestureRegcognizer;

@end

@interface SJContextMenuHelper : NSObject



@property (nonatomic, assign) id<contextMenuHelperDelegate> contextMenuHelpserDelegate;      // 代理

@property (nonatomic, strong) UILongPressGestureRecognizer *gestureRecongnizer;      // 长按

@property (nonatomic, weak) UIGestureRecognizer *selectionGestureRecognizer;      // 点击

- (instancetype)initWithWebViewController:(id)webVC;

@end
