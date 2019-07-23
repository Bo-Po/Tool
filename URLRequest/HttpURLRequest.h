//
//  HttpURLRequest.h
//  TranslateDemoIOS
//
//  Created by NTTData on 16/3/28.
//  Copyright © 2016年 NTTData. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PARA_KEY_Q @"key_query"
#define PARA_KEY_FROM @"key_from"
#define PARA_KEY_TO @"key_to"


#define kApi_Login @"/app/member/login.api"     // 登陆
#define kApi_Sendcode @"/app/member/sendcode.api"   // 获取验证码
#define kApi_Register @"/app/member/regist.api" // 注册
//#define kApi_Sendcode_Forgetpwd @"member/forgetpwd.api"   // 忘记密码验证码
#define kApi_Change_Password @"/app/member/updatepwd.api" // 修改密码

#define kApi_Upload_Image @"/app/member/uploadimg.api" // 图片上传
#define kApi_Get_Driver_Info @"/app/orderlist/getdriver.api" // 获取司机信息
#define kApi_Updata_User_Info @"/app/member/update.api" // 更新乘客信息
#define kApi_Get_Driver_Data @"/app/orderlist/driverordersum.api" // 获取司机 （接单数、赚钱） {driverId,orderStatus:5,dayFlag} 1、是当天的 2、是全部的
#define kApi_Driver_Cartype @"/app/order/updatelocationsts.api"  // 更新车辆状态


#define kApi_Get_Order_List @"/app/orderlist/queryorderlist.api" // 拉取订单列表
#define kApi_Get_Order_Detail @"/app/orderlist/orderdetail.api" // 拉取订单详情
#define kApi_Get_Order_track @"/app/orderlist/locationstrack.api" // 拉取订单路线point

#define kApi_Get_Unusr_Car @"/app/order/nearest.api" // 获取周围可用车辆
#define kApi_Send_Order @"/app/orderlist/memberorder.api" // 发送订单
#define kApi_Get_Pay_Order @"/app/orderlist/payorder.api" // 获取订单金额 参数 orderId
#define kApi_Get_Order_Pay_Detail @"/app/orderlist/paydetail.api" // 获取金额明细 orderId

#define kApi_Get_Pay_Charge @"/app/pay/charge.api" // 获取charge
#define kApi_Order_evaluate @"/app/evaluate/evaluate.api" // 评价
#define kApi_Get_Order_evaluate_Info @"/app/evaluate/queryevaluate.api" // 获取评价信息
#define kApi_Cancel_Order @"/app/orderlist/membercancleorder.api" // 取消订单


#define kApi_Msg_List @"/app/msg/msglist.api" // 消息列表
#define kApi_Msg_Detail @"/app/msg/msgdetail.api" // 消息详情
#define kApi_Queryinvoicelist @"/app/orderlist/queryinvoicelist.api" // 可开票订单
#define kApi_Insertinvoice @"/app/invoice/insertinvoice.api" // 开票申请
#define kApi_Coupon_List @"/app/discount/querydiscount.api" // 消息列表


#define kServicePort_8001 @":8011"
#define kServicePort_8011 @":8021"
#define kServicePort_8021 @":8031"
#define kServicePort_8041 @":8051"
#define kServiceHost @"http://47.104.7.56"
#define kImgServiceHost @"http://47.104.7.56/"
#define kServiceUrl(host, port, api) [NSString stringWithFormat:@"%@%@%@",host, port, api]
// @"172.16.4.248"
// @"172.16.4.25"
// 47.104.7.56

typedef void(^CallbackBlock)(NSDictionary *dic, NSError *error);
typedef void(^Callback)(id source, NSError * error);

@interface HttpURLRequest : NSObject
// 直接网络请求
- (void)requestGetWithURL:(NSString *)URLStr parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock;
- (void)requestPostWithURL:(NSString *)URLStr isFileUpdata:(BOOL)isUpdata parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock;
- (void)requestPutWithURL:(NSString *)URLStr parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock;
- (void)requestDeleteWithURL:(NSString *)URLStr parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock;
- (void)requestUploadWithURL:(NSString *)URLStr parameter:(NSDictionary *)para image:(UIImage *)image port:(NSString *)port callbackBlock:(Callback)callbackBlock;

//// 发送cmd到ac
//+ (void)sendCmdToServiceWithPara:(ACMsg *)Para callbackBlock:(Callback)callbackBlock;
// // 匿名
//+ (void)sendCmdToServiceWithAnonymousPara:(ACMsg *)Para callbackBlock:(Callback)callbackBlock;

@end
