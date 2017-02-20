//
//  SJHomePageLayout.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/5.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJHomePageLayout.h"

@implementation SJHomePageLayout

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];//需要调用super方法
    
    //初始化
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
    
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);//collectionView落在屏幕中点的x坐标
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

static CGFloat const ActiveDistance = 350;
static CGFloat const ScaleFactor = 0.05;

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
//        DLog(@"%f",distance);
        CGFloat normalizedDistance = distance / ActiveDistance;
        CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance));
//        DLog(@"%f", zoom)
        attributes.transform3D = CATransform3DMakeScale(1.0, 1.0, 1.0);
        attributes.zIndex = 1;
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
