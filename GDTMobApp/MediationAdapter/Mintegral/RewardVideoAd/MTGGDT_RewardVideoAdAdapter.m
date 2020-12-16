//
//  MTGGDT_RewardVideoAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/10/31.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "MTGGDT_RewardVideoAdAdapter.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKReward/MTGRewardAdManager.h>
#import <MTGSDKReward/MTGBidRewardAdManager.h>
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKBidding/MTGBiddingRequest.h>
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"

@interface MTGGDT_RewardVideoAdAdapter() <MTGRewardAdLoadDelegate,MTGRewardAdShowDelegate>

@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol> rewardVideoAdConnector;
@property (nonatomic, strong) MTGBidRewardAdManager *rewardVideoAd;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) MTGBiddingResponse *bidResponse;
@property (nonatomic, assign) NSInteger loadedTime;

@end

@implementation MTGGDT_RewardVideoAdAdapter

+ (NSString *)adapterVersion
{
    return @"1.0.0";
}

- (instancetype)initWithAdNetworkConnector:(id)connector
                                     posId:(NSString *)posId
                                    extStr:(NSString *)extStr
{
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.posId = posId;
        self.rewardVideoAdConnector = connector;
        NSDictionary *params = [MediationAdapterUtil getURLParams:extStr];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[MTGSDK sharedInstance] setAppID:params[@"appid"]
            ApiKey:params[@"appkey"]];
        });
        self.rewardVideoAd = [MTGBidRewardAdManager sharedInstance];
    }
    return self;
}

- (void)loadAd
{
    [MTGBiddingRequest getBidWithRequestParameter:[[MTGBiddingRequestParameter alloc] initWithUnitId:self.posId basePrice:@(0)]
                                completionHandler:^(MTGBiddingResponse * _Nonnull bidResponse) {
        self.bidResponse = bidResponse; // 获取竞价结果
        if (self.bidResponse.success) {
            [self.rewardVideoAd loadVideoWithBidToken:bidResponse.bidToken unitId:self.posId delegate:self];
        } else {
            [self.bidResponse notifyLoss:MTGBidLossedReasonCodeBidTimeout];
            [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:nil];
        }
    }];
    
}

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController
{
    [self.bidResponse notifyWin];
    if ([self.rewardVideoAd isVideoReadyToPlay:self.posId]) {
        [self.rewardVideoAd showVideo:self.posId
                         withRewardId:@"1"
                               userId:nil
                             delegate:self
                       viewController:viewController];
        return YES;
    } else {
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:[NSError new]];
        return NO;
    }
}

- (BOOL)isAdValid
{
    return [self.rewardVideoAd isVideoReadyToPlay:self.posId];
}

- (NSInteger)expiredTimestamp
{
    return self.loadedTime + 1800;
}

- (NSInteger)eCPM
{
    // mintegral 价格单位是 元， * 100 调整为 分。
    NSLog(@"mintegral 价格 --> %@", @((NSInteger)(self.bidResponse.price * 100)));
    return (NSInteger)(self.bidResponse.price * 100);
}

#pragma mark - MTGRewardAdLoadDelegate

/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait load video
 completely
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onAdLoadSuccess:(nullable NSString *)unitId
{
    if ([unitId isEqualToString:self.posId]) {
        self.loadedTime = [[NSDate date] timeIntervalSince1970];
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidLoad:self];
    }
}

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 *
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId
{
    if ([unitId isEqualToString:self.posId]) {
        [self.rewardVideoAdConnector adapter_rewardVideoAdVideoDidLoad:self];
    }
}

/**
 *  Called when there was an error loading the ad.
 *
 *  @param unitId      - the unitId string of the Ad that failed to load.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error
{
    if ([unitId isEqualToString:self.posId]) {
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:error];
    }
}

#pragma mark - MTGRewardAdShowDelegate
/**
 *  Called when the ad display success
 *
 *  @param unitId - the unitId string of the Ad that display success.
 */
- (void)onVideoAdShowSuccess:(nullable NSString *)unitId
{
    if ([unitId isEqualToString:self.posId]) {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidExposed:self];
    }
}

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param unitId      - the unitId string of the Ad that failed to be displayed.
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)onVideoAdShowFailed:(nullable NSString *)unitId withError:(nonnull NSError *)error
{
    if ([unitId isEqualToString:self.posId]) {
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:error];
    }
}

/**
 *  Called only when the ad has a video content, and called when the video play completed.
 *  @param unitId - the unitId string of the Ad that video play completed.
 */
- (void) onVideoPlayCompleted:(nullable NSString *)unitId
{
    if ([unitId isEqualToString:self.posId]) {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidPlayFinish:self];
    }
}

/**
 *  Called only when the ad has a endcard content, and called when the endcard show.
 *  @param unitId - the unitId string of the Ad that endcard show.
 */
- (void) onVideoEndCardShowSuccess:(nullable NSString *)unitId
{
    
}

/**
 *  Called when the ad is clicked
 *
 *  @param unitId - the unitId string of the Ad clicked.
 */
- (void)onVideoAdClicked:(nullable NSString *)unitId
{
    if ([unitId isEqualToString:self.posId]) {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidClicked:self];
    }
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *
 *  @param unitId      - the unitId string of the Ad that has been dismissed
 *  @param converted   - BOOL describing whether the ad has converted
 *  @param rewardInfo  - the rewardInfo object containing the info that should be given to your user.
 */
- (void)onVideoAdDismissed:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo
{
    if ([unitId isEqualToString:self.posId] && rewardInfo) {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidRewardEffective:self];
    }
}

/**
 *  Called when the ad  did closed;
 *
 *  @param unitId - the unitId string of the Ad that video play did closed.
 */
- (void)onVideoAdDidClosed:(nullable NSString *)unitId
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClose:self];
}
@end
