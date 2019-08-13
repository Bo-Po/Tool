# CPNoticeLabel
实现公告竖直方向上的滚动显示。

### 集成方法
   1. 将CPNoticeLabel文件夹拖入项目，引入头文件 
   > #import "CPNoticeLabel.h"

### 使用
  ```
  CPNoticeLabel *notice = [[CPNoticeLabel alloc] initWithFrame:CGRectMake(20, 160, 280, 44) titles:@[@"ahahkshfa", @"171974917", @"阿卡换卡换多少"]];
  // 设置滚动时间
  notice.duration = .25;
  [self.view addSubview:notice];
  ```
