//
//  BaseModel+SQLite.m
//  SQLite数据库操作-0C
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 邱学伟. All rights reserved.
//

#import "BaseModel+SQLite.h"

@implementation BaseModel (SQLite)

//将本身插入数据库
- (BOOL)insertSelfToDB {
    if (![self propertyContrastDBField]) {
        if (kIsShowLog) {
            NSLog(@"需要重写 (NSDictionary *)propertyContrastDBField 这个方法");
        }
        return NO;
    }
    
    // DB字段
    NSString *sql = @"";
    // 拼接插入值
    NSString *value = @"";
    // 获取需要插入数据库所对应的属性名
    NSArray *propertys = [self propertyContrastDBField].allKeys;
    for (NSString *key in propertys) {
        NSArray *fields = [[self propertyContrastDBField][key] componentsSeparatedByString:@"-"];
        NSString *field = [fields objectAtIndex:0];
        NSString *val = @"string";
        if (fields.count>1) {
            val = fields[1];
        }
        sql = [sql stringByAppendingFormat:@"%@,",field];
        if ([val.lowercaseString isEqualToString:@"string"]) {
            value = [value stringByAppendingFormat:@"'%@',", [self valueForKey:key]?:@""];
        } else {
            value = [value stringByAppendingFormat:@"%@,", [self valueForKey:key]];
        }
    }
    sql = [sql substringToIndex:sql.length-1];
    value = [value substringToIndex:value.length-1];
    //插入对象的SQL语句
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO '%@' (%@) VALUES (%@);",NSStringFromClass([self class]), sql, value];
    return [[SQLiteManager shareInstance] execSQL:insertSQL];
}
//数据库中所有对象
+ (NSArray *)selectObjcetFromDBWith:(NSDictionary *)condition {
    if (condition.count == 0) {
        return [self allObjcetFromDB];
    } else {
        NSString *cond = [self whereFromDictionary:condition];
        //查询表中所有数据的SQL语句
        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE %@", NSStringFromClass(self), cond];
        //取出数据库用户表中所有数据
        NSArray *allUserDictArr = [[SQLiteManager shareInstance] querySQL:SQL];
        NSLog(@"%@",allUserDictArr);
        //将字典数组转化为模型数组
        NSMutableArray *modelArrM = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in allUserDictArr) {
            [modelArrM addObject:[self objcetWithDictionary:dict]];
        }
        return modelArrM;
    }
}
//数据库中所有对象
+ (NSArray *)allObjcetFromDB {
    //查询表中所有数据的SQL语句
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM '%@'", NSStringFromClass(self)];
    //取出数据库用户表中所有数据
    NSArray *allUserDictArr = [[SQLiteManager shareInstance] querySQL:SQL];
    NSLog(@"%@",allUserDictArr);
    //将字典数组转化为模型数组
    NSMutableArray *modelArrM = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in allUserDictArr) {
        [modelArrM addObject:[self objcetWithDictionary:dict]];
    }
    return modelArrM;
}
// 更新数据库中对象
+ (BOOL)updateObjcet:(NSDictionary *)result where:(NSDictionary *)condition {
    if (result.count == 0) {
        NSLog(@"需要填写更新结果");
        return NO;
    } else {
        if (condition.count == 0) {
            return [self updateObjcet:result];
        } else {
            NSString *res = [self sqlFromDictionary:result];
            NSString *cond = [self whereFromDictionary:condition];
            //更新对应的SQL语句
            NSString *SQL = [NSString stringWithFormat:@"UPDATE '%@' SET %@ WHERE %@",NSStringFromClass(self), res, cond];
            return [[SQLiteManager shareInstance] execSQL:SQL];
        }
    }
}
+ (BOOL)updateObjcet:(NSDictionary *)result {
    if (result.count == 0) {
        NSLog(@"需要填写更新结果");
        return NO;
    } else {
        NSString *res = [self sqlFromDictionary:result];
        //更新对应的SQL语句
        NSString *SQL = [NSString stringWithFormat:@"UPDATE '%@' SET %@",NSStringFromClass(self), res];
        return [[SQLiteManager shareInstance] execSQL:SQL];
    }
}
// 删除数据库中对象
+ (BOOL)deleteObjcetWhere:(NSDictionary *)condition {
    if (condition.count == 0) {
        return [self deleteAllObjcet];
    } else {
        NSString *cond = [self whereFromDictionary:condition];
        //删除对应的SQL语句
        NSString *SQL = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@",NSStringFromClass(self), cond];
        return [[SQLiteManager shareInstance] execSQL:SQL];
    }
}
+ (BOOL)deleteAllObjcet {
    //删除对应的SQL语句 @"DELETE FROM 表名称 WHERE 列名称 = 值"
    NSString *SQL = [NSString stringWithFormat:@"DELETE FROM '%@'",NSStringFromClass(self)];
    return [[SQLiteManager shareInstance] execSQL:SQL];
}
/// 属性对应DB字段
- (NSDictionary *)propertyContrastDBField {
    return nil;
}
// sql 结果字符串
+ (NSString *)sqlFromDictionary:(NSDictionary *)dictionary {
    NSString *res = @"";
    NSArray *keys = dictionary.allKeys;
    for (NSString *key in keys) {
        NSArray *fields = [key componentsSeparatedByString:@"-"];
        NSString *field = [fields objectAtIndex:0];
        NSString *valType = @"string";
        if (fields.count>1) {
            valType = fields[1];
        }
        if ([valType.lowercaseString isEqualToString:@"string"]) {
            res = [res stringByAppendingFormat:@"%@='%@',", field, [dictionary valueForKey:key]];
        } else {
            res = [res stringByAppendingFormat:@"%@=%@,", field, [dictionary valueForKey:key]];
        }
    }
    return [res substringToIndex:res.length-1];
}
// sql 条件字符串
+ (NSString *)whereFromDictionary:(NSDictionary *)dictionary {
    NSString *where = @"";
    NSArray *keys = dictionary.allKeys;
    for (NSString *key in keys) {
        NSArray *fields = [key componentsSeparatedByString:@"-"];
        NSString *field = [fields objectAtIndex:0];
        NSString *valType = @"string";
        if (fields.count>1) {
            valType = fields[1];
        }
        if ([valType.lowercaseString isEqualToString:@"string"]) {
            where = [where stringByAppendingFormat:@"%@='%@' and ", field, [dictionary valueForKey:key]];
        } else {
            where = [where stringByAppendingFormat:@"%@=%@ and ", field, [dictionary valueForKey:key]];
        }
    }
    return [where substringToIndex:where.length-5];
}

@end
