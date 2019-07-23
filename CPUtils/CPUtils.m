//
//  CPUtils.m
//  TianjinTripDriver
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CPUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
//#import <CommonCrypto/CommonDigest.h>


#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation CPUtils

#pragma mark-
#pragma mark-＃＃＃＃＃＃＃＃＃＃＃字符串＃＃＃＃＃＃＃＃＃＃＃
+ (BOOL)isNil:(NSObject*)obj {
    if (obj == nil || obj == NULL) {
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isBlankString:(NSString*)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSValue class]]) {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (NSString*)toString:(NSString*)string {
    if ([string isKindOfClass:[NSNumber class]]) {
        string = [NSString stringWithFormat:@"%@",string];
    }
    if ([self isBlankString:string]) {
        return @"";
    }
    return string;
}

+ (NSAttributedString *)attributedStringWithStrings:(NSArray<NSString *> *)strings fonts:(NSArray<UIFont *> *)fonts colors:(NSArray<UIColor *> *)colors {
    __block NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@""];
    if (strings && strings.count > 0) {
        [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableAttributedString * otherPart = [[NSMutableAttributedString alloc] initWithString:obj];
            NSDictionary * otherAttributes = @{NSFontAttributeName:fonts[idx],NSForegroundColorAttributeName:colors[idx]};
            [otherPart setAttributes:otherAttributes range:NSMakeRange(0,otherPart.length)];
            [firstPart appendAttributedString:otherPart];
        }];
    }
    return firstPart;
}

/**
 * 返回传入veiw的所有层级结构
 *
 * @param view 需要获取层级结构的view
 *
 * @return 字符串
 */
+ (NSString *)digView:(UIView *)view {
    if ([view isKindOfClass:[UITableViewCell class]]) return @"";
    // 1.初始化
    NSMutableString *xml = [NSMutableString string];
    
    // 2.标签开头
    [xml appendFormat:@"<%@ frame=\"%@\"", view.class, NSStringFromCGRect(view.frame)];
    if (!CGPointEqualToPoint(view.bounds.origin, CGPointZero)) {
        [xml appendFormat:@" bounds=\"%@\"", NSStringFromCGRect(view.bounds)];
    }
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)view;
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, scroll.contentInset)) {
            [xml appendFormat:@" contentInset=\"%@\"", NSStringFromUIEdgeInsets(scroll.contentInset)];
        }
    }
    
    // 3.判断是否要结束
    if (view.subviews.count == 0) {
        [xml appendString:@" />"];
        return xml;
    } else {
        [xml appendString:@">"];
    }
    
    // 4.遍历所有的子控件
    for (UIView *child in view.subviews) {
        NSString *childXml = [self digView:child];
        [xml appendString:childXml];
    }
    
    // 5.标签结尾
    [xml appendFormat:@"<!--%@-->", view.class];
    
    return xml;
}

+ (void)callTel:(NSString *)tel toView:(UIView *)view {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [view addSubview:callWebview];
}

@end

@implementation CPUtils (user)
// 设置首次启动状态
+ (BOOL)setIsFirstStart:(BOOL)firstStart {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:firstStart forKey:kApp_First_Start];
    return [defaults synchronize];
}
// 取得首次启动状态
+ (BOOL)getIsFirstStart {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kApp_First_Start];
}
/// 设置用户信息
+ (BOOL)setUserInfo:(NSDictionary *)uerInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:uerInfo forKey:kUser];
    return [defaults synchronize];
}
/// 取得用户信息
+ (NSDictionary *)getUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:kUser];
}
// 设置登录状态
+ (BOOL)setIsLogin:(BOOL)isLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isLogin forKey:kUser_isLogin];
    return [defaults synchronize];
}
// 取得登录状态
+ (BOOL)getIsLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kUser_isLogin];
}
// 设置用户uuid
+ (BOOL)setUuid:(NSString *)uuid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:uuid forKey:kUser_uuid];
    return [defaults synchronize];
}
// 取得用户uuid
+ (NSString *)getUuid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:kUser_uuid];
}
// 设置司机ID
+ (BOOL)setDriverId:(NSString *)driverId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:driverId forKey:kDriver_Id];
    return [defaults synchronize];
}
// 取得司机ID
+ (NSString *)getDriverId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:kDriver_Id];
}
// 设置路况的开关
+ (BOOL)setTraffic:(BOOL)traffic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:traffic forKey:kSetter_traffic];
    return [defaults synchronize];
}
// 取得路况的开关
+ (BOOL)getTraffic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kSetter_traffic];
}

@end

@implementation CPUtils (filePath)

#pragma mark-＃＃＃＃＃＃＃＃＃＃＃文件操作＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃
// 取得本地文件的全路径
+ (NSString *)getLocalFilePath:(NSString*)fileName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingPathComponent:fileName];
}
// 取得本地文件名
+ (NSArray *)getLocalFile {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error = nil;
    //查看某个路径下的文件和目录
    NSArray * array = [fm contentsOfDirectoryAtPath:path error:&error];
    if(error != nil){
        NSLog(@"%@", error);
        exit(-1);
    }
    //如果读取正常，该方法，会创建一个数组对象--数组装文件或目录的名字--并返回数组的地址。
    NSLog(@"%@", array);
    return array;
}

// 取得缓存文件的全路径
+ (NSString *)getFilePath:(NSString*)fileName {
    //    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:fileName];
}

// 取得缓存文件名
+ (NSArray *)getCachesFileName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error = nil;
    //查看某个路径下的文件和目录
    NSArray * array = [fm contentsOfDirectoryAtPath:path error:&error];
    if(error != nil){
        NSLog(@"%@", error);
        exit(-1);
    }
    //如果读取正常，该方法，会创建一个数组对象--数组装文件或目录的名字--并返回数组的地址。
    NSLog(@"%@", array);
    return array;
}

// 保存图片至Caches
+ (BOOL)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    //    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    return [imageData writeToFile:fullPath atomically:NO];
}
// 获取MD5码
+ (NSString*)getFileMD5WithPath:(NSString*)path {

    return nil;//(__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);

}
//
//CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
//    
//    // Declare needed variables
//    
//    CFStringRef result = NULL;
    
//    CFReadStreamRef readStream = NULL;
//    
//    // Get the file URL
//    
//    CFURLRef fileURL =
//    
//    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
//                                  
//                                  (CFStringRef)filePath,
//                                  
//                                  kCFURLPOSIXPathStyle,
//                                  
//                                  (Boolean)false);
//    
//    if (!fileURL) goto done;
//    
//    // Create and open the read stream
//    
//    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
//                                            
//                                            (CFURLRef)fileURL);
//    
//    if (!readStream) goto done;
//    
//    bool didSucceed = (bool)CFReadStreamOpen(readStream);
//    
//    if (!didSucceed) goto done;
//    
//    // Initialize the hash object
//    
//    CC_MD5_CTX hashObject;
//    
//    CC_MD5_Init(&hashObject);
//    
//    // Make sure chunkSizeForReadingData is valid
//    
//    if (!chunkSizeForReadingData) {
//        
//        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
//        
//    }
//    
//    // Feed the data to the hash object
//    
//    bool hasMoreData = true;
//    
//    while (hasMoreData) {
//        
//        uint8_t buffer[chunkSizeForReadingData];
//        
//        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
//        
//        if (readBytesCount == -1) break;
//        
//        if (readBytesCount == 0) {
//            
//            hasMoreData = false;
//            
//            continue;
//            
//        }
//        
//        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
//        
//    }
//    
//    // Check if the read operation succeeded
//    
//    didSucceed = !hasMoreData;
//    
//    // Compute the hash digest
//    
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    
//    CC_MD5_Final(digest, &hashObject);
//    
//    // Abort if the read operation failed
//    
//    if (!didSucceed) goto done;
//    
//    // Compute the string result
//    
//    char hash[2 * sizeof(digest) + 1];
//    
//    for (size_t i = 0; i < sizeof(digest); ++i) {
//        
//        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
//        
//    }
//    
//    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
//    
//    
//    
//done:
//    
//    if (readStream) {
//        
//        CFReadStreamClose(readStream);
//        
//        CFRelease(readStream);
//        
//    }
//    
//    if (fileURL) {
//        
//        CFRelease(fileURL);
//        
//    }
    
//    return result;
//
//}
// 删除单个文件
+ (void)deleteFileWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"删除%@",path);
    BOOL blHave=[fileManager fileExistsAtPath:path];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}
//单个文件的大小

+ (long long)fileSizeAtPath:(NSString*)filePath {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.;
    }
    return 0;
}

- (void)ClearMovieFromDoucments{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        NSLog(@"%@",filename);
        if ([filename isEqualToString:@"tmp.PNG"]) {
            NSLog(@"删除%@",filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            continue;
        }
        if ([[[filename pathExtension] lowercaseString] isEqualToString:@"mp4"]||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"mov"]||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"png"]) {
            NSLog(@"删除%@",filename);
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

@end


@implementation CPUtils(image)
// 获取视频第一帧图片
+ (UIImage *)getImage:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL/*[NSURL fileURLWithPath:videoURL]*/ options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
    
}
+ (UIImage *)newImageFromImage:(UIImage *)image ToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


@end


@implementation CPUtils(time)
// date -- formatter --> string
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat = formatter;//指定转date得日期格式化形式
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter stringFromDate:date];
}

// string -- formatter --> date
+ (NSDate *)dateFromString:(NSString *)string formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat = formatter;//指定转date得日期格式化形式
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter dateFromString:string];
}

// date ---> string
+ (NSString *)stringFromDate:(NSDate *)date {
    return [self stringFromDate:date formatter:@"yyyyMMdd HH:mm:ss"];
}
// date ---> day
+ (NSString *)stringDayFromDate:(NSDate *)date {
    NSString *str = [self stringFromDate:date];
    
    return [[str componentsSeparatedByString:@" "] firstObject];
}
// date ---> time
+ (NSString *)stringTimeFromDate:(NSDate *)date {
    NSString *str = [self stringFromDate:date];
    
    return [[str componentsSeparatedByString:@" "] lastObject];
}
+ (NSString *)stringHhmmDayFromDate:(NSDate *)date {
    NSString *str = [self stringFromDate:date];
    NSArray *arr = [str componentsSeparatedByString:@" "];
    NSString *time;
    if (arr && arr.count) {
        time = [arr lastObject];
    }
    time = [time substringToIndex:5];
    return time;
}

// string ---> date
+ (NSDate *)dateFromString:(NSString *)string {
    return [self dateFromString:string formatter:@"yyyyMMdd HH:mm:ss"];
}
// day ---> date
+ (NSDate *)dateFromDay:(NSString *)day {
    return [self dateFromString:day formatter:@"yyyyMMdd"];
}

// 时间戳转date
+ (NSDate *)sectionDateByCreateTime:(NSTimeInterval)interval {
    return [NSDate dateWithTimeIntervalSince1970:interval];
}
// 时间戳转字符串
+ (NSString *)sectionStrByCreateTime:(NSTimeInterval)interval {
    return [self sectionStrByCreateTime:interval formatter:@"yyyyMMdd HH:mm:ss"];
}
// 时间戳转字符串
+ (NSString *)sectionStrByCreateTime:(NSTimeInterval)interval formatter:(NSString *)formatter {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self stringFromDate:date formatter:formatter];
}

// date转时间戳
+ (NSTimeInterval)timeStampWithDate:(NSDate *)date {
    NSTimeInterval timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue]*1000;
    return timeSp;
}

// 开始到结束的时间差
+ (NSTimeInterval)dateTimeDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime {
    NSTimeInterval start = [startTime timeIntervalSince1970]*1;
    NSTimeInterval end = [endTime timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    return value;
}


// 年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
+ (NSDateComponents *)dateComponentsDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime {// 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:startTime toDate:endTime options:0];
    return dateCom;
}

+ (NSDate *)dateWithComponents:(NSDateComponents *)dateComponents fromTime:(NSDate *)time {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:time];
    dateCom.year += dateComponents.year;
    dateCom.month += dateComponents.month;
    dateCom.day += dateComponents.day;
    dateCom.hour += dateComponents.hour;
    dateCom.minute += dateComponents.minute;
    dateCom.second += dateComponents.second;
    NSDate *date = [calendar dateFromComponents:dateCom];
    return date;
}

@end
