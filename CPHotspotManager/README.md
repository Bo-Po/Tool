# CPHotspotManager
实现查看设备是否开启热点并有其他设备连接。

### 集成方法
   1. 将CPHotspotManager文件夹拖入项目，引入头文件 
   > #import "CPHotspotManager.h"

### 使用
  ```
  /// 获取所有相关IP信息
  + (NSDictionary *)getIPAddresses;
  /// 获取设备当前网络IP地址
  + (NSString *)getIPAddress:(BOOL)preferIPv4;
  /// 判断热点是否开启
  + (BOOL)flagWithOpenHotSpot;
  ```
