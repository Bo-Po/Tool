# FileControl
异常捕捉。

### 集成方法
   1. 将FileControl文件夹拖入项目，引入头文件 
   > #import "FileControl.h"

### 使用
  ```
  /// 我们可以将应用程序的数据文件保存在该目录下。不过这些数据类型仅限于不可再生的数据，可再生的数据文件应该存放在Library/Cache目录下
  + (NSString *)getDocumentsPath;
  + (NSString *)getDocumentsFilePath:(NSString *)fileName;
  
  /// 这个目录就用于保存那些可再生的文件，比如网络请求的数据。鉴于此，应用程序通常还需要负责删除这些文件。
  + (NSString *)getCachesPath;
  + (NSString *)getCachesFilePath:(NSString *)fileName;
  
  
  /// 保存图片
  + (BOOL)saveImage:(UIImage *)image fileName:(NSString *)fileName isDocuments:(BOOL)isDocuments;
  /// 删除文件
  + (BOOL)deleteFileWithName:(NSString *)fileName isDocuments:(BOOL)isDocuments;
  /// 保存文件
  + (BOOL)saveFile:(NSData *)file name:(NSString *)fileName folder:(NSString *)folder isDocuments:(BOOL)isDocuments;
  
  /// 获取设备唯一标识符
  + (NSString *)idfaString;
  ```
