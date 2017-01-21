//
//  JiKeScrollView.m
//  JiKeScrollView
//
//  Created by 李龙 on 16/11/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "JiKeScrollView.h"
#import "JiKeSignalScrollView.h"


@interface JiKeScrollView ()

@property (nonatomic,strong) JiKeSignalScrollView *myJikeSignalScrollView;

@property (nonatomic,strong) NSMutableArray *myShowViewArray;

@end

@implementation JiKeScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化控件
        [self initSubViews];
    }
    return self;
}



- (void)initSubViews{
    
    _myShowViewArray = [NSMutableArray arrayWithCapacity:6];

    CGFloat singalScrollViewWidth = (kWindowW - LLLRMargin * 2 - LLverticalMargin * 2) * 0.3333;
    CGSize labelSize = [SJTool getSizeWithStrig:@"测试" font:LLLabelFont maxSize:(CGSize){singalScrollViewWidth,MAXFLOAT}];
    labelSize.height = labelSize.height / 2;
    CGFloat singalScrollViewHeight = LLTBMargin*2 + LLhorizontalMargin + singalScrollViewWidth + labelSize.height*2;
    
    LxDBAnyVar(labelSize);
    LxDBAnyVar(singalScrollViewWidth);
    LxDBAnyVar(singalScrollViewHeight);

    for (int i = 0; i < 6; i++) {
        
        CGRect signalFrame = CGRectZero;
        switch (i) {
            case 0:
                signalFrame = CGRectMake(SJ_ADAPTER_WIDTH(13), 0, HOMEPAGE_CELL_WIDTH, HOMEPAGE_CELL_HEIGHT);
                break;
            case 1:
                signalFrame = CGRectMake((kWindowW / 2 - 10) - HOMEPAGE_CELL_WIDTH / 2, 0, HOMEPAGE_CELL_WIDTH, HOMEPAGE_CELL_HEIGHT);
                break;
            case 2:
                signalFrame = CGRectMake(kWindowW - SJ_ADAPTER_WIDTH(20 + 13) - HOMEPAGE_CELL_WIDTH, 0, HOMEPAGE_CELL_WIDTH, HOMEPAGE_CELL_HEIGHT);
                break;
            case 3:
                signalFrame = CGRectMake(SJ_ADAPTER_WIDTH(13), HOMEPAGE_CELL_HEIGHT + SJ_ADAPTER_HEIGHT(30), HOMEPAGE_CELL_WIDTH, HOMEPAGE_CELL_HEIGHT);
                break;
            case 4:
                signalFrame = CGRectMake((kWindowW / 2 - SJ_ADAPTER_WIDTH(10)) - HOMEPAGE_CELL_WIDTH / 2, HOMEPAGE_CELL_HEIGHT + SJ_ADAPTER_HEIGHT(30), HOMEPAGE_CELL_WIDTH, HOMEPAGE_CELL_HEIGHT);
                break;
            case 5:
                signalFrame = CGRectMake(kWindowW - SJ_ADAPTER_WIDTH(20 + 13) - HOMEPAGE_CELL_WIDTH, HOMEPAGE_CELL_HEIGHT + SJ_ADAPTER_HEIGHT(30), HOMEPAGE_CELL_WIDTH, HOMEPAGE_CELL_HEIGHT);
                break;
                
            default:
                break;
        }
        JiKeSignalScrollView *signalScrollView = [[JiKeSignalScrollView alloc] initWithFrame:signalFrame withScrollLabelSize:labelSize];
        [self addSubview:signalScrollView];
        [_myShowViewArray addObject:signalScrollView];
    }
    
}




//处理首次传入的数据
- (void)setMyFirstArr:(NSMutableArray *)myFirstArr{
    if (myFirstArr.count < 6) {
        DLog(@"请传入初始数组（智能推荐）")
    }
    [self setFirstJikeScrollData:myFirstArr];
}



//执行下次数据动画
- (void)setMyNextArr:(NSArray *)myNextArr{
    if(myNextArr.count < 6)
        DLog(@"请传入下一个六张图片的链接");
    [self runJikeScrollImageView:myNextArr];
}





- (void)setFirstJikeScrollData:(NSArray *)data{
    for (int i = 0; i < data.count; i++) {
        JiKeSignalScrollView *signView = _myShowViewArray[i];
        signView.myFirstShowArray = data[i];
    }
}

//初始化数据
//- (void)setFisrtJikeScrollImageData:(NSArray *)data{
//    for (int i = 0; i < data.count; i++) {
//        JiKeSignalScrollView *signView = _myShowViewArray[i];
//        signView.myFirstShowImageLinkArray = data[i];
//        
//    }
//}
//- (void)setFisrtJikeScrollLabelData:(NSArray *)data{
//    for (int i = 0; i < data.count; i++) {
//        JiKeSignalScrollView *signView = _myShowViewArray[i];
//        signView.myFirstShowLabelDesArray = data[i];
//    }
//}


//执行动画
- (void)runJikeScrollImageView:(NSArray *)data{
    for (int i = 0; i < data.count; i++) {
        
        void(^tempDelayRunBlock)() = ^(){
            JiKeSignalScrollView *signView = _myShowViewArray[i];
            signView.myNextShowArray = data[i];
        };
        [self delayRun:tempDelayRunBlock index:i];
    }
}
- (void)runJikeScrollLabelView:(NSArray *)data{
    for (int i = 0; i < data.count; i++) {
        void(^tempDelayRunBlock)() = ^(){
            JiKeSignalScrollView *signView = _myShowViewArray[i];
            signView.myNextShowArray = data[i];
        };
        
        [self delayRun:tempDelayRunBlock index:i];
    }
}


//延迟执行代码
- (void)delayRun:(void (^)())delayRunBlock index:(int)index{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * index * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (delayRunBlock)
            delayRunBlock();
    });
}

@end
