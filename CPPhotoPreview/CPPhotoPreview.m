//
//  CPPhotoPreview.m
//  test
//
//  Created by mac on 2019/5/27.
//  Copyright © 2019年 bo. All rights reserved.
//

#import "CPPhotoPreview.h"

@interface CPPhotoPreview () <UIScrollViewDelegate> {
    CGRect _prect;
    UIViewContentMode _mode;
    BOOL _isHidden;
    NSArray *_imageSource;
    NSMutableArray<MyScrollView *> *_scrollViews;
    
    // 视频
    MyScrollView *_videoView;
    NSString *_videoString;
}

@property (nonatomic) UIImageView *imageView;
@property (nonatomic, assign) CPPhotoPreviewType type;

//底视图
@property (nonatomic, strong) UIScrollView *scrollView;
//当前页数
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CPPhotoPreview

- (instancetype)initWithImageView:(UIView *)imageView {
    if (self = [super init]) {
        _mode = ((UIImageView *)imageView).contentMode;
        self.imageView.image = ((UIImageView *)imageView).image;
        _prect = [imageView convertRect:imageView.bounds toView:nil];
        self.imageView.frame = _prect;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [self.view addGestureRecognizer:tap];
        self.view.backgroundColor = Color_Hex_alpha(@"#000000", 0.);
        self.type = CPPhotoPreviewTypeDefault;
        _scrollViews = @[].mutableCopy;
        self.isZoom = NO;
    }
    return self;
}

- (instancetype)initWithImages:(NSArray *)images selectedImageView:(UIView *)imageView atIndex:(NSInteger)index {
    if (self = [super init]) {
        _imageSource = [images copy];
        _mode = ((UIImageView *)imageView).contentMode;
        self.imageView.image = ((UIImageView *)imageView).image;
        _prect = [imageView convertRect:imageView.bounds toView:nil];
        self.imageView.frame = _prect;
        self.currentPage = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [self.view addGestureRecognizer:tap];
        self.view.backgroundColor = Color_Hex_alpha(@"#000000", 0.);
        self.type = CPPhotoPreviewTypeScroll;
        [self.view addSubview:self.scrollView];
        _scrollViews = @[].mutableCopy;
        self.scrollView.alpha = 0.;
        self.isZoom = YES;
    }
    return self;
}

- (instancetype)initWithVideo:(NSString *)videoString ImageView:(UIView *)imageView {
    if (self = [super init]) {
        _mode = ((UIImageView *)imageView).contentMode;
        self.imageView.image = ((UIImageView *)imageView).image;
        _prect = [imageView convertRect:imageView.bounds toView:nil];
        self.imageView.frame = _prect;
        self.view.backgroundColor = Color_Hex_alpha(@"#000000", 0.);
        self.type = CPPhotoPreviewTypeVideo;
        _videoString = videoString;
        _scrollViews = @[].mutableCopy;
        self.isZoom = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarHidden = YES;
    _isHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [self setupUI];
    [self.view addSubview:self.imageView];
    Code_Weakify(self)
    [UIView animateWithDuration:.25 animations:^{
        Code_Strongify(self)
        self.imageView.frame = self.view.bounds;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.view.backgroundColor = Color_Hex_alpha(@"#000000", 1.);
    } completion:^(BOOL finished) {
        Code_Strongify(self)
        [self.imageView removeFromSuperview];
        self.scrollView.alpha = 1.;
        if (self.type == CPPhotoPreviewTypeScroll) {
            [self->_scrollViews enumerateObjectsUsingBlock:^(MyScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Code_Strongify(self)
                [self.scrollView addSubview:obj];
            }];
        } else if (self.type == CPPhotoPreviewTypeVideo) {
            [self.view addSubview:self->_videoView];
        } else {
            [self.view addSubview:self->_scrollViews[0]];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewWillLayoutSubviews {
    self.imageView.frame = self.view.bounds;
    if (_scrollView) {
        _scrollView.frame = self.view.bounds;
    }
    _videoView.frame = _scrollView.bounds;
    Code_Weakify(self)
    [_scrollViews enumerateObjectsUsingBlock:^(MyScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Code_Strongify(self)
        obj.frame = self->_scrollView.bounds;
        obj.cp_x = idx * self->_scrollView.cp_width;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupUI {
    if (_scrollViews.count == 0) {
        MyScrollView *scrollView = [[MyScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, self.view.cp_width, self.view.cp_height);
        [_scrollViews addObject:scrollView];
    }
    if (self.type == CPPhotoPreviewTypeScroll) {
        for (NSInteger i = 0; (_imageSource.count - _scrollViews.count)>0; i++) {
            MyScrollView *scrollView = [[MyScrollView alloc] init];
            scrollView.frame = CGRectMake(_scrollViews.count*self.view.cp_width, 0, self.view.cp_width, self.view.cp_height);
            [_scrollViews addObject:scrollView];
        }
        Code_Weakify(self)
        [_scrollViews enumerateObjectsUsingBlock:^(MyScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Code_Strongify(self)
            obj.isZoom = self.isZoom;
            if ([self->_imageSource[idx] isKindOfClass:[UIImage class]]) {
                obj.m_imageView.image = self->_imageSource[idx];
            } else {
                [obj.m_imageView sd_setImageWithURL:[NSURL URLWithString:self->_imageSource[idx]] placeholderImage:nil];
            }
        }];
        self.scrollView.contentSize = CGSizeMake(_imageSource.count*self.view.cp_width, self.view.cp_height);
        [self.scrollView scrollRectToVisible:[_scrollViews objectAtIndex:self.currentPage].frame animated:NO];
    } else if (self.type == CPPhotoPreviewTypeVideo) {
        Code_Weakify(self)
        _videoView = [[MyScrollView alloc] initWithVideo:_videoString didVideoEnd:^(BOOL finish, CMTime currentTime, CMTime totalTime) {
            Code_Strongify(self)
            if (finish) {
                [self dismiss:nil];
                return ;
            }
            //当前播放的时间
            NSTimeInterval current = CMTimeGetSeconds(currentTime);
            //视频的总时间
            NSTimeInterval total = CMTimeGetSeconds(totalTime);
            if (current>=total) {
                [self dismiss:nil];
            }
        }];
        _videoView.isZoom = self.isZoom;
        _videoView.frame = CGRectMake(0, 0, self.view.cp_width, self.view.cp_height);
    }  else {
        MyScrollView *my = _scrollViews[0];
        my.isZoom = self.isZoom;
        my.m_imageView.image = self.imageView.image;
    }
}

- (void)dismiss:(id)sender {
    if (self.type == CPPhotoPreviewTypeScroll) {
        Code_Weakify(self)
        [UIView animateWithDuration:.15 animations:^{
            Code_Strongify(self)
            self.scrollView.alpha = 0.;
            self.view.backgroundColor = Color_Hex_alpha(@"#000000", 0.);
        } completion:^(BOOL finished) {
            Code_Strongify(self)
            [self dismissViewControllerAnimated:NO completion:nil];
            self->_isHidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    } else if (self.type == CPPhotoPreviewTypeVideo) {
        Code_Weakify(self)
        [UIView animateWithDuration:.15 animations:^{
            Code_Strongify(self)
            self.view.alpha = 0.;
        } completion:^(BOOL finished) {
            Code_Strongify(self)
            [self dismissViewControllerAnimated:NO completion:nil];
            self->_isHidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];
//            [self->_videoView->_cp_player removeTimeObserver:self->_videoView->cp_obj];
        }];
    } else {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.view addSubview:self.imageView];
        Code_Weakify(self)
        [UIView animateWithDuration:.25 animations:^{
            Code_Strongify(self)
            self.imageView.frame = self->_prect;
            self.imageView.contentMode = self->_mode;
            self.view.backgroundColor = Color_Hex_alpha(@"#000000", 0.);
        } completion:^(BOOL finished) {
            Code_Strongify(self)
            [self dismissViewControllerAnimated:NO completion:nil];
            self->_isHidden = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.currentPage = (scrollView.contentOffset.x) / scrollView.cp_width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.currentPage != (scrollView.contentOffset.x) / scrollView.cp_width) {
        self.currentPage = (scrollView.contentOffset.x) / scrollView.cp_width;
        [_scrollViews enumerateObjectsUsingBlock:^(MyScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setZoomScale:1];
        }];
    }
}
    
#pragma mark - getter / setter -
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = UIColor.clearColor;
        [_scrollView setMinimumZoomScale:1];
        [_scrollView setMaximumZoomScale:3];
        [_scrollView setZoomScale:1 animated:YES];
    }
    return _scrollView;
}

- (BOOL)prefersStatusBarHidden {
    return _isHidden;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@interface MyScrollView () <AVPlayerViewControllerDelegate> {
    UIView *_cp_playerView;
    AVPlayerLayer *_layer;
    NSString *_videoString;
    CGFloat _videoTime;
    
}
// 关闭按钮
@property (nonatomic, strong) UIButton *close_btn;
@property (nonatomic, strong) CPVideoTool *tool;
@property (nonatomic, copy) void(^endHandler)(BOOL finish, CMTime currentTime, CMTime totalTime);

@end

@implementation MyScrollView

- (void)layoutSubviews {
    self.m_imageView.frame = self.bounds;
    _cp_playerView.frame = self.bounds;
    _layer.frame = _cp_playerView.bounds;
    if (self.showController) {
        if (_close_btn) {
            self.close_btn.cp_origin = CGPointMake(self.cp_right - 44., 10.);
            [self.superview addSubview:self.close_btn];
        }
        if (_tool) {
            self.tool.cp_origin = CGPointMake(self.cp_x+10, self.cp_height-70.);
            self.tool.cp_width = self.cp_width-20;
            [self.superview addSubview:self.tool];
        }
    }
}

- (instancetype)init {
    if (self = [super init]) {
        // Initialization code
        self.delegate = self;
        self.frame = CGRectMake(0, 0, Size_ScreenWidth, Size_ScreenHeight);
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = UIColor.clearColor;
        self.showController = NO;
        [self initImageView];
    }
    return self;
}
- (instancetype)initWithVideo:(nullable NSString *)videoString didVideoEnd:(void(^)(BOOL finish, CMTime currentTime, CMTime totalTime))endHandler {
    self = [super init];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.frame = CGRectMake(0, 0, Size_ScreenWidth, Size_ScreenHeight);
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = UIColor.clearColor;
        _videoString = videoString;
        self.showController = YES;
        self.endHandler = endHandler;
        [self initVideoViewDidVideoEnd:endHandler];
    }
    return self;
}

- (void)initImageView {
    self.m_imageView = [[UIImageView alloc] init];
    self.m_imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.m_imageView];
    
    [self setMinimumZoomScale:1.];
    [self setMaximumZoomScale:3.];
    [self setZoomScale:1.];
}

- (void)initVideoViewDidVideoEnd:(void(^)(BOOL finish, CMTime currentTime, CMTime totalTime))endHandler {
    //设置播放的url
    NSURL *url = [NSURL URLWithString:_videoString];
    //设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    _cp_playerView = [[UIView alloc] initWithFrame:self.bounds];
    //初始化player对象
    _cp_player = [[AVPlayer alloc] initWithPlayerItem:item];
    //设置播放页面
    _layer = [AVPlayerLayer playerLayerWithPlayer:_cp_player];
    //设置播放页面的大小
    _layer.frame = _cp_playerView.bounds;
    _layer.backgroundColor = [UIColor blackColor].CGColor;
    //设置播放窗口和当前视图之间的比例显示内容
    _layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加播放视图到self.view
    [_cp_playerView.layer addSublayer:_layer];
    [self addSubview:_cp_playerView];
    [_cp_player play];
    
    if (self.showController) {
        self.close_btn.cp_origin = CGPointMake(self.cp_right - 44., 10.);
        [self.superview addSubview:self.close_btn];
        
        self.tool.cp_origin = CGPointMake(self.cp_x+10, self.cp_height-70.);
        self.tool.cp_width = self.cp_width-20;
        self.tool.player = _cp_player;
        [self.superview addSubview:self.tool];
    }
    //观察loadedTimeRanges，可以获取缓存进度，实现缓冲进度条
    [_cp_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    Code_Weakify(self)
    cp_obj = [_cp_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        Code_Strongify(self)
        //当前播放的时间
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval totalTime = 0;
        //更新显示：当前缓冲总时长
        self.tool.currentTimeLabel.text = [self formatTimeWithTimeInterVal:currentTime];
        //视频的总时间
        if (self) {
            totalTime = CMTimeGetSeconds(self->_cp_player.currentItem.duration);
            //更新显示：视频的总时长
            self.tool.totalTimeLabel.text = [self formatTimeWithTimeInterVal:totalTime];
            self.tool.slider.value = currentTime/totalTime;
            self.tool.slider.enabled = YES;
            if (endHandler) {
                endHandler(NO, time, self->_cp_player.currentItem.duration);
            }
        }
        if (currentTime>=totalTime) {
            NSLog(@"播放 结束");
        }
    }];
}
//转换时间格式的方法
- (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0, hour = 0, secend = timeInterVal;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

- (void)dismiss:(id)sender {
    if (self.endHandler) {
        self.endHandler(YES, CMTimeMake(0, 0), CMTimeMake(0, 0));
    }
}
//2.添加属性观察
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //获取视频缓冲进度数组，这些缓冲的数组可能不是连续的
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        //获取最新的缓冲区间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //缓冲区间的开始的时间
        NSTimeInterval loadStartSeconds = CMTimeGetSeconds(timeRange.start);
        //缓冲区间的时长
        NSTimeInterval loadDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        //当前视频缓冲时间总长度
        NSTimeInterval currentLoadTotalTime = loadStartSeconds + loadDurationSeconds;
        //NSLog(@"开始缓冲:%f,缓冲时长:%f,总时间:%f", loadStartSeconds, loadDurationSeconds, currentLoadTotalTime);
        //更新显示：缓冲进度条的值
        self.tool.progressView.progress = currentLoadTotalTime/CMTimeGetSeconds(_cp_player.currentItem.duration);
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.isZoom?(_videoString?_cp_playerView:self.m_imageView):nil;
}

// called before the scroll view begins zooming its content缩放开始的时候调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2) {
    NSLog(@"%s",__func__);
}

// scale between minimum and maximum. called after any 'bounce' animations缩放完毕的时候调用。
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    NSLog(@"scale is %f",scale);
    [scrollView setZoomScale:scale animated:NO];
}

// 缩放时调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 可以实时监测缩放比例
    NSLog(@"......scale is %f  ......content size is %@",scrollView.zoomScale, NSStringFromCGSize(scrollView.contentSize));
}

#pragma mark - AVPlayerViewControllerDelegate
- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    
}
- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler {
    completionHandler(YES);
}

- (void)setShowController:(BOOL)showController {
    _showController = showController;
    if (_showController) {
        self.close_btn.cp_origin = CGPointMake(self.cp_right - 44., 10.);
        if (!self.close_btn.superview) {
            [self.superview addSubview:self.close_btn];
        }
        self.tool.cp_origin = CGPointMake(self.cp_x+10, self.cp_height-70.);
        self.tool.cp_width = self.cp_width-20;
        if (!self.tool.superview) {
            [self.superview addSubview:self.tool];
        }
        _close_btn.hidden = !YES;
        _tool.hidden = !YES;
    } else {
        _close_btn.hidden = YES;
        _tool.hidden = YES;
    }
}

- (UIButton *)close_btn {
    if (!_close_btn) {
        _close_btn = [[UIButton alloc] init];
        [_close_btn setTitle:@"X" forState:(UIControlStateNormal)];
        [_close_btn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        _close_btn.backgroundColor = Color_Hex_alpha(@"#222222", 0.8);
        _close_btn.titleLabel.font = Font_Bold(40.);
        _close_btn.cp_size = CGSizeMake(34., 34.);
        _close_btn.layer.cornerRadius = 5.;
        _close_btn.layer.masksToBounds = YES;
        [_close_btn addTarget:self action:@selector(dismiss:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _close_btn;
}

- (CPVideoTool *)tool {
    if (!_tool) {
        
        _tool = [[CPVideoTool alloc] init];
        _tool.cp_height = 54.;
        _tool.backgroundColor = Color_Hex_alpha(@"#222222", 0.8);
        _tool.layer.cornerRadius = 5.;
        _tool.layer.masksToBounds = YES;
        
    }
    return _tool;
}

- (void)dealloc {
    [_cp_player removeTimeObserver:cp_obj];
    [_cp_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
}

@end


/// 视频控制
@interface CPVideoTool () {
    
}

@end


@implementation CPVideoTool

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    _playBtn.frame = CGRectMake(10, self.cp_height-44, 34., 34.);
    _currentTimeLabel.frame = CGRectMake(_playBtn.cp_right+10., self.cp_height-44, 40., 34.);
    _totalTimeLabel.frame = CGRectMake(self.cp_width - 55., self.cp_height-44, 40., 34.);
    _progressView.frame = CGRectMake(_currentTimeLabel.cp_right+5, self.cp_height-44, self.cp_width - 55. - _currentTimeLabel.cp_right-10, 34.);
    _progressView.cp_centerY = _currentTimeLabel.cp_centerY;
    _slider.frame = _progressView.frame;
    _slider.cp_centerY = _progressView.cp_centerY;
}

- (void)setupUI {
    [self addSubview:self.playBtn];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.slider];
}

- (void)clickPlay:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

//UISlider的响应方法:拖动滑块，改变播放进度
- (void)sliderViewChange:(UISlider *)sender {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval playTime = sender.value * CMTimeGetSeconds(self.player.currentItem.duration);
        CMTime seekTime = CMTimeMake(playTime, 1);
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
        }];
    }
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setTitle:@"| |" forState:(UIControlStateNormal)];
        [_playBtn setTitle:@"| |" forState:(UIControlStateHighlighted|UIControlStateNormal)];
        [_playBtn setTitle:@"| >" forState:(UIControlStateSelected|UIControlStateHighlighted)];
        [_playBtn setTitle:@"| >" forState:(UIControlStateSelected)];
        [_playBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        _playBtn.backgroundColor = Color_Hex_alpha(@"#222222", 0.8);
        _playBtn.titleLabel.font = Font_Bold(40.);
        _playBtn.cp_size = CGSizeMake(34., 34.);
        _playBtn.layer.cornerRadius = 5.;
        _playBtn.layer.masksToBounds = YES;
        [_playBtn addTarget:self action:@selector(clickPlay:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _playBtn;
}
- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.backgroundColor = UIColor.clearColor;
        _currentTimeLabel.font = Font(18.);
        _currentTimeLabel.textAlignment = 2;
        _currentTimeLabel.textColor = UIColor.whiteColor;
    }
    return _currentTimeLabel;
}
- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.backgroundColor = UIColor.clearColor;
        _totalTimeLabel.font = Font(18.);
        _totalTimeLabel.textColor = UIColor.whiteColor;
    }
    return _totalTimeLabel;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.backgroundColor = UIColor.clearColor;
        _progressView.progressTintColor = UIColor.lightGrayColor;
        _progressView.trackTintColor = UIColor.grayColor;
    }
    return _progressView;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0.;
        _slider.maximumValue = 1.;
        _slider.minimumTrackTintColor = UIColor.clearColor;
        _slider.maximumTrackTintColor = UIColor.clearColor;
        _slider.enabled = NO;
        [_slider addTarget:self action:@selector(sliderViewChange:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _slider;
}

@end
