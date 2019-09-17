# CPLoading
实现了加载视图。

### 集成方法
   1. 将CPLoading文件夹拖入项目，引入头文件 
   > #import "CPSpotLoadView.h"

### 使用
  ```
  // 直接放在控制器上
  [self.view showLoading];
  // 放在 window 上
  [CPSpotLoadView showLoadView];
  
  UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 100)];
  [self.view addSubview:view];
  // 放在具体视图上
  [view showLoading];
  ```
