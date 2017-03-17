//
//  UIImage+InsetEdge.h
//  addsou
//
//  Created by 杨兆欣 on 2017/3/17.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (InsetEdge)

- (UIImage *)imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color;

@end
