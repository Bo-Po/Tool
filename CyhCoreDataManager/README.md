# CyhCoreDataManager
coredata 集成工具

### 集成方法
   1. 将CyhCoreDataManager文件夹拖入项目，引入头文件 
   > #import "cyhCoredtaDB.h"

### 使用
  ```
  - (void)viewDidLoad {
  [super viewDidLoad];
  
  // 创建db文件
  [[cyhCoredtaDB coredataDBShare] createCoredataDB:@"Model"];
  }
  ```
  ```
  //   3.保存插入的数据
  [cyhCoredtaDB inserDataWith_CoredatamodelClass:[Student class] CoredataModel:^(Student * model) {
  
  model.age = arc4random()%20;
  model.name = [NSString stringWithFormat:@"Mr-%d",arc4random()%100];
  //        model.subordinateSchool = school;
  [self showTipsTitle:@"数据插入到数据库成功" determine:@"知道了" result:nil];
  } Error:^(NSError *error) {
  [self showTipsTitle:[NSString stringWithFormat:@"数据插入到数据库失败, %@",error] determine:@"知道了" result:nil];
  }];
  ```
