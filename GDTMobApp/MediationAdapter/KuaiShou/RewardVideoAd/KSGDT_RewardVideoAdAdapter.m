//
//  KSGDT_RewardVideoAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/10/31.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "KSGDT_RewardVideoAdAdapter.h"
#import <KSAdSDK/KSAdSDK.h>
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"
#import "MediationAdapterUtil.h"

@interface KSGDT_RewardVideoAdAdapter() <KSRewardedVideoAdDelegate>

@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>rewardVideoAdConnector;
@property (nonatomic, strong) KSRewardedVideoAd *rewardVideoAd;
@property (nonatomic, assign) NSInteger loadedTime;

@end

@implementation KSGDT_RewardVideoAdAdapter

+ (NSString *)adapterVersion {
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
        self.rewardVideoAdConnector = connector;
        if (KSAdSDKManager.appId.length == 0) {
            NSDictionary *params = [MediationAdapterUtil getURLParams:extStr];
            [KSAdSDKManager setAppId:params[@"appid"]];
        }
        self.rewardVideoAd = [[KSRewardedVideoAd alloc] initWithPosId:posId rewardedVideoModel:[KSRewardedVideoModel new]];
        self.rewardVideoAd.delegate = self;
    }
    return self;
}

- (void)loadAd
{
    [self.rewardVideoAd loadAdData];
}

- (BOOL)showAdFromRootViewController:(nonnull UIViewController *)viewController {
    if ([self.rewardVideoAd isValid]) {
        return [self.rewardVideoAd showAdFromRootViewController:viewController showScene:@"" type:KSRewardedVideoAdRewardedTypePlay30Second];
    } else {
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:[NSError new]];
        return NO;
    }
}

- (BOOL)isAdValid {
    return self.rewardVideoAd.isValid;
}

- (NSInteger)expiredTimestamp {
    return self.loadedTime + 1800;
}

- (NSInteger)eCPM {
    NSLog(@"kuaishou 价格 --> %@", @(self.rewardVideoAd.ecpm));
    return self.rewardVideoAd.ecpm;
}

#pragma mark - KSRewardedVideoAdDelegate

/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(KSRewardedVideoAd *)rewardedVideoAd
{
    // 快手此回调无意义，不使用。
}
/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:error];
}
/**
 This method is called when cached successfully.
 */
- (void)rewardedVideoAdVideoDidLoad:(KSRewardedVideoAd *)rewardedVideoAd
{
    self.loadedTime = [[NSDate date] timeIntervalSince1970];
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidLoad:self];
    [self.rewardVideoAdConnector adapter_rewardVideoAdVideoDidLoad:self];
}
/**
 This method is called when video ad slot will be showing.
 */
- (void)rewardedVideoAdWillVisible:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdWillVisible:self];
}
/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardedVideoAdDidVisible:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidExposed:self];
}
/**
 This method is called when video ad is about to close.
 */
- (void)rewardedVideoAdWillClose:(KSRewardedVideoAd *)rewardedVideoAd
{
    
}
/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClose:self];
}

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(KSRewardedVideoAd *)rewardedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClicked:self];
}
/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardedVideoAdDidPlayFinish:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    if (error) {
        [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:error];
    } else {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidPlayFinish:self];
    }
}
/**
 This method is called when the user clicked skip button.
 */
- (void)rewardedVideoAdDidClickSkip:(KSRewardedVideoAd *)rewardedVideoAd
{
    
}
/**
 This method is called when the video begin to play.
 */
- (void)rewardedVideoAdStartPlay:(KSRewardedVideoAd *)rewardedVideoAd
{
    
}
/**
 This method is called when the user close video ad.
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd hasReward:(BOOL)hasReward
{
    if (hasReward) {
        [self.rewardVideoAdConnector adapter_rewardVideoAdDidRewardEffective:self];
    }
}
@end
