# Base
CPProgressBar：简单的进度条、暂时还未加入拖动控制的进度。

### 集成方法
   1. 将CPProgressBar文件夹拖入项目，引入头文件 
   > #import "CPProgressBar.h"
   
### 介绍
```
    // 设置进度
    @property (nonatomic, assign) CGFloat progress;
    // 设置 颜色与进度
    - (instancetype)setDefaultColor:(UIColor *)defaultColor tintColor:(UIColor *)tintColor progress:(CGFloat)progress;
    
    #define progressStart 5         // 进度条开始的位置（相对父视图）
    #define progressWidth 5         // 显示的进度条的粗细
    #define controlSiza 10          // 控制柄大小
    #define controlOffset 2         // 控制柄外环粗细
    
```

### 使用
  ```
  // 创建控件
  __block CPProgressBar *progress = [[CPProgressBar alloc] initWithFrame:CGRectMake(20, 80, SCR_W-40, 40)];
  // 设置进度 随时可以改变
  progress.progress = arc4random()%11/10.;
  // 添加到要显示的位置
  [self.view addSubview:progress];
  ```
