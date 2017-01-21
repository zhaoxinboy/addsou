//
//  SJTransitionManager.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/7.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, XWCircleSpreadTransitionType) {
    XWCircleSpreadTransitionTypePresent = 0,
    XWCircleSpreadTransitionTypeDismiss
};

@interface SJTransitionManager : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) XWCircleSpreadTransitionType type;
+ (instancetype)transitionWithTransitionType:(XWCircleSpreadTransitionType)type;
- (instancetype)initWithTransitionType:(XWCircleSpreadTransitionType)type;

@end
