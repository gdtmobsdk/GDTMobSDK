//
//  IMAGDT_VASTVideoAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/11/13.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "IMAGDT_VASTVideoAdAdapter.h"
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"

@interface IMAGDT_VASTVideoAdAdapter() <IMAAdsLoaderDelegate, IMAAdsManagerDelegate>

@property (nonatomic, weak) id <GDTUnifiedNativeAdDataObjectConnectorProtocol>connector;

@property (nonatomic, strong) GDTUnifiedNativeAdDataObject *dataObject;
@property (nonatomic, weak) UIViewController *rootVC;
@property (nonatomic, weak) GDTUnifiedNativeAdView *containerView;

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isExposured;

@property(nonatomic, strong) IMAAdsLoader *adsLoader;
@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;
@property(nonatomic, strong) IMAAdsManager *adsManager;

@end

@implementation IMAGDT_VASTVideoAdAdapter

@synthesize duration;

- (instancetype)initWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
{
    if (self = [super init]) {
        self.dataObject = dataObject;
        self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];
        self.adsLoader.delegate = self;
    }
    return self;
}

#pragma mark - GDTUnifiedNativeAdDataObjectAdapterProtocol
- (NSString *)title
{
    return self.dataObject.title;
}

- (NSString *)desc
{
    return self.dataObject.desc;
}

- (NSString *)imageUrl
{
    return self.dataObject.imageUrl;
}

- (NSString *)iconUrl
{
    return self.dataObject.iconUrl;
}

- (BOOL)isVideoAd
{
    return self.dataObject.isVideoAd;
}

- (NSArray *)mediaUrlList
{
    return self.dataObject.mediaUrlList;
}

- (CGFloat)appRating
{
    return self.dataObject.appRating;
}

- (NSNumber *)appPrice
{
    return self.dataObject.appPrice;
}

- (BOOL)isAppAd
{
    return self.dataObject.isAppAd;
}

- (BOOL)isThreeImgsAd
{
    return self.dataObject.isThreeImgsAd;
}

- (NSInteger)imageWidth
{
    return self.dataObject.imageWidth;
}

- (NSInteger)imageHeight
{
    return self.dataObject.imageHeight;
}

- (NSInteger)eCPM
{
    return self.dataObject.eCPM;
}

- (NSString *)eCPMLevel
{
    return self.dataObject.eCPMLevel;
}

- (NSString *)callToAction
{
    return self.dataObject.callToAction;
}

- (BOOL)skippable
{
    return self.dataObject.skippable;
}

- (BOOL)equalsAdData:(id<GDTUnifiedNativeAdDataObjectAdapterProtocol>)dataObject
{
    return [self.dataObject equalsAdData:dataObject];
}

- (GDTVideoConfig *)videoConfig
{
    return self.dataObject.videoConfig;
}

- (void)setVideoConfig:(GDTVideoConfig *)videoConfig
{
    self.dataObject.videoConfig = videoConfig;
}


- (NSString *)vastTagUrl
{
    return self.dataObject.vastTagUrl;
}

- (NSString *)vastContent
{
    return self.dataObject.vastContent;
}

- (BOOL)isVastAd
{
    return self.dataObject.isVastAd;
}

- (void)registerConnector:(id<GDTUnifiedNativeAdDataObjectConnectorProtocol>)connector clickableViews:(NSArray *)clickableViews
{
    self.connector = connector;
    [connector.unifiedNativeAdView addSubview:connector.unifiedNativeAdView.mediaView];
    self.containerView = connector.unifiedNativeAdView;
    IMAAdDisplayContainer *adDisplayContainer = [[IMAAdDisplayContainer alloc] initWithAdContainer:connector.unifiedNativeAdView.mediaView
                                                                                    companionSlots:nil];
    if (self.vastTagUrl.length > 0) {
        IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:self.vastTagUrl
                                                      adDisplayContainer:adDisplayContainer
                                                         contentPlayhead:nil
                                                             userContext:nil];
        [self.adsLoader requestAdsWithRequest:request];
    } else if (self.vastContent.length > 0) {
        IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdsResponse:self.vastContent
                                                         adDisplayContainer:adDisplayContainer
                                                            contentPlayhead:nil
                                                                userContext:nil];
        [self.adsLoader requestAdsWithRequest:request];
    }
    
}

- (void)registerClickableCallToActionView:(UIView *)callToActionView {
    // VAST 不支持此方法
}

- (void)unregisterView
{
    [self.containerView unregisterDataObject];
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    self.rootVC = rootViewController;
}


- (BOOL)needsToDetectExposure
{
    return YES;
}

- (void)didRecordImpression
{
    self.isExposured = YES;
    [self updatePlayStatus];
}

#pragma mark AdsLoader Delegates

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
  self.adsManager = adsLoadedData.adsManager;
  self.adsManager.delegate = self;
  IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
  adsRenderingSettings.webOpenerPresentingController = self.rootVC;
  [self.adsManager initializeWithAdsRenderingSettings:adsRenderingSettings];
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
  NSLog(@"Error loading ads: %@", adErrorData.adError.message);
}

#pragma mark AdsManager Delegates

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
  // When the SDK notified us that ads have been loaded, play them.
    NSLog(@"__LOG event type ----> %@", @(event.type));
  if (event.type == kIMAAdEvent_LOADED) {
      self.isLoaded = YES;
      [self updatePlayStatus];
  }
    GDTVastAdEventType eventType = [self eventTypeWithIMAAdEventType:event.type];
    [self.connector adapter_unifiedNativeAdView:self originDataObject:self.dataObject vastAdEventType:eventType];
    if (eventType == GDTVastAdEventTypeStarted) {
        [self.connector adapter_unifiedNativeAdViewWillExpose:self];
        // 开始播放单独上报一次曝光
        [self.connector adapter_unifiedNativeAdView:self originDataObject:self.dataObject vastAdEventType:GDTVastAdEventTypeExposed];
    } else if (eventType == GDTVastAdEventTypeClicked) {
        [self.connector adapter_unifiedNativeAdViewDidClick:self];
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
  // Something went wrong with the ads manager after ads were loaded. Log the error and play the
  // content.
  NSLog(@"AdsManager error: %@", error.message);
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
  // The SDK is going to play ads, so pause the content.
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
  // The SDK is done playing ads (at least for now), so resume the content.
}

#pragma mark - private
- (void)updatePlayStatus
{
    if (self.isExposured && self.isLoaded) {
        [self.adsManager start];
    }
}

- (GDTVastAdEventType)eventTypeWithIMAAdEventType:(IMAAdEventType)type
{
    switch (type) {
        case kIMAAdEvent_LOADED:
            return GDTVastAdEventTypeLoaded;
            break;
        case kIMAAdEvent_STARTED:
            return GDTVastAdEventTypeStarted;
            break;
        case kIMAAdEvent_FIRST_QUARTILE:
            return GDTVastAdEventTypeFirstQuartile;
            break;
        case kIMAAdEvent_MIDPOINT:
            return GDTVastAdEventTypeMidPoint;
            break;
        case kIMAAdEvent_THIRD_QUARTILE:
            return GDTVastAdEventTypeThirdQuartile;
            break;
        case kIMAAdEvent_COMPLETE:
            return GDTVastAdEventTypeComplete;
            break;
        case kIMAAdEvent_ALL_ADS_COMPLETED:
            return GDTVastAdEventTypeAllAdsComplete;
            break;
        case kIMAAdEvent_CLICKED:
            return GDTVastAdEventTypeClicked;
            break;
        default:
            return GDTVastAdEventTypeUnknow;
            break;
    }
}


@end
