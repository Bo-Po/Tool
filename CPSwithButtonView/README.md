# CPSwithButtonView
简单易懂的多按钮选择器

### 集成方法
   1. 将CPSwithButtonView文件夹拖入项目，引入头文件 
   > #import "CPSwithButtonView.h"

### 使用
``` 
    // 创建空间（推荐高度 44.）
    _swithButton = [[CPSwithButtonView alloc] initWithFrame:CGRectMake(0, 64, Size_ScreenWidth, 44.)];
    // 设置是否可滚动
    //    _swithButton.type = CPSwithButtonTypeScroll;
    // 设置按钮标题、字号、以及颜色
    [_swithButton createSwithButton:@[@"好(hao)", @"的(de、di)", @"你(ni)" ,@"想(xiang)", @"怎(zen)", @"么(me)", @"样(yang)"] font:kFont_System_15 defaultColor:kColor_btn_gary_title selectedColor:kColor_btn_blark_title];
    // 设置选择回调
    _swithButton.didTappedButton = ^(CPSwithButtonView *view, NSInteger idx) {
    Code_Log(@"idx is %ld", idx);
    };
    [self.view addSubview:_swithButton];
  ```
