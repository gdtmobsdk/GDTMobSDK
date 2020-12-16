//
//  GDTRewardVideoAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/6/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTBaseAdNetworkAdapterProtocol.h"

@protocol GDTRewardVideoAdNetworkConnectorProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol GDTRewardVideoAdNetworkAdapterProtocol <GDTBaseAdNetworkAdapterProtocol>

- (void)loadAd;

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController;

- (BOOL)isAdValid;

- (NSInteger)expiredTimestamp;

@optional
@property (nonatomic) BOOL videoMuted;

@end

NS_ASSUME_NONNULL_END
