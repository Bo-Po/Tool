//
//  BaseModel+SQLite.h
//  SQLite数据库操作-0C
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 邱学伟. All rights reserved.
//

#import "BaseModel.h"
#import "SQLiteManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel (SQLite)

/// 将本身插入数据库
- (BOOL)insertObjcetToDB;
/// 数据库中所有对象
+ (NSArray *)allObjcetFromDB;
+ (NSArray *)selectObjcetFromDBWith:(NSDictionary *)condition;
/// 更新数据库中对象 result的key eg. 属性名-DB数据类型
+ (BOOL)updateObjcet:(NSDictionary *)result;
+ (BOOL)updateObjcet:(NSDictionary *)result where:(NSDictionary *)condition;
/// 删除数据库中对象
+ (BOOL)deleteAllObjcet;
+ (BOOL)deleteObjcetWhere:(NSDictionary *)condition;
/// 属性对应DB字段
- (NSDictionary *)propertyContrastDBField;

@end

NS_ASSUME_NONNULL_END
