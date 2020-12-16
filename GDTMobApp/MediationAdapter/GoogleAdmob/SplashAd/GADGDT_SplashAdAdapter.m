//
//  GADGDT_SplashAdAdapter.m
//  GDTMobApp
//
//  Created by 胡俊峰 on 2019/12/5.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GADGDT_SplashAdAdapter.h"
#import "GDTSplashAdNetworkConnectorProtocol.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MediationAdapterUtil.h"
#import "GDTUnifiedNativeAdNetworkAdapterProtocol.h"

@interface GADGDT_SplashAdAdapter () <GDTSplashAdNetworkConnectorProtocol, GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate>

@property (nonatomic, assign) BOOL loadCanceled;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) BOOL adLoaded;
@property (nonatomic, assign) BOOL adExposured;

@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol>connector;

@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, strong) GADUnifiedNativeAdView *nativeAdView;
@property (nonatomic, strong) GADUnifiedNativeAd *nativeAd;
@property (nonatomic, strong) GADMediaView *mediaView;

@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *headLineLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIButton *visitSiteButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) NSInteger countdownDuration;
@property (nonatomic, strong) NSTimer *countDownTimer;

@end

@implementation GADGDT_SplashAdAdapter

@synthesize backgroundColor;
@synthesize backgroundImage;
@synthesize fetchDelay;
@synthesize skipButtonCenter;

#pragma mark - GDTSplashAdNetworkConnectorProtocol
+ (NSString *)adapterVersion {
    return @"1.0.0";
}

- (instancetype)initWithAdNetworkConnector:(id)connector posId:(NSString *)posId extStr:(NSString *)extStr {
    if (!connector) {
        return nil;
    }
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
        self.params = [MediationAdapterUtil getURLParams:extStr];
        
        GADNativeAdViewAdOptions *adViewOptions = [[GADNativeAdViewAdOptions alloc] init];
        adViewOptions.preferredAdChoicesPosition = GADAdChoicesPositionBottomRightCorner;
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:self.posId rootViewController:nil adTypes:@[kGADAdLoaderAdTypeUnifiedNative] options:@[adViewOptions]];
        self.adLoader.delegate = self;
        self.countdownDuration = 5;
        
    }
    return self;
}

- (void)loadAdAndShowInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView {
    if (self.loadCanceled) {
        return;
    }
    self.window = window;
    self.bottomView = bottomView;
//        skipButton可由流量自定义
    if ([skipView isKindOfClass:[UIButton class]]) {
        self.skipButton = (UIButton *)skipView;
    }
    [self.skipButton addTarget:self action:@selector(clickSkip) forControlEvents:UIControlEventTouchUpInside];
    
    [self.adLoader loadRequest:[GADRequest request]];
        
}

- (void)loadAd {
    if (self.loadCanceled) {
            return;
        }
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView {
    self.window = window;
    self.bottomView = bottomView;
//        skipButton可由流量自定义
    if ([skipView isKindOfClass:[UIButton class]]) {
        self.skipButton = (UIButton *)skipView;
    }
    [self.skipButton addTarget:self action:@selector(clickSkip) forControlEvents:UIControlEventTouchUpInside];
    
    [self renderSplashAdView];
    [self addAllViews];
    [self layoutViews];
    
    [self updateCountDown];
    [self.countDownTimer isValid];
}

- (BOOL)isAdValid {
    return self.adLoaded && !self.adExposured;
}

- (void)cancelLoad {
    self.loadCanceled = YES;
}

- (NSInteger)eCPM {
    return -1;
}

#pragma mark - GADAdLoader
- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    if (self.loadCanceled) {
        return;
    }
    self.nativeAd = nativeAd;
    self.nativeAdView.nativeAd = nativeAd;
    self.nativeAd.delegate = self;
    
    if (self.window) {
        [self renderSplashAdView];
        [self addAllViews];
        [self layoutViews];
        
        [self updateCountDown];
        [self.countDownTimer isValid];
    }
    self.adLoaded = YES;
    [self.connector adapter_splashAdDidLoad:self];

}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    [self.connector adapter_splashAdFailToPresent:self withError:error];
}

#pragma mark - GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    [self.connector adapter_splashAdClicked:self];
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    self.adExposured = YES;
    [self.connector adapter_splashAdSuccessPresentScreen:self];
    [self.connector adapter_splashAdExposured:self];

}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    [self.connector adapter_splashAdWillDismissFullScreenModal:self];
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {

}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)nativeAdIsMuted:(nonnull GADUnifiedNativeAd *)nativeAd {
    
}

#pragma mark - private
- (void)renderSplashAdView {
    UIImage *image = [self.nativeAd.images firstObject].image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setValue:@20.0f forKey: @"inputRadius"];
        CIImage *resultImage = [filter valueForKey:kCIOutputImageKey];
        CGImageRef outImage = [context createCGImage: resultImage fromRect:ciImage.extent];
        UIImage * blurImage = [UIImage imageWithCGImage:outImage];
        dispatch_async(dispatch_get_main_queue(), ^{
          self.backgroundImageView.image = blurImage;
        });
    });
    
}

- (void)clickSkip {
    [self removeAllSubviews];
    [self.connector adapter_splashAdWillClosed:self];
    [self.connector adapter_splashAdClosed:self];
}

- (void)removeAllSubviews {
    [self.skipButton removeFromSuperview];
    [self.bottomView removeFromSuperview];
    [self.nativeAdView removeFromSuperview];
}

- (void)updateCountDown {
    if (self.countdownDuration > 0) {
        [self.skipButton setTitle:[NSString stringWithFormat:@"Skip %@", @(self.countdownDuration)] forState:UIControlStateNormal];
        self.countdownDuration -= 1;
    } else {
        [self destoryTimer];
    }
}

- (void)destoryTimer {
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [self removeAllSubviews];
}

- (void)addAllViews {
    [self.nativeAdView addSubview:self.backgroundImageView];
    [self.nativeAdView addSubview:self.maskView];
    [self.containerView addSubview:self.mediaView];
    [self.containerView addSubview:self.headLineLabel];
    [self.containerView addSubview:self.bodyLabel];
    [self.containerView addSubview:self.visitSiteButton];
    [self.nativeAdView addSubview:self.containerView];
    [self.window.rootViewController.view addSubview:self.nativeAdView];
    [self.window.rootViewController.view addSubview:self.bottomView];
    [self.window.rootViewController.view addSubview:self.skipButton];
}

- (void)layoutViews {
    CGRect bottomRect = CGRectMake(0,
                                   self.window.bounds.size.height - self.bottomView.bounds.size.height,
                                   self.window.bounds.size.width,
                                   self.bottomView.bounds.size.height);
    CGRect nativeRect = CGRectMake(0,
                                   0,
                                   self.window.bounds.size.width,
                                   self.window.bounds.size.height - bottomRect.size.height);
    
    self.bottomView.frame = bottomRect;
    self.nativeAdView.frame = nativeRect;
    self.backgroundImageView.frame = nativeRect;
    self.maskView.frame = nativeRect;

    [self.containerView.heightAnchor constraintEqualToAnchor:self.nativeAdView.heightAnchor multiplier:0.7].active = YES;
    [self.containerView.widthAnchor constraintEqualToAnchor:self.nativeAdView.widthAnchor multiplier:1.0].active = YES;
    [self.containerView.centerXAnchor constraintEqualToAnchor:self.nativeAdView.centerXAnchor].active = YES;
    [self.containerView.centerYAnchor constraintEqualToAnchor:self.nativeAdView.centerYAnchor].active = YES;
    
    [self.skipButton.heightAnchor constraintEqualToConstant:35].active = YES;
    [self.skipButton.widthAnchor constraintEqualToConstant:60].active = YES;
    [self.skipButton.bottomAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:-20].active = YES;
    [self.skipButton.rightAnchor constraintEqualToAnchor:self.window.rootViewController.view.rightAnchor constant:-20].active = YES;

    [self.headLineLabel.heightAnchor constraintEqualToConstant:20].active = YES;
    [self.headLineLabel.widthAnchor constraintEqualToAnchor:self.containerView.widthAnchor multiplier:1.0].active = YES;
    [self.headLineLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor].active = YES;
    [self.headLineLabel.bottomAnchor constraintEqualToAnchor:self.mediaView.topAnchor constant:-20].active = YES;

    [self.mediaView.heightAnchor constraintEqualToAnchor:self.containerView.heightAnchor multiplier:0.56].active = YES;
    [self.mediaView.widthAnchor constraintEqualToAnchor:self.containerView.widthAnchor multiplier:1.0].active = YES;
    [self.mediaView.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor].active = YES;

    [self.bodyLabel.heightAnchor constraintEqualToConstant:60].active = YES;
    [self.bodyLabel.topAnchor constraintEqualToAnchor:self.mediaView.bottomAnchor].active = YES;
    [self.bodyLabel.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor constant:10].active = YES;
    [self.bodyLabel.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor constant:-10].active = YES;

    [self.visitSiteButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.visitSiteButton.widthAnchor constraintEqualToConstant:200].active = YES;
    [self.visitSiteButton.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor].active = YES;
    [self.visitSiteButton.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;
}


#pragma mark - property getter
- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _skipButton.layer.cornerRadius = 18.0;
        _skipButton.layer.borderWidth = 1.0;
        _skipButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        _skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _skipButton;
}

- (GADUnifiedNativeAdView *)nativeAdView {
    if (!_nativeAdView) {
        _nativeAdView = [[GADUnifiedNativeAdView alloc] init];
        self.nativeAdView.backgroundColor = [UIColor blackColor];
    }
    return _nativeAdView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

- (GADMediaView *)mediaView {
    if (!_mediaView) {
        GADMediaView *mediaView = [[GADMediaView alloc] init];
        _nativeAdView.mediaView = mediaView;
        _nativeAdView.mediaView.mediaContent = self.nativeAd.mediaContent;
        _mediaView = self.nativeAdView.mediaView;
        _mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mediaView;
}

- (UILabel *)headLineLabel {
    if (!_headLineLabel) {
        _headLineLabel = [[UILabel alloc] init];
        _headLineLabel.text = self.nativeAd.headline;
        _headLineLabel.textColor = [UIColor whiteColor];
        _headLineLabel.numberOfLines = 0;
        _headLineLabel.font = [UIFont systemFontOfSize:20.0];
        _headLineLabel.textAlignment = NSTextAlignmentCenter;
        [_headLineLabel sizeToFit];
        _headLineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headLineLabel;
}

- (UILabel *)bodyLabel {
    if (!_bodyLabel) {
        _bodyLabel = [[UILabel alloc] init];
        _bodyLabel.text = self.nativeAd.body;
        _bodyLabel.textColor = [UIColor whiteColor];
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.font = [UIFont systemFontOfSize:16.0];
        _bodyLabel.textAlignment = NSTextAlignmentCenter;
        [_bodyLabel sizeToFit];
        _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bodyLabel;
}

- (UIButton *)visitSiteButton {
    if (!_visitSiteButton) {
        _visitSiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _visitSiteButton.layer.cornerRadius = 26.0;
        _visitSiteButton.backgroundColor = [UIColor colorWithRed:0.19 green:0.52 blue:0.99 alpha:1.0];
        [_visitSiteButton setTitle:@"VISIT SITE" forState:UIControlStateNormal];
        _visitSiteButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        _visitSiteButton.translatesAutoresizingMaskIntoConstraints = NO;
        _nativeAdView.callToActionView = _visitSiteButton;
    }
    return _visitSiteButton;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _nativeAdView.callToActionView = self.maskView;
    }
    return _maskView;
}

- (NSTimer *)countDownTimer {
    if (!_countDownTimer) {
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
    }
    return _countDownTimer;
}


@end
