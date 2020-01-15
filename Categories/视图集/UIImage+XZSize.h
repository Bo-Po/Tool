//
//  UIImage+XZSize.h
//  XZOnLive
//
//  Created by 州龚 on 2019/9/30.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XZSize)

/**
 *  convert color to image
 *
 *  @param color
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  静态毛玻璃效果
 *
 *  @param blur 毛玻璃透明效果值
 *
 *  @return UIImage
 */
- (UIImage*)imageWithBlur:(CGFloat)blur;

/**
 *  按图片的大小裁剪图片
 *
 *  @param asize
 *
 *  @return UIImage
 */
- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize;

/**
 *   指定一个UIImageView的区域的范围来裁剪图片
 *
 *  @param subimagerect 指定的区域
 *  @param aimageView   要裁剪的图片
 *
 *  @return UIImage
 */
- (UIImage *)cropImage:(CGRect)subimagerect imageView:(UIImageView *)aimageView;

/**
 *  图片压缩成指定的大小（高度和宽度）
 *
 *  @param targetSize 指定图片的大小
 *
 *  @return UIImage
 */
- (UIImage *)compressImageBySize:(CGSize)targetSize;

/**
 *  图片压缩成指定的比例
 *
 *  @param percent 百分比
 *
 *  @return UIImage
 */
- (UIImage *)compressImageByPercent:(float)percent;

/**
 *  图片压缩成指定的数据量
 *
 *  @param data 图片的数据量
 *
 *  @return UIIamge
 */
- (UIImage *)compressImageByData:(CGFloat)data;

/**
 *  下面的这个方法适用于 对压缩后的图片的质量要求不高或者没有要求,因为这种方法只是压缩了图片的大小
 */
- (UIImage*)imageWithScaledToSize:(CGSize)newSize;


/**
 *  将图片存入沙盒
 *
 *  path 沙盒路径
 */
- (NSString *)writeToFile:(NSString * _Nullable)path;

@end

NS_ASSUME_NONNULL_END
