//
//  Constant.h
//  TianjinTrip
//
//  Created by Mac on 2017/10/20.
//  Copyright © 2017年 Mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef Ration_h
#define Ration_h


#define kIsShowLog NO


#endif /* Ration_h */


static NSString *const customerService = @"4001018341"; // 客服电话

static NSString *const billingProposal = @"尊敬的乘客您好，如您继续报销，我们推荐您使用电子发票。根据国家的相关规定，电子发票的法律效力、基本用途、基本使用规定等与国家税务机关监制增值税普通发票相同。";

static NSString *const BMapKey = @"CuqgeOI2eTNFWfwmchwiVvKAhGgmF2DT";  // 百度地图key
static NSString *const IFlyAppId = @"5a3a0821";  // 讯飞appid


static NSString *const serviceHost = @"47.104.8.105";    // MQTT host
static UInt32    const servicePort = 58919;         // MQTT port
static NSString *const serviceUserName = @"mqtt_tjtrek_user";       // MQTT 用户名
static NSString *const servicePassword = @"P@ssw0rd";       // MQTT 密码
static CGFloat    const MqttReconnectionDuration = 0.5; //  mqtt 重连延迟时间


static NSString *const noLogin = @"没有登录";       // 未登录  判断标示


static NSInteger    const bespeakLimitTime = 30*60; // 约单限制时间
static CGFloat    const promptDuration = 2.5; // 提示显示时长
static CGFloat    const pageReplaceDuration = 0.; //  页面替换的延迟


static NSInteger    const listPageSize = 15; //  列表页每页元素数



#ifdef DEBUG
static CGFloat    const locationUpdataMinDistance = 5.; //  位置上报最短移动距离
static CGFloat    const directionUpdataMinHeading = 15.; //  方向更新的最小变动角度
static NSInteger    const requestTimeout = 10;
#else
static CGFloat    const locationUpdataMinDistance = 5.; //  位置上报最短移动距离
static CGFloat    const directionUpdataMinHeading = 15.; //  方向更新的最小变动角度
static NSInteger    const requestTimeout = 10;
#endif



// 通知
static NSString *const MQTTSessionLinkSuccess = @"MQTTSessionLinkSuccess"; //  mqtt新消息
static NSString *const MQTTSessionNewMessage = @"MQTTSessionNewMessage"; //  mqtt新消息
static NSString *const MQTTSessionVehicleInfo = @"MQTTSessionVehicleInfo"; //  mqtt车辆消息
static NSString *const MQTTSessionAssignOrder = @"MQTTSessionAssignOrder"; //  mqtt订单通知
static NSString *const NetworkChangedNotification = @"NetworkChangedNotification"; //  网络变化
static NSString *const MQTTSessionDiscount = @"MQTTSessionDiscountNotification"; //  优惠券


