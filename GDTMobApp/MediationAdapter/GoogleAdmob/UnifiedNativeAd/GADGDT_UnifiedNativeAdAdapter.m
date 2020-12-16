//
//  GADGDT_UnifiedNativeAdAdapter.m
//  GDTMobApp
//
//  Created by Nancy on 2019/7/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GADGDT_UnifiedNativeAdAdapter.h"
#import "MediationAdapterUtil.h"
#import "GDTUnifiedNativeAdNetworkConnectorProtocol.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GADGDT_UnifiedNativeAdDataObjectAdapter.h"


@interface GADGDT_UnifiedNativeAdAdapter () <GADUnifiedNativeAdLoaderDelegate>
@property (nonatomic, weak) id <GDTUnifiedNativeAdNetworkConnectorProtocol>connector;
@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation GADGDT_UnifiedNativeAdAdapter
@dynamic maxVideoDuration;
@dynamic minVideoDuration;

+ (NSString *)adapterVersion {
    return @"1.0.0";
}

- (instancetype)initWithAdNetworkConnector:(id)connector posId:(NSString *)posId extStr:(NSString *)extStr {
    if (!connector || ![connector conformsToProtocol:@protocol(GDTUnifiedNativeAdNetworkConnectorProtocol)]) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.params = [MediationAdapterUtil getURLParams:extStr];
        self.posId = posId;
    }
    
    return self;
}

- (void)loadAdWithCount:(NSInteger)count {
    if (count <= 0) {
        return;
    }
    
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = YES;
    videoOptions.customControlsRequested = YES;
    videoOptions.clickToExpandRequested = YES;
    
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:self.posId rootViewController:nil adTypes:@[kGADAdLoaderAdTypeUnifiedNative] options:@[videoOptions]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}

- (NSInteger)eCPM {
    return -1;
}

#pragma mark - GADAdLoader

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    if (nativeAd) {
        if ([self.connector respondsToSelector:@selector(adapter:unifiedNativeAdLoaded:error:)]) {
            GADGDT_UnifiedNativeAdDataObjectAdapter *adapter = [[GADGDT_UnifiedNativeAdDataObjectAdapter alloc] initWithNativeAd:nativeAd];
            [self.connector adapter:self unifiedNativeAdLoaded:@[adapter] error:nil];
        }
    }
    else {
        if ([self.connector respondsToSelector:@selector(adapter:unifiedNativeAdLoaded:error:)]) {
            [self.connector adapter:self unifiedNativeAdLoaded:nil error:nil];
        }
    }
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    if ([self.connector respondsToSelector:@selector(adapter:unifiedNativeAdLoaded:error:)]) {
        [self.connector adapter:self unifiedNativeAdLoaded:nil error:error];
    }
}

@end
