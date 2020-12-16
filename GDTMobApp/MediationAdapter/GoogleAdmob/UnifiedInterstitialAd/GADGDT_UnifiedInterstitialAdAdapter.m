//
//  GADGDT_UnifiedInterstitialAdAdapter.m
//  GDTMobApp
//
//  Created by Nancy on 2019/8/12.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GADGDT_UnifiedInterstitialAdAdapter.h"
#import "GDTUnifiedInterstitialAdNetworkConnectorProtocol.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import "MediationAdapterUtil.h"

@interface GADGDT_UnifiedInterstitialAdAdapter () <GADInterstitialDelegate>
@property (nonatomic, weak) id <GDTUnifiedInterstitialAdNetworkConnectorProtocol>connector;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) GADInterstitial *interstitialAd;

@end

@implementation GADGDT_UnifiedInterstitialAdAdapter

+ (NSString *)adapterVersion {
    return @"1.0.0";
}

- (instancetype)initWithAdNetworkConnector:(id)connector posId:(NSString *)posId extStr:(NSString *)extStr {
    if (!connector || ![connector conformsToProtocol:@protocol(GDTUnifiedInterstitialAdNetworkConnectorProtocol)]) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.params = [MediationAdapterUtil getURLParams:extStr];
        self.posId = posId;
        
        self.interstitialAd = [[GADInterstitial alloc] initWithAdUnitID:self.posId];
        self.interstitialAd.delegate = self;
    }
    
    return self;
}

- (void)loadAd {
    [self.interstitialAd loadRequest:[GADRequest request]];
}

- (void)presentAdFromRootViewController:(UIViewController *)rootViewController {
    if (self.interstitialAd.isReady) {
        [self.interstitialAd presentFromRootViewController:rootViewController];
    }
    else {
        if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialFailToPresentAd:error:)]) {
            [self.connector adapter_unifiedInterstitialFailToPresentAd:self error:nil];
        }
    }
}

- (BOOL)isAdValid {
    return self.interstitialAd.isReady;
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialSuccessToLoadAd:)]) {
        [self.connector adapter_unifiedInterstitialSuccessToLoadAd:self];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialFailToLoadAd:error:)]) {
        [self.connector adapter_unifiedInterstitialFailToLoadAd:self error:error];
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialWillExposure:)]) {
        [self.connector adapter_unifiedInterstitialWillExposure:self];
    }
    
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialWillPresentScreen:)]) {
        [self.connector adapter_unifiedInterstitialWillPresentScreen:self];
    }
    
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialDidPresentScreen:)]) {
        [self.connector adapter_unifiedInterstitialDidPresentScreen:self];
    }
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialFailToPresentAd:error:)]) {
        [self.connector adapter_unifiedInterstitialFailToPresentAd:self error:nil];
    }
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialDidDismissScreen:)]) {
        [self.connector adapter_unifiedInterstitialDidDismissScreen:self];
    }
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialClicked:)]) {
        [self.connector adapter_unifiedInterstitialClicked:self];
    }
    
    if ([self.connector respondsToSelector:@selector(adapter_unifiedInterstitialWillLeaveApplication:)]) {
        [self.connector adapter_unifiedInterstitialWillLeaveApplication:self];
    }
}

@end
