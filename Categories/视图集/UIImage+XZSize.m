//
//  UIImage+XZSize.m
//  XZOnLive
//
//  Created by 州龚 on 2019/9/30.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import "UIImage+XZSize.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (XZSize)

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)imageWithBlur:(CGFloat)blur{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
        //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
        //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
        // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
        //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
        //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize{
    UIImage *newimage;
    UIImage *image = self;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        else{
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToRect(context, CGRectMake(0, 0, asize.width, asize.height));
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

-(UIImage*) cropImage:(CGRect)subimagerect imageView:(UIImageView *)aimageView{
        //按照比例换算宽高和x，y坐标
        //    NSLog(@"width=%f height=%f",self.imageview.image.size.width,self.imageview.image.size.height);
    CGFloat koex = aimageView.image.size.height / aimageView.frame.size.height;
        //    NSLog(@"%f",koex);
    CGFloat koey = aimageView.image.size.width / aimageView.frame.size.width;
    
    CGRect finalImageRect = CGRectMake(koey * subimagerect.origin.x, koex * subimagerect.origin.y, koey * subimagerect.size.width, koex *subimagerect.size.height);
    UIImage *croppedImage = [aimageView.image imageAtRect:finalImageRect];
    return croppedImage;
    
}

- (UIImage *)imageAtRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}

- (UIImage *)compressImageBySize:(CGSize)targetSize{
    CGFloat scale;
    CGSize newsize = self.size;
    if (newsize.height && (newsize.height > targetSize.height)) {
        scale = targetSize.height/newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    if (newsize.width && (newsize.width >= targetSize.width)) {
        scale = targetSize.width /newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    UIGraphicsBeginImageContext(targetSize);
    
    float dwidth = (targetSize.width - newsize.width)/2.0f;
    float dheight = (targetSize.height - newsize.height)/2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, newsize.width, newsize.height);
    [self drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)compressImageByPercent:(float)percent{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width *percent, self.size.height * percent));
    [self drawInRect:CGRectMake(0, 0, self.size.width * percent, self.size.height * percent)];
    UIImage *scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)compressImageByData:(CGFloat)data{
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
    CGFloat ratio = 0.0;
    if (imageData && imageData.length > 0) {
        ratio = data * 1000 / imageData.length;
    }
    NSData *newData;
    if (ratio < 1.0) {
        newData = UIImageJPEGRepresentation(self, ratio);
    }else{
        newData = UIImageJPEGRepresentation(self, 1);
    }
    UIImage *newImage = [UIImage imageWithData:newData];
    return newImage;
}

//下面的这个方法适用于 对压缩后的图片的质量要求不高或者没有要求,因为这种方法只是压缩了图片的大小
- (UIImage*)imageWithScaledToSize:(CGSize)newSize {
        // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
        // Tell the old image to draw in this new context, with the desired
        // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        // End the context
    UIGraphicsEndImageContext();
        // Return the new image.
    return newImage;
}
// 将图片存入沙盒
- (NSString *)writeToFile:(NSString * _Nullable)path {
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    NSString *cachepath;
        // 将图片写入文件
    if (path) {
        [imageData writeToFile:path atomically:NO];
        cachepath = path;
    } else {
            // 获取沙盒目录
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSString *imgpath =Code_StringFormat(@"img/%0.f.jpg", interval);
        imgpath = [FileControl getCachesFilePath:imgpath];
        NSError *error;
        BOOL is = [imageData writeToFile:imgpath options:NSDataWritingAtomic error:&error];
        if (!is) {
            NSLog(@"is =====  %d ,   error   ====   %@",is, error);
            return nil;
        }
        cachepath = imgpath;
    }
    return cachepath;
}

@end
