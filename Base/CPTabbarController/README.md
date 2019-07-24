# CPTabbarController
自定义TabbarController，可设置随意一个tabItem为大图，方便设置阴影，具体看下方使用。

# 图例
    ![image](https://github.com/Bo-Po/Tool/tree/master/Base/CPTabbarController/tabbar.png)
### 集成方法
   1. 将CPTabbarController文件夹拖入项目，引入头文件 
   > #import "CPTabbarController.h"

### 使用
``` 
    // 设置ViewController数组
    NSMutableArray *ctrlList = [NSMutableArray arrayWithArray:@[webNav,messageNav,contactNav,setNav]];
    // 初始化
    CPTabbarController *tabbar = [[CPTabbarController alloc] init];
    // 设置大图标与突出tabbar高度的偏移
    [tabbar setBigItem:1 offset:20.];
    // 设置隐藏顶部黑色线条
    tabbar.hidenTopLine = YES;
    // 设置阴影
    tabbar.showShadow = YES;
    tabbar.viewControllers = ctrlList;
    self.window.rootViewController = tabbar;
    // 代理没搞太明白
    tabbar.delegate = self;
  ```
