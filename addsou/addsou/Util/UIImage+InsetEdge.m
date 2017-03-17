//
//  UIImage+InsetEdge.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/17.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "UIImage+InsetEdge.h"

@implementation UIImage (InsetEdge)

- (UIImage *)imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color{
    CGSize size = self.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    CGRect rect = CGRectMake(-insets.left, -insets.top, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (color) {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    [self drawInRect:rect];
    UIImage *insetEdgedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return insetEdgedImage;
}

@end
