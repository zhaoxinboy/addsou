//
//  JiKeScrollImageView.m
//  JikePictureShow
//
//  Created by 李龙 on 16/11/21.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "JiKeScrollImageView.h"
#import "JiKeAnimationStatus.h"
#import "UIView+Frame.h"
#import "SJSearchViewModel.h"



@interface JiKeScrollImageView ()

@property (nonatomic, strong) SJSearchViewModel *searchVM;


@property (nonatomic,strong) NSArray *myImageViewArray;
@end


@implementation JiKeScrollImageView{
    int _scrollIndex;
    
    CGFloat _originalTopY;
    CGFloat _originalCenterY;
    CGFloat _originalDownY;
    
    //动画执行标记
    JiKeAnimationStatus animStatus;
}

- (SJSearchViewModel *)searchVM{
    if (!_searchVM) {
        _searchVM = [SJSearchViewModel new];
    }
    return _searchVM;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化控件
        [self initSubViews];
    }
    return self;
}




- (NSArray *)myImageViewArray
{
    if (!_myImageViewArray) {
        SJImageViewAndButton *iconView0 = [[SJImageViewAndButton alloc] init];
        iconView0.image = [UIImage imageNamed:@"tempBack"];
        
        SJImageViewAndButton *iconView1 = [[SJImageViewAndButton alloc] init];
        iconView1.image = [UIImage imageNamed:@"tempBack"];
        
        _myImageViewArray = [NSArray arrayWithObjects:iconView0, iconView1, nil];
    }
    return _myImageViewArray;
}



- (void)initSubViews{
    
    
    CGFloat topMargin = LLTBMargin;
    CGFloat iconWH = self.frame.size.width;
    
    _originalTopY = -iconWH;
    _originalCenterY = 0;
    _originalDownY = iconWH;
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iconWH, iconWH)];
    backView.clipsToBounds = YES;
    [self addSubview:backView];
    
    
    _myImageView0 = ({
        SJImageViewAndButton *iconView0 = self.myImageViewArray[0];
        [iconView0.clickBtn addTarget:self action:@selector(jumpHTML:) forControlEvents:UIControlEventTouchUpInside];
        [iconView0.addBtn addTarget:self action:@selector(addHTML:) forControlEvents:UIControlEventTouchUpInside];
        iconView0.frame = (CGRect){0,_originalCenterY,iconWH,iconWH};
        [backView addSubview:iconView0];
        iconView0;
    });
    
    
    _myImageView1 = ({
        SJImageViewAndButton *iconView1 = self.myImageViewArray[1];
        [iconView1.clickBtn addTarget:self action:@selector(jumpHTML:) forControlEvents:UIControlEventTouchUpInside];
        [iconView1.addBtn addTarget:self action:@selector(addHTML:) forControlEvents:UIControlEventTouchUpInside];
        iconView1.frame = (CGRect){0,_originalTopY,iconWH,iconWH};
        [backView addSubview:iconView1];
        iconView1;
    });
    
    
    
    _scrollIndex = 0;
}
- (void)addHTML:(UIButton *)sender{
    DLog(@"添加")
    if (animStatus == STATUS_RUNNING) {
        return;
    }else{
        SJHomeAddressDataModel *model = [SJHomeAddressDataModel new];
        if (_scrollIndex == 1) {
            model = (SJHomeAddressDataModel *)_myImageView1.model;
        }else if (_scrollIndex == 0){
            model = (SJHomeAddressDataModel *)_myImageView0.model;
        }
        DLog(@"%@", model.appname)
        DLog(@"%d", sender.selected)
        __weak typeof (self) wself = self;
        if (!sender.selected) {
            [self.searchVM postAddAppInfoToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:UserDefaultObjectForKey(LOCAL_READ_USERID) CompleteHandle:^(NSError *error) {
                if ([wself.searchVM.successStr isEqualToString:@"success"]) {
                    // 成功添加后 刷新关注列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"focusViewRefresh" object:model];
                    sender.selected = !sender.selected;
                }
            }];
        }else{
            [self.searchVM postDeleteCollectAppByUserid:UserDefaultObjectForKey(LOCAL_READ_USERID) appid:[NSString stringWithFormat:@"%@", model.qdrid] CompleteHandle:^(NSError *error) {
                if ([wself.searchVM.deleStr isEqualToString:@"success"]) {
                    // 成功删除后 刷新关注列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"focusViewRefresh" object:model];
                    sender.selected = !sender.selected;
                }
            }];
        }
    }
}

- (void)jumpHTML:(UIButton *)sender{
    
    DLog(@"点击")
    
    if (animStatus == STATUS_RUNNING) {
        return;
    }else{
        SJHomeAddressDataModel *model = [SJHomeAddressDataModel new];
        if (_scrollIndex == 1) {
            model = (SJHomeAddressDataModel *)_myImageView1.model;
        }else if (_scrollIndex == 0){
            model = (SJHomeAddressDataModel *)_myImageView0.model;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionViewCellJump" object:model];
    }
}


- (void)beiginScrollDown{
    _scrollIndex++;
    
    [self runAnimation];
}


- (void)runAnimation{
    
    void (^changeBlock)() = ^(){
        animStatus = STATUS_RUNNING;
        
        if (_scrollIndex == 1) {
            _myImageView1.y = _originalCenterY;
            _myImageView0.y = _originalDownY;
            
        }else if(_scrollIndex == 2){
            
            _myImageView1.y = _originalDownY;
            _myImageView0.y = _originalCenterY;
            
            _scrollIndex = 0;
        }
        
        //蒙版
//        _myCoverView.hidden = NO;
//        _myCoverView.alpha = 0.3f;
//        _myCoverView.y =_originalDownY;
    };
    
    
    void (^completionBlock)(BOOL) = ^(BOOL finished){
        
        if(finished){
            if (_scrollIndex == 1) {
                _myImageView0.y = _originalTopY;
                [_myImageView0 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, _myNextShowImageLink.appshowimg]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
                if ([_myNextShowImageLink.iscollected isEqualToString:@"0"]) {
                    _myImageView0.addBtn.selected = NO;
                }else{
                    _myImageView0.addBtn.selected = YES;
                }
                _myImageView0.model = (SJHomeAddressDataModel *)_myNextShowImageLink;
            }else if(_scrollIndex == 0){
                _myImageView1.y = _originalTopY;
                [_myImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, _myNextShowImageLink.appshowimg]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
                if ([_myNextShowImageLink.iscollected isEqualToString:@"0"]) {
                    _myImageView1.addBtn.selected = NO;
                }else{
                    _myImageView1.addBtn.selected = YES;
                }
                _myImageView1.model = (SJHomeAddressDataModel *)_myNextShowImageLink;
            }
            //蒙版归位
//            _myCoverView.hidden = YES;
//            _myCoverView.alpha = 0.f;
//            _myCoverView.y =_originalCenterY;
            
            animStatus = STATUS_END;
        }
    };
    
    [self doAnimation:changeBlock completion:completionBlock];

}



- (void)doAnimation:(void(^)())changeBK completion:(void(^)(BOOL finished))competionBK{
    [UIView animateWithDuration:0.6f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:changeBK completion:competionBK];
}



#pragma mark ================ 传入数据处理 ================
-(void)setMyFirstShowImageLinkArray:(NSArray *)myFirstShowImageLinkArray{
    if(myFirstShowImageLinkArray == nil || myFirstShowImageLinkArray.count < 2)
        DLog(@"请设置两张初始化图片");
    
    _myFirstShowImageLinkArray = myFirstShowImageLinkArray;
    SJHomeAddressDataModel *model0 = (SJHomeAddressDataModel *)_myFirstShowImageLinkArray[0];
    SJHomeAddressDataModel *model1 = (SJHomeAddressDataModel *)_myFirstShowImageLinkArray[1];
    [_myImageView0 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model0.appshowimg]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    if ([model0.iscollected isEqualToString:@"0"]) {
        _myImageView0.addBtn.selected = NO;
    }else{
        _myImageView0.addBtn.selected = YES;
    }
    _myImageView0.model = model0;
    [_myImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model1.appshowimg]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    if ([model1.iscollected isEqualToString:@"0"]) {
        _myImageView1.addBtn.selected = NO;
    }else{
        _myImageView1.addBtn.selected = YES;
    }
    _myImageView1.model = model1;
}


// 在设置myFirstShowImageLink之后,传入后自动调用下一个张操作
-(void)setMyNextShowImageLink:(SJHomeAddressDataModel *)myNextShowImageLink{
    //保证动画当前顺序执行
    if (animStatus == STATUS_RUNNING)
        return;
    
    //处理数据
    if(_myFirstShowImageLinkArray == nil || _myFirstShowImageLinkArray.count < 2)
        DLog(@"还是先设置两张初始化图片吧");
    
    _myNextShowImageLink = myNextShowImageLink;
    
    [self beiginScrollDown];
}

























@end
