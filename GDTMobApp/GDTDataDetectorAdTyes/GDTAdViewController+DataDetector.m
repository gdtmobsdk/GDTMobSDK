//
//  GDTAdViewController+DataDetector.m
//  GDTMobDataDetectorSample
//
//  Created by nimo on 2020/8/25.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "GDTAdViewController+DataDetector.h"

@implementation GDTAdViewController (DataDetector)
- (void)loadView
{
    [super loadView];
    self.demoArray = [@[
                        @[@"Data Detector", @"DataDetectorViewController"],
                        @[@"模板 2.0", @"NativeExpressProAdViewController"],
                        @[@"自渲染2.0", @"UnifiedNativeAdViewController"],
                        @[@"开屏广告", @"SplashViewController"],
                        @[@"原生模板广告", @"NativeExpressAdViewController"],
                        @[@"原生视频模板广告", @"NativeExpressVideoAdViewController"],
                        @[@"激励视频广告", @"RewardVideoViewController"],
                        @[@"HybridAd", @"HybridAdViewController"],
                        @[@"Banner2.0", @"UnifiedBannerViewController"],
                        @[@"插屏2.0", @"UnifiedInterstitialViewController"],
                        @[@"插屏2.0全屏", @"UnifiedInterstitialFullScreenVideoViewController"],
                        @[@"获取IDFA", @(1)],
                        @[@"试玩广告调试", @"PlayableAdTestViewController"],
                        ] mutableCopy];
}
@end
