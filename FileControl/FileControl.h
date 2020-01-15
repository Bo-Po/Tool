//
//  FileControl.h
//  TianjinTrip
//
//  Created by Mac on 2017/10/24.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserInfoFileName @"user-info.plist"
#define kHeaderImageName @"user-header-img.png"
#define kPoiHistory @"poi-History.plist"
#define kPoiHomeAddress @"poi-Home-Address.plist"
#define kPoiCompany @"poi-Company.plist"

@interface FileControl : NSObject

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

/// 根据网络视频地址获取某一帧图片
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
/// 获取本地视频的缩略图
+(UIImage *)getImage:(NSString *)videoURL;
/// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;

+ (NSString *)idfaString;


    /// 缓存大小
+(NSString *)getCachesSize;
    /// 清除缓存
+ (void)removeCache:(UIView *)view back:(CPClickButton)back;
@end
