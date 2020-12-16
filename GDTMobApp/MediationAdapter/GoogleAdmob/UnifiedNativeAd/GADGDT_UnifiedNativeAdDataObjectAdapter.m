//
//  GADGDT_UnifiedNativeAdDataObjectAdapter.m
//  GDTMobApp
//
//  Created by Nancy on 2019/7/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GADGDT_UnifiedNativeAdDataObjectAdapter.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import "GDTMediaView.h"

@interface GADGDT_UnifiedNativeAdDataObjectAdapter () <GADUnifiedNativeAdDelegate, GADVideoControllerDelegate>
@property (nonatomic, strong) GADUnifiedNativeAd *nativeAd;
@property (nonatomic, strong) GDTVideoConfig *gadVideoConfig;
@property (nonatomic, weak) id <GDTUnifiedNativeAdDataObjectConnectorProtocol> connector;
@property (nonatomic, strong) GADUnifiedNativeAdView *nativeAdView;
@end

@implementation GADGDT_UnifiedNativeAdDataObjectAdapter

- (instancetype)initWithNativeAd:(GADUnifiedNativeAd *)nativeAd {
    if (self = [super init]) {
        self.nativeAd = nativeAd;
    }
    
    return self;
}

#pragma mark - GDTUnifiedNativeAdDataObjectAdapterProtocol
- (NSString *)title
{
    return self.nativeAd.headline;
}

- (NSString *)desc
{
    return self.nativeAd.body;
}

- (NSString *)imageUrl
{
    GADNativeAdImage *image = [self.nativeAd.images firstObject];
    return image.imageURL.absoluteString;
}

- (NSString *)iconUrl
{
    return self.nativeAd.icon.imageURL.absoluteString;
}

- (BOOL)isVideoAd
{
    return self.nativeAd.mediaContent.hasVideoContent;
}

- (NSArray *)mediaUrlList
{
    NSMutableArray *container = [NSMutableArray array];
    for (GADNativeAdImage *image in self.nativeAd.images) {
        if (image.imageURL.absoluteString) {
            [container addObject:image.imageURL.absoluteString];
        }
    }
    
    return [NSArray arrayWithArray:container];
}

- (CGFloat)appRating
{
    return [self.nativeAd.starRating floatValue];
}

- (NSNumber *)appPrice
{
    return [NSNumber numberWithInteger:[self.nativeAd.price integerValue]];
}

- (BOOL)isAppAd
{
    return NO;
}

- (BOOL)isThreeImgsAd
{
    return [self.nativeAd.images count] == 3;
}

- (NSInteger)imageWidth
{
    GADNativeAdImage *image = [self.nativeAd.images firstObject];
    return image.image.size.width;
}

- (NSInteger)imageHeight
{
    GADNativeAdImage *image = [self.nativeAd.images firstObject];
    return image.image.size.height;
}

- (NSInteger)eCPM
{
    return -1;
}

- (BOOL)equalsAdData:(id<GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject
{
    if (![dataObject isKindOfClass:[GADGDT_UnifiedNativeAdDataObjectAdapter class]]) {
        return NO;
    }
    
    GADGDT_UnifiedNativeAdDataObjectAdapter *adapter = (GADGDT_UnifiedNativeAdDataObjectAdapter *)dataObject;
    if (adapter.nativeAd == self.nativeAd) {
        return YES;
    }
    
    return NO;
}

- (GDTVideoConfig *)videoConfig {
    return self.gadVideoConfig;
}

- (void)setVideoConfig:(GDTVideoConfig *)videoConfig
{
    _gadVideoConfig = videoConfig;
    [self configGadVideoController];
}

- (void)registerConnector:(id<GDTUnifiedNativeAdDataObjectConnectorProtocol>)connector clickableViews:(NSArray *)clickableViews {
    [self unregisterView];
    self.connector = connector;
    self.nativeAd.delegate = self;
    
    self.nativeAdView = [[GADUnifiedNativeAdView alloc] initWithFrame:self.connector.unifiedNativeAdView.bounds];
    self.nativeAdView.nativeAd = self.nativeAd;
    [self.connector.unifiedNativeAdView addSubview:self.nativeAdView];
    
    for (UIView *view in clickableViews) {
        view.userInteractionEnabled = NO;
        if ([view isKindOfClass:[UILabel class]]) {
            if (!self.nativeAdView.headlineView) {
                self.nativeAdView.headlineView = view;
            }
            else if (!self.nativeAdView.bodyView) {
                self.nativeAdView.bodyView = view;
            }
            
        } else if ([view isKindOfClass:[UIImageView class]]) {
            //调用GDTUnifiedNativeAdView的registerDataObject方法时传入的UIImageView 必须按先icon后image的顺序来，否则注册点击事件可能会异常
            if (!self.nativeAdView.iconView) {
                self.nativeAdView.iconView = view;
            }
            else if (!self.nativeAdView.imageView){
                self.nativeAdView.imageView = view;
            }
            
        } else if ([view isKindOfClass:[UIButton class]]) {
            self.nativeAdView.callToActionView = view;
        }
        
    }
    
    if (self.nativeAd.mediaContent.hasVideoContent) {
        GADMediaView *mediaView = [[GADMediaView alloc] initWithFrame:self.connector.unifiedNativeAdView.bounds];
        mediaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.nativeAdView.mediaView = mediaView;
        self.nativeAdView.mediaView.mediaContent = self.nativeAd.mediaContent;
        [self.connector.unifiedNativeAdView.mediaView addSubview:self.nativeAdView.mediaView];
        self.nativeAd.mediaContent.videoController.delegate = self;
        NSLog(@"%d %d", self.nativeAd.mediaContent.videoController.customControlsEnabled, self.nativeAd.mediaContent.videoController.clickToExpandEnabled);
    }
}

- (void)unregisterView
{
    [self.nativeAdView removeFromSuperview];
    self.nativeAdView = nil;
    
    [self.nativeAd unregisterAdView];
    self.connector = nil;
}

- (void)configGadVideoController {
    [self.nativeAd.mediaContent.videoController setMute:self.gadVideoConfig.videoMuted];
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    self.nativeAd.rootViewController = rootViewController;
}

- (UIViewController *)rootViewController
{
    return self.nativeAd.rootViewController;
}

#pragma mark - GDTMediaViewAdapterProtocol
/**
 * 视频广告时长，单位 ms
 */
- (CGFloat)videoDuration
{
    return 0.0;
}

/**
 * 视频广告已播放时长，单位 ms
 */
- (CGFloat)videoPlayTime
{
    return 0.0;
}

- (void)play
{
    [self.nativeAd.mediaContent.videoController play];
}

- (void)pause
{
    [self.nativeAd.mediaContent.videoController pause];
}

- (void)stop
{
    [self.nativeAd.mediaContent.videoController stop];
}

- (void)muteEnable:(BOOL)flag
{
    [self.nativeAd.mediaContent.videoController setMute:flag];
}

- (void)setPlayButtonImage:(UIImage *)image size:(CGSize)size
{
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdViewDidClick:)]) {
        [self.connector adapter_unifiedNativeAdViewDidClick:self];
    }
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdViewWillExpose:)]) {
        [self.connector adapter_unifiedNativeAdViewWillExpose:self];
    }
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdDetailViewWillPresentScreen:)]) {
        [self.connector adapter_unifiedNativeAdDetailViewWillPresentScreen:self];
    }
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdViewApplicationWillEnterBackground:)]) {
        [self.connector adapter_unifiedNativeAdViewApplicationWillEnterBackground:self];
    }
}

- (void)nativeAdIsMuted:(nonnull GADUnifiedNativeAd *)nativeAd {
    
}

#pragma mark - GADVideoControllerDelegate
/// Tells the delegate that the video controller has began or resumed playing a video.
- (void)videoControllerDidPlayVideo:(GADVideoController *)videoController {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdView:playerStatusChanged:userInfo:)]) {
        [self.connector adapter_unifiedNativeAdView:self playerStatusChanged:GDTMediaPlayerStatusStarted userInfo:nil];
    }
}

/// Tells the delegate that the video controller has paused video.
- (void)videoControllerDidPauseVideo:(GADVideoController *)videoController {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedNativeAdView:playerStatusChanged:userInfo:)]) {
        [self.connector adapter_unifiedNativeAdView:self playerStatusChanged:GDTMediaPlayerStatusPaused userInfo:nil];
    }
}

/// Tells the delegate that the video controller's video playback has ended.
- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    if ([self.connector.mediaView respondsToSelector:@selector(adapter_mediaViewDidPlayFinished:)]) {
        [self.connector.mediaView adapter_mediaViewDidPlayFinished:self];
    }
}

/// Tells the delegate that the video controller has muted video.
- (void)videoControllerDidMuteVideo:(GADVideoController *)videoController {
    
}

/// Tells the delegate that the video controller has unmuted video.
- (void)videoControllerDidUnmuteVideo:(GADVideoController *)videoController {
    
}
@end
