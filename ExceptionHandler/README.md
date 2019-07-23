# ExceptionHandler
异常捕捉。

### 集成方法
   1. 将ExceptionHandler文件夹拖入项目，引入头文件 
   > #import "ExceptionHandler.h"

### 使用
  ```
  // 初始化（注意不要被第三方覆盖掉）
  InstallUncaughtExceptionHandler();
  ```
