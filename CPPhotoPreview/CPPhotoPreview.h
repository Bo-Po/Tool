//
//  CPPhotoPreview.h
//  test
//
//  Created by mac on 2019/5/27.
//  Copyright © 2019年 bo. All rights reserved.
//  查看大图、播放视频

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CPPhotoPreviewTypeDefault = 0,
    CPPhotoPreviewTypeFixed = CPPhotoPreviewTypeDefault,
    CPPhotoPreviewTypeScroll,
    CPPhotoPreviewTypeVideo
} CPPhotoPreviewType;

@interface CPPhotoPreview : UIViewController

@property (assign , nonatomic) BOOL isZoom;

// 单图大图展示
- (instancetype)initWithImageView:(UIView *)imageView;
// 多图大图展示
- (instancetype)initWithImages:(NSArray *)images selectedImageView:(UIView *)imageView atIndex:(NSInteger)index;
// 播放视频
- (instancetype)initWithVideo:(NSString *)videoString ImageView:(UIView *)imageView;

@end


/// 大图、视频显示 视图
@interface MyScrollView : UIScrollView<UIScrollViewDelegate> {
    @public AVPlayer *_cp_player;
    @public id cp_obj;
}

@property (assign , nonatomic) BOOL isZoom;
@property (strong , nonatomic, nonnull) UIImageView *m_imageView;
@property (assign , nonatomic) BOOL showController;// 显示控制条


- (instancetype)initWithVideo:(nullable NSString *)videoString didVideoEnd:(void(^)(BOOL finish, CMTime currentTime, CMTime totalTime))endHandler;

@end


/// 视频控制
@interface CPVideoTool : UIView {
    
}


@property (strong , nonatomic) AVPlayer *player;

@property (strong , nonatomic) UIButton *playBtn;           // 开始/暂停
@property (strong , nonatomic) UILabel *currentTimeLabel;   // 视频当前播放时间
@property (strong , nonatomic) UILabel *totalTimeLabel;     // 视频总时长
@property (strong , nonatomic) UIProgressView *progressView;// 缓冲进度
@property (strong , nonatomic) UISlider *slider;// 播放进度

@end

NS_ASSUME_NONNULL_END
