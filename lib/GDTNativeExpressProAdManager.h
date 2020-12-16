//
//  GDTNativeExpressProAdManager.h
//  GDTMobApp
//
//  Created by royqpwang on 2020/4/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTAdParams.h"

NS_ASSUME_NONNULL_BEGIN

@class GDTNativeExpressProAdManager;
@class GDTNativeExpressProAdView;

@protocol GDTNativeExpressProAdManagerDelegate <NSObject>

@optional
/**
 * 拉取原生模板2.0广告成功
 */
- (void)gdt_nativeExpressProAdSuccessToLoad:(GDTNativeExpressProAdManager *)adManager views:(NSArray<__kindof GDTNativeExpressProAdView *> *)views;

/**
 * 拉取原生模板2.0广告失败
 */
- (void)gdt_nativeExpressProAdFailToLoad:(GDTNativeExpressProAdManager *)adManager error:(NSError *)error;

@end


@interface GDTNativeExpressProAdManager : NSObject

/**
 *  委托对象
 */
@property (nonatomic, weak) id<GDTNativeExpressProAdManagerDelegate> delegate;

@property (nonatomic, readonly) NSString *placementId;

@property (nonatomic, strong, readonly) GDTAdParams *adParams;

/**
 *  构造方法
 *  详解：placementId - 广告位 ID
 *       adSize - 广告参数
 */
- (instancetype)initWithPlacementId:(NSString *)placementId adPrams:(GDTAdParams *)adParams;

- (void)loadAd:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
