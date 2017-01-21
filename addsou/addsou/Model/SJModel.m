//
//  SJModel.m
//  addsou
//
//  Created by 杨兆欣 on 2017/1/3.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "SJModel.h"

@implementation SJModel

@end

@implementation SJHomePageModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[SJHomeDataModel class]};
}

@end

@implementation SJHomeDataModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"qdrid":@"id"};
}

@end

@implementation SJHomeAddressModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[SJHomeAddressDataModel class]};
}

@end

@implementation SJHomeAddressDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"qdrid":@"id"};
}


@end

@implementation SJClassificationModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : [SJClassiModel class]};
}
@end

@implementation SJClassiModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"appinfo" : [SJClassiDataModel class]};
}
@end

@implementation SJClassiDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"qdrid":@"id"};
}

@end

@implementation SJSkinModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : [SJSkinDataModel class]};
}

@end

@implementation SJSkinDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"skinId":@"id"};
}

@end

@implementation SJLoginModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[SJLoginDataModel class]};
}

@end

@implementation SJLoginDataModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userid":@"id"};
}

@end

@implementation SJFirstModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userid":@"id"};
}

@end

@implementation SJIsLoginModel


@end

@implementation SJWXLgoinModel


@end

@implementation SJQQLgoinModel


@end

@implementation SJHistoryModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[SJHistoryArrModel class]};
}

@end


@implementation SJHistoryArrModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"appID":@"id"};
}

@end

@implementation SJSearchModel


@end

@implementation SJThirdSearchModel


@end



