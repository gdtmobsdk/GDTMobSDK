//
//  GDTAdViewController+Sample.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/3/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTAdViewController+Sample.h"

@implementation GDTAdViewController (Sample)

- (void)loadView
{
    [super loadView];
    self.demoArray = [@[
                        @[@"模板 2.0", @"NativeExpressProAdViewController"],
                        @[@"模版激励视频广告", @"NativeExpressRewardVideoViewController"],
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
