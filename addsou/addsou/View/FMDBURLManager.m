//
//  FMDBURLManager.m
//  addsou
//
//  Created by 杨兆欣 on 2017/3/28.
//  Copyright © 2017年 杨兆欣. All rights reserved.
//

#import "FMDBURLManager.h"
#import "QDRBookViewModel.h"
#import "FMDatabaseAdditions.h"

static FMDBURLManager *manager = nil;

@interface FMDBURLManager ()<NSCopying, NSMutableCopying>{
    FMDatabase *_db;
}


@end

@implementation FMDBURLManager

+ (instancetype)sharedFMDBUrlManager{
    if (manager == nil) {
        manager = [[FMDBURLManager alloc] init];
        [manager initDataBase];
    }
    return manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (manager == nil) {
        manager = [super allocWithZone:zone];
    }
    return manager;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

-(void)initDataBase{
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"urlmodel.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    // 初始化数据表
    NSString *bookViewSql = @"CREATE TABLE 'urlmodel' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'urlmodel_id' VARCHAR(255),'urlmodel_urlname' VARCHAR(255),'urlmodel_isopen' VARCHAR(255),'urlmodel_url' VARCHAR(255),'urlmodel_imgurl' VARCHAR(255),'urlmodel_href' VARCHAR(255),'urlmodel_classname' VARCHAR(255),'urlmodel_strid' VARCHAR(255));";
    if ([_db open]) {
        BOOL result = [_db executeUpdate:bookViewSql];
        if (result) {
            NSLog(@"创建表成功");
        }
    }
    [_db close];
}

- (BOOL)addUrlModel:(SJUrlModel *)model{
    [_db open];
//    if (![_db columnExists:@"QDRBookViewModel_appName" inTableWithName:@"QDRBookViewModel"]){
//        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"QDRBookViewModel",@"QDRBookViewModel_appName"];
//        BOOL worked = [_db executeUpdate:alertStr];
//        if(worked){
//            NSLog(@"QDRBookViewModel_appName 插入成功");
//        }else{
//            NSLog(@"QDRBookViewModel_appName 插入失败");
//        }
//    }
    NSNumber *maxID = @(0);
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM urlmodel"];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"urlmodel_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"urlmodel_id"] integerValue] ) ;
        }
    }
    maxID = @([maxID integerValue] + 1);
    BOOL judge = [_db executeUpdate:@"INSERT INTO urlmodel(urlmodel_id,urlmodel_urlname,urlmodel_isopen,urlmodel_url,urlmodel_imgurl,urlmodel_href,urlmodel_classname,urlmodel_strid)VALUES(?,?,?,?,?,?,?,?)",maxID, model.urlName, model.isOpen, model.url, model.imgUrl, model.href, model.className, model.strid];
    NSLog(@"向数据库中添加元素 %d", judge);
    [_db close];
    return judge;
}

- (BOOL)deleteUrlModel:(SJUrlModel *)model{
    [_db open];
    BOOL judge = [_db executeUpdate:@"DELETE FROM urlmodel WHERE urlmodel_id = ?", model.ID];
    NSLog(@"从数据库中删除元素  %d", judge);
    [_db close];
    return judge;
}

- (BOOL)updateUrlModel:(SJUrlModel *)model{
    [_db open];
    BOOL judge = NO;
    judge = [_db executeUpdate:@"UPDATE 'urlmodel' SET urlmodel_urlname = ?  WHERE QDRBookViewModel_id = ? ",model.urlName,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'urlmodel' SET urlmodel_isopen = ?  WHERE QDRBookViewModel_id = ? ",model.isOpen,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'urlmodel' SET urlmodel_url = ?  WHERE QDRBookViewModel_id = ? ",model.url,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'urlmodel' SET urlmodel_imgurl = ?  WHERE QDRBookViewModel_id = ? ",model.imgUrl,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'urlmodel' SET urlmodel_href = ?  WHERE QDRBookViewModel_id = ? ",model.href,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'urlmodel' SET urlmodel_classname = ?  WHERE QDRBookViewModel_id = ? ",model.className,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'urlmodel' SET urlmodel_strid = ?  WHERE QDRBookViewModel_id = ? ",model.strid,model.ID];
    [_db close];
    return judge;
}

- (NSMutableArray *)getAllUrlModel{
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM urlmodel"];
    while ([res next]) {
        SJUrlModel *model = [[SJUrlModel alloc] init];
        model.ID = @([[res stringForColumn:@"urlmodel_id"] integerValue]);
        model.urlName = [res stringForColumn:@"urlmodel_urlname"];
        model.isOpen = [res stringForColumn:@"urlmodel_isopen"];
        model.url = [res stringForColumn:@"urlmodel_url"];
        model.imgUrl = [res stringForColumn:@"urlmodel_imgurl"];
        model.href = [res stringForColumn:@"urlmodel_href"];
        model.className = [res stringForColumn:@"urlmodel_classname"];
        model.strid = [res stringForColumn:@"urlmodel_strid"];
        [dataArray addObject:model];
    }
    
    [_db close];
    return dataArray;
}


@end
