//
//  GADGDT_RewardVideoAdAdapter.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GADGDT_RewardVideoAdAdapter.h"
#import <GoogleMobileAds/GADRewardBasedVideoAd.h>
#import "GDTRewardVideoAdNetworkConnectorProtocol.h"

@interface GADGDT_RewardVideoAdAdapter() <GADRewardBasedVideoAdDelegate>

@property (nonatomic, weak) id <GDTRewardVideoAdNetworkConnectorProtocol>rewardVideoAdConnector;
@property (nonatomic, strong) GADRewardBasedVideoAd *rewardVideoAd;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, assign) NSInteger loadedTime;

@end

@implementation GADGDT_RewardVideoAdAdapter

+ (nonnull NSString *)adapterVersion {
    return @"1.0.0";
}

- (nullable instancetype)initWithAdNetworkConnector:(nonnull id<GDTRewardVideoAdNetworkConnectorProtocol>)connector
                                              posId:(nonnull NSString *)posId
                                             extStr:(nonnull NSString *)extStr {
    if (!connector) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.posId = posId;
        self.rewardVideoAdConnector = connector;
        self.rewardVideoAd = [GADRewardBasedVideoAd sharedInstance];
        self.rewardVideoAd.delegate = self;
        
    }
    return self;
}

- (void)loadAd {
    GADRequest *request = [GADRequest request];
    [self.rewardVideoAd loadRequest:request withAdUnitID:self.posId];
}

- (BOOL)showAdFromRootViewController:(nonnull UIViewController *)viewController {
    [self.rewardVideoAd presentFromRootViewController:viewController];
    return YES;
}

- (BOOL)isAdValid {
    return self.rewardVideoAd.ready;
}

- (NSInteger)expiredTimestamp {
    return self.loadedTime + 1800;
}

- (NSInteger)eCPM {
    return -1;
}

#pragma mark - GADRewardBasedVideoAdDelegate
/// Tells the delegate that the reward based video ad has rewarded the user.
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidRewardEffective:self];
}

/// Tells the delegate that the reward based video ad failed to load.
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error;
{
    [self.rewardVideoAdConnector adapter_rewardVideoAd:self didFailWithError:error];
}

/// Tells the delegate that a reward based video ad was received.
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    self.loadedTime = [[NSDate date] timeIntervalSince1970];
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidLoad:self];
    [self.rewardVideoAdConnector adapter_rewardVideoAdVideoDidLoad:self];
}

/// Tells the delegate that the reward based video ad opened.
- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdWillVisible:self];
}

/// Tells the delegate that the reward based video ad started playing.
- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidExposed:self];
}

/// Tells the delegate that the reward based video ad completed playing.
- (void)rewardBasedVideoAdDidCompletePlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidPlayFinish:self];
}

/// Tells the delegate that the reward based video ad closed.
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClose:self];
}

/// Tells the delegate that the reward based video ad will leave the application.
- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    [self.rewardVideoAdConnector adapter_rewardVideoAdDidClicked:self];
}

/// Tells the delegate that the reward based video ad's metadata changed. Called when an ad loads,
/// and when a loaded ad's metadata changes.
- (void)rewardBasedVideoAdMetadataDidChange:(GADRewardBasedVideoAd *)rewardBasedVideoAd
{
    NSLog(@"metadata ---> %@", rewardBasedVideoAd);
//    [self.rewardVideoAdConnector adapter_rewardVideoAd]
}

@end
