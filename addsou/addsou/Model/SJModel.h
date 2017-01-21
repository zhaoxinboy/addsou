//
//  SJModel.h
//  addsou
//
//  Created by 杨兆欣 on 2017/1/3.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SJModel : BaseModel

@end

/*--------------------公司信息--------------------*/

@interface SJHomePageModel : BaseModel

@property (nonatomic, copy) NSString *status;   /* 返回码 */

@property (nonatomic, strong) NSMutableArray *data;   /* 内容 */

@end

@interface SJHomeDataModel : BaseModel

@property (nonatomic, copy) NSString *companyname;   /* 公司名称 */

@property (nonatomic, copy) NSString *addtime;   /* 加入时间 */

@property (nonatomic, copy) NSString *record;   /* 记录 */

@property (nonatomic, copy) NSString *modifytime;   /* 修改时间 */

@property (nonatomic, copy) NSString *logo;   /* logo */

@property (nonatomic, assign) NSNumber *qdrid;   /* 用户ID */

@property (nonatomic, copy) NSString *legal;   /* 法律条款 */

@end

/*--------------------end--------------------*/


/*--------------------链接信息--------------------*/

@interface SJHomeAddressModel : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSMutableArray *data;

@end

/*
 "applogopath": "/media/applogo/2016/09/me_07_PJFiA8G.png",
 "appname": "网易",
 "addtime": "2016-09-24 10:33:30",
 "isshow": true,
 "appurl": "wap.wangyi.com",
 "appindex": 6,
 "modifytime": "2016-09-24 10:33:30",
 "id": 7,
 "desc": "321"
 */

@interface SJHomeAddressDataModel : BaseModel

@property (nonatomic, copy) NSString *applogopath;

@property (nonatomic, copy) NSString *appname;

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, copy) NSString *isshow;

@property (nonatomic, copy) NSString *appurl;

@property (nonatomic, copy) NSString *appindex;

@property (nonatomic, copy) NSString *modifytime;

@property (nonatomic, copy) NSNumber *qdrid;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *supercode;

@property (nonatomic, copy) NSString *iscollected;

@property (nonatomic, copy) NSString *appshowimg;

@end

/*--------------------end--------------------*/




/*--------------------分类--------------------*/

@interface SJClassificationModel : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSMutableArray *data;

@end

@interface SJClassiModel : BaseModel

@property (nonatomic, assign) NSNumber *index;

@property (nonatomic, strong) NSMutableArray *appinfo;

@property (nonatomic, copy) NSString *categoryname;

@end

@interface SJClassiDataModel : BaseModel

@property (nonatomic, copy) NSString *applogopath;

@property (nonatomic, copy) NSString *appname;

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, copy) NSString *isshow;

@property (nonatomic, copy) NSString *appurl;

@property (nonatomic, copy) NSString *appindex;

@property (nonatomic, copy) NSString *modifytime;

@property (nonatomic, assign) NSNumber *qdrid;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *iscollected;

@property (nonatomic, copy) NSString *supercode;

@end


/*--------------------end--------------------*/






/*--------------------皮肤--------------------*/

@interface SJSkinModel : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSMutableArray *data;

@end

@interface SJSkinDataModel : BaseModel

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, assign) NSNumber *skinId;

@property (nonatomic, copy) NSString *modifytime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *picaddr;

@end

/*--------------------end--------------------*/






/*--------------------登录--------------------*/
@interface SJLoginModel : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSDictionary *data;

@end

@interface SJLoginDataModel : BaseModel

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *qq;

@property (nonatomic, copy) NSString *first_name;

@property (nonatomic, copy) NSString *last_name;

@property (nonatomic, copy) NSString *usertype;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *is_superuser;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *is_staff;

@property (nonatomic, copy) NSString *last_login;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *rtoken;

@property (nonatomic, assign) NSNumber *userid;      // 用户ID

@property (nonatomic, copy) NSString *date_joined;

@end

//{
//    data =     {
//        avatar = "/media/avatar/default.png";
//        company = 1;
//        "date_joined" = "2016-10-05 07:17:16";
//        email = "";
//        "first_name" = "";
//        id = 14;
//        "is_active" = 1;
//        "is_staff" = 0;
//        "is_superuser" = 0;
//        "last_login" = "<null>";
//        "last_name" = "";
//        mobile = "<null>";
//        qq = "<null>";
//        serialnumber = "3E56A64F-BA3B-4214-B954-1EE9C5216179";
//        username = "3E56A64F-BA3B-4214-B954-1EE9C5216179";
//        usertype = 2;
//    };
//    status = 0;
//}

@interface SJFirstModel : BaseModel

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *date_joined;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *first_name;

@property (nonatomic, assign) NSNumber *userid;      // 用户ID

@property (nonatomic, assign) NSNumber *usertype;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *is_staff;

@property (nonatomic, copy) NSString *is_superuser;

@property (nonatomic, copy) NSString *last_login;

@property (nonatomic, copy) NSString *last_name;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *qq;

@property (nonatomic, copy) NSString *serialnumber;

@property (nonatomic, copy) NSString *rtoken;

@property (nonatomic, copy) NSString *username;


@end

@interface SJIsLoginModel : BaseModel

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSMutableDictionary *outerinfo;

@end


// 微信登录
@interface SJWXLgoinModel : BaseModel

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *headimgurl;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *openid;

@property (nonatomic, copy) NSString *privilege;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *unionid;

@end


// QQ登录
@interface SJQQLgoinModel : BaseModel

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *figureurl;

@property (nonatomic, copy) NSString *figureurl_1;

@property (nonatomic, copy) NSString *figureurl_2;

@property (nonatomic, copy) NSString *figureurl_qq_1;

@property (nonatomic, copy) NSString *figureurl_qq_2;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *is_lost;

@property (nonatomic, copy) NSString *is_yellow_vip;

@property (nonatomic, copy) NSString *is_yellow_year_vip;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *vip;

@property (nonatomic, copy) NSString *ret;

@property (nonatomic, copy) NSString *yellow_vip_level;

@end
/*--------------------end--------------------*/




/*--------------------历史记录--------------------*/
@interface SJHistoryModel : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSMutableArray *data;

@end

@interface SJHistoryArrModel : BaseModel

@property (nonatomic, copy) NSString *appurl;

@property (nonatomic, copy) NSNumber *appID;

@property (nonatomic, copy) NSString *applogopath;

@property (nonatomic, copy) NSString *appname;

@property (nonatomic, copy) NSString *supercode;

@end
/*--------------------end--------------------*/

/*--------------------搜索--------------------*/
@interface SJSearchModel : BaseModel

@property (nonatomic, copy) NSString *searchField;   /* 搜索字段 */

@property (nonatomic, copy) NSString *searchTitle;   /* 搜索引擎 */

@property (nonatomic, copy) NSString *searchImageStr;   /* 对应图片 */

@end
/*--------------------end--------------------*/


@interface SJThirdSearchModel : BaseModel

@property (nonatomic, copy) NSString *title;   /* 标题 */

@property (nonatomic, copy) NSString *descriptionStr;   /* 文案 */

@property (nonatomic, copy) NSString *webpageUrl;   /* 链接 */

@property (nonatomic, strong) UIImage *thumbImage;   /* 图片 */

@end
