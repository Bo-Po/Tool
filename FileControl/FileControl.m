//
//  FileControl.m
//  TianjinTrip
//
//  Created by Mac on 2017/10/24.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "FileControl.h"
#import <AdSupport/AdSupport.h>

@implementation FileControl

+ (NSString *)getDocumentsPath {
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString*path=[paths objectAtIndex:0];
    return path;
}
+ (NSString *)getDocumentsFilePath:(NSString *)fileName {
    return [[self getDocumentsPath] stringByAppendingPathComponent:fileName];
}


+ (NSString *)getCachesPath {
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    
    NSString*path=[paths objectAtIndex:0];
    return path;
}
+ (NSString *)getCachesFilePath:(NSString *)fileName {
    return [[self getCachesPath] stringByAppendingPathComponent:fileName];
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

@end
