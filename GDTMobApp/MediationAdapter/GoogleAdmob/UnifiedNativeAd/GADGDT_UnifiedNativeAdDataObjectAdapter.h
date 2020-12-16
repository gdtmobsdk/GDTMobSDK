//
//  GADGDT_UnifiedNativeAdDataObjectAdapter.h
//  GDTMobApp
//
//  Created by Nancy on 2019/7/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GDTUnifiedNativeAdNetworkAdapterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GADGDT_UnifiedNativeAdDataObjectAdapter : NSObject <GDTUnifiedNativeAdDataObjectAdapterProtocol, GDTMediaViewAdapterProtocol>

- (instancetype)initWithNativeAd:(GADUnifiedNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
