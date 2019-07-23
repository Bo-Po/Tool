# Base
BaseModel：为实例的基础Model，方便dictionary与实例互转，实现递归转换。
BaseViewController：为ViewController的基础控制器。

### 集成方法
   1. 将Base文件夹拖入项目，引入头文件 
   > #import "BaseModel.h"
   > #import "BaseViewController.h"

### 使用
``` 
    // 实现了NSCoding协议
    @interface BaseModel : NSObject<NSCoding>

    /// 实例与字典互转
    + (instancetype)objcetWithDictionary:(NSDictionary *)dict;
    - (NSDictionary *)dictionary;

    /// 属性与key的对照关系
    - (NSDictionary *)propertyFormKey;

    /// 获取实例的所有属性
    - (NSArray<CPProperty *> *)getPropertyList;

    /// 存储到本地UserDefaults
    +(void)setModel:(id)obj forKey:(NSString *)key;
    +(id)modelForKey:(NSString *)key;

    @end
    
    // 继承BaseModel的实例
    @interface CPModel : BaseModel
    @property(nonatomic,copy) NSArray<CPModel *> *arr;
    @end
    
    CPModel *M = [CPModel objcetWithDictionary:@{@"arr": @[@{@"arr":@[]},@{}]}];
    
  ```
  ```
  // 继承BaseModel的实例
  @interface CPModel : BaseModel
  @property(nonatomic,copy) NSArray<NSString *> *arr;
  @end
  
  CPModel *model = [[CPModel alloc] init];
  model.arr = @[@"好",@"个屁",@"👃"];
  CPModel *model1 = [[CPModel alloc] init];
  model1.arr = @[@"那",@"不好",@"？"];
  model.model = model1;
  // 存入UserDefaults；
  [CPModel setModel:@[model, model1] forKey:@"CPModel"];
  // 从UserDefaults取出
  CPModel *obj = [CPModel modelForKey:@"CPModel"];
  ```
