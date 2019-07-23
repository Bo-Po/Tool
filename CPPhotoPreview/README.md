# CPPhotoPreview
实现了查看大图（视频）的视图。

### 集成方法
   1. 将CPPhotoPreview文件夹拖入项目，引入头文件 
   > #import "CPPhotoPreview.h"

### 使用
  ```
  NSArray *arr = @[
  @"http://5b0988e595225.cdn.sohucs.com/images/20180502/0fc22f6e10b14570975a8b8d3fafa30b.jpeg",
  @"http://www.mms591.com/www.mms591.com-photo/2017032921/1-1F329213148_480x800.jpg",
  ((UIImageView *)tap.view).image,
  @"http://wx2.sinaimg.cn/large/006prIg7gy1fr41snenbaj30rs0fmkic.jpg"];
  // 单视频大屏显示
  //    CPPhotoPreview *preview = [[CPPhotoPreview alloc] initWithVideo:@"https://ksv-video-publish.cdn.bcebos.com/012c693b82adf1f6a4ed849d2bee004e5f804751.mp4?auth_key=1560933117-0-0-05c8ddd0724910f8ca742dc7b309314f" ImageView:tap.view];
  // 单图大图预览
  //    CPPhotoPreview *preview = [[CPPhotoPreview alloc] initWithImageView:tap.view];
  // 多图大图显示
  CPPhotoPreview *preview = [[CPPhotoPreview alloc] initWithImages:arr selectedImageView:tap.view atIndex:2];
  // 是否缩放
  preview.isZoom = NO;
  [self presentViewController:preview animated:NO completion:nil];
  ```
