//
//  CPHotspotManager.h
//  Linkdood
//
//  Created by mac on 2019/4/9.
//  Copyright © 2019年 xiong qing. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <Foundation/Foundation.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

NS_ASSUME_NONNULL_BEGIN

@interface CPHotspotManager : NSObject

/// 获取所有相关IP信息
+ (NSDictionary *)getIPAddresses;
/// 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
/// 判断热点是否开启
+ (BOOL)flagWithOpenHotSpot;

@end

NS_ASSUME_NONNULL_END
