//
//  FileControl.m
//  TianjinTrip
//
//  Created by Mac on 2017/10/24.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "FileControl.h"
#import <AdSupport/AdSupport.h>
#import <AVFoundation/AVFoundation.h>

@implementation FileControl

+ (NSString *)getDocumentsPath {
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString*path=[paths objectAtIndex:0];
    return path;
}
+ (NSString *)getDocumentsFilePath:(NSString *)fileName {
    NSMutableArray *paths = [fileName componentsSeparatedByString:@"/"].mutableCopy;
    NSString *name = [paths lastObject];
    [paths removeObjectAtIndex:paths.count-1];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *zuihouPath = [self getDocumentsPath];
    for (NSString *path in paths) {
        zuihouPath = [zuihouPath stringByAppendingPathComponent:path];
        if (![fileManager fileExistsAtPath:zuihouPath]) {
            BOOL blCreateFolder = [fileManager createDirectoryAtPath:zuihouPath withIntermediateDirectories:NO attributes:nil error:NULL];
            if (blCreateFolder) {
                NSLog(@" folder success");
            }else {
                return nil;
                NSLog(@" folder fial");
            }
        }
    }
    return [zuihouPath stringByAppendingPathComponent:name];
}


+ (NSString *)getCachesPath {
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    
    NSString*path=[paths objectAtIndex:0];
    return path;
}
+ (NSString *)getCachesFilePath:(NSString *)fileName {
    NSMutableArray *paths = [fileName componentsSeparatedByString:@"/"].mutableCopy;
    NSString *name = [paths lastObject];
    [paths removeObjectAtIndex:paths.count-1];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *zuihouPath = [self getCachesPath];
    for (NSString *path in paths) {
        zuihouPath = [zuihouPath stringByAppendingPathComponent:path];
        if (![fileManager fileExistsAtPath:zuihouPath]) {
            BOOL blCreateFolder = [fileManager createDirectoryAtPath:zuihouPath withIntermediateDirectories:NO attributes:nil error:NULL];
            if (blCreateFolder) {
                NSLog(@" folder success");
            }else {
                return nil;
                NSLog(@" folder fial");
            }
        }
    }
    return [zuihouPath stringByAppendingPathComponent:name];
}

// 保存图片
+ (BOOL)saveImage:(UIImage *)image fileName:(NSString *)fileName isDocuments:(BOOL)isDocuments {
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    NSData *data = UIImagePNGRepresentation(image);
    if (data) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    if (isDocuments) {
        return [data writeToFile:[self getDocumentsFilePath:fileName] atomically:YES];
    } else {
        return [data writeToFile:[self getCachesFilePath:fileName] atomically:YES];
    }
}

// 删除文件
+ (BOOL)deleteFileWithName:(NSString *)fileName isDocuments:(BOOL)isDocuments {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    if (isDocuments) {
        ;
        return [[NSFileManager defaultManager] fileExistsAtPath:[self getDocumentsFilePath:fileName]];
    } else {
        return [[NSFileManager defaultManager] fileExistsAtPath:[self getCachesFilePath:fileName]];
    }
    
}

// 保存文件
+ (BOOL)saveFile:(NSData *)file name:(NSString *)fileName folder:(NSString *)folder isDocuments:(BOOL)isDocuments {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderAll,*filePath;
    if (isDocuments) {
        folderAll = [self getDocumentsFilePath:folder];
    } else {
        folderAll = [self getCachesFilePath:folder];
    }
    filePath = [folderAll stringByAppendingPathComponent:fileName];
    
    if (![fileManager fileExistsAtPath:folder]) {
        
        BOOL blCreateFolder= [fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:NULL];
        
        if (blCreateFolder) {
            
            NSLog(@" folder success");
            
        }else {
            
            NSLog(@" folder fial");
            
        }
        
    }else {
        
        NSLog(@" 沙盒文件已经存在");
        
    }
    
    if (![fileManager fileExistsAtPath:filePath]) {
//        BOOL result = [file writeToFile:filePath atomically:YES];
    }
    return [file writeToFile:filePath atomically:YES];
}

// 根据网络视频地址获取某一帧图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    return thumbnailImage;
}
    // 获取本地视频的缩略图
+(UIImage *)getImage:(NSString *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
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
    // 根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)imageURL {
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
        {
        size =  [self getGIFImageSizeWithRequest:request];
        }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
        {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
            {
            size = image.size;
            }
        }
    return size;
}
    //  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
        {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
        }
    return CGSizeZero;
}
    //  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
        {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
        }
    return CGSizeZero;
}
    //  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

+ (NSString *)idfaString {
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

    // 缓存大小
+(NSString *)getCachesSize {
        // 调试
#ifdef DEBUG
    
        // 如果文件夹不存在 or 不是一个文件夹, 那么就抛出一个异常
        // 抛出异常会导致程序闪退, 所以只在调试阶段抛出。发布阶段不要再抛了,--->影响用户体验
    
    BOOL isDirectory = NO;
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        
        NSException *exception = [NSException exceptionWithName:@"文件错误" reason:@"请检查你的文件路径!" userInfo:nil];
        
        [exception raise];
    }
    
        //发布
#else
    
#endif
    
        //1.获取“cachePath”文件夹下面的所有文件
    NSArray *subpathArray= [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSString *filePath = nil;
    long long totalSize = 0;
    
    for (NSString *subpath in subpathArray) {
        
            // 拼接每一个文件的全路径
        filePath =[cachePath stringByAppendingPathComponent:subpath];
        
        BOOL isDirectory = NO;   //是否文件夹，默认不是
        
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];   // 判断文件是否存在
        
            // 文件不存在,是文件夹,是隐藏文件都过滤
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) continue;
        
            // attributesOfItemAtPath 只可以获得文件属性，不可以获得文件夹属性，
            //这个也就是需要遍历文件夹里面每一个文件的原因
        
        long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        
        totalSize += fileSize;
        
    }
    
        // 2.将文件夹大小转换为 M/KB/B
    NSString *totalSizeString = nil;
    
    if (totalSize > 1000 * 1000) {
        
        totalSizeString = [NSString stringWithFormat:@"%.1fM",totalSize / 1000.0f /1000.0f];
        
    } else if (totalSize > 1000) {
        
        totalSizeString = [NSString stringWithFormat:@"%.1fKB",totalSize / 1000.0f ];
        
    } else {
        
        totalSizeString = [NSString stringWithFormat:@"%.1fB",totalSize / 1.0f];
        
    }
    
    return totalSizeString;
    
}

    // 清除缓存
+ (void)removeCache:(UIView *)view back:(CPClickButton)back {
    
        // 1.拿到cachePath路径的下一级目录的子文件夹
        // contentsOfDirectoryAtPath:error:递归
        // subpathsAtPath:不递归
    
    NSArray *subpathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:nil];
    
        // 2.如果数组为空，说明没有缓存或者用户已经清理过，此时直接return
    if (subpathArray.count == 0) {
        [[view getCurrentViewController] showToastWithMessage:@"缓存已清理"];
        if (back) {
            back([NSObject new], 0);
        }
        return ;
    }
    
    NSError *error = nil;
    NSString *filePath = nil;
    BOOL flag = NO;
    
    NSString *size = [self getCachesSize];
    
    for (NSString *subpath in subpathArray) {
        
        filePath = [cachePath stringByAppendingPathComponent:subpath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            
                // 删除子文件夹
            BOOL isRemoveSuccessed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            
            if (isRemoveSuccessed) { // 删除成功
                
                flag = YES;
            }
        }
        
    }
    
    if (NO == flag)
        [[view getCurrentViewController] showToastWithMessage:@"缓存已清理"];
    else
        [[view getCurrentViewController] showToastWithMessage:[NSString stringWithFormat:@"为您腾出%@空间",size]];
    if (back) {
        back([NSObject new], 0);
    }
    
    return ;
    
}

@end
