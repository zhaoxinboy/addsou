//
//  JiKeScrollView.m
//  JiKeScrollView
//
//  Created by 李龙 on 16/11/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "JiKeSignalScrollView.h"
#import "UIView+Frame.h"
#import "JiKeScrollImageView.h"
#import "JiKeScrollLabel.h"

@interface JiKeSignalScrollView ()

@property (nonatomic,strong) JiKeScrollImageView *myJiKeScrollImageView;
@property (nonatomic,strong) JiKeScrollLabel *myJiKeScrollLabel;

@property (nonatomic,strong) UIView *mySignleShowView;

//模拟数据
@property (nonatomic,strong) NSArray *tempDataArray;
@end


@implementation JiKeSignalScrollView{
    int dataShowIndex;
}

-(instancetype)initWithFrame:(CGRect)frame withScrollLabelSize:(CGSize)labelSize{
    
    if (self = [super initWithFrame:frame]) {
        //初始化控件
        [self initSubViewsWithLabelSize:labelSize];
    }
    return self;
}



- (void)initSubViewsWithLabelSize:(CGSize)LabelSize{
    
    //滚动图
    _myJiKeScrollImageView = ({
        JiKeScrollImageView *scrollImageView = [[JiKeScrollImageView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, self.frame.size.width}];
        [self addSubview:scrollImageView];
        scrollImageView;
    });
    
    
    //滚动文字
    _myJiKeScrollLabel = ({
        CGFloat scrollLabelY = self.frame.size.height - LabelSize.height / 2 - 8;
        if (kWindowW <= 320) {
            scrollLabelY = self.frame.size.height - LabelSize.height / 2 + 3;
        }
        JiKeScrollLabel *scrollLabel = [[JiKeScrollLabel alloc] initWithFrame:(CGRect){0, scrollLabelY, self.frame.size.width, LabelSize.height * 2}];
        [self addSubview:scrollLabel];
        scrollLabel;
    });
}




//初始化数据
- (void)setMyFirstShowArray:(NSArray *)myFirstShowArray{
    _myJiKeScrollImageView.myFirstShowImageLinkArray = myFirstShowArray;
    _myJiKeScrollLabel.myFirstShowLabelDesArray = myFirstShowArray;
}



//执行下一次显示动画
- (void)setMyNextShowArray:(SJHomeAddressDataModel *)myNextShowArray{
    _myJiKeScrollLabel.myNextShowLabelDes = myNextShowArray;
    _myJiKeScrollImageView.myNextShowImageLink = myNextShowArray;
}






@end
