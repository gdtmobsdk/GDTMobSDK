//
//  UnifiedNativePreVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativePreVideoViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "UnifiedNativeAdCustomView.h"

@interface UnifiedNativePreVideoViewController () <GDTUnifiedNativeAdDelegate, GDTUnifiedNativeAdViewDelegate, GDTMediaViewDelegate>

@property (nonatomic, strong) UIView *videoContainerView;
@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property (nonatomic, strong) UnifiedNativeAdCustomView *nativeAdCustomView;
@property (nonatomic, strong) GDTUnifiedNativeAdDataObject *dataObject;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation UnifiedNativePreVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //---- 视频配置项，整段注释可使用外部VC开关控制
////    self.placementId = @"3050349752532954";
//    self.videoConfig.videoMuted = NO;
//    self.videoConfig.autoPlayPolicy = GDTVideoAutoPlayPolicyAlways;
//    self.videoConfig.userControlEnable = YES;
//    self.videoConfig.autoResumeEnable = NO;
//    self.videoConfig.detailPageEnable = NO;
//    self.videoConfig.coverImageEnable = YES;
//    self.videoConfig.progressViewEnable = NO;
//    //-----
    
    self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId];
    self.unifiedNativeAd.delegate = self;
    self.unifiedNativeAd.minVideoDuration = self.minVideoDuration;
    self.unifiedNativeAd.maxVideoDuration = self.maxVideoDuration;

    [self.unifiedNativeAd setVastClassName:@"IMAGDT_VASTVideoAdAdapter"]; // 如果需要支持 VAST 广告，拉取广告前设置

    [self.unifiedNativeAd loadAdWithAdCount:1];
    
    [self.view addSubview:self.videoContainerView];
    // 播放器容器
    self.videoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoContainerView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.videoContainerView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.videoContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.videoContainerView.heightAnchor constraintEqualToAnchor:self.videoContainerView.widthAnchor multiplier:9/16.0].active = YES;
    
    [self.videoContainerView addSubview:self.nativeAdCustomView];
    // 贴片广告布局
    self.nativeAdCustomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdCustomView.leftAnchor constraintEqualToAnchor:self.videoContainerView.leftAnchor].active = YES;
    [self.nativeAdCustomView.rightAnchor constraintEqualToAnchor:self.videoContainerView.rightAnchor].active = YES;
    [self.nativeAdCustomView.topAnchor constraintEqualToAnchor:self.videoContainerView.topAnchor].active = YES;
    [self.nativeAdCustomView.bottomAnchor constraintEqualToAnchor:self.videoContainerView.bottomAnchor].active = YES;
    
    self.nativeAdCustomView.clickButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdCustomView.clickButton.rightAnchor constraintEqualToAnchor:self.nativeAdCustomView.rightAnchor constant:-10].active = YES;
    [self.nativeAdCustomView.clickButton.bottomAnchor constraintEqualToAnchor:self.nativeAdCustomView.bottomAnchor constant:-10].active = YES;
    [self.nativeAdCustomView.clickButton.widthAnchor constraintEqualToConstant:80].active = YES;
    [self.nativeAdCustomView.clickButton.heightAnchor constraintEqualToConstant:44].active = YES;
    self.nativeAdCustomView.clickButton.backgroundColor = [UIColor orangeColor];

    self.countdownLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdCustomView addSubview:self.countdownLabel];
    [self.countdownLabel.rightAnchor constraintEqualToAnchor:self.nativeAdCustomView.rightAnchor constant:-10].active = YES;
    [self.countdownLabel.topAnchor constraintEqualToAnchor:self.nativeAdCustomView.topAnchor constant:10].active = YES;
    [self.countdownLabel.widthAnchor constraintEqualToConstant:40].active = YES;
    [self.countdownLabel.heightAnchor constraintEqualToConstant:40].active = YES;

    self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdCustomView addSubview:self.skipButton];
    [self.skipButton.rightAnchor constraintEqualToAnchor:self.countdownLabel.leftAnchor constant:-10].active = YES;
    [self.skipButton.topAnchor constraintEqualToAnchor:self.countdownLabel.topAnchor].active = YES;
    [self.skipButton.widthAnchor constraintEqualToConstant:60].active = YES;
    [self.skipButton.heightAnchor constraintEqualToConstant:40].active = YES;
    
    [self.nativeAdCustomView addSubview:self.nativeAdCustomView.logoView];
    self.nativeAdCustomView.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nativeAdCustomView.logoView.rightAnchor constraintEqualToAnchor:self.nativeAdCustomView.rightAnchor].active = YES;
    [self.nativeAdCustomView.logoView.bottomAnchor constraintEqualToAnchor:self.nativeAdCustomView.bottomAnchor].active = YES;
    [self.nativeAdCustomView.logoView.widthAnchor constraintEqualToConstant:kGDTLogoImageViewDefaultWidth].active = YES;
    [self.nativeAdCustomView.logoView.heightAnchor constraintEqualToConstant:kGDTLogoImageViewDefaultHeight].active = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // timer 需要开发者自行管理
    [self.timer invalidate];
    self.timer = nil;
}

- (void)reloadAd
{
    self.dataObject.videoConfig = self.videoConfig;
    self.nativeAdCustomView.viewController = self;
    [self.nativeAdCustomView registerDataObject:self.dataObject clickableViews:@[self.nativeAdCustomView.clickButton]];
    if (self.dataObject.isAppAd) {
        [self.nativeAdCustomView.clickButton setTitle:@"点击下载" forState:UIControlStateNormal];
    } else {
        [self.nativeAdCustomView.clickButton setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    self.nativeAdCustomView.mediaView.delegate = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
}

- (void)timeUpdate
{
    CGFloat playTime = [self.nativeAdCustomView.mediaView videoPlayTime];
    CGFloat duration = [self.nativeAdCustomView.mediaView videoDuration];
    if (duration > 0) {
        self.countdownLabel.hidden = NO;
    }
    if (playTime > 5000) {
        // 播放 5 秒展示跳过按钮
        self.skipButton.hidden = NO;
    }
    if (playTime < duration) {
        self.countdownLabel.text =  [NSString stringWithFormat:@"%@", @((NSInteger)(duration - playTime) / 1000)];
        NSLog(@"总时长：%@， 已播放：%@", @(duration), @(playTime));
    }
}

#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (!error && unifiedNativeAdDataObjects.count > 0) {
        NSLog(@"成功请求到广告数据");
        self.dataObject = unifiedNativeAdDataObjects[0];
        NSLog(@"eCPM:%ld eCPMLevel:%@", [self.dataObject eCPM], [self.dataObject eCPMLevel]);
        if (self.dataObject.isVideoAd) {
            [self reloadAd];
            return;
        } else if (self.dataObject.isVastAd) {
            [self reloadAd];
            return;
        }
    }
    
    if (error.code == 5004) {
        NSLog(@"没匹配的广告，禁止重试，否则影响流量变现效果");
    } else if (error.code == 5005) {
        NSLog(@"流量控制导致没有广告，超过日限额，请明天再尝试");
    } else if (error.code == 5009) {
        NSLog(@"流量控制导致没有广告，超过小时限额");
    } else if (error.code == 5006) {
        NSLog(@"包名错误");
    } else if (error.code == 5010) {
        NSLog(@"广告样式校验失败");
    } else if (error.code == 3001) {
        NSLog(@"网络错误");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    } else if (error) {
        NSLog(@"ERROR: %@", error);
    }
}

#pragma mark - GDTMediaViewDelegate
- (void)gdt_mediaViewDidPlayFinished:(GDTMediaView *)mediaView
{
    NSLog(@"%s",__FUNCTION__);
    [self clickSkip];
}

#pragma mark - GDTUnifiedNativeAdViewDelegate
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@ 广告被点击", unifiedNativeAdView.dataObject);
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告被曝光");
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告详情页已关闭");
}

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告进入后台");
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"广告详情页面即将打开");
}

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频广告状态变更");
    switch (status) {
        case GDTMediaPlayerStatusInitial:
            NSLog(@"视频初始化");
            break;
        case GDTMediaPlayerStatusLoading:
            NSLog(@"视频加载中");
            break;
        case GDTMediaPlayerStatusStarted:
            NSLog(@"视频开始播放");
            break;
        case GDTMediaPlayerStatusPaused:
            NSLog(@"视频暂停");
            break;
        case GDTMediaPlayerStatusStoped:
            NSLog(@"视频停止");
            break;
        case GDTMediaPlayerStatusError:
            NSLog(@"视频播放出错");
        default:
            break;
    }
    if (userInfo) {
        long videoDuration = [userInfo[kGDTUnifiedNativeAdKeyVideoDuration] longValue];
        NSLog(@"视频广告长度为 %ld s", videoDuration);
    }
}

#pragma mark - private
- (void)clickSkip
{
    [self.timer invalidate];
    self.timer = nil;
    [self.nativeAdCustomView removeFromSuperview];
    [self.nativeAdCustomView unregisterDataObject];
    _nativeAdCustomView = nil;
}

#pragma mark - property getter
- (UnifiedNativeAdCustomView *)nativeAdCustomView
{
    if (!_nativeAdCustomView) {
        _nativeAdCustomView = [[UnifiedNativeAdCustomView alloc] init];
        _nativeAdCustomView.delegate = self;
        _nativeAdCustomView.accessibilityIdentifier = @"nativeAdCustomView_id";
    }
    return _nativeAdCustomView;
}

- (UIView *)videoContainerView
{
    if (!_videoContainerView) {
        _videoContainerView = [[UIView alloc] init];
        _videoContainerView.backgroundColor = [UIColor grayColor];
        _videoContainerView.accessibilityIdentifier = @"videoContainerView_id";
    }
    return _videoContainerView;
}

- (UILabel *)countdownLabel
{
    if (!_countdownLabel) {
        _countdownLabel = [[UILabel alloc] init];
        _countdownLabel.hidden = YES;
        _countdownLabel.textColor = [UIColor redColor];
        _countdownLabel.backgroundColor = [UIColor blueColor];
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.accessibilityIdentifier = @"countdownLabel_id";
    }
    return _countdownLabel;
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] init];
        _skipButton.backgroundColor = [UIColor grayColor];
        _skipButton.hidden = YES;
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(clickSkip) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.accessibilityIdentifier = @"skipButton_id";
    }
    return _skipButton;
}

@end
