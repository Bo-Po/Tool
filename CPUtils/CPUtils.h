//
//  CPUtils.h
//  TianjinTripDriver
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPUtils : NSObject

+ (BOOL)isNil:(NSObject*)obj;
+ (BOOL)isBlankString:(NSString*)string;
+ (NSString *)toString:(NSString *)string;
/// 解析视图
+ (NSString *)digView:(UIView *)view;
/// 属性字符串
+ (NSAttributedString *)attributedStringWithStrings:(NSArray<NSString *> *)strings fonts:(NSArray<UIFont *> *)fonts colors:(NSArray<UIColor *> *)colors;

///  打电话
+ (void)callTel:(NSString *)tel toView:(UIView *)view;

@end

#define kUser @"user"
#define kUser_info_id @"userId"
#define kUser_info_header @"userPicture"
#define kUser_info_name @"userName"
#define kUser_info_nickName @"nickName"
#define kUser_info_sex @"sex"
#define kUser_info_phone @"phoneNumber"
#define kUser_info_birth @"birth"
#define kUser_isLogin @"user-isLogin"
#define kUser_uuid @"user-uuid"
#define kDriver_Id @"driver-id"


#define kSetter_traffic @"setter_traffic"

#define kApp_First_Start @"app-First-Start"

@interface CPUtils(user)
/// 设置首次启动状态
+ (BOOL)setIsFirstStart:(BOOL)firstStart;
/// 取得首次启动状态
+ (BOOL)getIsFirstStart;
/// 设置用户信息
+ (BOOL)setUserInfo:(NSDictionary *)uerInfo;
/// 取得用户信息
+ (NSDictionary *)getUserInfo;
/// 设置登录状态
+ (BOOL)setIsLogin:(BOOL)isLogin;
/// 取得登录状态
+ (BOOL)getIsLogin;
/// 设置用户uuid
+ (BOOL)setUuid:(NSString *)uuid;
/// 取得用户uuid
+ (NSString *)getUuid;
/// 设置司机ID
+ (BOOL)setDriverId:(NSString *)driverId;
/// 取得司机ID
+ (NSString *)getDriverId;
/// 设置路况的开关
+ (BOOL)setTraffic:(BOOL)traffic;
/// 取得路况的开关
+ (BOOL)getTraffic;
@end

@interface CPUtils(filePath)
// 取得本地文件的全路径
+ (NSString *)getLocalFilePath:(NSString*)fileName;
// 取得本地文件名
+ (NSArray *)getLocalFile;
// 取得缓存文件的全路径
+ (NSString *)getFilePath:(NSString*)fileName;
// 取得缓存文件名
+ (NSArray *)getCachesFileName;
// 保存图片至Caches
+ (BOOL)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
/// 获取文件MD5码
+ (NSString*)getFileMD5WithPath:(NSString*)path;
// 删除文件
+ (void)deleteFileWithPath:(NSString *)path;

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath;
@end


@interface CPUtils(image)
/// 获取视频第一帧图片
+ (UIImage *)getImage:(NSURL *)videoURL;
/// 改变图片大小
+ (UIImage *)newImageFromImage:(UIImage *)image ToSize:(CGSize)size;
@end


@interface CPUtils(time)
/// date -- formatter --> string
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;
/// string -- formatter --> date
+ (NSDate *)dateFromString:(NSString *)string formatter:(NSString *)formatter;
/// date -- "yyyyMMdd hh:mm:ss" --> string
+ (NSString *)stringFromDate:(NSDate *)date;
/// date -- "yyyyMMdd" --> string
+ (NSString *)stringDayFromDate:(NSDate *)date;
/// date -- "hh:mm:ss" --> string
+ (NSString *)stringTimeFromDate:(NSDate *)date;
/// date -- "hh:mm" --> string
+ (NSString *)stringHhmmDayFromDate:(NSDate *)date;

/// string -- "yyyyMMdd hh:mm:ss" --> date
+ (NSDate *)dateFromString:(NSString *)string;
/// day -- "yyyyMMdd" --> date
+ (NSDate *)dateFromDay:(NSString *)day;

/// 时间戳转date
+ (NSDate *)sectionDateByCreateTime:(NSTimeInterval)interval;
/// 时间戳转字符串 --> "yyyyMMdd hh:mm:ss"
+ (NSString *)sectionStrByCreateTime:(NSTimeInterval)interval;
/// 时间戳转字符串
+ (NSString *)sectionStrByCreateTime:(NSTimeInterval)interval formatter:(NSString *)formatter;
/// date转时间戳
+ (NSTimeInterval)timeStampWithDate:(NSDate *)date;


/// 开始到结束的时间差
+ (NSTimeInterval)dateTimeDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime;
/// 年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
+ (NSDateComponents *)dateComponentsDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime;

+ (NSDate *)dateWithComponents:(NSDateComponents *)dateComponents fromTime:(NSDate *)time;

@end

