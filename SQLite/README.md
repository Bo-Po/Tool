# SQLite
基于BaseModel集成的本地数据库存储。

### 集成方法
   1. 将SQLite文件夹拖入项目，引入头文件 
   > #import "BaseModel+SQLite.h"

### 使用
  ```
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
  ```
